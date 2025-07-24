# 🌿 NZ Discovery

A multifunctional blog platform designed to share journeys and stories of exploring New Zealand. It features user registration, login, post creation, comments, likes, and a separate admin dashboard for user management.

## 🎥 Demo Preview

### User Interface (Frontend Demo)

![NZ Discovery Demo](./nz-discovery.gif)

### Admin Dashboard (Java GUI Demo)

![Admin Dashboard Demo](./admin.gif)

---

## 🖥 Frontend

- React (Vite)
- React Router
- JavaScript + JSX
- CSS

## 🔧 Backend

- Node.js
- Express
- SQLite (via `sqlite3`)

## 📦 Java Admin Client

- Java Swing GUI
- HTTP Client (`java.net.http.HttpClient`)
- JSON parsing (`Jackson`)
- Communicates with backend API for login and user management

---

## 📁 Project Structure
NZ-Discovery/
├── frontend/ # React frontend
├── backend/ # Node.js backend (Express + SQLite)
├── java-client/ # Java admin client (Swing)
├── admin.gif # Admin demo animation
├── nz-discovery.gif # Frontend demo animation
├── README.md

2. Frontend
cd frontend
npm install
npm run dev
Runs on: http://localhost:5173/

3. Java Admin Client
Open java-client in IntelliJ or VS Code and run AdminInterface.java.

Test login credentials:
username: admin_john_doe
password: randomPass1

