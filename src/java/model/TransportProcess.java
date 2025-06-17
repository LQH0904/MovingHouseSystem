package model;

import java.time.LocalDateTime;

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
}
