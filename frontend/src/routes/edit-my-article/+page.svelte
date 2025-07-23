<script>
  import { onMount } from "svelte";
  import { PUBLIC_API_BASE_URL, PUBLIC_URL } from "$env/static/public";
  import { initializeTinyMCE } from "$lib/js/utils.js";
  export let data;
  let article = data?.article || {};
  let newImageFile = null;
  let imagePreview = null;
  let errorMessage = null;

  onMount(() => {
    // Set image preview if an image exists
    if (article.image) {
      imagePreview = `${PUBLIC_URL}/${article.image}`;
    }
    if (!data || !data.article) {
      error = "Error: Article data not found.";
    }
    // Initialize TinyMCE editor and set article content
    initializeTinyMCE("#editor", (content) => {
      article.content = content;
    });
  });

  // Handle file input change for image upload
  function handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      newImageFile = file;
      const reader = new FileReader();
      reader.onload = (e) => {
        imagePreview = e.target.result;
      };
      reader.readAsDataURL(file);
    } else {
      imagePreview = article.image ? `${PUBLIC_URL}/${article.image}` : null;
      newImageFile = null;
    }
  }

  // Remove the selected image
  function removeImage() {
    newImageFile = null;
    imagePreview = null;
    article.image = null;
  }

  // Handle form submission to update the article
  async function handleSubmit(event) {
    event.preventDefault();

    const formData = new FormData();
    formData.append("id", article.id);
    formData.append("title", article.title);
    formData.append("content", tinymce.get("editor").getContent()); // get content from TinyMCE

    // Append image if updated; if removed, set removeImage to true
    if (newImageFile) {
      formData.append("image", newImageFile);
    } else if (!imagePreview && article.image === null) {
      formData.append("removeImage", "true");
    }

    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/articles/update/${article.id}`, {
        method: "PATCH",
        credentials: "include",
        body: formData
      });

      const result = await response.json();
      if (response.ok) {
        // Redirect to article page on success
        window.location.href = `/articles/${article.id}`;
      } else {
        errorMessage = "Failed to update article: " + result.message;
      }
    } catch (error) {
      console.error("Error updating article:", error);
      errorMessage = "An error occurred while updating the article. Please try again later.";
    }
  }
</script>

{#if article}
  <form on:submit={handleSubmit}>
    <label for="title">Title</label>
    <input id="title" type="text" bind:value={article.title} required />

    <label for="editor">Content</label>
    <textarea id="editor">{article.content}</textarea>
    <!-- bind content to textarea -->

    <label for="image">Article Image</label>
    <input id="image" type="file" accept="image/*" on:change={handleFileChange} />

    {#if imagePreview}
      <div>
        <img src={imagePreview} alt="Article Image Preview" width="200" />
        <button type="button" on:click={removeImage}>Remove Image</button>
      </div>
    {:else}
      <p>No image selected</p>
    {/if}

    <button type="submit">Save Changes</button>
  </form>

  {#if errorMessage}
    <div class="error">{errorMessage}</div>
  {/if}
{:else if data.error}
  <p>Error: {data.error.message}</p>
{:else}
  <p>Loading article...</p>
{/if}

<style>
  form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  label {
    font-weight: bold;
  }

  input[type="text"],
  input[type="file"] {
    padding: 0.5rem;
    font-size: 1rem;
  }

  img {
    max-width: 100%;
    height: auto;
    margin-top: 10px;
  }

  button {
    display: inline-block;
    margin-left: 10px;
  }
</style>
