<script>
  import LikeButton from "$lib/components/LikeButton.svelte";
  import { PUBLIC_URL } from "$env/static/public";
  import { page } from "$app/stores";
  export let article;
  export let isLoggedIn;
  export let isFollowing;
  export let toggleFollow;
  export let editArticle;
  export let deleteArticle;

  function getAvatarUrl(author_avatar) {
    // Return default avatar if none provided
    if (!author_avatar) {
      return `${PUBLIC_URL}images/default-avatar.jpg`;
    }
    // Return the avatar URL if it starts with http or https
    if (author_avatar.startsWith("http://") || author_avatar.startsWith("https://")) {
      return author_avatar;
    }
    // Construct the avatar URL
    return `${PUBLIC_URL}${author_avatar}`;
  }

  // Reactive property for author information
  $: authorInfo = {
    username: article.username || "Unknown",
    avatarUrl: getAvatarUrl(article.author_avatar)
  };
</script>

<header>
  <div class="title-like-container">
    <h1>{article.title}</h1>
    <div class="like-button-container">
      <LikeButton articleId={article.id} {isLoggedIn} />
    </div>
  </div>
  <div class="article-meta">
    <div class="author-info">
      <img class="author-avatar" src={authorInfo.avatarUrl} alt="{authorInfo.username} Avatar" />
      <div>
        <p class="article-author">
          Author: {authorInfo.username}
          {#if isLoggedIn}
          <!-- Show edit and delete buttons if the logged-in user is the author -->
            {#if $page.data.user && $page.data.user.id === article.userid}
              <button on:click={editArticle} class="edit-button">Edit</button>
              <button on:click={deleteArticle} class="delete-button">Delete</button>
            {:else}
            <!-- Show follow/unfollow button if the logged-in user is not the author -->
              <button on:click={toggleFollow} class="follow-button">
                {isFollowing ? "Unfollow" : "Follow"}
              </button>
            {/if}
          {/if}
        </p>
        <p class="article-date">
          Published on {new Date(article.create_date).toLocaleDateString()}
        </p>
      </div>
    </div>
  </div>
</header>

{#if article.image}
  <img src="{PUBLIC_URL}{article.image}" alt={article.title} class="article-image" />
{/if}

<div class="article-content">
  <p>{@html article.content}</p>
</div>

<style>
  .article-image {
    width: 100%;
    max-height: 400px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  .article-content {
    line-height: 1.6;
    font-size: 18px;
    color: #333;
    padding: 10px;
  }

  h1 {
    font-size: 32px;
    color: #222;
    margin-bottom: 16px;
  }

  .author-info {
    display: flex;
    align-items: center;
    background-color: #f8f9fa;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 20px;
  }

  .author-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin-right: 15px;
    border: 2px solid #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .article-author {
    font-size: 16px;
    font-weight: bold;
  }

  .edit-button,
  .delete-button {
    padding: 10px 20px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin: 5px;
    width: 100px;
  }

  .edit-button {
    background-color: #4caf50;
    color: white;
  }

  .edit-button:hover {
    background-color: #45a049;
  }

  .delete-button {
    background-color: #f44336;
    color: white;
  }

  .delete-button:hover {
    background-color: #e53935;
  }

  .edit-button,
  .delete-button,
  .follow-button {
    margin-left: 10px;
  }

  .article-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #f8f9fa;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 20px;
  }

  .title-like-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
  }

  .title-like-container h1 {
    margin: 0;
    flex-grow: 1;
  }

  .like-button-container {
    margin-left: 20px;
    flex-shrink: 0;
  }
</style>
