import express from "express";
import { requiresAuthentication } from "../../middleware/auth-middleware.js";
import {
    getAllArticles,
    getUserArticles,
    addArticles,
    articleSchema,
    deleteArticle,
    getArticleById,
    updateArticle,
    getArticleLikes,
    checkUserLike,
    addLike,
    removeLike,
    searchArticles  
} from "../../data/articles-dao.js";
import { getUserById } from "../../data/users-dao.js";
import { createNotificationsForFollowers } from "../../data/notification-dao.js";
import { getFollowersByUserId } from "../../data/users-dao.js";



import multer from 'multer';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
dotenv.config();

const router = express.Router();
router.use(express.json());

// Route for searching articles, placed at the top for better routing order.
router.get("/search", async (req, res) => {
    console.log("Search endpoint hit with query:", req.query);
    const query = req.query.q;
    const sortBy = req.query.sortBy || "date";
    const sortOrder = req.query.sortOrder || "desc";

    console.log("Sort by:", sortBy, "Sort order:", sortOrder);

    // Return an empty array if no query is provided.
    if (!query || query.trim() === '') {
        console.log("No query provided, returning empty array");
        return res.json([]);
    }

    try {
        console.log("Searching for:", query);
        const articles = await searchArticles(query.trim(), sortBy, sortOrder);
        console.log("Found articles:", articles.length);
        res.json(articles);
    } catch (error) {
        console.error("Error searching articles:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

// Route to get all articles.
router.get("/", async (req, res) => {
    const sortBy = req.query.sortBy || "date";
    const sortOrder = req.query.sortOrder || "desc";

    try {
        const articles = await getAllArticles(sortBy, sortOrder);
        res.json(articles);
    } catch (error) {
        console.error("Error fetching articles:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

// Route to get a specific article by its ID.
router.get("/article/:articleId", async (req, res) => {
    const articleId = req.params.articleId;

    try {
        const article = await getArticleById(articleId);
        res.json(article);
    } catch (error) {
        console.error("Error fetching article:", error);

        if (error.message.includes("not found")) {
            res.status(404).json({ error: "Article not found" });
        } else {
            res.status(500).json({ error: "Internal Server Error" });
        }
    }
});

// Route to get articles from a specific authenticated user.
router.get("/myarticles", requiresAuthentication, async (req, res) => {
    try {
        const userId = req.user.id;
        const articles = await getUserArticles(userId);
        res.json(articles);
    } catch (error) {
        console.error("Error fetching user articles:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

// Route to get an article with additional user information like author and avatar.
router.get("/:id", async (req, res) => {
    try {
        console.log("Received request for article ID:", req.params.id);
        const articleId = req.params.id;
        const article = await getArticleById(articleId);
        if (article) {
            console.log("Found article:", article);
            const author = await getUserById(article.userid);
            article.author = author ? author.username : "Unknown";
            if (article.author_avatar === null) {
                article.author_avatar = author ? author.avatar_url : null;
            }
            res.json(article);
        } else {
            console.log("Article not found for ID:", articleId);
            res.status(404).json({ error: "Article not found" });
        }
    } catch (error) {
        console.error("Error fetching article:", error);
        res.status(500).json({ error: "Internal Server Error", details: error.message, stack: error.stack });
    }
});

/// Multer configuration for image uploads.
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadPath = path.join(process.cwd(), 'public', 'images');

        // Create the upload directory if it doesn't exist.
        if (!fs.existsSync(uploadPath)) {
            fs.mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1E9)}${path.extname(file.originalname)}`;
        cb(null, uniqueSuffix);
    }
});

// File filter to restrict allowed image types.
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        cb(new Error('Only .png, .jpg and .gif formats are allowed!'), false);
    }
};

// Create the middleware for file uploads.
const upload = multer({
    storage,
    fileFilter
});

// Route to add a new article with optional image upload, and notify the followers.
router.post('/newarticles', upload.single('image'), requiresAuthentication, async (req, res) => {
    const articleData = req.body;
    try {
        articleData.userid = req.user.id;
        // If an image is uploaded, save its path, otherwise set image to null.
        if (req.file) {
            articleData.image = `images/${req.file.filename}`;
        } else {
            articleData.image = null;
        }
        await articleSchema.validate(articleData, { abortEarly: false });
        const result = await addArticles(articleData);
        const newArticleId = result.lastID;
         // get all the followers
        const followers = await getFollowersByUserId(req.user.id);
       
        await createNotificationsForFollowers(newArticleId, followers);
 
        res.status(201).json({
            message: 'Article added successfully',
            articleId: newArticleId,
        });
    } catch (error) {
        if (error.name === 'ValidationError') {
            return res.status(400).json({
                message: 'Validation failed',
                errors: error.errors,
            });
        }
        console.error('Error adding article:', error);
        res.status(500).json({
            message: 'Internal server error',
        });
    }
});

// Route to update an article, handling both JSON and form-data content types.
router.patch('/update/:id', upload.single('image'), requiresAuthentication, async (req, res) => {
    const articleId = req.params.id;
    let articleData;

    // Handle multipart/form-data for image uploads, and JSON for non-image updates.
    if (req.is('multipart/form-data')) {
        articleData = req.body;
    } else if (req.is('application/json')) {
        articleData = req.body;
    } else {
        return res.status(400).json({ message: 'Unsupported content type' });
    }
    try {
        const existingArticle = await getArticleById(articleId);
        if (!existingArticle) {
            return res.status(404).json({ message: 'Article not found' });
        }
        if (existingArticle.userid !== req.user.id) {
            return res.status(403).json({ message: 'You are not authorized to edit this article' });
        }

        // Update image if a new one is uploaded, or remove it if specified.
        if (req.file) {
            articleData.image = `images/${req.file.filename}`;
            if (existingArticle.image) {
                const oldImagePath = path.join(process.cwd(), 'public', existingArticle.image);
                if (fs.existsSync(oldImagePath)) {
                    fs.unlinkSync(oldImagePath);
                }
            }
        } else if (articleData.removeImage === 'true') {
            articleData.image = null;
            if (existingArticle.image) {
                const oldImagePath = path.join(process.cwd(), existingArticle.image);
                if (fs.existsSync(oldImagePath)) {
                    fs.unlinkSync(oldImagePath);
                }
            }
        } else {
            articleData.image = existingArticle.image;
        }

        await articleSchema.validate(articleData, { abortEarly: false });

        const updatedArticle = await updateArticle(articleId, articleData);

        res.json({
            message: 'Article updated successfully',
            article: updatedArticle
        });
    } catch (error) {
        if (error.name === 'ValidationError') {
            return res.status(400).json({
                message: 'Validation failed',
                errors: error.errors,
            });
        }
        console.error('Error updating article:', error);
        res.status(500).json({
            message: 'Internal server error',
        });
    }
});

// Route to delete an article, ensuring user authorization and image removal.
router.delete('/delete/:id', requiresAuthentication, async (req, res) => {
    const articleId = req.params.id;
    try {
        // Check if the article exists and if the user has permission to delete it.
        const article = await getArticleById(articleId);
        if (!article) {
            return res.status(404).json({ message: "Article not found" });
        }
        if (article.userid !== req.user.id) {
            return res.status(403).json({ message: "You are not authorized to delete this article" });
        }

        const result = await deleteArticle(articleId);
        if (result.success) {
            res.status(200).json({ message: result.message });
        } else {
            res.status(400).json({ message: result.message });
        }
    } catch (error) {
        console.error('Error deleting article:', error);
        res.status(500).json({ message: 'Internal server error, failed to delete article' });
    }
});

// Get the number of likes for an article.
router.get('/:id/likes', async (req, res) => {
    try {
        const likes = await getArticleLikes(req.params.id);
        res.json({ likes });
    } catch (error) {
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Check if the authenticated user has liked the article.
router.get('/:id/like', requiresAuthentication, async (req, res) => {
    try {
        const hasLiked = await checkUserLike(req.user.id, req.params.id);
        const likes = await getArticleLikes(req.params.id);
        res.json({ hasLiked, likes });
    } catch (error) {
        console.error("Error checking like status:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Toggle like/unlike status for an article.
router.post('/:id/like', requiresAuthentication, async (req, res) => {
    try {
        const hasLiked = await checkUserLike(req.user.id, req.params.id);
        if (hasLiked) {
            await removeLike(req.user.id, req.params.id);
        } else {
            await addLike(req.user.id, req.params.id);
        }
        const newLikes = await getArticleLikes(req.params.id);
        res.json({ likes: newLikes, hasLiked: !hasLiked });
    } catch (error) {
        console.error("Error toggling like:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

export default router;
