<script>
  import { ARTICLES_URL } from "$lib/js/api-urls.js";
  import { onMount } from "svelte";
  import ArticleCard from "$lib/components/ArticleCard.svelte";
  export let data;

  // Store the list of articles to display on the page
  let articlesToDisplay = data.articles;

  // Variables for search query and sorting options
  let searchQuery = "";
  let sortOrder = "desc"; // Default sorting order: descending
  let sortBy = "date"; // Default sorting criteria: date

  /**
   * Handle change in sorting criteria.
   * @param {Event} event - The change event from the dropdown.
   */
  function handleSortChange(event) {
    sortBy = event.target.value; // Update sorting criteria
    handleSearch(); // Refresh the search results with new sorting
  }

  /**
   * Perform a search and update the list of articles based on query and sort options.
   */
  async function handleSearch() {
    try {
      // Construct URL based on search query and sorting options
      const url = searchQuery.trim()
        ? `${ARTICLES_URL}/search?q=${encodeURIComponent(searchQuery.trim())}&sortBy=${sortBy}&sortOrder=${sortOrder}`
        : `${ARTICLES_URL}?sortBy=${sortBy}&sortOrder=${sortOrder}`;

      // Fetch the search results from the API
      const response = await fetch(url, { credentials: "include" });

      if (!response.ok) {
        throw new Error("Search failed"); // Throw error if search fails
      }

      const results = await response.json(); // Parse the JSON response

      // Dispatch an event to update the displayed articles
      window.dispatchEvent(
        new CustomEvent("searchResultsUpdated", {
          detail: { results } // Pass search results to the event
        })
      );
    } catch (error) {
      console.error("Error searching articles:", error); // Log error to the console
    }
  }

  /**
   * Update the like count of a specific article.
   * @param {string} articleId - The ID of the article to update.
   * @param {number} newLikes - The new like count for the article.
   */
  function updateArticleLikes(articleId, newLikes) {
    // Update the like count for the targeted article
    articlesToDisplay = articlesToDisplay.map((article) =>
      article.id === articleId ? { ...article, likes: newLikes } : article
    );
  }

  /**
   * Toggle the sorting order between ascending and descending.
   */
  function toggleSortOrder() {
    sortOrder = sortOrder === "asc" ? "desc" : "asc"; // Toggle sort order
    handleSearch(); // Refresh search results after toggling
  }

  onMount(() => {
    /**
     * Event handler for updating search results.
     * @param {CustomEvent} event - Custom event with search results.
     */
    const handleSearchResults = (event) => {
      articlesToDisplay = event.detail.results; // Update displayed articles with new results
    };

    /**
     * Reset articles and search options to their default state.
     */
    const handleReset = () => {
      articlesToDisplay = data.articles; // Reset to initial articles
      searchQuery = ""; // Clear search query
      sortBy = "date"; // Reset sorting criteria
    };

    // Add event listeners
    window.addEventListener("searchResultsUpdated", handleSearchResults);
    window.addEventListener("resetArticles", handleReset);

    // Remove event listeners on component unmount
    return () => {
      window.removeEventListener("searchResultsUpdated", handleSearchResults);
      window.removeEventListener("resetArticles", handleReset);
    };
  });
</script>

<svelte:head>
  <title>NZ Discovery</title>
</svelte:head>

<div class="page-container">
  <!-- Search and Sort functionality -->
  <div class="search-sort">
    <!-- Search Bar -->
    <div class="search-input-group">
      <input
        type="text"
        placeholder="Search title, author or content keywords..."
        class="search-bar"
        bind:value={searchQuery}
        on:keydown={(e) => e.key === "Enter" && handleSearch()}
      />
      <button class="button compact" id="search-button" on:click={handleSearch}>
        <i class="fas fa-search"></i>
      </button>
    </div>
    <!-- Sorting Options -->
    <div class="filters">
      <select class="dropdown" on:change={handleSortChange}>
        <option value="date">Sort by Create Date</option>
        <option value="title">Sort by Article Title</option>
        <option value="username">Sort by Username</option>
      </select>
      <button class="button compact sort-direction" on:click={toggleSortOrder}>
        <i class="fas fa-arrow-{sortOrder === 'asc' ? 'down' : 'up'}"></i>
        <!-- Sort direction icon -->
      </button>
    </div>
  </div>

  <!-- Display articles in a grid layout -->
  <div class="article-grid">
    {#if articlesToDisplay && articlesToDisplay.length > 0}
      {#each articlesToDisplay as article (article.id)}
        <ArticleCard
          {article}
          on:likeUpdated={(event) => updateArticleLikes(article.id, event.detail.likes)}
        />
      {/each}
    {:else}
      <p class="no-articles">No articles found</p>
      <!-- Message when no articles are available -->
    {/if}
  </div>
</div>

<style>
  .page-container {
    max-width: 1200px;
    margin: 20px auto;
    padding: 0 20px;
  }

  .search-sort {
    display: flex;
    gap: 15px;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
  }

  .search-input-group {
    display: flex;
    align-items: center;
    gap: 8px;
    flex: 1;
  }

  .search-bar {
    flex: 1;
    min-width: 100px;
  }

  /* Filter options container */
  .filters {
    display: flex;
    align-items: center;
    gap: 8px;
    white-space: nowrap;
  }

  .dropdown {
    width: 180px;
    padding-left: 8px;
  }

  /* Article grid layout */
  .article-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
  }

  /* Empty state message */
  .no-articles {
    text-align: center;
    padding: 20px;
    font-size: 1.2em;
    color: #666;
    grid-column: 1 / -1;
  }

  /* Responsive styles */
  @media (max-width: 768px) {
    .page-container {
      padding: 0 15px;
    }

    .search-sort {
      flex-direction: column;
      gap: 10px;
      align-items: stretch;
    }

    .search-input-group,
    .filters {
      display: flex;
      width: 100%;
      gap: 8px;
    }

    .search-bar,
    .dropdown {
      flex: 1;
      width: auto;
      min-width: 0; /* Prevent overflow */
    }

    #search-button,
    .sort-direction {
      flex: 0 0 40px;
      width: 40px;
      height: 40px;
      padding: 0;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    #search-button i,
    .sort-direction i {
      margin: auto;
    }

    .article-grid {
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 15px;
    }
  }

  @media (max-width: 480px) {
    .article-grid {
      grid-template-columns: 1fr;
      gap: 10px;
    }
  }
</style>
