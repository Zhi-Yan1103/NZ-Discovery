import { requiresAuthentication } from "../../middleware/auth-middleware.js";
import { createNotificationsForFollowers, getNotificationCounts, getNotificationsByUserId, markNotificationAsRead } from "../../data/notification-dao.js";
import { getFollowersByUserId } from "../../data/users-dao.js";
import express from 'express';
const router = express.Router();

// 1. Get all notifications for the authenticated user
router.get('/', requiresAuthentication, async (req, res) => {
    const userId = req.user.id;
    try {
        const notifications = await getNotificationsByUserId(userId); 
        res.status(200).json(notifications);
    } catch (error) {
        console.error('Error retrieving notifications:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 2. Mark a specific notification as read
router.put('/:notifyId', requiresAuthentication, async (req, res) => {
    const notifyId = req.params.notifyId; // 从请求参数获取通知 ID
    try {
        await markNotificationAsRead(notifyId); // 标记通知为已读
        res.status(200).json({ message: 'Notification marked as read' });
    } catch (error) {
        console.error('Error marking notification as read:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 3. Create notifications for all followers when a new article is posted
router.post('/', requiresAuthentication, async (req, res) => {
    const { articleId } = req.body; // 从请求体获取文章 ID
    const userId = req.user.id;

    try {
        const followers = await getFollowersByUserId(userId);
        await createNotificationsForFollowers(articleId, followers);
        res.status(201).json({ message: 'Notifications created for followers' });
    } catch (error) {
        console.error('Error creating notifications:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 4. Get notification counts for the authenticated user
router.get('/counts', requiresAuthentication, async (req, res) => {
    try {
        const userId = req.user.id; 
        const counts = await getNotificationCounts(userId);
        res.json(counts);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
export default router;   