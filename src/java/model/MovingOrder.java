package model;

import java.math.BigDecimal;
import java.util.Date;

public class MovingOrder {
    private int orderId;
    private int customerId;
    private String pickupAddress;
    private String deliveryAddress;
    private Date movingDate;
    private String status; 
    private BigDecimal estimatedCost;
    private Date createdAt;
    private Date updatedAt;
    private String customerName;

    public MovingOrder() {
    }

    public MovingOrder(int orderId, int customerId, String pickupAddress, String deliveryAddress,
                       Date movingDate, String status, BigDecimal estimatedCost, Date createdAt, Date updatedAt) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.pickupAddress = pickupAddress;
        this.deliveryAddress = deliveryAddress;
        this.movingDate = movingDate;
        this.status = status;
        this.estimatedCost = estimatedCost;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
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

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public Date getMovingDate() {
        return movingDate;
    }

    public void setMovingDate(Date movingDate) {
        this.movingDate = movingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getEstimatedCost() {
        return estimatedCost;
    }

    public void setEstimatedCost(BigDecimal estimatedCost) {
        this.estimatedCost = estimatedCost;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    @Override
    public String toString() {
        return "MovingOrder{" +
               "orderId=" + orderId +
               ", customerId=" + customerId +
               ", pickupAddress='" + pickupAddress + '\'' +
               ", deliveryAddress='" + deliveryAddress + '\'' +
               ", movingDate=" + movingDate +
               ", status='" + status + '\'' +
               ", estimatedCost=" + estimatedCost +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               ", customerName='" + customerName + '\'' +
               '}';
    }
}