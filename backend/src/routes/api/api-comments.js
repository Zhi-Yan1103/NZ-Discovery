import express from 'express';
import {
    addComment,
    getCommentsByArticleId,
    deleteComment,
    getCommentById,
} from '../../data/comments-dao.js';
import { requiresAuthentication } from '../../middleware/auth-middleware.js';
import { getArticleById } from '../../data/articles-dao.js';

const router = express.Router();

// Add a new comment
router.post('/', requiresAuthentication, async (req, res) => {
    const { content, parentId, articleId } = req.body;
    const userId = req.user.id;

    if (content.length > 140) {
        return res.status(400).json({ message: "Comment cannot exceed 140 characters." });
    }

    try {
        const newComment = await addComment(articleId, userId, content, parentId);
        const commentWithUserInfo = { 
            ...newComment, 
            username: req.user.username,
            avatar_url: req.user.avatar_url
        };
        res.status(201).json(commentWithUserInfo);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Get all comments for an article
router.get('/article/:articleId', async (req, res) => {
    const { articleId } = req.params;
    try {
        const comments = await getCommentsByArticleId(articleId);
        res.status(200).json(comments);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Delete a comment
router.delete('/:commentId', requiresAuthentication, async (req, res) => {
    const { commentId } = req.params;
    const userId = req.user.id;

    try {
        const comment = await getCommentById(commentId);
        if (!comment) {
            return res.status(404).json({ message: "Comment not found" });
        }

        const article = await getArticleById(comment.article_id);
        if (!article) {
            return res.status(404).json({ message: "Article not found" });
        }

        if (comment.userid !== userId && article.userid !== userId) {
            return res.status(403).json({ message: "You don't have permission to delete this comment" });
        }

        await deleteComment(commentId);
        res.status(200).json({ message: "Comment deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

export default router;