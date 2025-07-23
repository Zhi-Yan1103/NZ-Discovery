<script>
  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import { invalidate } from "$app/navigation";
  import { USER_URL } from "../js/api-urls";

  export let user;
  export let updateUser;

  let isEditing = false;
  let editedUser = {};
  let passwordError = "";
  let usernameError = "";
  let today = new Date().toISOString().split("T")[0];

  // Enter edit mode with current user data
  function startEditing() {
    editedUser = {
      username: user.username,
      password: "",
      confirmPassword: "",
      realname: user.realname,
      description: user.description,
      dob: user.dob ? new Date(user.dob).toISOString().split("T")[0] : ""
    };
    isEditing = true;
  }

  // Exit edit mode, reset temporary data and errors
  function cancelEditing() {
    isEditing = false;
    editedUser = {};
    passwordError = "";
    usernameError = "";
  }

  // Validate username and check availability
  async function checkUsername() {
    if (editedUser.username.length < 3) {
      usernameError = "Username must be at least 3 characters long";
      return;
    }
    if (editedUser.username === user.username) {
      usernameError = "";
      return;
    }
    const response = await fetch(
      `${PUBLIC_API_BASE_URL}/users/check-username/${editedUser.username}`
    );
    const data = await response.json();
    usernameError = data.taken ? "This username is already taken" : "";
  }

  // Validate password length and match
  function checkPasswords() {
    if (editedUser.password) {
      if (editedUser.password.length < 6) {
        passwordError = "Password must be at least 6 characters long";
        return;
      }
      if (editedUser.password !== editedUser.confirmPassword) {
        passwordError = "Passwords do not match";
        return;
      }
    }
    passwordError = "";
  }

  // Save changes or show confirmation for username/password changes
  async function handleSave() {
    if (usernameError || passwordError) return;

    const updates = {};
    if (editedUser.username !== user.username) updates.username = editedUser.username;
    if (editedUser.password) updates.password = editedUser.password;
    if (editedUser.realname !== user.realname) updates.realname = editedUser.realname;
    if (editedUser.description !== user.description) updates.description = editedUser.description;
    if (editedUser.dob !== user.dob) updates.dob = editedUser.dob;

    if (Object.keys(updates).length === 0) {
      cancelEditing();
      return;
    }

    await saveUpdates(updates);
  }

  // Send update request to server and handle logout if necessary
  async function saveUpdates(updates) {
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(updates),
        credentials: "include"
      });

      if (!response.ok) throw new Error("Failed to update");

      const updatedUser = await response.json();

      updateUser(updatedUser);

      await invalidate(USER_URL);

      isEditing = false;
    } catch (error) {
      console.error("Update failed:", error);
      alert(error.message);
    }
  }

  function formatDate(dateString) {
    if (!dateString) return "Not set";
    const date = new Date(dateString);
    return date.toLocaleDateString("en-NZ");
  }
</script>

