import { PUBLIC_API_BASE_URL } from "$env/static/public";

// Used for getting / updating info about the currently authenticated user
export const USER_URL = `${PUBLIC_API_BASE_URL}/users/me`;
export const USERS_URL = `${PUBLIC_API_BASE_URL}/users`;
export const ARTICLES_URL = `${PUBLIC_API_BASE_URL}/articles`;

// Used for logging in and out
export const AUTH_URL = `${PUBLIC_API_BASE_URL}/auth`;
