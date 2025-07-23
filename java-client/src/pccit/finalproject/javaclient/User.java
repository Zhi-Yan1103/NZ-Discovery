package pccit.finalproject.javaclient;

// User model class to store user information
public class User {
    private int id;// User ID
    private String username; // Username
    private String role;// User role (admin, user)
    private String password;// User password
    private String create_date;// Account creation date
    private String realname;// Real name of the user
    private String description;// User description or bio
    private String avatar_url;// URL to the user's avatar image
    private String dob;// Date of birth of the user

    // Default constructor
    public User() {
    }

    // Constructor with username and role
    public User(String username, String role) {
        this.username = username;
        this.role = role;
    }

    // Getter for username
    public String getUsername() {
        return username;
    }

    // Setter for username
    public void setUsername(String username) {
        this.username = username;
    }

    // Getter for role
    public String getRole() {
        return role;
    }

    // Getter for user ID
    public int getId() {
        return id;
    }

    // Setter for user ID
    public void setId(int id) {
        this.id = id;
    }

    // Setter for role
    public void setRole(String role) {
        this.role = role;
    }

    // Getter for password
    public String getPassword() {
        return password;
    }

    // Setter for password
    public void setPassword(String password) {
        this.password = password;
    }

    // Getter for account creation date
    public String getCreate_date() {
        return create_date;
    }

    // Setter for account creation date
    public void setCreate_date(String create_date) {
        this.create_date = create_date;
    }

    // Getter for real name
    public String getRealname() {
        return realname;
    }

    // Setter for real name
    public void setRealname(String realname) {
        this.realname = realname;
    }

    // Getter for user description
    public String getDescription() {
        return description;
    }

    // Setter for user description
    public void setDescription(String description) {
        this.description = description;
    }

    // Getter for avatar URL
    public String getAvatar_url() {
        return avatar_url;
    }

    // Setter for avatar URL
    public void setAvatar_url(String avatar_url) {
        this.avatar_url = avatar_url;
    }

    // Getter for date of birth
    public String getDob() {
        return dob;
    }

    // Setter for date of birth
    public void setDob(String dob) {
        this.dob = dob;
    }
}
