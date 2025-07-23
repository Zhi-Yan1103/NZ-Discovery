<script>
  import { goto } from "$app/navigation";
  import { AUTH_URL } from "$lib/js/api-urls.js";
  import { updateUserAndNotifications } from "../../stores/userStore.js";
  import { fetchNotificationCounts } from "../../stores/notifications.js";
  let username = "";
  let password = "";
  let error = false;

  /**
   * Handles logging in by sending a POST request to the authentication API.
   * If successful, updates user data and redirects to the homepage.
   * If unsuccessful, sets an error flag to display an error message.
   */
  async function handleSubmit() {
    error = false;
    const response = await fetch(AUTH_URL, {
      method: "POST",
      credentials: "include",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password })
    });

    if (response.status === 401) {
      error = true;
    } else {
      const userData = await response.json();
      const counts = await fetchNotificationCounts();
      updateUserAndNotifications(userData, counts.unreadCount);
      await new Promise((resolve) => setTimeout(resolve, 100));

      goto("/", { invalidateAll: true, replaceState: true });
      await invalidate(() => userStore);
    }

    return response;
  }
</script>

<svelte:head>
  <title>Login</title>
</svelte:head>

<div class="login-container">
  <h1>Login</h1>
  <p class="subtitle">Login to discover more!</p>

  <form on:submit|preventDefault={handleSubmit}>
    <!-- Form submission handler -->
    <div class="form-group">
      <label for="username">Username:</label>
      <input type="text" name="username" bind:value={username} required />
    </div>
    <div class="form-group">
      <label for="password">Password:</label>
      <input type="password" name="password" bind:value={password} required />
    </div>
    <button type="submit" class="submit-btn">Login</button>
    {#if error}
      <span class="error">Could not log in with those credentials, please try again.</span>
    {/if}
  </form>

  <p class="register-link">Don't have an account? <a href="/register">Register</a></p>
</div>

<style>
  .login-container {
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
  input[type="password"] {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box;
  }

  .error {
    color: #d32f2f;
    font-size: 0.875rem;
    margin-top: 0.25rem;
  }

  .register-link {
    text-align: center;
    margin-top: 1rem;
    color: #666;
  }
</style>
