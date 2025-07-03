// 1. SurveyConfigDAO.java - Xử lý đọc/ghi file
package dao;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class SurveyConfigDAO {
    private static final String CONFIG_BASE_PATH = "web/survey/"; // Đường dẫn tới thư mục chứa file config
    
    /**
     * Đọc nội dung file cấu hình
     */
    public List<String> readConfigFile(String fileName) throws IOException {
        String filePath = CONFIG_BASE_PATH + fileName;
        Path path = Paths.get(filePath);
        
        if (!Files.exists(path)) {
            throw new FileNotFoundException("File không tồn tại: " + fileName);
        }
        
        return Files.readAllLines(path, StandardCharsets.UTF_8);
    }
    
    /**
     * Ghi nội dung vào file cấu hình
     */
    public boolean writeConfigFile(String fileName, List<String> content) throws IOException {
        String filePath = CONFIG_BASE_PATH + fileName;
        Path path = Paths.get(filePath);
        
        // Tạo thư mục nếu chưa tồn tại
        Files.createDirectories(path.getParent());
        
        Files.write(path, content, StandardCharsets.UTF_8);
        return true;
    }
    
    /**
     * Thêm option mới vào file
     */
    public boolean addOption(String fileName, String newOption) throws IOException {
        List<String> currentOptions = readConfigFile(fileName);
        
        // Kiểm tra trùng lặp
        if (!currentOptions.contains(newOption.trim())) {
            currentOptions.add(newOption.trim());
            writeConfigFile(fileName, currentOptions);
            return true;
        }
        return false;
    }
    
    /**
     * Xóa option khỏi file
     */
    public boolean removeOption(String fileName, String optionToRemove) throws IOException {
        List<String> currentOptions = readConfigFile(fileName);
        
        boolean removed = currentOptions.remove(optionToRemove.trim());
        if (removed) {
            writeConfigFile(fileName, currentOptions);
        }
        return removed;
    }
    
    /**
     * Cập nhật option (thay thế option cũ bằng option mới)
     */
    public boolean updateOption(String fileName, String oldOption, String newOption) throws IOException {
        List<String> currentOptions = readConfigFile(fileName);
        
        int index = currentOptions.indexOf(oldOption.trim());
        if (index != -1) {
            currentOptions.set(index, newOption.trim());
            writeConfigFile(fileName, currentOptions);
            return true;
        }
        return false;
    }
    
    /**
     * Lấy danh sách tất cả các file cấu hình có sẵn
     */
    public List<String> getAvailableConfigFiles() {
        List<String> configFiles = new ArrayList<>();
        configFiles.add("age_group.txt");
        configFiles.add("area.txt");
        configFiles.add("expectation.txt");
        configFiles.add("housing_type.txt");
        configFiles.add("important_factor.txt");
        configFiles.add("packing_quality.txt");
        return configFiles;
    }
}