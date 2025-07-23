import yup from "yup";
import { getDatabase } from "./database.js";
import { updateDatabase } from "./util.js";
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

/**
 * Schema for "update user". We can optionally supply a first name, last name, password, and / or blurb. We cannot edit the id or username,
 * or supply any other random data.
 */
const updateUserSchema = yup
  .object({
    realname: yup.string().min(1).optional(),
    description: yup.string().optional(),
    dob: yup.date().optional(),
    role: yup.string().optional(),
    username: yup.string().optional(),
    avatar_url: yup.string().optional(),
    password: yup.string().min(6).optional()  // Add password validation
  })
  .required();

/**
 * Gets the user with the given username, if it exists.
 *
 * @param {string} username the username to search
 * @returns the user with the matching username, or undefined.
 */
export async function getUserWithUsername(username) {
  const db = await getDatabase();
  return await db.get("SELECT * from users WHERE username = ?", username);
}

/**
 * Gets the user with the given username and password, if it exists.
 *
 * @param {string} username the username to search
 * @param {*} password the password to search
 * @returns the user with the given credentials, or undefined.
 */
export async function getUserWithCredentials(username, password) {
  const db = await getDatabase();
  const user = await db.get("SELECT * from users WHERE username = ?", username);
  if (user) {
    if (user.password.startsWith('$2b$')) {
      // This is a hashed password
      if (await bcrypt.compare(password, user.password)) {
        return user;
      }
    } else {
      // This is a plaintext password
      if (password === user.password) {
        return user;
      }
    }
  }
  return null;
}

/**
 * Updates the user with the given id if it exists, with the given update data. Update data can optionally include a firstName, lastName,
 * password, and / or blurb.
 *
 * @param {*} id the user id to update, will be converted to a number using parseInt().
 * @param {*} udpateData the update data to apply.
 * @returns true if the database was updated, false otherwise
 * @throws an error if updateData is invalid.
 */
export async function updateUser(id, udpateData) {
  // Validate incoming data (throw error if invalid)
  const parsedUpdateData = updateUserSchema.validateSync(udpateData, {
    abortEarly: false,
    stripUnknown: true
  });

  if (parsedUpdateData.password) {
    parsedUpdateData.password = await bcrypt.hash(parsedUpdateData.password, SALT_ROUNDS);
  }

  // Build and run update statement
  const db = await getDatabase();
  const dbResult = await updateDatabase(db, "Users", parsedUpdateData, id);

  // Return true if changes applied, false otherwise
  return dbResult.changes > 0;
}

export async function getAllUsers() {
  const db = await getDatabase();

  try {
    const users = await db.all("SELECT * FROM users");
    return users;
  } catch (error) {
    console.error("Database error:", error);
    throw error;
  }
}
export async function getUserById(id) {
  const db = await getDatabase();
  try {
    const user = await db.get("SELECT * FROM users WHERE id = ?", id);
    return user || null;
  } catch (error) {
    console.error("Database error:", error);
    throw error;
  }
}

// create a new user
export async function createUser({ username, password, realname, dob, description, avatar_url }) {
  const db = await getDatabase();
  const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
  const result = await db.run(
    "INSERT INTO users (username, password, realname, dob, description, avatar_url, create_date) VALUES (?, ?, ?, ?, ?, ?, ?)",
    [username, hashedPassword, realname, dob, description, avatar_url, new Date().toISOString()]
  );
  return { id: result.lastID };
}

export async function deleteUser(id) {
  const db = await getDatabase();
  try {
    // First delete from follows table to maintain referential integrity
    await db.run("DELETE FROM follows WHERE follower_id = ? OR followed_id = ?", [id, id]);
    
    // Then delete the user
    const result = await db.run("DELETE FROM users WHERE id = ?", id);
    return result.changes > 0;
  } catch (error) {
    console.error("Error deleting user:", error);
    throw error;
  }
}

/**
 * Social features
 * Handles following/follower relationships
 */
export async function getFollowersByUserId(userId) {
  const db = await getDatabase(); 
  const sql = `SELECT u.id, u.username, u.realname, u.avatar_url 
               FROM follows f 
               JOIN users u ON f.follower_id = u.id 
               WHERE f.followed_id = ?`; 
  const rows = await db.all(sql, [userId]); 
  return rows;
}

export async function getFollowingsByUserId(userId) {
  const db = await getDatabase(); 
  const sql = `SELECT u.id, u.username, u.realname, u.avatar_url 
               FROM follows f 
               JOIN users u ON f.followed_id = u.id 
               WHERE f.follower_id = ?`; 
  const rows = await db.all(sql, [userId]); 
  return rows;
}
