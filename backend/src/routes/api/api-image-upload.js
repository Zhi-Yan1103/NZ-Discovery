import express from 'express';
import multer from 'multer';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

const router = express.Router();
dotenv.config(); 

//Configure Multer for file storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // Define the upload path
        const uploadPath = path.join(process.cwd(), 'uploads');

        // Create the upload directory if it doesn't exist
        if (!fs.existsSync(uploadPath)) {
            fs.mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        // Create a unique filename using the current timestamp and a random number
        const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1E9)}${path.extname(file.originalname)}`;
        cb(null, uniqueSuffix);
    }
});

// File filter to restrict the allowed file types
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        cb(new Error('Only .png, .jpg and .gif formats are allowed!'), false);
    }
};

// Create a Multer middleware for file uploads
const upload = multer({ 
    storage,
    fileFilter 
});
// API route to handle image uploads
router.post('/upload', upload.single('image'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'No file uploaded.' });
    }

    const imageUrl =`${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    res.json({ imageUrl });
});
export default router;