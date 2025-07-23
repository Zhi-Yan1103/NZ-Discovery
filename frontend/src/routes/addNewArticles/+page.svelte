<script>
  import { onMount } from "svelte";
  import { initializeTinyMCE } from "$lib/js/utils.js";
  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import { invalidate } from "$app/navigation";
  import { ARTICLES_URL } from "../../lib/js/api-urls";

  export let data;
  let article = data?.article || {};
  let title = "";
  let content = "";
  let image = "";
  let error = "";
  let successMessage = "";
  let articleLink = "";
  let imagePreview;

  // Handle form submission to add a new article
  async function handleSubmit() {
    error = "";
    const formData = new FormData();
    formData.append("title", title);
    formData.append("content", content);
    if (image) {
      formData.append("image", image);
    }

    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/articles/newarticles`, {
        method: "POST",
        credentials: "include",
        body: formData
      });

      if (response.ok) {
        const result = await response.json();
        if (result && result.articleId) {
          successMessage = "Article added successfully!";
          articleLink = `/articles/${result.articleId}`;
          await invalidate(ARTICLES_URL);
          window.location.href = articleLink;
        }
      } else {
        const errorData = await response.json();
        error = errorData.message || "Failed to add article";
        console.error("Error adding article:", errorData);
      }
    } catch (err) {
      error = "An error occurred while submitting the article";
      console.error("Error:", err);
    }
  }

  // Handle image file selection and preview
  function handleImageUpload(event) {
    const file = event.target.files[0];
    if (file) {
      image = file;
      const reader = new FileReader();
      reader.onload = (e) => {
        imagePreview = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  // Initialize TinyMCE editor on component mount
  onMount(() => {
    initializeTinyMCE("#content-editor", (contentValue) => {
      content = contentValue;
    });
  });

  // Add delete image function
  function handleDeleteImage() {
    image = null;
    imagePreview = null;
    // Reset file input
    const fileInput = document.querySelector('input[type="file"]');
    if (fileInput) {
      fileInput.value = '';
    }
  }
</script>

<h1>Add New Article</h1>

<form on:submit|preventDefault={handleSubmit}>
  <label for="title">Title</label>
  <input type="text" bind:value={title} required />

  <label for="content">Content</label>
  <textarea id="content-editor"></textarea>

  <label for="image">Image</label>
  <input type="file" accept="image/*" on:change={handleImageUpload} />

  {#if imagePreview}
    <div class="image-preview-container">
      <div class="preview-content">
        <img src={imagePreview} alt="Image Preview" width="200" />
        <button type="button" class="delete-image-btn" on:click={handleDeleteImage}>
          Delete Image
        </button>
      </div>
    </div>
  {:else}
    <p>No image selected</p>
  {/if}

  <button type="submit">Add Article</button>

  {#if error}
    <span class="error">{error}</span>
  {/if}
</form>

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

  .image-preview-container {
    margin-top: 10px;
  }

  .preview-content {
    display: flex;
    align-items: flex-end;
    gap: 20px;
  }

  .delete-image-btn {
    background-color: #ff4444;
    color: white;
    border: none;
    border-radius: 4px;
    padding: 8px 16px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 0.9rem;
    height: fit-content;
  }

  .delete-image-btn:hover {
    background-color: #cc0000;
  }

  img {
    max-width: 100%;
    height: auto;
  }
</style>
