// Initialize and configure TinyMCE rich text editor
export function initializeTinyMCE(selector, onChangeCallback) {
  // Create script element for TinyMCE
  const script = document.createElement("script");
  // Set source to TinyMCE CDN with API key
  script.src =
    "https://cdn.tiny.cloud/1/v1k4h2a3tvbdnvz5rhz2xmeelhvyz80zbhpshxz5qt6snsmm/tinymce/7/tinymce.min.js";

  // Initialize TinyMCE once the script is loaded
  script.onload = () => {
    tinymce.init({
      selector,
      // Enable essential plugins for basic formatting
      plugins: ["lists", "link"],
      // Configure toolbar with basic formatting options
      toolbar: "formatselect | bold italic underline | bullist numlist",
      // Set up event handlers
      setup: (editor) => {
        // Listen for content changes and trigger callback
        editor.on("change", () => {
          onChangeCallback(editor.getContent());
        });
      }
    });
  };

  // Append TinyMCE script to document head
  document.head.appendChild(script);
}
