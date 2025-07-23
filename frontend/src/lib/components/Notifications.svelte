<script>
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";
  import {
    unreadCount,
    fetchNotifications,
    fetchNotificationCounts,
    markAsRead
  } from "../../stores/notifications.js";

  let notifications = [];
  let loading = true;
  let error = null;
  let totalCount = 0;
  let localUnreadCount = 0;
  $: localUnreadCount = $unreadCount;

 // Fetch notifications when the component mounts.
  onMount(async () => {
    try {
        loading = true;
        let notificationsData = await fetchNotifications();
        notifications = notificationsData.sort((a, b) => {
            return new Date(b.create_date) - new Date(a.create_date);
        });
        const counts = await fetchNotificationCounts();
        totalCount = counts.totalCount ?? 0;
    } catch (err) {
        error = `An error occurred: ${err.message}`;
    } finally {
        loading = false;
    }
});
// Updating the notification state both locally and in the store.
  async function handleMarkAsRead(notificationId) {
    try {
      const notif = notifications.find((n) => n.id === notificationId);
      if (notif) {
        notif.is_read = true; // update local state

        await markAsRead(notificationId);

        notifications = [...notifications]; // trigger UI update
        const counts = await fetchNotificationCounts();
        totalCount = counts.totalCount ?? 0;
      }
    } catch (err) {
        error = "Failed to mark notification as read. Please try again later.";
    }
  }
</script>

{#if loading}
<div class="status-message">Loading...</div>
{:else if error}
<div class="status-message error">{error}</div>
{:else if notifications.length === 0}
<div class="status-message">No notifications</div>
{:else}
<!-- Render the list of notifications when available -->
<div class="notifications-list">
    {#each notifications as notif (notif.id)}
        <div class="notification-item" transition:fade>
            <div class="notification-content">
                <div class="message-wrapper">
                    <!-- Display notification message, bold if unread -->
                    <div class="message" style="font-weight: {notif.is_read ? 'normal' : 'bold'}">
                        <span>{notif.username}</span> published a new article on {notif.create_date}:
                        <a href="/articles/{notif.article_id}">{notif.title}</a>
                    </div>
                    <div class="action-button">
                        {#if notif.is_read}
                            <i class="fas fa-check-circle"></i>
                        {:else}
                            <button on:click={() => handleMarkAsRead(notif.id)}>
                                Mark as Read
                            </button>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    {/each}
</div>
{/if}
<style>
    .notifications-list {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .notification-item {
        padding: 12px;
        background-color: #f8f9fa;
        border-radius: 8px;
    }

    .notification-content {
        width: 100%;
    }

    .message-wrapper {
        display: flex;
        justify-content: space-between;
        align-items:  center;
        gap: 12px;
    }

     .message {
        flex: 1;
        min-width: 0;
        word-wrap: break-word;
        
    }

    .message span {
        color: #2c3e50;
    }

    .message a {
        color: #007bff;
        text-decoration: none;
    }

    .message a:hover {
        text-decoration: underline;
    }

    .action-button {
        flex-shrink: 0;
        white-space: nowrap;
        align-self: flex-end;
    }
    button {
        background: none;
        border: none;
        color: #dc3545;
        font-size: 14px;
        cursor: pointer;
        padding: 4px 8px;
    }

    button:hover {
        text-decoration: underline;
    }

    .fa-check-circle {
        color: #28a745;
    }

    .status-message {
        padding: 12px;
        text-align: center;
        color: #666;
    }

    .error {
        color: #dc3545;
    }
</style>
