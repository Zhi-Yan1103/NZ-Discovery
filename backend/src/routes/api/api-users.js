import express from "express";
import multer from "multer";
import { requiresAuthentication } from "../../middleware/auth-middleware.js";
import { getAllUsers, updateUser, getUserById, createUser, getUserWithUsername, deleteUser, getFollowersByUserId, getFollowingsByUserId } from "../../data/users-dao.js";
import { getDatabase } from "../../data/database.js";
import path from 'path';
import fs from 'fs'; // File system module for managing files
import sharp from 'sharp'; // Sharp library for image processing
import { createUserJWT } from "../../utils/jwt-utils.js";

const router = express.Router();

// Setup multer to store the file in memory (for processing later) and apply size/type limits
const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Only JPEG, PNG and GIF are allowed.'));
    }
  }
});

// get current user info
router.get("/me", requiresAuthentication, (req, res) => {
  return res.json(req.user);
});

// update user info
router.patch("/me", requiresAuthentication, async (req, res) => {
  console.log("Received update data:", req.body);
  try {
    const isUpdated = await updateUser(req.user.id, req.body);
    if (isUpdated) {
      const updatedUser = await getUserById(req.user.id);

      // only create new JWT when username or password is modified
      if (req.body.username || req.body.password) {
        const jwtToken = createUserJWT(updatedUser.username);
        const expires = new Date(Date.now() + 86400000);
        return res
          .cookie("authToken", jwtToken, { httpOnly: true, expires })
          .json(updatedUser);
      }

      return res.json(updatedUser);
    } else {
      return res.sendStatus(404);
    }
  } catch (error) {
    console.error("Error updating user:", error);
    return res.sendStatus(422);
  }
});

// Handle avatar upload and update
router.post("/me", requiresAuthentication, upload.single('avatar'), async (req, res) => {
  const userId = req.user.id;
  let avatarUrl;

  if (req.file) {
    // Custom avatar upload
    const filename = `${Date.now()}-${path.extname(req.file.originalname)}`;
    const filepath = path.join(process.cwd(), 'public', 'images', filename);

    await sharp(req.file.buffer)
      .resize(200, 200)
      .toFile(filepath);

    avatarUrl = `/images/${filename}`;
  } else if (req.body.avatar) {
    // Default avatar selection
    avatarUrl = req.body.avatar;
  } else {
    return res.status(400).json({ message: "No avatar provided." });
  }

  // Update user's avatar URL
  const isUpdated = await updateUser(userId, { avatar_url: avatarUrl });
  if (isUpdated) {
    const updatedUser = await getUserById(userId);
    return res.json(updatedUser);
  } else {
    return res.status(404).json({ message: "User not found." });
  }
});

