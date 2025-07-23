/**
 * Main routing module
 * Handles base routing configuration and API route integration
 */
import express from "express";
import apiRoutes from "./api/api.js";

/**
 * Express router instance for handling all application routes
 * @type {express.Router}
 */
const router = express.Router();

/**
 * Base route handler
 * Serves as a health check endpoint and API verification
 * 
 * @route GET /
 * @returns {Object} JSON response with a welcome message
 */
router.get("/", (req, res) => {
    return res.json({ message: "Hello, world!" });
});

/**
 * API Routes Integration
 * Mounts all API routes under the /api prefix
 * See api.js for detailed route definitions
 */
router.use("/api", apiRoutes);

/**
 * Export the router so it can be used outside.
 */
export default router;
