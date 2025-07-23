<script>
  export let message;
  export let onConfirm;
  export let onCancel;
  function handleConfirm() {
    onConfirm();
  }
  function handleCancel() {
    onCancel();
  }
</script>
<!-- Modal structure -->
<div class="modal">
  <div class="modal-content">
    <h2>Confirm information</h2>
    <p>{message}</p>
    <button class="confirm-button" on:click={handleConfirm}>Confirm</button>
    <button class="cancel-button" on:click={handleCancel}>Cancel</button>
  </div>
</div>

<style>
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .modal-content {
    background-color: white;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
    text-align: center;
  }

  .confirm-button,
  .cancel-button {
    margin: 5px;
    padding: 10px 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }

  .confirm-button {
    background-color: #f44336;
    color: white;
  }

  .cancel-button {
    background-color: #4caf50;
    color: white;
  }
</style>
