import { getDatabase } from "./database.js";

// 1. Create notifications for all followers of a user when a new article is posted
export async function createNotificationsForFollowers(articleId, followers) {
    const db = await getDatabase(); 
    const sqlInsertNotify = `INSERT INTO notify (article_id, userid, is_read) VALUES (?, ?, FALSE)`; 

    if (followers.length === 0) {
        console.log('No followers to notify');
        return; 
    }

    try {
        const insertPromises = followers.map(follower => {
            return db.run(sqlInsertNotify, [articleId, follower.id]);
        });

        await Promise.all(insertPromises); 
        console.log(`Notifications created for ${followers.length} followers.`);
    } catch (error) {
        console.error('Error creating notifications:', error);
    }
}

// 2. Get all notifications for a specific user by their user ID
export async function getNotificationsByUserId(userId) {
    const db = await getDatabase();
    const sql = `
        SELECT n.id,n.article_id, n.userid, n.is_read, a.title,a.create_date,
        u.username
        FROM notify n
        JOIN articles a ON n.article_id = a.id
        JOIN users u ON a.userid = u.id
        WHERE n.userid = ?
        ORDER BY n.article_id DESC
    `;
    const notifications = await db.all(sql, userId); // get all notifications
    return notifications;
};

// 3. Mark a specific notification as read using its notification ID
export async function markNotificationAsRead(notifyId) {
    const db = await getDatabase();
    const sql = `UPDATE notify SET is_read = TRUE WHERE id = ?`; 
    await db.run(sql, notifyId); 
};

// 4. Get the total and unread counts of notifications for a specific user
export async function getNotificationCounts(userId) {
    const db = await getDatabase();
    const sql = `
        SELECT 
            COUNT(*) as total_count,
            SUM(CASE WHEN is_read = FALSE THEN 1 ELSE 0 END) as unread_count
        FROM notify
        WHERE userid = ?
    `;
    const result = await db.get(sql, userId);
    return {
        totalCount: result.total_count,
        unreadCount: result.unread_count
    };
}