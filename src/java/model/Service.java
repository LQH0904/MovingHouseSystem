/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
import java.math.BigDecimal;

public class Service {

    private int id;
    private String name;
    private String description;
    private BigDecimal basePrice;
    private BigDecimal ratePerKm;

    public BigDecimal getRatePerKm() {
        return ratePerKm;
    }

    public void setRatePerKm(BigDecimal ratePerKm) {
        this.ratePerKm = ratePerKm;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }
}
