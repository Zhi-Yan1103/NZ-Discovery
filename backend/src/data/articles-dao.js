import { getDatabase } from "./database.js";
import yup from "yup";
import fs from 'fs';
import path from 'path';

/**
 * Validation schema for article data
 * Defines required fields and their constraints
 */
export const articleSchema = yup.object().shape({
    title: yup.string()
        .required('Title is required.'),
    content: yup.string()
        .required('Content is required.'),
    image: yup.string()
        .nullable()       // could be null
        .notRequired(),    
    userid: yup.number()
        .nullable() 
        .positive('User ID must be a positive number.')
        .integer('User ID must be an integer.'),
});

export async function getAllArticles(sortBy = "date", sortOrder = "desc") {
    const db = await getDatabase();
    const validSortBy = ["title", "username", "date"];
    const validSortOrder = ["asc", "desc"];

    if (!validSortBy.includes(sortBy)) sortBy = "date";
    if (!validSortOrder.includes(sortOrder)) sortOrder = "desc";

    const sql = `
        SELECT articles.*, users.username as username, users.avatar_url as author_avatar
        FROM articles
        JOIN users ON articles.userid = users.id
        ORDER BY ${sortBy === "date" ? "articles.create_date" : sortBy} ${sortOrder}
    `;
    return await db.all(sql);
};

export async function getArticleById(id) {
    const db = await getDatabase();
        const article = await db.get(`
            SELECT articles.*, users.username, users.username as author, users.avatar_url as author_avatar
            FROM articles 
            JOIN users ON articles.userid = users.id 
            WHERE articles.id = ?
        `, id);
        return article || null;
    };

export async function getUserArticles(userId) {
    const db = await getDatabase();
    const sql = `
        SELECT articles.*, users.username as username, users.avatar_url as author_avatar
        FROM articles
        JOIN users ON articles.userid = users.id
        WHERE articles.userid = ?
        ORDER BY articles.create_date DESC
    `;
    return await db.all(sql, userId);
};

/**
 * Article management operations
 * Handles CRUD operations with additional features like image handling
 */
export async function addArticles(articleData) {
    try {
        await articleSchema.validate(articleData, { abortEarly: false });
        const db = await getDatabase();
        const sql = `INSERT INTO articles (title, content, image, userid)
            VALUES (?, ?, ?, ?)`;
        const { title, content, image } = articleData;
        const userid = articleData.userid;
        const result = await db.run(sql, title, content, image || null, userid);
        return result;
    } catch (error) {
        if (error.name === 'ValidationError') {
            console.error('Validation errors:', error.errors);
        } else {
            console.error('Error adding article:', error);
        }
    }
};

export async function deleteArticle(articleId) {
    try {
        const db = await getDatabase();
        const article = await db.get('SELECT * FROM articles WHERE id = ?', articleId);
        if (!article) {
            return { success: false, message: 'No article found with the specified ID.' };
        }
    
        const result = await db.run('DELETE FROM articles WHERE id = ?', articleId);

        if (result.changes > 0) {
            // If the article has associated images, delete the image files.
            if (article.image) {
                const imagePath = path.join(process.cwd(), 'uploads', article.image);
                if (fs.existsSync(imagePath)) {
                    fs.unlinkSync(imagePath);
                }
            }
            return { success: true, message: 'Article and associated image deleted successfully.' };
        } else {
            return { success: false, message: 'Failed to delete the article.' };
        }
    } catch (error) {
        console.error('Error deleting article:', error);
        throw new Error('Failed to delete the article. Please try again later.');
    }
};

export async function updateArticle(articleId, articleData) {
    const db = await getDatabase();
    const { title, content, image } = articleData;

    const sql = `
        UPDATE articles
        SET title = ?, content = ?, image = ?
        WHERE id = ?
    `;

    await db.run(sql, [title, content, image, articleId]);
    return await getArticleById(articleId);
}

// search articles by title, content, or username
export async function searchArticles(query, sortBy = "date", sortOrder = "desc") {
    const db = await getDatabase();
    const validSortBy = ["title", "username", "date"];
    const validSortOrder = ["asc", "desc"];

    if (!validSortBy.includes(sortBy)) sortBy = "date";
    if (!validSortOrder.includes(sortOrder)) sortOrder = "desc";

    const sql = `
        SELECT articles.*, users.username as username, users.avatar_url as author_avatar
        FROM articles
        JOIN users ON articles.userid = users.id
        WHERE LOWER(articles.title) LIKE LOWER(?) 
        OR LOWER(articles.content) LIKE LOWER(?) 
        OR LOWER(users.username) LIKE LOWER(?)
        ORDER BY ${sortBy === "date" ? "articles.create_date" : sortBy} ${sortOrder}
    `;

    const searchTerm = `%${query}%`;
    const params = [searchTerm, searchTerm, searchTerm];

    console.log("Executing search with query:", query);
    const articles = await db.all(sql, params);

    // case-insensitive search
    articles.forEach(article => {
        if (
            article.title.toLowerCase().includes(query.toLowerCase()) ||
            article.content.toLowerCase().includes(query.toLowerCase()) ||
            article.username.toLowerCase().includes(query.toLowerCase())
        ) {
            console.log(`Matched article: "${article.title}" (matched in ${article.title.toLowerCase().includes(query.toLowerCase()) ? 'title' :
                article.content.toLowerCase().includes(query.toLowerCase()) ? 'content' :
                    'username'
                })`);
        }
    });


    return articles;
}

/**
 * Like-related operations
 * Manages article likes functionality
 */
export async function getArticleLikes(articleId) {
    const db = await getDatabase();
    const result = await db.get('SELECT likes FROM articles WHERE id = ?', articleId);
    return result ? result.likes : 0;
}

// check if the user has likes the article
export async function checkUserLike(userId, articleId) {
    const db = await getDatabase();
    const result = await db.get('SELECT * FROM likes WHERE userid = ? AND article_id = ?', [userId, articleId]);
    return !!result;
}

// add a like
export async function addLike(userId, articleId) {
    const db = await getDatabase();
    await db.run('INSERT INTO likes (userid, article_id) VALUES (?, ?)', [userId, articleId]);
    await db.run('UPDATE articles SET likes = likes + 1 WHERE id = ?', articleId);
}

// remove a like
export async function removeLike(userId, articleId) {
    const db = await getDatabase();
    await db.run('DELETE FROM likes WHERE userid = ? AND article_id = ?', [userId, articleId]);
    await db.run('UPDATE articles SET likes = likes - 1 WHERE id = ?', articleId);
}
