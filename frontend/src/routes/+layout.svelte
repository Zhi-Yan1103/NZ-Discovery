<script>
  import { onMount } from "svelte";
  import "$lib/css/app.css";
  import BannerContent from "$lib/components/BannerContent.svelte";
  import Footer from "$lib/components/Footer.svelte";
  import { initializeUserAndNotifications } from "../stores/userStore.js";
  import { PUBLIC_URL } from "$env/static/public";

  export let data;

  // Initialize user data and notifications when component mounts
  onMount(async () => {
    if (data.isLoggedIn) {
      await initializeUserAndNotifications(data.user);
    }
  });
</script>

<!-- Main layout structure -->
<!-- Banner section with background image and content -->
<div class="banner-container">
  <img src="{PUBLIC_URL}images/banner-picture-new.jpg" alt="Banner" class="banner-image" />
  <BannerContent {data} />
</div>

<!-- Main content area -->
<div class="content-wrapper">
  <slot />
</div>

<!-- Footer component -->
<Footer />

<style>
  .banner-container {
    position: relative;
    width: 100%;
    height: 50vh;
    min-height: 300px;
    overflow: hidden;
  }

  .banner-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .content-wrapper {
    max-width: 1200px;
    margin: 40px auto;
    padding: 0 20px;
    box-sizing: border-box;
    width: 100%;
  }

  /* Media queries for responsive design */
  @media (max-width: 768px) {
    .content-wrapper {
      margin: 30px auto;
      padding: 0 15px;
    }
  }

  @media (max-width: 480px) {
    .content-wrapper {
      margin: 20px auto;
      padding: 0 10px;
    }
  }
</style>
