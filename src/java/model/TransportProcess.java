package model;

import java.time.LocalDateTime;
import java.math.BigDecimal;

public class TransportProcess {

    private int orderId;
    private String pickupLocation;
    private String warehouseLocation;
    private String shippingLocation;
    private LocalDateTime pickupDate;
    private LocalDateTime warehouseDate;
    private LocalDateTime shippingDate;
    private String pickupWarehouseDist;
    private String warehouseShippingDist;
    // Trường mới
    private BigDecimal pickupLat;
    private BigDecimal pickupLng;
    private BigDecimal shippingLat;
    private BigDecimal shippingLng;
    private String mapUrl;

    // Getters & Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getPickupLocation() {
        return pickupLocation;
    }

    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

    public String getWarehouseLocation() {
        return warehouseLocation;
    }

    public void setWarehouseLocation(String warehouseLocation) {
        this.warehouseLocation = warehouseLocation;
    }

    public String getShippingLocation() {
        return shippingLocation;
    }

    public void setShippingLocation(String shippingLocation) {
        this.shippingLocation = shippingLocation;
    }

    public LocalDateTime getPickupDate() {
        return pickupDate;
    }

    public void setPickupDate(LocalDateTime pickupDate) {
        this.pickupDate = pickupDate;
    }

    public LocalDateTime getWarehouseDate() {
        return warehouseDate;
    }

    public void setWarehouseDate(LocalDateTime warehouseDate) {
        this.warehouseDate = warehouseDate;
    }

    public LocalDateTime getShippingDate() {
        return shippingDate;
    }

    public void setShippingDate(LocalDateTime shippingDate) {
        this.shippingDate = shippingDate;
    }

    public String getPickupWarehouseDist() {
        return pickupWarehouseDist;
    }

    public void setPickupWarehouseDist(String pickupWarehouseDist) {
        this.pickupWarehouseDist = pickupWarehouseDist;
    }

    public String getWarehouseShippingDist() {
        return warehouseShippingDist;
    }

    public void setWarehouseShippingDist(String warehouseShippingDist) {
        this.warehouseShippingDist = warehouseShippingDist;
    }

    // Getter và Setter cho trường mới
    public BigDecimal getPickupLat() {
        return pickupLat;
    }

    public void setPickupLat(BigDecimal pickupLat) {
        this.pickupLat = pickupLat;
    }

    public BigDecimal getPickupLng() {
        return pickupLng;
    }

    public void setPickupLng(BigDecimal pickupLng) {
        this.pickupLng = pickupLng;
    }

    public BigDecimal getShippingLat() {
        return shippingLat;
    }

    public void setShippingLat(BigDecimal shippingLat) {
        this.shippingLat = shippingLat;
    }

    public BigDecimal getShippingLng() {
        return shippingLng;
    }

    public void setShippingLng(BigDecimal shippingLng) {
        this.shippingLng = shippingLng;
    }

    public String getMapUrl() {
        return mapUrl;
    }

    public void setMapUrl(String mapUrl) {
        this.mapUrl = mapUrl;
    }
}
