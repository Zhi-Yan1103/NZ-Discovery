<script>
  import { goto } from "$app/navigation";
  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import { PUBLIC_URL } from "$env/static/public";

  let username = "";
  let password = "";
  let confirmPassword = "";
  let realname = "";
  let dob = "";
  let description = "";
  let error = "";
  let usernameError = "";
  let passwordError = "";

  let selectedAvatar = null;
  let uploadedAvatar = null;
  let avatarOptions = [
    `images/avatar-boy-green.png`,
    `images/avatar-boy-orange.png`,
    `images/avatar-girl-pink.png`,
    `images/avatar-girl-blue.png`
  ];

  let today = new Date().toISOString().split("T")[0];

  function handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        uploadedAvatar = e.target.result;
        selectedAvatar = null;
      };
      reader.readAsDataURL(file);
    }
  }

  async function checkUsername() {
    if (username.length < 3) {
      usernameError = "Username must be at least 3 characters long";
      return;
    }
    const response = await fetch(`${PUBLIC_API_BASE_URL}/users/check-username/${username}`);
    const data = await response.json();
    if (data.taken) {
      usernameError = "This username is already taken";
    } else {
      usernameError = "";
    }
  }

  function checkPasswords() {
    if (password !== confirmPassword) {
      passwordError = "Passwords do not match";
    } else {
      passwordError = "";
    }
  }

  function validateForm() {
    if (password !== confirmPassword) {
      error = "Passwords do not match";
      return false;
    }
    if (password.length < 6) {
      error = "Password must be at least 6 characters long";
      return false;
    }
    if (!realname || !dob || !description) {
      error = "All fields are required";
      return false;
    }
    error = "";
    return true;
  }

  async function handleSubmit() {
    if (!validateForm()) return;

    const formData = new FormData();
    formData.append("username", username);
    formData.append("password", password);
    formData.append("realname", realname);
    formData.append("dob", dob);
    formData.append("description", description);

    if (selectedAvatar) {
      formData.append("avatar", selectedAvatar);
    } else if (uploadedAvatar) {
      const response = await fetch(uploadedAvatar);
      const blob = await response.blob();
      formData.append("avatar", blob, "avatar.png");
    }
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/register`, {
        method: "POST",
        body: formData
      });

      if (response.ok) {
        goto("/login");
      } else {
        const data = await response.json();
        error = data.message || "Registration failed";
      }
    } catch (err) {
      console.error(err);
      error = "An error occurred during registration";
    }
  }
</script>

<svelte:head>
  <title>Register - NZ Discovery</title>
</svelte:head>

<div class="register-container">
  <h1>Create Your Account</h1>
  <p class="subtitle">Join NZ Discovery and start sharing your adventures!</p>

  <form on:submit|preventDefault={handleSubmit}>
    <div class="form-group">
      <label for="username">Username</label>
      <input
        type="text"
        id="username"
        name="username"
        bind:value={username}
        on:input={checkUsername}
        required
      />
      {#if usernameError}
        <span class="error">{usernameError}</span>
      {/if}
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input
        type="password"
        id="password"
        name="password"
        bind:value={password}
        on:input={checkPasswords}
        required
      />
    </div>

    <div class="form-group">
      <label for="confirmPassword">Confirm Password</label>
      <input
        type="password"
        id="confirmPassword"
        name="confirmPassword"
        bind:value={confirmPassword}
        on:input={checkPasswords}
        required
      />
      {#if passwordError}
        <span class="error">{passwordError}</span>
      {/if}
    </div>

    <div class="form-group">
      <label for="realname">Real Name</label>
      <input type="text" id="realname" name="realname" bind:value={realname} required />
    </div>

    <div class="form-group">
      <label for="dob">Date of Birth</label>
      <input type="date" id="dob" name="dob" bind:value={dob} required max={today} />
    </div>

    <div class="form-group">
      <label for="description">About You</label>
      <textarea id="description" name="description" bind:value={description} required></textarea>
    </div>

    <div class="avatar-selection">
      <h3>Choose an avatar or upload your own</h3>
      <div class="avatar-options">
        {#each avatarOptions as avatar}
          <img
            src="{PUBLIC_URL}{avatar}"
            alt="Avatar option"
            class="avatar-option {selectedAvatar === avatar ? 'selected' : ''}"
            on:click={() => {
              selectedAvatar = avatar;
              uploadedAvatar = null;
            }}
          />
        {/each}
      </div>
      <div class="avatar-upload">
        <label for="avatar-upload" class="custom-file-upload">
          <i class="fas fa-upload"></i> Upload Avatar
        </label>
        <input type="file" id="avatar-upload" accept="image/*" on:change={handleFileChange} />
      </div>
      {#if uploadedAvatar}
        <img src={uploadedAvatar} alt="Uploaded avatar" class="uploaded-avatar" />
      {/if}
    </div>

    <button type="submit" class="submit-btn" disabled={usernameError || passwordError}
      >Register</button
    >
    {#if error}
      <span class="error">{error}</span>
    {/if}
  </form>
</div>

<style>
  .register-container {
    width: 90%;
    max-width: 600px;
    margin: 2rem auto;
    padding: 2rem;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  h1 {
    color: #333;
    text-align: center;
    margin-bottom: 0.5rem;
  }

  .subtitle {
    text-align: center;
    color: #666;
    margin-bottom: 2rem;
  }

  .form-group {
    margin-bottom: 1.5rem;
  }

  label {
    display: block;
    margin-bottom: 0.5rem;
    color: #555;
  }

  input[type="text"],
  input[type="password"],
  input[type="date"],
  textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box;
  }

  textarea {
    height: 100px;
    resize: vertical;
  }

  .error {
    color: #d32f2f;
    font-size: 0.875rem;
    margin-top: 0.25rem;
    display: block;
  }

  .avatar-selection {
    margin-top: 2rem;
  }

  .avatar-options {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .avatar-option {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    cursor: pointer;
    border: 2px solid transparent;
    transition: border-color 0.3s ease;
  }

  .avatar-option.selected {
    border-color: #4caf50;
  }

  .avatar-upload {
    text-align: center;
    margin-bottom: 1rem;
  }

  .custom-file-upload {
    display: inline-block;
    padding: 0.6rem 1.2rem;
    cursor: pointer;
    background-color: #f0f0f0;
    border-radius: 4px;
    transition: background-color 0.3s ease;
    width: 100%;
    box-sizing: border-box;
    text-align: center;
  }

  .custom-file-upload:hover {
    background-color: #e0e0e0;
  }

  input[type="file"] {
    display: none;
  }

  .uploaded-avatar {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    object-fit: cover;
    display: block;
    margin: 1rem auto;
  }

  .submit-btn {
    width: 100%;
    padding: 0.75rem;
    background-color: #4caf50;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .submit-btn:hover {
    background-color: #45a049;
  }

  .submit-btn:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
  }

  @media (max-width: 600px) {
    .register-container {
      width: 95%;
      padding: 1rem;
    }

    h1 {
      font-size: 1.8em;
    }

    .subtitle {
      font-size: 1em;
    }

    .avatar-options {
      gap: 0.5rem;
    }

    .avatar-option {
      width: 50px;
      height: 50px;
    }
  }
</style>
