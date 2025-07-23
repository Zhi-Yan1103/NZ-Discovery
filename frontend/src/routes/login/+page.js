import { goto } from "$app/navigation";
import { browser } from "$app/environment";

// Load function to check if the user is already logged in
export async function load({ parent }) {
  if (!browser) return;
  const { isLoggedIn } = await parent();
  if (isLoggedIn) goto("/", { replaceState: true });
}