<script>
  import { onMount } from "svelte";
  import { USERS_URL, ARTICLES_URL } from "$lib/js/api-urls";
  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import Comment from "$lib/components/Comment.svelte";
  import AddComment from "$lib/components/AddComment.svelte";
  import { goto } from "$app/navigation";
  import { page } from "$app/stores";
  import ConfirmInformation from "$lib/components/ConfirmInformation.svelte";
  import SingleArticleDisplay from "$lib/components/SingleArticleDisplay.svelte";

  export let data;
  let { article } = data;
  let comments = [];
  let showComments = true;
  let currentUserId = null;
  let isFollowing;
  let showConfirmDialog = false;

  $: isLoggedIn = $page.data.isLoggedIn;

  onMount(async () => {
    const userResponse = await fetch(`${PUBLIC_API_BASE_URL}/users/me`, {
      credentials: "include"
    });
    if (userResponse.ok) {
      const userData = await userResponse.json();
      currentUserId = userData.id;
    }

    await loadComments();
    await checkFollowStatus();
  });

  // Load comments for the article
  async function loadComments() {
    const response = await fetch(`${PUBLIC_API_BASE_URL}/comments/article/${article.id}`);
    if (response.ok) {
      const allComments = await response.json();
      comments = buildCommentTree(allComments);
    }
  }

  // Build a tree structure for comments
  function buildCommentTree(flatComments) {
    const commentMap = {};
    const tree = [];

    flatComments.forEach((comment) => {
      commentMap[comment.id] = comment;
      comment.replies = [];
    });

    flatComments.forEach((comment) => {
      if (comment.parent_id === null) {
        tree.unshift(comment);
      } else {
        const parent = commentMap[comment.parent_id];
        if (parent) {
          parent.replies.unshift(comment);
        }
      }
    });

    return tree;
  }

  // Check if the current user is following the article author
  async function checkFollowStatus() {
    if (!data.article || !data.article.author) {
      console.error("Article data or author is missing");
      return;
    }

    try {
      const response = await fetch(`${USERS_URL}/me/followings/${data.article.author}`, {
        credentials: "include"
      });
      if (response.ok) {
        const data = await response.json();
        isFollowing = data.isFollowing;
      } else {
        console.error("Failed to check follow status:", response.statusText);
      }
    } catch (error) {
      console.error("Error checking follow status:", error);
    }
  }

  // Toggle comments visibility
  function toggleComments() {
    showComments = !showComments;
  }

  // Handle new comment addition
  async function handleCommentAdded(event) {
    const newComment = event.detail;
    if (newComment.parent_id === null) {
      comments = [newComment, ...comments];
    } else {
      await loadComments();
    }
    showComments = true;
  }

  // Handle comment deletion
  async function handleCommentDeleted(event) {
    await loadComments();
  }

  // Toggle follow status for the article author
  async function toggleFollow() {
    if (!isLoggedIn) {
      goto("/login");
      return;
    }

    const url = `${USERS_URL}/me/followings/${data.article.author}`;
    const method = isFollowing ? "DELETE" : "POST";

    try {
      const response = await fetch(url, {
        method,
        credentials: "include"
      });

      if (response.ok) {
        isFollowing = !isFollowing;
      } else {
        const errorData = await response.json();
        console.error("Failed to toggle follow status:", errorData.message);
      }
    } catch (error) {
      console.error("Error toggling follow status:", error);
    }
  }

  // Confirm article deletion
  async function confirmDelete() {
    try {
      const response = await fetch(`${ARTICLES_URL}/delete/${article.id}`, {
        method: "DELETE",
        credentials: "include",
        headers: {
          "Content-Type": "application/json"
        }
      });

      if (response.ok) {
        goto("/my-articles");
      } else {
        const errorData = await response.json();
        alert(`Failed to delete article: ${errorData.message}`);
      }
    } catch (error) {
      console.error("Error deleting article:", error);
    } finally {
      showConfirmDialog = false;
    }
  }

  // Trigger article deletion confirmation
  function deleteArticle() {
    showConfirmDialog = true;
  }

  // Cancel article deletion
  function cancelDelete() {
    showConfirmDialog = false;
  }

  // Navigate to edit article page
  function editArticle() {
    goto(`/edit-my-article?id=${data.article.id}`);
  }
</script>

<svelte:head>
  <title>{article.title}</title>
</svelte:head>
<article class="article-container">
  <SingleArticleDisplay
    {article}
    {isLoggedIn}
    {isFollowing}
    {toggleFollow}
    {editArticle}
    {deleteArticle}
  />

  <!-- Toggle text based on comment visibility -->
  {#if comments.length > 0}
    <a href="#" class="action-link" on:click|preventDefault={toggleComments}>
      {showComments ? "Hide Comments" : "Show Comments"}
    </a>
  {/if}

  <!-- Show comments header if user is logged in or there are comments -->
  {#if isLoggedIn || (comments.length > 0 && showComments)}
    <h2>Comments</h2>
  {/if}

  <!-- Show the AddComment component only if the user is logged in -->
  {#if isLoggedIn}
    <AddComment articleId={article.id} on:commentAdded={handleCommentAdded} />
  {/if}

  <!-- Show comments section if comments are visible and there are comments -->
  {#if showComments && comments.length > 0}
    <div class="comments-section">
      {#each comments as comment (comment.id)}
        <Comment
          {comment}
          {currentUserId}
          articleAuthorId={article.userid}
          on:commentAdded={handleCommentAdded}
          on:commentDeleted={handleCommentDeleted}
        />
      {/each}
    </div>
  {/if}

  <a href="/" class="back-link">Back to all articles</a>

  {#if showConfirmDialog}
    <ConfirmInformation
      message="Are you sure you want to delete this article? This action cannot be undone."
      onConfirm={confirmDelete}
      onCancel={cancelDelete}
    />
  {/if}
</article>

<style>
  .article-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 30px;
    background-color: #fff;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border-radius: 12px;
  }

  .comments-section {
    margin-top: 40px;
    background-color: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
  }

  .action-link {
    display: block;
    margin-top: 20px;
  }

  .back-link {
    display: block;
    margin-top: 20px;
    text-align: center;
  }
</style>
