package model;

public class OrderInfo {
     private int orderId;
     private int customerId;
    private String fullName;
    private String createdAt;
    private String updatedAt;
    private String deliverySchedule;
    private double totalDistanceKm;
    private String pickupLocation;
    private String shippingLocation;
    private String orderStatus;

    public OrderInfo() {
    }

    public OrderInfo(int orderId, int customerId, String fullName, String createdAt, String updatedAt, String deliverySchedule, double totalDistanceKm, String pickupLocation, String shippingLocation, String orderStatus) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.fullName = fullName;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deliverySchedule = deliverySchedule;
        this.totalDistanceKm = totalDistanceKm;
        this.pickupLocation = pickupLocation;
        this.shippingLocation = shippingLocation;
        this.orderStatus = orderStatus;
    }

    

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }
    
    
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getDeliverySchedule() {
        return deliverySchedule;
    }

    public void setDeliverySchedule(String deliverySchedule) {
        this.deliverySchedule = deliverySchedule;
    }

    public double getTotalDistanceKm() {
        return totalDistanceKm;
    }

    public void setTotalDistanceKm(double totalDistanceKm) {
        this.totalDistanceKm = totalDistanceKm;
    }

    public String getPickupLocation() {
        return pickupLocation;
    }

    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

    public String getShippingLocation() {
        return shippingLocation;
    }

    public void setShippingLocation(String shippingLocation) {
        this.shippingLocation = shippingLocation;
    }

    
}