<script>
  import { createEventDispatcher } from "svelte";

  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import { PUBLIC_URL } from "$env/static/public";
  import ConfirmInformation from "./ConfirmInformation.svelte";

  export let comment;
  export let currentUserId;
  export let articleAuthorId;
  export let level = 0;

  const dispatch = createEventDispatcher();

  let showReplyForm = false;
  let replyContent = "";
  let showConfirmDialog = false;

  // Format a date string into a readable format
  function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString("en-NZ", { dateStyle: "medium", timeStyle: "medium" });
  }
  // Toggle the visibility of the reply form
  function toggleReplyForm() {
    showReplyForm = !showReplyForm;
  }

  async function submitReply() {
    if (replyContent.trim().length === 0 || replyContent.length > 140) return;
  // Send a POST request to create a new reply
    const response = await fetch(`${PUBLIC_API_BASE_URL}/comments`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        content: replyContent,
        parentId: comment.id,
        articleId: comment.article_id
      }),
      credentials: "include"
    });
 // If the request is successful, update the comments list
    if (response.ok) {
      const newReply = await response.json();
      newReply.create_date = formatDate(newReply.create_date);
      newReply.avatar_url = getAvatarUrl(newReply.avatar_url);
      if (!comment.replies) comment.replies = [];
      comment.replies = [newReply, ...comment.replies];
      dispatch("commentAdded", newReply);
      replyContent = "";
      showReplyForm = false;
    }
  }

  function confirmDelete() {
    showConfirmDialog = true;
  }

  async function handleConfirmDelete() {
    showConfirmDialog = false;
 // Send a DELETE request to remove the comment
    const response = await fetch(`${PUBLIC_API_BASE_URL}/comments/${comment.id}`, {
      method: "DELETE",
      credentials: "include" 
    });

    if (response.ok) {
      dispatch("commentDeleted", comment.id); // Dispatch an event for comment deletion
    }
  }

  function handleCancelDelete() {
    showConfirmDialog = false;
  }

  function getAvatarUrl(avatarUrl) {
    if (!avatarUrl) {
      return `${PUBLIC_URL}/images/default-avatar.png`;
    }
    return avatarUrl.startsWith("http") ? avatarUrl : `${PUBLIC_URL}/${avatarUrl}`;
  }
</script>
<!-- Main structure of the comment component -->
<div class="comment" style="margin-left: {level * 16}px;">
  <div class="comment-header">
    <!-- Display the user's avatar -->
    <img src={getAvatarUrl(comment.avatar_url)} alt="{comment.username}'s avatar" class="avatar" />
    <div class="comment-info">
      <strong>{comment.username}</strong>
      <span class="comment-date">{formatDate(comment.create_date)}</span>
    </div>
  </div>
  <p class="comment-content">{comment.content}</p>

  <div class="comment-actions">
    {#if currentUserId && level < 3}
      <button on:click={toggleReplyForm} class="action-button">Reply</button>
    {/if}

    {#if currentUserId === comment.userid || currentUserId === articleAuthorId}
      <button on:click={confirmDelete} class="action-button delete-button">Delete</button>
    {/if}
  </div>

  {#if showReplyForm}
    <div class="reply-form">
      <textarea bind:value={replyContent} maxlength="140" placeholder="Write your reply..."
      ></textarea>
      <button on:click={submitReply} class="submit-button">Submit Reply</button>
    </div>
  {/if}
 <!-- If there are replies, recursively display them -->
  {#if comment.replies && comment.replies.length > 0}
    {#each comment.replies as reply (reply.id)}
      <svelte:self
        comment={reply}
        {currentUserId}
        {articleAuthorId}
        level={level + 1}
        on:commentAdded
        on:commentDeleted
      />
    {/each}
  {/if}

  {#if showConfirmDialog}
  <!-- Delete confirmation dialog -->
    <ConfirmInformation
      message="Are you sure you want to delete this comment?"
      onConfirm={handleConfirmDelete}
      onCancel={handleCancelDelete}
    />
  {/if}
</div>

<style>
  .comment {
    background-color: #ffffff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    padding: 16px;
    margin-bottom: 16px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  }

  .comment-header {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
  }

  .avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 12px;
    object-fit: cover;
  }

  .comment-info {
    display: flex;
    flex-direction: column;
  }

  .comment-info strong {
    font-size: 1em;
    color: #333;
  }

  .comment-date {
    font-size: 0.85em;
    color: #888;
  }

  .comment-content {
    margin: 12px 0;
    font-size: 1em;
    line-height: 1.5;
    color: #444;
    white-space: pre-wrap;
    word-wrap: break-word;
    max-width: 100%;
  }

  .comment-actions {
    display: flex;
    justify-content: flex-start;
    gap: 12px;
    margin-top: 12px;
  }

  .action-button {
    background-color: transparent;
    border: none;
    padding: 6px 10px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9em;
    transition: background-color 0.2s;
    color: #666;
  }

  .action-button:hover {
    background-color: #f0f0f0;
  }

  .delete-button {
    color: #d32f2f;
  }

  .reply-form {
    margin-top: 12px;
  }

  textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
    resize: vertical;
    min-height: 70px;
    font-size: 0.95em;
    white-space: pre-wrap;
    word-wrap: break-word;
  }

  .submit-button {
    background-color: #2196f3;
    color: white;
    border: none;
    padding: 8px 14px;
    border-radius: 4px;
    cursor: pointer;
    margin-top: 10px;
    font-size: 0.9em;
    transition: background-color 0.2s;
  }

  .submit-button:hover {
    background-color: #1976d2;
  }
</style>