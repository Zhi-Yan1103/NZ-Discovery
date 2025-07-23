import { writable } from 'svelte/store';
import { fetchNotificationCounts } from './notifications.js';
import { unreadCount } from './notifications.js';

/**
 * Store for managing user state and related data
 * Contains user information and notification counts
 */
export const userStore = writable({
    user: null,      // Current user object or null if not logged in
    notificationCount: 0  // Number of unread notifications
});

/**
 * Updates both user state and notification counts
 * @param {Object|null} user - User object or null when logging out
 * @param {number} count - Number of unread notifications
 */
export function updateUserAndNotifications(user, count) {
    if (user === null) {
        // Reset notification count when user logs out
        unreadCount.set(0);
    } else {
        // Update notification count for logged-in user
        unreadCount.set(count);
    }
}

/**
 * Initializes user data and fetches their notification counts
 * @param {Object|null} user - User object or null
 * @returns {Promise<void>}
 */
export async function initializeUserAndNotifications(user) {
    if (user) {
        // If user is logged in, fetch their notification counts
        try {
            const counts = await fetchNotificationCounts();
            unreadCount.set(counts.unreadCount || 0);
        } catch (error) {
            console.error('Error initializing notifications:', error);
        }
    } else {
        // Reset notification count for logged-out state
        unreadCount.set(0);
    }
}
