package pccit.finalproject.javaclient;

import java.io.*;
import java.net.*;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import javax.swing.*;

public class ApiClient {
    private static ApiClient instance;
    private static final String BASE_URL = "http://localhost:3000/api";

    // Singleton pattern to ensure only one instance of ApiClient exists
    public static ApiClient getInstance() {
        if (instance == null) {
            instance = new ApiClient();
        }
        return instance;
    }

    private final CookieManager cookieManager;
    private final HttpClient client;

    // Private constructor to initialize HttpClient and CookieManager
    private ApiClient() {
        this.cookieManager = new CookieManager();

        this.client = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .followRedirects(HttpClient.Redirect.NEVER)
                .connectTimeout(Duration.ofSeconds(10))
                .cookieHandler(this.cookieManager)
                .build();
    }

    // Login method that sends username and password to the backend
    public boolean login(String username, String password) {
        try {
            String json = JSONUtils.toJSON(new LoginRequest(username, password));
            System.out.println(json);
            HttpRequest request = HttpRequest.newBuilder()
//                    .uri(new URI(BASE_URL + "/auth"))
                    .uri(new URI(BASE_URL + "/auth"))
                    .setHeader("Accept", "application/json")
                    .setHeader("Content-Type", "application/json")
                    .method("POST", HttpRequest.BodyPublishers.ofString(json))
                    .build();
            System.out.println(request);
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println(response);
            return response.statusCode() == 200;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Logout method
    public void logout() {
        try {
            HttpRequest request = HttpRequest.newBuilder()
//                    .uri(new URI(BASE_URL + "/auth"))
                    .uri(new URI(BASE_URL + "/auth")) 
                    .DELETE()
                    .build();

            client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Method to retrieve all user information from the backend
    public List<User> getUsers() {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(new URI(BASE_URL + "/users"))
                    .GET()
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                return JSONUtils.toList(response.body(), User.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // Method to delete a user by their ID
    public boolean deleteUserById(int userId) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(new URI(BASE_URL + "/users/" + userId))
                    .DELETE()
                    .build();
            System.out.println(request);
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                System.out.println("User deleted successfully");
                return true;
            } else {
                System.out.println("Failed to delete user, response code: " + response.statusCode());
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to get a specific user's avatar
    public byte[] getUserAvatar(String username) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(new URI(BASE_URL + "/users/" + username + "/avatar-url")) // Ensure the path matches with the backend
                    .setHeader("Accept", "application/octet-stream")
                    .GET()
                    .build();

            HttpResponse<byte[]> response = client.send(request, HttpResponse.BodyHandlers.ofByteArray());
            if (response.statusCode() == 200) {
                return response.body();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new byte[0];
    }

    // Inner class representing the login request payload
    private static class LoginRequest {
        private String username;
        private String password;

        public LoginRequest(String username, String password) {
            this.username = username;
            this.password = password;
        }

        public String getPassword() {
            return password;
        }

        public String getUsername() {
            return username;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public void setUsername(String username) {
            this.username = username;
        }
    }}
