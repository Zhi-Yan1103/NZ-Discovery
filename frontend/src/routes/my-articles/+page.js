import { PUBLIC_API_BASE_URL } from '$env/static/public';

// Load function to fetch the user's articles and handle errors
export async function load({ fetch }) {
  try {
    const response = await fetch(`${PUBLIC_API_BASE_URL}/articles/myarticles`, { credentials: "include" });
    if (!response.ok) {
      throw new Error('Failed to fetch articles');
    }

    const myarticles = await response.json();
    return {
      myarticles
    };
  } catch (error) {
    console.error('Error loading articles:', error);
    return {
      myarticles: [],
      error: 'Failed to load articles. Please try again later.'
    };
  }
}