<div class="profile-details">
  <!-- Username Field -->
  <div class="username-field">
    <p><strong>Username: </strong></p>
    {#if isEditing}
      <!-- Editable input for username with error handling -->
      <input type="text" bind:value={editedUser.username} on:input={checkUsername} />
      {#if usernameError}
        <span class="error-message">{usernameError}</span>
      {/if}
    {:else}
      <!-- Display username when not editing -->
      <span class="username-display">{user.username}</span>
    {/if}
  </div>

  <!-- Password Field -->
  <div class="password-field">
    <p><strong>Password: </strong></p>
    {#if isEditing}
      <div class="password-inputs">
        <!-- Input fields for setting new password and confirmation with validation -->
        <input
          type="password"
          bind:value={editedUser.password}
          placeholder="New password (optional)"
          on:input={checkPasswords}
        />
        <input
          type="password"
          bind:value={editedUser.confirmPassword}
          placeholder="Confirm password (optional)"
          on:input={checkPasswords}
        />
      </div>
      {#if passwordError}
        <span class="error-message">{passwordError}</span>
      {/if}
    {:else}
      <!-- Display hidden password dots when not editing -->
      <span class="password-hidden">••••••••</span>
    {/if}
  </div>

  <!-- Real Name Field -->
  <p class="realname-field">
    <strong>Real Name:</strong>
    {#if isEditing}
      <!-- Editable input for real name -->
      <input type="text" bind:value={editedUser.realname} />
    {:else}
      <!-- Display real name when not editing -->
      {user.realname}
    {/if}
  </p>

  <!-- Description Field -->
  <p class="description-field">
    <strong>Description:</strong>
    {#if isEditing}
      <!-- Editable input for description -->
      <textarea bind:value={editedUser.description} />
    {:else}
      <!-- Display description when not editing -->
      <p>{user.description}</p>
    {/if}
  </p>

  <!-- Date of Birth Field -->
  <div class="dob-field">
    <div class="dob-field-text">
      <p><strong>Date of Birth:</strong></p>
      {#if isEditing}
        <!-- Editable date input for date of birth, restricted to today's date or earlier -->
        <div class="dob-input-container">
          <input type="date" bind:value={editedUser.dob} max={today} />
        </div>
      {:else}
        <!-- Display formatted date of birth when not editing -->
        {formatDate(user.dob)}
      {/if}
    </div>
  </div>

  <!-- Account Created Date Field -->
  <div class="account-created-field">
    <p>
      <strong>Account Created:</strong>
      <!-- Display formatted account creation date -->
      {formatDate(user.create_date)}
    </p>
  </div>

  <!-- Edit and Save/Cancel Buttons -->
  <div class="edit-buttons">
    {#if !isEditing}
      <!-- Edit button to start editing profile fields -->
      <button class="profile-edit-button" on:click={startEditing}>Edit</button>
    {:else}
      <!-- Save and Cancel buttons to save changes or discard edits -->
      <button
        class="profile-save-button"
        on:click={handleSave}
        disabled={usernameError || passwordError}
      >
        Save
      </button>
      <button class="profile-cancel-button" on:click={cancelEditing}>Cancel</button>
    {/if}
  </div>
</div>


<style>
  .profile-details {
    display: flex;
    flex-direction: column;
    row-gap: 15px;
    column-gap: 150px;
  }

  /* Layout for username field with grid arrangement */
  .username-field {
    display: grid;
    grid-template-columns: auto auto;
    grid-template-rows: auto auto;
    row-gap: 5px;
  }

  /* Username label positioning */
  .username-field > p {
    grid-column: 1/2;
    grid-row: 1/2;
    text-align: left;
  }

  /* Username display and input alignment */
  .username-display,
  .username-field > input {
    grid-column: 2/3;
    grid-row: 1/2;
    text-align: right;
    justify-self: flex-end;
  }

  /* Error message styling for username field */
  .username-field > .error-message {
    grid-column: 1/3;
    grid-row: 2/3;
    text-align: center;
  }

  /* Layout for password field */
  .password-field {
    display: grid;
    grid-template-columns: auto auto;
    grid-template-rows: auto auto;
    justify-content: space-between;
  }

  /* Password label positioning */
  .password-field > p {
    grid-column: 1/2;
    grid-row: 1/2;
    text-align: left;
  }

  /* Hidden password display alignment */
  .password-hidden {
    grid-column: 2/3;
    grid-row: 1/2;
    text-align: right;
  }

  /* Password input field styling for editing mode */
  .password-inputs {
    display: flex;
    flex-direction: column;
    gap: 10px;
    width: 100%;
    max-width: 300px;
    margin: 0 auto;
  }

  /* Password error message positioning */
  .password-field > .error-message {
    grid-column: 1/2;
    grid-row: 2/3;
    text-align: left;
  }

  /* Date of birth field styling */
  .dob-field {
    display: flex;
    flex-direction: column;
    gap: 5px;
    justify-content: flex-end;
  }

  /* Date of birth input container alignment */
  .dob-input-container {
    justify-self: flex-end;
    align-self: flex-end;
  }

  /* Date input text alignment */
  .dob-input-container > input {
    text-align: right;
  }

  /* Real name and description field text alignment */
  .realname-field > input {
    text-align: right;
  }

  .description-field > p {
    text-align: right;
    resize: vertical;
    min-height: 30px;
    max-height: 60px;
    overflow-wrap: break-word;
    word-break: break-all;     
    overflow-y: auto;
    white-space: pre-wrap;
    line-height: 1.4;
    padding: 8px;              
  }

  .description-field > textarea {
    width: 194px;
    text-align: left;
  }

  /* Layout for various profile fields */
  .dob-field-text,
  .realname-field,
  .description-field,
  .account-created-field > p {
    display: flex;
    flex-direction: row;
    column-gap: 50px;
    align-items: center;
    justify-content: space-between;
  }

  /* Edit button styling */
  .edit-buttons {
    margin-top: 10px;
    width: auto;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
  }

  /* Profile edit, save, and cancel button styles */
  .profile-edit-button,
  .profile-save-button,
  .profile-cancel-button {
    width: 130px;
  }

  .profile-edit-button,
  .profile-save-button {
    box-shadow: 0 0 5px #439b46b0;
    background-color: #4caf50;
    color: white;
  }

  /* Hover effect for edit and save buttons */
  .profile-save-button:hover,
  .profile-edit-button:hover {
    background-color: #2d8030e7;
  }

  /* Cancel button styling */
  .profile-cancel-button {
    background-color: #f0f0f0;
    color: black;
    box-shadow: 0 0 5px #ddd;
  }

  /* Hover effect for cancel button */
  .profile-cancel-button:hover {
    background-color: #e0e0e0;
  }

  /* Error message styling */
  .error-message {
    color: red;
    font-size: 0.9em;
    text-align: center;
  }

  /* Input field styling */
  input {
    width: 200px;
    height: 32px;
    padding: 5px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1em;
    box-sizing: border-box;
  }

  /* Placeholder styling */
  ::placeholder {
    font-family: inherit;
    color: #999;
    font-size: 1em;
    text-align: right;
  }

  /* Reset margin for paragraph elements */
  p {
    margin: 0px;
  }

  /* Button styling */
  button {
    border-radius: 5px;
    border: 1px solid none;
    height: auto;
    text-align: center;
    transition: background-color 0.3s ease;
    cursor: pointer;
  }

  @media (max-width: 680px) {
    .profile-edit-button,
    .profile-save-button,
    .profile-cancel-button {
      font-size: 0.8em;
    }
  }
</style>