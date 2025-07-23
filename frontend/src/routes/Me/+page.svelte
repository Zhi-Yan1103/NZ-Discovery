<script>
  import { goto } from "$app/navigation";
  import { onMount } from "svelte";
  import EditProfile from "../../lib/components/EditProfile.svelte";
  import DeleteAccount from "../../lib/components/DeleteAccount.svelte";
  import AvatarUpload from "../../lib/components/AvatarUpload.svelte";
  import FollowLists from "../../lib/components/FollowLists.svelte";

  export let data;
  $: user = data.user; // Reactive statement to track user data

  // Redirect to homepage if not logged in
  onMount(async () => {
    if (!data.isLoggedIn) {
      goto("/");
    }
  });

  // Update user data when changes are made
  function updateUser(updatedUserData) {
    user = updatedUserData;
  }
</script>

<div class="container">
  {#if user}
    <div class="profile-info">
      <h2 class="profile-title">Personal Profile</h2>
      <AvatarUpload {user} {updateUser} />
      <EditProfile {user} {updateUser} />
      <div class="view-and-delete">
        <button id="view-articles-button" on:click={() => goto("/my-articles")}>
          View My Articles
        </button>
        <DeleteAccount />
      </div>
    </div>
    <FollowLists/>
  {:else}
    <p>Error loading user information. Please try again later.</p>
  {/if}
</div>

<style>
  .container {
    display: flex;
    flex-direction: row;
    column-gap: 30px;
    justify-content: center;
    margin: auto auto;
    background-color: transparent;
    width: auto;
    height: auto;
  }

  .profile-info {
    background-color: white;
    margin: 0px;
    padding: 40px;
    width: 500px;
    border: 1px solid #ddd;
    border-radius: 5px;
    box-shadow: 0 0 5px #ddd;
    flex: 0 0 auto;
    height: fit-content;
  }

  .profile-title {
    text-align: center;
    margin: 0px;
    font-size: 1.5em;
  }

  .view-and-delete {
    margin-top: 30px;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    width: auto;
  }

  #view-articles-button {
    width: 130px;
  }

  @media (max-width: 1290px) {
    .container {
      flex-direction: column;
      align-items: center;
      row-gap: 30px;
      padding: 20px;
    }
  }

  @media (max-width: 680px) {
    .container {
      width: 90%;
      justify-items: center;
    }

    .profile-info {
      width: 90%;
    }

    .profile-title {
      font-size: 1.3em;
    }

    .view-and-delete {
      gap: 10px;
    }

    #view-articles-button {
      font-size: 0.8em;
    }
  }
</style>
