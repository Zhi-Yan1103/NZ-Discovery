import { browser } from "$app/environment";
import { goto } from "$app/navigation";

// Load function to check if the user is already logged in
export async function load({ parent }) {
    if (!browser) return;
    const { isLoggedIn, user } = await parent();
    if (!isLoggedIn) {
        goto("/login", { replaceState: true });
    }
    return { user };
}