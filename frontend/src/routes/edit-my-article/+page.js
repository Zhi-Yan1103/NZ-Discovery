import { PUBLIC_API_BASE_URL } from '$env/static/public';

// Load function to fetch article data based on the provided article ID
export async function load({ fetch, url }) {
    const articleId = url.searchParams.get('id'); // Get article ID from URL parameters

    if (!articleId) {
        return {
            status: 400,
            error: new Error('Article ID is missing'),
        };
    }
    try {
        const response = await fetch(`${PUBLIC_API_BASE_URL}/articles/article/${articleId}`);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const article = await response.json();
        return { article };
    } catch (error) {
        console.error('Error loading article:', error);
        return {
            status: 500,
            error: new Error('Failed to load article data'),
        };
    }
}