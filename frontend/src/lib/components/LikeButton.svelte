<script>
  import { createEventDispatcher } from "svelte";
  import { onMount } from "svelte";
  import { ARTICLES_URL } from "$lib/js/api-urls";

  export let articleId;
  export let isLoggedIn;

  const dispatch = createEventDispatcher();

  // Initial state for likes and loading status
  let likes = 0;
  let hasLiked = false;
  let isLoading = true;

  // Fetch like status when component mounts
  onMount(async () => {
    await loadLikeStatus();
  });

  // Load the current like status of the article
  async function loadLikeStatus() {
    isLoading = true;
    try {
      // Fetch data based on login status
      const url = isLoggedIn
        ? `${ARTICLES_URL}/${articleId}/like`
        : `${ARTICLES_URL}/${articleId}/likes`;

      const response = await fetch(url, { credentials: "include" });

      if (response.ok) {
        const data = await response.json();
        likes = data.likes;
        hasLiked = isLoggedIn ? data.hasLiked : false;
      } else {
        console.error("Failed to load like status:", response.statusText);
      }
    } catch (error) {
      console.error("Error loading like status:", error);
    } finally {
      isLoading = false;
    }
  }

  // Handle like/unlike functionality
  async function handleLike() {
    if (!isLoggedIn) {
      alert("Please log in first");
      return;
    }

    try {
      const response = await fetch(`${ARTICLES_URL}/${articleId}/like`, {
        method: "POST",
        credentials: "include"
      });

      if (response.ok) {
        const data = await response.json();
        likes = data.likes;
        hasLiked = data.hasLiked;
        dispatch("likeUpdated", { likes, hasLiked });
      } else {
        console.error("Failed to update like status:", response.statusText);
      }
    } catch (error) {
      console.error("Error while updating like status:", error);
    }
  }
</script>

<div class="like-section">
  {#if isLoading}
    <span>Loading...</span>
  {:else if isLoggedIn}
    <button on:click={handleLike} class:liked={hasLiked}>
      {#if hasLiked}
        ❤️
      {:else}
        🤍
      {/if}
    </button>
  {:else}
    <span class="heart-icon">🤍</span>
  {/if}
  <span class="likes-count">{likes}</span>
</div>

<style>
  .like-section {
    display: inline-flex;
    align-items: center;
    gap: 5px;
  }

  .like-section button,
  .heart-icon {
    font-size: 24px;
    background: none;
    border: none;
    cursor: pointer;
    transition: transform 0.2s;
    display: flex;
    align-items: center;
    padding: 0;
    margin: 0;
  }

  .like-section button:hover {
    transform: scale(1.1);
  }

  .liked {
    color: red;
  }

  .heart-icon {
    cursor: default;
    opacity: 0.7;
  }

  .likes-count {
    font-size: 16px;
    font-weight: bold;
  }
</style>
