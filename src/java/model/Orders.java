package model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Orders {
    @JsonProperty("order_id")
    private int orderId;
    @JsonProperty("customer_id")
    private int customerId;
    @JsonProperty("customer_name")
    private String customerName;
    @JsonProperty("transport_unit_id")
    private Integer transportUnitId;
    @JsonProperty("transport_unit_name")
    private String transportUnitName;
    @JsonProperty("storage_unit_id")
    private Integer storageUnitId;
    @JsonProperty("storage_unit_name")
    private String storageUnitName;
    @JsonProperty("order_status")
    private String orderStatus;
    @JsonProperty("created_at")
    private Timestamp createdAt;
    @JsonProperty("updated_at")
    private Timestamp updatedAt;
    @JsonProperty("delivery_schedule")
    private Timestamp deliverySchedule;
    @JsonProperty("total_fee")
    private BigDecimal totalFee;
    @JsonProperty("accepted_at")
    private Timestamp acceptedAt;
    @JsonProperty("delivered_at")
    private Timestamp deliveredAt;
    @JsonProperty("description")
    private String description;
    @JsonProperty("special_note")
    private String specialNote;
    @JsonProperty("service_type")
    private String serviceType;
    @JsonProperty("pickup_time_desired")
    private Timestamp pickupTimeDesired;
    @JsonProperty("transport_fee")
    private BigDecimal transportFee;
    @JsonProperty("service_fee")
    private BigDecimal serviceFee;
    @JsonProperty("vat_amount")
    private BigDecimal vatAmount;
    @JsonProperty("discount")
    private BigDecimal discount;
    @JsonProperty("total_distance_km")
    private BigDecimal totalDistanceKm;

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

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Integer getTransportUnitId() {
        return transportUnitId;
    }

    public void setTransportUnitId(Integer transportUnitId) {
        this.transportUnitId = transportUnitId;
    }

    public String getTransportUnitName() {
        return transportUnitName;
    }

    public void setTransportUnitName(String transportUnitName) {
        this.transportUnitName = transportUnitName;
    }

    public Integer getStorageUnitId() {
        return storageUnitId;
    }

    public void setStorageUnitId(Integer storageUnitId) {
        this.storageUnitId = storageUnitId;
    }

    public String getStorageUnitName() {
        return storageUnitName;
    }

    public void setStorageUnitName(String storageUnitName) {
        this.storageUnitName = storageUnitName;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getDeliverySchedule() {
        return deliverySchedule;
    }

    public void setDeliverySchedule(Timestamp deliverySchedule) {
        this.deliverySchedule = deliverySchedule;
    }

    public BigDecimal getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(BigDecimal totalFee) {
        this.totalFee = totalFee;
    }

    public Timestamp getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(Timestamp acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public Timestamp getDeliveredAt() {
        return deliveredAt;
    }

    public void setDeliveredAt(Timestamp deliveredAt) {
        this.deliveredAt = deliveredAt;
    }

    // Getter và Setter cho trường mới
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSpecialNote() {
        return specialNote;
    }

    public void setSpecialNote(String specialNote) {
        this.specialNote = specialNote;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public Timestamp getPickupTimeDesired() {
        return pickupTimeDesired;
    }

    public void setPickupTimeDesired(Timestamp pickupTimeDesired) {
        this.pickupTimeDesired = pickupTimeDesired;
    }

    public BigDecimal getTransportFee() {
        return transportFee;
    }

    public void setTransportFee(BigDecimal transportFee) {
        this.transportFee = transportFee;
    }

    public BigDecimal getServiceFee() {
        return serviceFee;
    }

    public void setServiceFee(BigDecimal serviceFee) {
        this.serviceFee = serviceFee;
    }

    public BigDecimal getVatAmount() {
        return vatAmount;
    }

    public void setVatAmount(BigDecimal vatAmount) {
        this.vatAmount = vatAmount;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public BigDecimal getTotalDistanceKm() {
        return totalDistanceKm;
    }

    public void setTotalDistanceKm(BigDecimal totalDistanceKm) {
        this.totalDistanceKm = totalDistanceKm;
    }
}