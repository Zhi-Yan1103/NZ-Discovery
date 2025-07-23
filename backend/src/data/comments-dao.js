import { getDatabase } from './database.js';

/**
 * Creates a new comment for an article
 * @param {number} articleId - ID of the article
 * @param {number} userId - ID of the commenting user
 * @param {string} content - Comment content
 * @param {number|null} parentId - ID of parent comment for nested comments
 */
export async function addComment(articleId, userId, content, parentId = null) {
    const db = await getDatabase();
    const result = await db.run(
        `INSERT INTO comments (article_id, userid, content, parent_id) 
         VALUES (?, ?, ?, ?)`,
        [articleId, userId, content, parentId]
    );
    return getCommentById(result.lastID);
}

/**
 * Retrieves all comments for a specific article with user details
 * @param {number} articleId - ID of the article
 */
export async function getCommentsByArticleId(articleId) {
    const db = await getDatabase();
    return await db.all(
        `SELECT comments.*, users.username, users.avatar_url
         FROM comments 
         JOIN users ON comments.userid = users.id
         WHERE article_id = ? 
         ORDER BY create_date ASC`,
        articleId
    );
}

/**
 * Retrieves a single comment by its ID
 * @param {number} commentId - ID of the comment
 */
export async function getCommentById(commentId) {
    const db = await getDatabase();
    return await db.get('SELECT * FROM comments WHERE id = ?', commentId);
}
/**
 * Removes a comment from the database
 * @param {number} commentId - ID of the comment to delete
 */
export async function deleteComment(commentId) {
    const db = await getDatabase();
    return await db.run('DELETE FROM comments WHERE id = ?', commentId);
}

