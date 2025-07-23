import { USER_URL, ARTICLES_URL } from "$lib/js/api-urls.js";

/**
 * Load function to fetch shared data across all pages
 * This includes:
 * 1. User authentication status and user data
 * 2. All articles for the application
 * 
 * @param {Object} params - Contains fetch function for making HTTP requests
 * @returns {Object} Object containing user data, login status, and articles
 */
export async function load({ fetch }) {
    let user, isLoggedIn;

    // Attempt to fetch user information and determine login status
    try {
        const response = await fetch(USER_URL, {
            credentials: "include",
            cache: "no-store"  // Disable cache for real-time updates
        });
        if (response.status === 401) {
            isLoggedIn = false;
        } else {
            user = await response.json();
            isLoggedIn = true;
        }
    } catch (error) {
        console.error("Error fetching user info:", error);
        isLoggedIn = false;
    }

    // Fetch all articles for the application
    let articles = [];
    try {
        const articlesResponse = await fetch(ARTICLES_URL);
        if (articlesResponse.ok) {
            articles = await articlesResponse.json();
        } else {
            console.error("Failed to fetch articles, status code:", articlesResponse.status);
        }
    } catch (error) {
        console.error("Error fetching articles:", error);
    }

    return { user, isLoggedIn, articles };
}
