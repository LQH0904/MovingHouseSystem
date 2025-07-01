    package model; // Đã đổi package thành model

    public class UserComplaint { // Đã đổi tên class
        private int userId;
        private String username;

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }
    }