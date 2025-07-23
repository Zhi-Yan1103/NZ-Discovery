import bcrypt from 'bcrypt';
import { getDatabase } from "./data/database.js";
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const SALT_ROUNDS = 10;

// Function to hash a single password
async function hashPassword(password) {
  return await bcrypt.hash(password, SALT_ROUNDS);
}

// Function to generate and display hashed versions of test passwords
async function generateHashedPasswords() {
  const passwords = [
    'randomPass3', 'randomPass4', 'randomPass5', 'randomPass6', 'randomPass7',
    'randomPass8', 'randomPass9', 'randomPass10', 'randomPass1', 'randomPass2'
  ];

  console.log('Generating hashed versions of test passwords:');
  for (const password of passwords) {
    const hashedPassword = await hashPassword(password);
    console.log(`Original: ${password}, Hashed: ${hashedPassword}`);
  }
}

// Function to update existing passwords in database
async function updateExistingPasswords() {
  const db = await getDatabase();
  
  const users = await db.all("SELECT id, username, password FROM users WHERE password NOT LIKE '$2b$%'");
  
  console.log(`Found ${users.length} users with plaintext passwords`);
  
  for (const user of users) {
    const hashedPassword = await hashPassword(user.password);
    await db.run(
      "UPDATE users SET password = ? WHERE id = ?",
      [hashedPassword, user.id]
    );
    console.log(`Updated password for user: ${user.username}`);
  }
  
  console.log('Password update complete!');
}

// Allow both functions to be run from command line
const command = process.argv[2];
if (command === 'generate') {
  generateHashedPasswords().catch(console.error);
} else if (command === 'update') {
  updateExistingPasswords().catch(console.error);
} else {
  console.log('Please specify a command: generate or update');
}

// To see hashed versions 
//node src/password-utils.js generate

// To update database 
//node src/password-utils.js update