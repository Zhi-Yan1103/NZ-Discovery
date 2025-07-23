<script>
  import { PUBLIC_URL, PUBLIC_API_BASE_URL } from "$env/static/public";
  import { onMount } from "svelte";
  import { invalidate } from "$app/navigation";
  import { USER_URL } from "../js/api-urls";

  let followers = [];
  let followings = [];
  // Fetch and display the list of followers
  async function displayFollowers() {
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me/followers`, {
        method: "GET",
        credentials: "include"
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Failed to fetch followers");
      }
      followers = await response.json();
    } catch (error) {
      console.error("Error fetching followers:", error);
      followers = []; // Reset followers if there was an error
    }
  }
  // Fetch and display the list of followings
  async function displayFollowings() {
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me/followings`, {
        method: "GET",
        credentials: "include"
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Failed to fetch followings");
      }
      followings = await response.json();
    } catch (error) {
      console.error("Error fetching followings:", error);
      followings = [];
    }
  }
// Send POST request to follow a user by username
  async function handleFollow(username) {
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me/followings/${username}`, {
        method: "POST",
        credentials: "include"
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Failed to follow user");
      }
      await invalidate(USER_URL);
      // Re-fetch both followings and followers
      await Promise.all([displayFollowings(), displayFollowers()]);
    } catch (error) {
      console.error("Error following user:", error);
    }
  }

  // Send DELETE request to unfollow a user by username
  async function handleUnfollow(username) {
    try {
      const response = await fetch(`${PUBLIC_API_BASE_URL}/users/me/followings/${username}`, {
        method: "DELETE",
        credentials: "include"
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Failed to unfollow user");
      }
      await invalidate(USER_URL);
      await Promise.all([displayFollowings(), displayFollowers()]);
    } catch (error) {
      console.error("Error unfollowing user:", error);
    }
  }
  // Fetch followers and followings when the component mounts
  onMount(async () => {
    await Promise.all([displayFollowers(), displayFollowings()]);
  });
</script>
<!-- Displaying followings and followers -->
<div class="follow-container">
  <div class="followings-list">
    <h2 class="followings-title">People you follow ({followings.length})</h2>
    {#if followings.length > 0}
      <ul>
        {#each followings as following}
          <li>
            <div class="user-info">
              <img src="{PUBLIC_URL}{following.avatar_url}" alt="{following.username}'s avatar" />
              <span class="username">{following.username}</span>
            </div>
            <button class="follow-button" on:click={() => handleUnfollow(following.username)}>
              Unfollow
            </button>
          </li>
        {/each}
      </ul>
    {:else}
      <p class="empty-message">You are not following anyone yet.</p>
    {/if}
  </div>
 <!-- Section for displaying people who follow the user -->
  <div class="followers-list">
    <h2 class="followers-title">People who follow you ({followers.length})</h2>
    {#if followers.length > 0}
      <ul>
        {#each followers as follower}
          <li>
            <div class="user-info">
              <img src="{PUBLIC_URL}{follower.avatar_url}" alt="{follower.username}'s avatar" />
              <span class="username">{follower.username}</span>
            </div>
            {#if followings.find((f) => f.username === follower.username)}
              <button class="follow-button" on:click={() => handleUnfollow(follower.username)}>
                Unfollow
              </button>
            {:else}
              <button class="follow-button" on:click={() => handleFollow(follower.username)}>
                Follow
              </button>
            {/if}
          </li>
        {/each}
      </ul>
    {:else}
      <p class="empty-message">No followers yet.</p>
    {/if}
  </div>
</div>

<style>
  .follow-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 580px;
    height: fit-content;
  }

  .followings-list,
  .followers-list {
    background: white;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 40px;
    box-shadow: 0 0 5px #ddd;
    display: flex;
    flex-direction: column;
    height: fit-content;
    width: 500px;
    margin: 0;
  }

  .followings-title,
  .followers-title {
    font-size: 1.5em;
    font-weight: 600;
    text-align: center;
    margin: 0 0 15px 0;
    color: #333;
    padding-bottom: 10px;
  }

  ul {
    list-style: none;
    padding: 0;
    margin: 0;
    overflow-y: auto;
    max-height: 320px;
  }

  li {
    display: grid;
    grid-template-columns: 1fr 100px;
    align-items: center;
    padding: 12px;
    margin-bottom: 5px;
  }

  .user-info {
    display: flex;
    align-items: center;
    gap: 12px;
    overflow: hidden;
  }

  .username {
    font-size: 1em;
    color: #333;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  img {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #eee;
  }

  .follow-button {
    width: 90px;
    justify-self: end;
  }

  .empty-message {
    text-align: center;
    color: #666;
    padding: 20px;
    font-style: italic;
    font-size: 1em;
  }

  /* 美化滚动条 */
  ul::-webkit-scrollbar {
    width: 6px;
  }

  ul::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
  }

  ul::-webkit-scrollbar-thumb {
    background: #888;
    border-radius: 3px;
  }

  ul::-webkit-scrollbar-thumb:hover {
    background: #555;
  }

  @media (max-width: 680px) {
    .follow-container {
      width: 100%;
      gap: 30px;
    }

    .followings-title,
    .followers-title {
      font-size: 1.3em;
    }

    .followings-list,
    .followers-list {
      width: 90%;
      padding: 20px;
      margin: 0;
    }

    .follow-button {
      font-size: 0.8em;
    }
  }
</style>