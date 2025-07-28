package model;

public class ChartDataPoint {
    private String label;
    private int count;

    public ChartDataPoint(String label, int count) {
        this.label = label;
        this.count = count;
    }

    public String getLabel() {
        return label;
    }

    public int getCount() {
        return count;
    }
}
