package model;

import java.math.BigDecimal;

public class OrderDetailItem {
    private int orderDetailId;
    private int orderId;
    private String itemName;
    private String imageUrl;
    private int quantity;
    private BigDecimal weightKg;
    private Integer lengthCm;
    private Integer widthCm;
    private Integer heightCm;
    private String note;
    private BigDecimal volumeM3;
    private BigDecimal itemPrice;

    // Constructor không tham số
    public OrderDetailItem() {}

    // Constructor đầy đủ
    public OrderDetailItem(int orderDetailId, int orderId, String itemName, String imageUrl, int quantity,
                           BigDecimal weightKg, Integer lengthCm, Integer widthCm, Integer heightCm,
                           String note, BigDecimal volumeM3, BigDecimal itemPrice) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.itemName = itemName;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
        this.weightKg = weightKg;
        this.lengthCm = lengthCm;
        this.widthCm = widthCm;
        this.heightCm = heightCm;
        this.note = note;
        this.volumeM3 = volumeM3;
        this.itemPrice = itemPrice;
    }

    // Getters và Setters
    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(BigDecimal weightKg) {
        this.weightKg = weightKg;
    }

    public Integer getLengthCm() {
        return lengthCm;
    }

    public void setLengthCm(Integer lengthCm) {
        this.lengthCm = lengthCm;
    }

    public Integer getWidthCm() {
        return widthCm;
    }

    public void setWidthCm(Integer widthCm) {
        this.widthCm = widthCm;
    }

    public Integer getHeightCm() {
        return heightCm;
    }

    public void setHeightCm(Integer heightCm) {
        this.heightCm = heightCm;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public BigDecimal getVolumeM3() {
        return volumeM3;
    }

    public void setVolumeM3(BigDecimal volumeM3) {
        this.volumeM3 = volumeM3;
    }

    public BigDecimal getItemPrice() {
        return itemPrice;
    }

    public void setItemPrice(BigDecimal itemPrice) {
        this.itemPrice = itemPrice;
    }
}
