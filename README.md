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

## ▶️ How to Run

### 💻 Backend + Frontend

```bash
# Start Backend
cd backend
npm install
npm start
# Server runs at: http://localhost:3000/

# In a new terminal, start Frontend
cd ../frontend
npm install
npm run dev
# App runs at: http://localhost:5173/

---

### 🖥️ Java Admin Client

- Open `java-client` in IntelliJ or VS Code  
- Run `AdminInterface.java`

> 💡 **Test login credentials:**  
> - **Username**: `admin_john_doe`  
> - **Password**: `randomPass1`


