<script>
  // Import necessary components and modules
  import ArticleCard from "$lib/components/ArticleCard.svelte";
  import ConfirmInformation from "$lib/components/ConfirmInformation.svelte";
  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import { invalidate } from "$app/navigation";
  import { ARTICLES_URL } from "../../lib/js/api-urls";

  export let data;

  // State management
  let showModal = false; // Controls the visibility of the delete confirmation modal
  let articleIdToDelete; // Stores the ID of the article to be deleted

  // Function to initiate article deletion
  async function deleteArticle(articleId) {
    articleIdToDelete = articleId;
    showModal = true;
  }

  // Function to confirm and execute the article deletion
  async function confirmDelete() {
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/articles/delete/${articleIdToDelete}`, {
        method: "DELETE",
        credentials: "include"
      });
      const result = await response.json();

      if (response.ok) {
        // Handle article deletion success and update local state
        await invalidate(ARTICLES_URL);
        console.log("Article deleted successfully:", result.message);
        data.myarticles = data.myarticles.filter((article) => article.id !== articleIdToDelete);
        showModal = false; // Close the modal
      } else {
        console.error("Failed to delete article:", result.message);
        alert(result.message);
      }
    } catch (error) {
      console.error("Error deleting article:", error);
      alert("An error occurred while trying to delete the article. Please try again later.");
    }
  }

  // Function to cancel the deletion action
  function cancelDelete() {
    showModal = false;
  }
</script>

<svelte:head>
  <title>My Articles</title>
</svelte:head>

<h1>My Articles</h1>

<!-- Render articles if available -->
{#if data.myarticles && data.myarticles.length > 0}
  {#each data.myarticles as article (article.id)}
    <ArticleCard {article} showEditDelete={true} onDelete={deleteArticle} />
  {/each}
{:else}
  <p>You haven't written any articles yet.</p>
{/if}

<!-- Confirmation modal for article deletion -->
{#if showModal}
  <ConfirmInformation
    message="Are you sure you want to delete this article?"
    onConfirm={confirmDelete}
    onCancel={cancelDelete}
  />
{/if}
