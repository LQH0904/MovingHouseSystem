package dao;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class SurveyConfigDAO {
    
    /**
     * Đọc file txt từ thư mục source (web/page/survey/)
     */
    public List<String> readFile(String fileName) throws IOException {
        String actualFileName = ensureTxtExtension(fileName);
        String filePath = getSourceFilePath(actualFileName);
        
        System.out.println("Reading file from: " + filePath);
        
        File file = new File(filePath);
        if (!file.exists()) {
            System.err.println("File not found: " + filePath);
            throw new FileNotFoundException("File không tồn tại: " + filePath);
        }
        
        List<String> content = readFileContent(file);
        System.out.println("Read " + content.size() + " lines from file");
        return content;
    }
    
    /**
     * Lưu file txt vào thư mục source (web/page/survey/)
     */
    public void saveFile(String fileName, List<String> content) throws IOException {
        String actualFileName = ensureTxtExtension(fileName);
        String filePath = getSourceFilePath(actualFileName);
        
        System.out.println("=== SAVING FILE ===");
        System.out.println("File name: " + actualFileName);
        System.out.println("Full path: " + filePath);
        System.out.println("Content lines: " + content.size());
        System.out.println("Content: " + content);
        
        File file = new File(filePath);
        
        // Kiểm tra và tạo thư mục nếu chưa tồn tại
        File parentDir = file.getParentFile();
        if (!parentDir.exists()) {
            System.out.println("Creating directories: " + parentDir.getAbsolutePath());
            boolean created = parentDir.mkdirs();
            System.out.println("Directories created: " + created);
        }
        
        // Kiểm tra quyền ghi
        System.out.println("Parent directory writable: " + parentDir.canWrite());
        System.out.println("File exists before save: " + file.exists());
        
        // Backup file cũ nếu tồn tại
        if (file.exists()) {
            System.out.println("File exists, creating backup...");
            File backupFile = new File(filePath + ".backup");
            if (file.renameTo(backupFile)) {
                System.out.println("Backup created: " + backupFile.getAbsolutePath());
            }
        }
        
        // Ghi file mới
        try {
            writeFileContent(file, content);
            System.out.println("File written successfully");
            
            // Verify file sau khi ghi
            verifyFileSaved(file, content);
            
        } catch (IOException e) {
            System.err.println("Error writing file: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Verify file đã được lưu đúng
     */
    private void verifyFileSaved(File file, List<String> expectedContent) throws IOException {
        System.out.println("=== VERIFYING SAVED FILE ===");
        System.out.println("File exists after save: " + file.exists());
        System.out.println("File size: " + file.length() + " bytes");
        System.out.println("File last modified: " + new java.util.Date(file.lastModified()));
        
        if (file.exists()) {
            List<String> actualContent = readFileContent(file);
            System.out.println("Actual content lines: " + actualContent.size());
            System.out.println("Expected content lines: " + expectedContent.size());
            
            boolean contentMatches = actualContent.equals(expectedContent);
            System.out.println("Content matches: " + contentMatches);
            
            if (!contentMatches) {
                System.err.println("WARNING: Saved content doesn't match expected content!");
                System.err.println("Expected: " + expectedContent);
                System.err.println("Actual: " + actualContent);
            } else {
                System.out.println("SUCCESS: File saved and verified correctly");
            }
        } else {
            System.err.println("ERROR: File doesn't exist after save operation!");
        }
        System.out.println("=== VERIFICATION COMPLETE ===");
    }
    
    /**
     * Đảm bảo file có đuôi .txt
     */
    private String ensureTxtExtension(String fileName) {
        return fileName.toLowerCase().endsWith(".txt") ? fileName : fileName + ".txt";
    }
    
    /**
     * Tạo đường dẫn tới file trong thư mục source
     */
    private String getSourceFilePath(String fileName) {
        String workingDir = System.getProperty("user.dir");
        System.out.println("Working directory: " + workingDir);
        
        String filePath = workingDir + File.separator + "web" + File.separator + 
                         "page" + File.separator + "survey" + File.separator + fileName;
        
        System.out.println("Constructed file path: " + filePath);
        return filePath;
    }
    
    /**
     * Đọc nội dung file
     */
    private List<String> readFileContent(File file) throws IOException {
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(file), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    lines.add(line.trim());
                }
            }
        }
        return lines;
    }
    
    /**
     * Ghi nội dung vào file
     */
    private void writeFileContent(File file, List<String> content) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(file), StandardCharsets.UTF_8))) {
            for (String line : content) {
                writer.write(line);
                writer.newLine();
            }
            writer.flush();
            System.out.println("File content written and flushed");
        }
    }
    
    /**
     * Debug method để kiểm tra trạng thái file system
     */
    public void debugFileSystem(String fileName) {
        String actualFileName = ensureTxtExtension(fileName);
        String filePath = getSourceFilePath(actualFileName);
        
        System.out.println("=== FILE SYSTEM DEBUG ===");
        System.out.println("Working directory: " + System.getProperty("user.dir"));
        System.out.println("File path: " + filePath);
        
        File file = new File(filePath);
        System.out.println("File exists: " + file.exists());
        System.out.println("File absolute path: " + file.getAbsolutePath());
        System.out.println("Parent directory: " + file.getParent());
        System.out.println("Parent exists: " + file.getParentFile().exists());
        System.out.println("Parent writable: " + file.getParentFile().canWrite());
        System.out.println("=== DEBUG COMPLETE ===");
    }
}