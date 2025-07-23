<script>
  import { goto, invalidate } from "$app/navigation";
  import { PUBLIC_API_BASE_URL } from "$env/static/public";
  import { USER_URL, AUTH_URL } from "../../lib/js/api-urls";
  import ConfirmInformation from "./ConfirmInformation.svelte";

  let showDeleteConfirm = false;

  async function logout() {
      const response = await fetch(AUTH_URL, {
      method: "DELETE",  // Send a DELETE request to the AUTH_URL to log out
      credentials: "include"
    });
    await invalidate(USER_URL);
    if (response.ok) {
      goto("/"); // Navigate to the homepage after logout
    }
  }

  function openDeleteConfirm() {
    showDeleteConfirm = true;
  }

  async function confirmDeleteAccount() {
   // Send a DELETE request to the user's endpoint to delete the account
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me`, {
        method: "DELETE",
        credentials: "include"
      });
      if (response.ok) {
        await logout(); // If successful, log the user out
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || "Failed to delete account");
      }
    } catch (error) {
      console.error("Error deleting account:", error);
    } finally {
      showDeleteConfirm = false;
    }
  }
</script>

<button id="delete-account-button" on:click={openDeleteConfirm}>Delete Account</button>
<!-- Conditional rendering of the confirmation dialog -->
{#if showDeleteConfirm}
  <ConfirmInformation
    message="Are you sure you want to delete your account? This action cannot be undone."
    onConfirm={confirmDeleteAccount}
    onCancel={() => (showDeleteConfirm = false)}
  />
{/if}

<style>
  #delete-account-button {
    background-color: #ff4136;
    color: white;
    padding: 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    box-shadow: 0 0 5px #ddd;
    width: 130px;
  }

  #delete-account-button:hover {
    background-color: #be1313;
  }

  @media (max-width: 680px) {
    #delete-account-button {
      font-size: 0.8em;
    }
  }
</style>