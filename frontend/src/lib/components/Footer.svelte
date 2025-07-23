<!-- Footer component with about information and team details -->
<footer>
  <div class="footer-content flex-container">
    <!-- About section -->
    <div class="about">
      <h3>About NZ Discovery</h3>
      <p>
        Your gateway to New Zealand's beauty and culture. Comprehensive guides and authentic stories
        to inspire your Aotearoa journey.
      </p>
    </div>

    <!-- Team information and feak social media links -->
    <div class="team-and-social">
      <h3>Our Team</h3>
      <p> </p>
      <!-- Social media icons with external links -->
      <div class="social-icons">
        <a href="https://facebook.com" target="_blank" aria-label="Facebook">
          <i class="fab fa-facebook"></i>
        </a>
        <a href="https://instagram.com" target="_blank" aria-label="Instagram">
          <i class="fab fa-instagram"></i>
        </a>
        <a href="https://twitter.com" target="_blank" aria-label="Twitter">
          <i class="fab fa-twitter"></i>
        </a>
      </div>
    </div>
  </div>
</footer>

<style>
  /* Main footer container styles */
  footer {
    background-color: rgba(44, 62, 80, 0.9);
    color: #ecf0f1;
    padding: 20px;
    margin-top: 50px;
    width: 100%;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    box-sizing: border-box;
  }

  /* Footer content layout styles */
  .footer-content {
    display: flex;
    justify-content: space-between;
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    gap: 20px;
    box-sizing: border-box;
  }

  /* Common styles for footer sections */
  .footer-content > div {
    flex: 1;
    padding: 0 20px;
  }

  /* Typography styles */
  footer h3 {
    color: #3498db;
    margin-bottom: 20px;
    font-size: 1.3em;
  }

  footer p {
    font-size: 1.05em;
    line-height: 1.6;
    margin-bottom: 15px;
  }

  /* Social media icons styles */
  .social-icons {
    display: flex;
    gap: 20px;
    justify-content: flex-start;
  }

  .social-icons a {
    color: #ecf0f1;
    font-size: 1.5em;
    transition: color 0.3s ease;
  }

  .social-icons a:hover {
    color: #3498db;
  }

  /* Responsive design */
  /* For standard desktop displays */
  @media (max-width: 1440px) {
    .footer-content {
      max-width: 1200px;
      padding: 0 20px;
    }
  }

  /* For smaller desktop screens and laptops */
  @media (max-width: 1280px) {
    .footer-content {
      max-width: 1100px;
    }
  }

  /* For small laptops and tablets landscape */
  @media (max-width: 1024px) {
    .footer-content {
      padding: 0 15px;
      max-width: 900px;
    }

    footer h3 {
      font-size: 1.2em;
    }

    footer p {
      font-size: 1em;
    }
  }

  /* For tablets portrait and large phones */
  @media (max-width: 768px) {
    .footer-content {
      flex-direction: column;
      align-items: center;
      gap: 30px;
      padding: 0 20px;
    }

    .footer-content > div {
      width: 100%;
      margin-bottom: 0;
      text-align: center;
      padding: 0;
    }

    .social-icons {
      justify-content: center;
      margin-top: 20px;
    }
  }

  /* For large phones */
  @media (max-width: 480px) {
    footer {
      padding: 15px 10px;
      margin-top: 30px;
    }

    .footer-content {
      padding: 0 15px;
    }

    footer h3 {
      font-size: 1.1em;
      margin-bottom: 15px;
    }

    footer p {
      font-size: 0.95em;
      line-height: 1.5;
    }

    .social-icons {
      gap: 15px;
    }

    .social-icons a {
      font-size: 1.3em;
    }
  }

  /* For extra small phones */
  @media (max-width: 320px) {
    footer {
      padding: 12px 8px;
      margin-top: 25px;
    }

    .footer-content {
      padding: 0 10px;
    }

    footer h3 {
      font-size: 1em;
      margin-bottom: 12px;
    }

    footer p {
      font-size: 0.9em;
      line-height: 1.4;
    }

    .social-icons {
      gap: 12px;
    }

    .social-icons a {
      font-size: 1.2em;
    }
  }
</style>
