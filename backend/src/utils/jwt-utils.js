import jwt from "jsonwebtoken";

/**
 * Verifies the given JWT token and extracts the username.
 * Throws an error if the JWT is invalid or expired, or if there's no username in the token.
 *
 * @param {string} token The JWT token to verify.
 * @returns {string} The username extracted from the token.
 */
export function getUsernameFromJWT(token) {
    // Decode token; will throw an error if the token is invalid or expired.
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    if (!decoded.username) throw new Error("JWT is valid but did not contain a username.");
    return decoded.username;
}

/**
 * Creates a new JWT for the user with the given username.
 *
 * @param {string} username The username to encode in the token.
 * @param {string} expiresIn When this token expires (default is 24 hours).
 * @returns {string} The generated JWT token.
 */
export function createUserJWT(username, expiresIn = "24h") {
    return jwt.sign({ username }, process.env.JWT_SECRET, { expiresIn });
}