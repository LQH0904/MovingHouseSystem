package model;

import java.util.List;

public class SurveyConfigModel {
    private String fileName;
    private String displayName;
    private List<String> options;
    private String description;
    
    public SurveyConfigModel() {
    }
    
    public SurveyConfigModel(String fileName, String displayName, List<String> options, String description) {
        this.fileName = fileName;
        this.displayName = displayName;
        this.options = options;
        this.description = description;
    }
    
    // Getters and Setters
    public String getFileName() {
        return fileName;
    }
    
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
    
    public List<String> getOptions() {
        return options;
    }
    
    public void setOptions(List<String> options) {
        this.options = options;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
}