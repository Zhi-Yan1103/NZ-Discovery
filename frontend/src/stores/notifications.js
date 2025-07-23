import { writable } from 'svelte/store';
import { PUBLIC_API_BASE_URL } from "$env/static/public";

// Store for tracking the number of unread notifications
export const unreadCount = writable(0);

/**
 * Fetches all notifications for the current user
 * @returns {Promise<Array>} Array of notification objects
 * @throws {Error} If the API request fails
 */
export async function fetchNotifications() {
    try {
        const response = await fetch(`${PUBLIC_API_BASE_URL}/user/notifications`, {
            credentials: "include"
        });
        if (!response.ok) {
            throw new Error(`Failed to fetch notifications: ${response.status} ${response.statusText}`);
        }
        return await response.json();
    } catch (err) {
        console.error('Error fetching notifications:', err);
        throw err;
    }
}

/**
 * Fetches notification counts (read/unread) and updates the unreadCount store
 * @returns {Promise<Object>} Object containing notification counts
 * @throws {Error} If the API request fails
 */
export async function fetchNotificationCounts() {
    try {
        const response = await fetch(`${PUBLIC_API_BASE_URL}/user/notifications/counts`, {
            credentials: "include"
        });
        if (!response.ok) {
            throw new Error(`Failed to fetch notification counts: ${response.status} ${response.statusText}`);
        }
        const counts = await response.json();
        // Update the unreadCount store with the new count, defaulting to 0 if null
        unreadCount.set(counts.unreadCount ?? 0);
        return counts;
    } catch (err) {
        console.error('Error fetching notification counts:', err);
        throw err;
    }
}

/**
 * Marks a specific notification as read
 * @param {string|number} notificationId
 * @returns {Promise<void>}
 * @throws {Error} If the API request fails
 */
export async function markAsRead(notificationId) {
    try {
        const response = await fetch(`${PUBLIC_API_BASE_URL}/user/notifications/${notificationId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'include'
        });
        if (!response.ok) {
            throw new Error('Failed to mark notification as read');
        }
        await fetchNotificationCounts();
    } catch (err) {
        console.error('Error marking notification as read:', err);
        throw err;
    }
}