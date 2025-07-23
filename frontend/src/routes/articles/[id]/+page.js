import { ARTICLES_URL } from "$lib/js/api-urls";

/**
 * Load function to fetch a specific article based on its ID.
 * @param {Object} params - The parameters from the route, including the article ID.
 * @param {Function} fetch - The fetch function to make API requests.
 * @returns {Object} - Returns the article data or an error message if the fetch fails.
 */
export async function load({ params, fetch }) {
    try {
        console.log("Fetching article with id:", params.id);
        const articleResponse = await fetch(`${ARTICLES_URL}/${params.id}`);

        if (!articleResponse.ok) {
            throw new Error(`HTTP error! status: ${articleResponse.status}`);
        }
        const article = await articleResponse.json();
        return { article };
    } catch (error) {
        console.error('Error loading article:', error);
        return { article: null, error: error.message };
    }
}
