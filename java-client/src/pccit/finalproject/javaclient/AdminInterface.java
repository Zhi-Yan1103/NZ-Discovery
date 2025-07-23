package pccit.finalproject.javaclient;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.URL;
import java.util.List;
import javax.swing.table.DefaultTableModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

// Main interface code for Java Swing, including text fields, buttons, JTable, and JPanel
public class AdminInterface extends JFrame {
    // Define components
    private JTextField usernameField;
    private JPasswordField passwordField;
    private JButton loginButton;
    private JButton logoutButton;
    private JTable userTable;
    private JButton deleteUserButton;
    private JLabel userImageLabel; // Label for displaying user avatar
    private JLabel userInfoLabel; // Label for displaying username

    public AdminInterface() {
        setTitle("Admin Interface");
        setSize(1000, 400);// Set window size to display all content
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        // Top panel
        JPanel topPanel = new JPanel();
        topPanel.setLayout(new FlowLayout());

        usernameField = new JTextField(15);
        passwordField = new JPasswordField(15);
        loginButton = new JButton("Login");
        logoutButton = new JButton("Logout");
        logoutButton.setEnabled(false);

        topPanel.add(new JLabel("Username:"));
        topPanel.add(usernameField);
        topPanel.add(new JLabel("Password:"));
        topPanel.add(passwordField);
        topPanel.add(loginButton);
        topPanel.add(logoutButton);

        add(topPanel, BorderLayout.NORTH);

        // Middle panel (user data table)
        String[] columnNames = { "ID", "Username", "Role", "url" };
        userTable = new JTable(new Object[][] {}, columnNames);
        userTable.getColumnModel().getColumn(0).setMinWidth(30); // Set minimum width for ID column
        userTable.getColumnModel().getColumn(0).setMaxWidth(30); // Set maximum width for ID column
        userTable.getColumnModel().getColumn(2).setMinWidth(50); // Set minimum width for Role column
        userTable.getColumnModel().getColumn(2).setMaxWidth(50); // Set maximum width for Role column
        JScrollPane scrollPane = new JScrollPane(userTable);
        scrollPane.setPreferredSize(new Dimension(700, 300)); // Set fixed width and height for middle panel
        add(scrollPane, BorderLayout.CENTER);

        // Bottom panel (delete user button)
        JPanel bottomPanel = new JPanel();
        deleteUserButton = new JButton("Delete User");
        deleteUserButton.setEnabled(false);
        bottomPanel.add(deleteUserButton);

        add(bottomPanel, BorderLayout.SOUTH);

        // Right panel for displaying user information and avatar
        JPanel rightPanel = new JPanel();
        rightPanel.setLayout(new BoxLayout(rightPanel, BoxLayout.Y_AXIS));
        rightPanel.setPreferredSize(new Dimension(250, 200)); // Set fixed width for right panel
        userImageLabel = new JLabel();
        userImageLabel.setHorizontalAlignment(SwingConstants.CENTER);
        userImageLabel.setPreferredSize(new Dimension(100, 100));
        userInfoLabel = new JLabel();

        JPanel userProfilePanel = new JPanel();
        userProfilePanel.setLayout(new FlowLayout(FlowLayout.CENTER)); // Center the avatar and username horizontally
        userImageLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
        userInfoLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
        rightPanel.add(userImageLabel);
        rightPanel.add(userInfoLabel);

        rightPanel.add(userProfilePanel);

        add(rightPanel, BorderLayout.EAST);

        // Button event listeners
        loginButton.addActionListener(new LoginAction());
        logoutButton.addActionListener(new LogoutAction());
        deleteUserButton.addActionListener(new DeleteUserAction());

        // Table selection event listener
        userTable.getSelectionModel().addListSelectionListener(new UserSelectionListener());
    }

    // Action listener for login button
    private class LoginAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            String username = usernameField.getText();
            String password = new String(passwordField.getPassword());