// Get avatar by username
router.get('/:username/avatar', async (req, res) => {
  const { username } = req.params;
  try {
    const user = await getUserWithUsername(username);
    if (user && user.avatar_url) {
      const avatarPath = path.join(process.cwd(), user.avatar_url);
      if (fs.existsSync(avatarPath)) {
        return res.sendFile(avatarPath); //return the avatat file
      }
    }
    return res.status(404).json({ message: "Avatar not found." });
  } catch (error) {
    console.error("Error fetching avatar:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Get all users (admin only)
router.get("/", requiresAuthentication, async (req, res) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ message: "Forbidden" });
  }
  try {
    const users = await getAllUsers();
    return res.json(users);
  } catch (error) {
    console.error("Error fetching users:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Delete current user's account
router.delete("/me", requiresAuthentication, async (req, res) => {
  try {
    const user = await getUserById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Delete avatar if exists
    if (user.avatar_url) {
      const avatarPath = path.join(process.cwd(), 'public', user.avatar_url);
      if (fs.existsSync(avatarPath)) {
        fs.unlinkSync(avatarPath);
      }
    }

    // Delete user
    const isDeleted = await deleteUser(req.user.id);
    if (isDeleted) {
      res.clearCookie('authToken');
      return res.status(200).json({ message: "User deleted successfully" });
    } else {
      return res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error deleting user:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Delete user by ID (admin only)
router.delete("/:id", requiresAuthentication, async (req, res) => {
  const userId = parseInt(req.params.id);

  try {
    if (req.user.role !== "admin" && req.user.id !== userId) {
      return res.status(403).json({ message: "Forbidden: You can only delete your own account" });
    }

    const user = await getUserById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Delete avatar if exists
    if (user.avatar_url) {
      const avatarPath = path.join(process.cwd(), 'public', user.avatar_url);
      if (fs.existsSync(avatarPath)) {
        fs.unlinkSync(avatarPath);
      }
    }

    // Delete user
    const isDeleted = await deleteUser(userId);
    if (isDeleted) {
      if (req.user.id === userId) {
        res.clearCookie('authToken');
      }
      return res.status(200).json({ message: "User deleted successfully" });
    } else {
      return res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error deleting user:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Check if a username is already taken during registration
router.get("/check-username/:username", async (req, res) => {
  const { username } = req.params;
  const user = await getUserWithUsername(username);
  res.json({ taken: !!user });
});

// Register a new user
router.post("/register", upload.single('avatar'), async (req, res) => {
  try {
    const { username, password, realname, dob, description } = req.body;

    let avatarUrl = null;
    if (req.file) {
      const filename = `${Date.now()}-${path.extname(req.file.originalname)}`;
      const filepath = path.join(process.cwd(), 'public', 'images', filename);

      await sharp(req.file.buffer)
        .resize(200, 200)
        .toFile(filepath);

      avatarUrl = `/images/${filename}`;
    } else if (req.body.avatar) {
      avatarUrl = req.body.avatar;
    }
    const newUser = await createUser({ username, password, realname, dob, description, avatar_url: avatarUrl });
    res.status(201).json({ message: "User registered successfully", userId: newUser.id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error registering user" });
  }
});

// Get the list of followers for the current user
router.get("/me/followers", requiresAuthentication, async (req, res) => {
  const userId = req.user.id; // get current user with req.user.id
  try {
    const followers = await getFollowersByUserId(userId);
    return res.json(followers);
  } catch (error) {
    console.error("Error fetching followers:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// router for get followings list
router.get("/me/followings", requiresAuthentication, async (req, res) => {
  const userId = req.user.id; // get current user with req.user.id
  try {
    const followings = await getFollowingsByUserId(userId);
    return res.json(followings);
  } catch (error) {
    console.error("Error fetching followings:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Get the list of users the current user is following
router.post("/me/followings/:username", requiresAuthentication, async (req, res) => {
  const followerId = req.user.id;
  const followedUsername = req.params.username;

  try {
    const followedUser = await getUserWithUsername(followedUsername);
    if (!followedUser) {
      return res.status(404).json({ message: "User not found." });
    }

    const followedId = followedUser.id;
    const db = await getDatabase();

    // check if already followed
    const existingFollow = await db.get("SELECT * FROM follows WHERE follower_id = ? AND followed_id = ?", [followerId, followedId]);
    if (existingFollow) {
      return res.status(200).json({ message: "You are already following this user." });
    }

    await db.run("INSERT INTO follows (follower_id, followed_id) VALUES (?, ?)", [followerId, followedId]);
    return res.status(200).json({ message: "Followed successfully." });
  } catch (error) {
    console.error("Error following user:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// unfollow user
router.delete("/me/followings/:username", requiresAuthentication, async (req, res) => {
  const followerId = req.user.id;
  const followedUsername = req.params.username;

  try {
    const followedUser = await getUserWithUsername(followedUsername);
    if (!followedUser) {
      return res.status(404).json({ message: "User not found." });
    }

    const followedId = followedUser.id;
    const db = await getDatabase();

    const existingFollow = await db.get("SELECT * FROM follows WHERE follower_id = ? AND followed_id = ?", [followerId, followedId]);
    if (!existingFollow) {
      return res.status(200).json({ message: "You are not following this user." });
    }

    await db.run("DELETE FROM follows WHERE follower_id = ? AND followed_id = ?", [followerId, followedId]);
    return res.status(200).json({ message: "Unfollowed successfully." });
  } catch (error) {
    console.error("Error unfollowing user:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// check if following
router.get("/me/followings/:username", requiresAuthentication, async (req, res) => {
  const followerId = req.user.id;
  const followedUsername = req.params.username;

  try {
    const followedUser = await getUserWithUsername(followedUsername);
    if (!followedUser) {
      return res.status(404).json({ message: "User not found." });
    }

    const followedId = followedUser.id;
    const db = await getDatabase();

    const existingFollow = await db.get("SELECT * FROM follows WHERE follower_id = ? AND followed_id = ?", [followerId, followedId]);
    if (existingFollow) {
      return res.status(200).json({ isFollowing: true });
    } else {
      return res.status(200).json({ isFollowing: false });
    }
  } catch (error) {
    console.error("Error checking follow status:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export default router;
