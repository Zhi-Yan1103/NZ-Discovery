<script>
  // Import necessary dependencies
  import { page } from "$app/stores";
  import { invalidate, goto } from "$app/navigation";
  import { AUTH_URL, USER_URL } from "$lib/js/api-urls.js";
  import { unreadCount } from "../../stores/notifications.js";
  import { updateUserAndNotifications } from "../../stores/userStore.js";

  export let data;

  // Reactive declaration for current path
  $: path = $page.url.pathname;

  /**
   * Function to handle user logout
   * It sends a DELETE request to the AUTH_URL and updates the user store if successful
   */
  async function handleLogout() {
    try {
      const response = await fetch(AUTH_URL, {
        method: "DELETE",
        credentials: "include"
      });

      // Invalidate user data to refresh the store
      await invalidate(USER_URL);

      if (response.ok) {
        updateUserAndNotifications(null, 0); // Reset user and notifications
        goto("/"); // Redirect to home page
      } else {
        console.error("Failed to log out");
      }
    } catch (error) {
      console.error("Logout error:", error);
    }
  }
</script>

<!-- Header section with title and authentication buttons -->
<div class="header">
  <h1 class="main-title">NZ Discovery</h1>
  <div class="auth-buttons">
    {#if data.isLoggedIn}
      <!-- Logout button if the user is logged in -->
      <button on:click={handleLogout} class="button">
        <i class="fas fa-sign-out-alt"></i> Logout
      </button>
    {:else}
      <!-- Login and Register buttons if the user is not logged in -->
      <button on:click={() => goto("/login")} class="button">
        <i class="fas fa-sign-in-alt"></i> Login
      </button>
      <button on:click={() => goto("/register")} class="button">
        <i class="fas fa-user-plus"></i> Register
      </button>
    {/if}
  </div>
</div>

<!-- Info panel with welcome message and navigation icons -->
<div class="info-panel card">
  <div class="top-container">
    <p class="top-text main-text">
      Explore New Zealand's stunning landscapes and rich Maori culture. Plan your journey now!
    </p>
    {#if data.isLoggedIn}
      <p class="top-text">
        Welcome back, {data.user.realname}! Continue exploring Aotearoa's wonders.
      </p>
    {:else}
      <p class="top-text secondary-text">
        Join our community to share experiences and get insider tips on NZ travel.
      </p>
    {/if}
  </div>

  <!-- Navigation icons section -->
  <div class="bottom-container">
    <div class="banner-icons">
      <!-- Home icon with reset articles event -->
      <a
        href="/"
        class="icon-group"
        class:active={path === "/"}
        on:click|preventDefault={() => {
          window.dispatchEvent(new CustomEvent("resetArticles"));
          goto("/");
        }}
      >
        <i class="fas fa-home"></i>
        <span>Home</span>
      </a>

      <!-- Navigation icons for logged-in users -->
      {#if data.isLoggedIn}
        <a href="/addNewArticles" class="icon-group" class:active={path === "/addNewArticles"}>
          <i class="fas fa-plus"></i>
          <span>Post</span>
        </a>

        <!-- Notifications icon with unread count badge -->
        <div class="notification-container">
          <a href="/notification" class="icon-group" class:active={path === "/notification"}>
            <i class="fas fa-bell"></i>
            <span>Messages</span>
            {#if $unreadCount > 0}
              <span class="notification-badge">{$unreadCount}</span>
            {/if}
          </a>
        </div>

        <a href="/Me" class="icon-group" class:active={path === "/Me"}>
          <i class="fas fa-user"></i>
          <span>Me</span>
        </a>
      {/if}
    </div>
  </div>
</div>

<style>
  /* Header styles */
  .header {
    position: absolute;
    top: 20px;
    left: 40px;
    right: 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: nowrap;
    white-space: nowrap;
  }

  .main-title {
    font-size: 3em;
    color: #ffffff;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
    margin: 0;
    font-weight: bold;
    letter-spacing: 1px;
    flex-shrink: 0; /* Prevent shrinking */
  }

  /* Authentication buttons styles */
  .auth-buttons {
    display: flex;
    gap: 10px;
    flex-shrink: 0; /* Prevent shrinking */
  }

  .button {
    padding: 8px 15px;
    cursor: pointer;
  }

  /* Info panel styles */
  .info-panel {
    position: absolute;
    bottom: 40px;
    left: 40px;
    right: 40px;
    background-color: rgba(255, 255, 255, 0.8);
    padding: 15px 20px;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    gap: 0px;
  }

  .top-text {
    font-size: 1.1em;
    color: #2c3e50;
    line-height: 1.4;
    margin-top: 5px;
  }

  .top-text.main-text {
    font-weight: bold;
  }

  /* Navigation icons styles */
  .bottom-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .banner-icons {
    display: flex;
    justify-content: flex-start;
    width: 100%;
  }

  .icon-group {
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #2c3e50;
    text-decoration: none;
    position: relative;
    padding: 5px;
    width: 80px;
    transition: all 0.3s ease;
  }

  .icon-group i {
    font-size: 1.3em;
    margin-bottom: 3px;
    transition: all 0.3s ease;
  }

  .icon-group:hover {
    color: #3498db;
    transform: translateY(-3px);
  }

  .icon-group.active {
    color: #3498db;
  }

  .icon-group.active::after {
    content: "";
    display: block;
    width: 100%;
    height: 2px;
    background-color: blue;
    position: absolute;
    bottom: -3px;
    left: 0;
  }

  /* Notification badge styles */
  .notification-container {
    position: relative;
    display: inline-flex;
    align-items: center;
    margin-left: 5px;
  }

  .notification-badge {
    background-color: red;
    color: white;
    border-radius: 50%;
    width: 17px;       
    height: 17px;      
    font-size: 0.6em;  
    line-height: 20px; 
    text-align: center; 
    position: absolute;
    top: -5px;        
    right: 20px;       
    padding: 0;     
    display: flex;
    justify-content: center;
    align-items: center;
  }

  /* Responsive Styles */
  /* 1440px+ Default styles remain unchanged */

  /* 1280px - 1440px: Standard Desktop Monitors */
  @media (max-width: 1440px) {
    .banner-icons {
      width: 85%;
    }
  }

  /* 1024px - 1280px: Small Laptops */
  @media (max-width: 1280px) {
    .banner-icons {
      width: 80%;
    }
  }

  /* 768px - 1024px: Tablets */
  @media (max-width: 1024px) {
    .main-title {
      font-size: 2.8em;
    }

    .banner-icons {
      width: 75%;
    }
  }

  /* 480px - 768px: Large Phones, Tablet Portrait */
  @media (max-width: 768px) {
    .main-title {
      font-size: 2.0em;
    }

    .auth-buttons {
      gap: 5px;
    }

    .button {
      padding: 6px 12px;
      font-size: 0.9em;
    }

    .top-text {
      font-size: 1.1em;
      line-height: 1.2;
      margin-bottom: 15px;
    }

    .info-panel {
      padding: 10px 20px;
    }

    .banner-icons {
      width: 100%;
    }
  }

  /* 320px - 480px: Extra Small Screens (Phones) */
  @media (max-width: 480px) {
    .header {
      flex-direction: column;
      align-items: flex-start;
    }

    .main-title {
      font-size: 1.8em; /* Further reduced for very small screens */
    }

    .auth-buttons {
      margin-top: 10px;
    }

    .button {
      padding: 4px 8px; /* Further reduced for very small screens */
      font-size: 0.7em;
    }

    .icon-group i {
      font-size: 1.2em;
    }

    .info-panel {
      padding: 10px 20px;
      bottom: 20px; /* Adjusted to prevent overlap */
    }

    .top-text {
      font-size: 0.8em; /* Reduced font size for smaller screens */
    }

    .icon-group > span {
      font-size: 0.8em;
    }

    .icon-group > i {
      font-size: 0.8em;
    }
  }
</style>
