<script>
  import { PUBLIC_URL, PUBLIC_API_BASE_URL } from "$env/static/public";
  import { invalidate } from "$app/navigation";
  import { USER_URL } from "../js/api-urls";

  export let user;
  export let updateUser;

  let isEditAvatar = false;
  let selectedDefaultAvatar = null;
  // Default avatar options
  let avatarOptions = [
    `images/avatar-boy-green.png`,
    `images/avatar-boy-orange.png`,
    `images/avatar-girl-pink.png`,
    `images/avatar-girl-blue.png`
  ];
  let selectedFile = null;
  let fileSelected = false;
  let isUploading = false;
  let errorMessage = "";

  function selectAvatar(avatar) {
    selectedDefaultAvatar = avatar;
    selectedFile = null;
    fileSelected = false;
  }

  // Handle file input changes
  function handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      const allowedTypes = ["image/png", "image/jpeg", "image/jpg"];
      if (!allowedTypes.includes(file.type)) {
        errorMessage = "Invalid file type. Only .png, .jpg, and .jpeg are allowed.";
        fileSelected = false;
        return;
      }
      if (file.size > 2 * 1024 * 1024) {
        errorMessage = "File size exceeds 2MB limit.";
        fileSelected = false;
        return;
      }
      selectedFile = file;
      fileSelected = true;
      selectedDefaultAvatar = null;
      errorMessage = "";
    } else {
      fileSelected = false;
      errorMessage = "";
    }
  }

  async function uploadAvatar() {
    if (!selectedFile && !selectedDefaultAvatar) {
      errorMessage = "Please select an avatar or upload a file.";
      return;
    }

    isUploading = true;
    const formData = new FormData();

    if (selectedFile) {
      formData.append("avatar", selectedFile);
    } else if (selectedDefaultAvatar) {
      const response = await fetch(`${PUBLIC_URL}${selectedDefaultAvatar}`);
      const blob = await response.blob();
      formData.append("avatar", blob, selectedDefaultAvatar.split("/").pop());
    }
    // Make a POST request to update the user's avatar
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me`, {
        method: "POST",
        body: formData,
        credentials: "include"
      });

      if (!response.ok) {
        const result = await response.json();
        throw new Error(result.message || "Failed to update avatar.");
      }

      await invalidate(USER_URL);
      isEditAvatar = false;
      selectedDefaultAvatar = null;
      selectedFile = null;
      fileSelected = false;
      errorMessage = "";

      if (response.ok) {
        const updatedUser = await response.json();
        updateUser(updatedUser);

        await invalidate(USER_URL);
      }
    } catch (error) {
      console.error("Error updating avatar:", error);
      errorMessage = error.message;
    } finally {
      isUploading = false;
    }
  }
</script>

<!-- Avatar display and editing UI -->
<div class="avatar-container">
  <img
    class="avatar"
    src="{PUBLIC_URL}{isEditAvatar && selectedDefaultAvatar
      ? selectedDefaultAvatar
      : user.avatar_url}"
    alt="User Avatar"
  />
  <!-- Show Change Button when not edit -->
  {#if !isEditAvatar}
    <button class="avatar-button" id="change-button" on:click={() => (isEditAvatar = true)}>
      Change
    </button>
  {:else}
    <!-- Choose vatar to upload -->
    <p>Select an Avatar or upload your own</p>
    <div class="avatar-options">
      {#each avatarOptions as avatar}
        <img
          src="{PUBLIC_URL}{avatar}"
          alt="Avatar"
          class="avatar-option {selectedDefaultAvatar === avatar ? 'selected' : ''}"
          on:click={() => selectAvatar(avatar)}
        />
      {/each}
    </div>

    <div class="avatar-button-group">
      <label class="custom-file-upload">
        <input type="file" accept="image/png, image/jpeg, image/jpg" on:change={handleFileChange} />
        Upload File
      </label>

      <button
        class="avatar-button"
        id="save-avatar-button"
        on:click={uploadAvatar}
        disabled={(!selectedDefaultAvatar && !selectedFile) || isUploading}
      >
        {isUploading ? "Uploading..." : "Save"}
      </button>

      <button
        class="avatar-button"
        id="cancel-avatar-button"
        on:click={() => {
          isEditAvatar = false;
          selectedDefaultAvatar = null;
          selectedFile = null;
          fileSelected = false;
          errorMessage = "";
        }}
      >
        Cancel
      </button>
    </div>

    {#if selectedFile}
      <img
        src={URL.createObjectURL(selectedFile)}
        alt="Uploaded avatar preview"
        class="uploaded-avatar-preview"
      />
    {/if}
    {#if errorMessage}
      <span class="error-message">{errorMessage}</span>
    {/if}
  {/if}
</div>

<style>
  .avatar-container {
    display: grid;
    grid-template-columns: auto 2fr 1fr 1fr;
    grid-template-rows: auto auto auto;
    row-gap: 10px;
    column-gap: 10px;
    margin-top: 20px;
    margin-bottom: 30px;
    width: 100%;
  }

  .avatar {
    grid-column: 1/2;
    grid-row: 1/3;
    width: 130px;
    height: 130px;
    border-radius: 50%;
    object-fit: cover;
  }

  .avatar-container > #change-button {
    grid-column: 1/2;
    grid-row: 3/4;
    width: 120px;
    justify-self: center;
    margin: 0px;
  }

  .avatar-container > p {
    grid-column: 2/5;
    grid-row: 1/2;
    text-align: center;
    margin-bottom: 0px;
  }

  .avatar-options {
    grid-column: 2/5;
    grid-row: 2/3;
    display: flex;
    justify-content: center;
    gap: 15px;
    flex-wrap: wrap;
  }

  .avatar-option {
    display: flex;
    width: 70px;
    height: 70px;
    border-radius: 50%;
    cursor: pointer;
    border: 2px solid transparent;
    transition: border-color 0.3s ease;
  }

  .avatar-option.selected {
    border-color: #4caf50;
  }

  .avatar-button-group {
    grid-column: 2/5;
    grid-row: 3/4;
    display: flex;
    align-items: center;
    gap: 10px;
    justify-content: center;
  }

  .custom-file-upload {
    font-size: 1em;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.6rem 1.2rem;
    cursor: pointer;
    background-color: #f0f0f0;
    border-radius: 4px;
    transition: background-color 0.3s ease;
    text-align: center;
    flex: 1;
    max-width: 200px;
    height: 32px;
    line-height: 16px;
    padding: 8px 12px;
    box-sizing: border-box;
  }

  .custom-file-upload input[type="file"] {
    display: none;
  }

  .uploaded-avatar-preview {
    grid-column: 1/2;
    grid-row: 3/4;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    display: block;
    justify-self: center;
  }

  button {
    border-radius: 5px;
    border: 1px solid none;
    height: auto;
    text-align: center;
    transition: background-color 0.3s ease;
    cursor: pointer;
  }

  #change-button,
  #save-avatar-button,
  #cancel-avatar-button {
    width: 80px;
  }

  #change-button,
  #save-avatar-button {
    box-shadow: 0 0 5px #439b46b0;
    background-color: #4caf50;
    color: white;
  }

  #save-avatar-button:hover,
  #change-button:hover {
    background-color: #2d8030e7;
  }

  #cancel-avatar-button,
  .custom-file-upload {
    background-color: #f0f0f0;
    color: black;
    box-shadow: 0 0 5px #ddd;
  }

  #cancel-avatar-button:hover,
  .custom-file-upload:hover {
    background-color: #e0e0e0;
  }

  .error-message {
    color: red;
    font-size: 0.9em;
    text-align: center;
  }

  @media (max-width: 680px) {
    .avatar-button,
    .custom-file-upload {
      font-size: 0.8em;
    }
  }
</style>