            boolean success = ApiClient.getInstance().login(username, password);
            if (success) {
                JOptionPane.showMessageDialog(null, "Login Successful!");
                logoutButton.setEnabled(true);
                loginButton.setEnabled(false);
                loadUserData();
            } else {
                JOptionPane.showMessageDialog(null, "Login Failed! Please check your credentials.");
            }
        }
    }

    // Action listener for logout button
    private class LogoutAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            ApiClient.getInstance();
            JOptionPane.showMessageDialog(null, "Logged out successfully!");
            logoutButton.setEnabled(false);
            loginButton.setEnabled(true);
            userTable.setModel(new DefaultTableModel());
            userImageLabel.setIcon(null); // Clear user avatar
            userInfoLabel.setText(""); // Clear user information
        }
    }

    // Action listener for delete user button
    private class DeleteUserAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int selectedRow = userTable.getSelectedRow();
            if (selectedRow != -1) {
                // String username = (String) userTable.getValueAt(selectedRow, 0);
                int userId = (int) userTable.getValueAt(selectedRow, 0); // Get user ID
                // ApiClient.deleteUserById(username);
                boolean success = ApiClient.getInstance().deleteUserById(userId); // Call method to delete user
                // JOptionPane.showMessageDialog(null, "User deleted successfully!");
//                 loadUserData();
                if (success) {
                    JOptionPane.showMessageDialog(null, "User deleted successfully!");
                    loadUserData(); // Reload user data to update UI
                } else {
                    JOptionPane.showMessageDialog(null, "Failed to delete user.");
                }
            }
        }
    }

    // Load user data into the table
    private void loadUserData() {
        // Use SwingWorker to avoid blocking the main thread
        SwingWorker<List<User>, Void> worker = new SwingWorker<>() {
            @Override
            protected List<User> doInBackground() throws Exception {
                // Fetch user data
                return ApiClient.getInstance().getUsers();
            }

            @Override
            protected void done() {
                try {
                    List<User> users = get();
                    String[] columnNames = { "ID", "Username", "Role", "url" };
                    Object[][] data = new Object[users.size()][4];
                    for (int i = 0; i < users.size(); i++) {
                        data[i][0] = users.get(i).getId();
                        data[i][1] = users.get(i).getUsername();
                        data[i][2] = users.get(i).getRole();
                        data[i][3] = users.get(i).getAvatar_url();
                    }

                    // Update table model
                    userTable.setModel(new DefaultTableModel(data, columnNames));
                    userTable.getColumnModel().getColumn(0).setMinWidth(30); // Set minimum width for ID column
                    userTable.getColumnModel().getColumn(0).setMaxWidth(30); // Set maximum width for ID column
                    userTable.getColumnModel().getColumn(2).setMinWidth(50); // Set minimum width for Role column
                    userTable.getColumnModel().getColumn(2).setMaxWidth(50); // Set maximum width for Role column
                    updateButtonStates(); // Update button states
                } catch (Exception e) {
                    e.printStackTrace();
                    JOptionPane.showMessageDialog(null, "Failed to load user data.");
                }
            }
        };
        worker.execute();
    }

    // Listener for table row selection
    private class UserSelectionListener implements ListSelectionListener {
        @Override
        public void valueChanged(ListSelectionEvent event) {
            if (!event.getValueIsAdjusting() && userTable.getSelectedRow() != -1) {
                String username = (String) userTable.getValueAt(userTable.getSelectedRow(), 1);
                loadUserProfile(username);
                deleteUserButton.setEnabled(true);
            }
        }
    }

    // Load user profile information including avatar
    private void loadUserProfile(String username) {
        // Use SwingWorker to avoid blocking the main thread
        SwingWorker<ImageIcon, Void> worker = new SwingWorker<>() {
            @Override
            protected ImageIcon doInBackground() throws Exception {
                // Fetch user avatar from server
                String avatarUrl = (String) userTable.getValueAt(userTable.getSelectedRow(), 3); // Get avatar URL from
                // table
                if (avatarUrl != null && !avatarUrl.isEmpty()) {
                    try {
                        // Construct URL object
                        URL url = new URL("http://localhost:3000/" + avatarUrl); // Ensure URL matches image path on
                        // server
                        System.out.println(url);
                        // Read image from URL
                        Image image = ImageIO.read(url);
                        if (image != null) {
                            // Scale image to fit JLabel
                            Image scaledImage = image.getScaledInstance(100, 100, Image.SCALE_SMOOTH);
                            return new ImageIcon(scaledImage);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try {
                    ImageIcon avatar = get();
                    if (avatar != null) {
                        userImageLabel.setIcon(avatar);
                        userInfoLabel.setText("Username: " + username);
                    } else {
                        userImageLabel.setIcon(null);
                        userInfoLabel.setText("Failed to load profile.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    userImageLabel.setIcon(null);
                    userInfoLabel.setText("Failed to load profile.");
                }
            }
        };
        worker.execute();
    }

    // Update button states based on user selection
    private void updateButtonStates() {
        deleteUserButton.setEnabled(userTable.getSelectedRow() != -1);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            AdminInterface adminInterface = new AdminInterface();
            adminInterface.setVisible(true);
        });
    }
}
