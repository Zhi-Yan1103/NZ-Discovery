<script>
  import { PUBLIC_URL } from "$env/static/public";
  import { goto } from "$app/navigation";
  import LikeButton from "./LikeButton.svelte";
  import { page } from "$app/stores";

  export let article;
  export let showEditDelete = false;
  export let onDelete = () => {};

  // Function to truncate content to a specified maximum length
  function truncateContent(content, maxLength = 150) {
   const textContent = content.replace(/<(?!\/?(ol|ul|li)\b)[^>]+>/gi, ""); // Remove HTML tags from the content
    return textContent.length > maxLength ? textContent.slice(0, maxLength) + "..." : textContent;
  }

  function getAvatarUrl(author_avatar) {
    if (!author_avatar) {
      return `${PUBLIC_URL}images/default-avatar.jpg`;
    }
    if (author_avatar.startsWith("http://") || author_avatar.startsWith("https://")) {
      return author_avatar;
    }
    return `${PUBLIC_URL}${author_avatar}`;
  }
  //  Go to the edit article page
  function editArticle() {
    goto(`/edit-my-article?id=${article.id}`);
  }

  // Reactive statement to check if the user is logged in
  $: isLoggedIn = $page.data.isLoggedIn;
</script>

<!-- Display articles -->
<div class="article-card">
  <a href="/articles/{article.id}" class="article-card-link">
    {#if article.image}
      <img
        src={`${PUBLIC_URL}${encodeURI(article.image)}`}
        alt={article.title}
        class="article-image"
      />
    {/if}
    <div class="article-content">
      <h2>{article.title}</h2>
      <div class="author-info">
        <img
          class="author-avatar"
          src={getAvatarUrl(article.author_avatar)}
          alt="{article.username || 'Unknown'} Avatar"
        />
        <div>
          <p class="article-author">{article.username || "Unknown"}</p>
          <p class="article-date">
            {new Date(article.create_date).toLocaleDateString()}
          </p>
        </div>
      </div>
      <p class="article-description">{@html truncateContent(article.content)}</p>
    </div>
  </a>

  <!-- Edit and Delete buttons -->
  <div class="article-footer">
    {#if showEditDelete}
      <div class="button-container">
        <button on:click|preventDefault={editArticle} class="edit-button">Edit</button>
        <button class="delete-button" on:click|preventDefault={() => onDelete(article.id)}
          >Delete</button
        >
      </div>
    {/if}

    <!-- likes button -->
    <div class="like-button-container">
      <LikeButton articleId={article.id} {isLoggedIn} />
    </div>
  </div>
</div>

<style>
  .article-card {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    margin-bottom: 20px;
    position: relative;
    transition:
      transform 0.3s ease,
      box-shadow 0.3s ease;
  }

  .article-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
  }

  .article-card-link {
    display: block;
    text-decoration: none;
    color: inherit;
  }

  .article-image {
    width: 100%;
    height: 200px;
    object-fit: cover;
  }

  .article-content {
    padding: 20px;
  }

  .article-content h2 {
    margin: 0 0 10px;
    font-size: 1.4em;
  }

  .author-info {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
  }

  .author-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
  }

  .article-author,
  .article-date {
    font-size: 0.9em;
    color: #666;
    margin: 0;
    line-height: 1.2;
  }

  .article-description {
    font-size: 0.95em;
    line-height: 1.5;
    margin-top: 10px;
  }

  .article-footer {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-top: 10px;
    padding: 0 20px 20px;
  }

  .like-button-container {
    position: absolute;
    bottom: 10px;
    right: 10px;
  }

  .button-container {
    display: flex;
  }

  .edit-button,
  .delete-button {
    display: inline-block;
    font-weight: bold;
    width: 80px;
    margin-left: 10px;
    padding: 5px 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
    color: white;
    text-align: center;
    text-decoration: none;
    box-sizing: border-box;
  }

  .edit-button {
    background-color: #4caf50;
  }

  .delete-button {
    background-color: #f44336;
  }
</style>
