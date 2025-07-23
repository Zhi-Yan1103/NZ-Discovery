import { ARTICLES_URL } from "$lib/js/api-urls";

// Load function to fetch articles from the API
export async function load({ fetch }) {
    try {
        const response = await fetch(ARTICLES_URL);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const articles = await response.json();
        return { articles };
    } catch (error) {
        console.error('Error loading articles:', error);
        return { articles: [], error: error.message };
    }
}
