import express from "express";
import authRoutes from "./api-auth.js";
import userRoutes from "./api-users.js";
import articleRoutes from "./api-articles.js";
import imageUpload from "./api-image-upload.js";
import commentRoutes from "./api-comments.js";
import notificationRoutes from "./api-notifications.js"; 

const router = express.Router();

router.use("/auth", authRoutes);
router.use("/users", userRoutes);
router.use("/articles", articleRoutes);  
router.use("/image", imageUpload);
router.use("/comments", commentRoutes);
router.use("/user/notifications", notificationRoutes); 

export default router;