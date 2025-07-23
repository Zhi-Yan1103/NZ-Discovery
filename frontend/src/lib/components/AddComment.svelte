<script>
  // Import Svelte's event dispatcher and public environment variables
  import { createEventDispatcher } from "svelte";
  import { PUBLIC_API_BASE_URL, PUBLIC_URL } from "$env/static/public";
 
  // Accept the article ID as a prop from the parent component
  export let articleId;

 // Create an event dispatcher for sending events from this component
  const dispatch = createEventDispatcher();

  let content = "";

 // Function to format the date string into a readable format
  function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString("en-NZ", { dateStyle: "medium", timeStyle: "medium" });
  }
 // Get the user's avatar URL
  function getAvatarUrl(avatarUrl) {
    if (!avatarUrl) {
      return `${PUBLIC_URL}/images/default-avatar.png`;
    }
    return avatarUrl.startsWith("http") ? avatarUrl : `${PUBLIC_URL}/${avatarUrl}`;
  }
 
  // Send a POST request to the comments API to add a new comment
  async function submitComment() {
    if (content.trim().length === 0 || content.length > 140) return;

    const response = await fetch(`${PUBLIC_API_BASE_URL}/comments`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ content, articleId }),
      credentials: "include"
    });

    if (response.ok) {
      const newComment = await response.json();
      newComment.create_date = formatDate(newComment.create_date);
      newComment.avatar_url = getAvatarUrl(newComment.avatar_url);
      newComment.replies = [];
      dispatch("commentAdded", newComment);  // Dispatch the 'commentAdded' event with the new comment data
      content = "";
    } else {
      console.error("Failed to add comment");
    }
  }
</script>

<div class="add-comment">
  <textarea bind:value={content} maxlength="140" placeholder="Add a comment (max 140 characters)"
  ></textarea>
  <button on:click={submitComment}>Submit Comment</button>
</div>

<style>
  .add-comment {
    margin-top: 24px;
    margin-bottom: 24px;
  }

  textarea {
    width: 100%;
    min-height: 70px;
    margin-bottom: 12px;
    padding: 10px;
    resize: vertical;
    white-space: pre-wrap;
    word-wrap: break-word;
    font-size: 0.95em;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
  }
</style>
