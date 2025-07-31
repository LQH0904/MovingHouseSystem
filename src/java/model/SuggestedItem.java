package model;

/**
 *
 * @author admin
 */
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;

public class SuggestedItem {

    @JsonProperty("itemId")
    private int itemId;

    @JsonProperty("name")
    private String name;

    @JsonProperty("defaultQuantity")
    private int defaultQuantity;

    @JsonProperty("defaultWeightKg")
    private BigDecimal defaultWeightKg;

    @JsonProperty("defaultVolumeM3")
    private BigDecimal defaultVolumeM3;

    @JsonProperty("defaultPrice")
    private BigDecimal defaultPrice;

    @JsonProperty("description")
    private String description;

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDefaultQuantity() {
        return defaultQuantity;
    }

    public void setDefaultQuantity(int defaultQuantity) {
        this.defaultQuantity = defaultQuantity;
    }

    public BigDecimal getDefaultWeightKg() {
        return defaultWeightKg;
    }

    public void setDefaultWeightKg(BigDecimal defaultWeightKg) {
        this.defaultWeightKg = defaultWeightKg;
    }

    public BigDecimal getDefaultVolumeM3() {
        return defaultVolumeM3;
    }

    public void setDefaultVolumeM3(BigDecimal defaultVolumeM3) {
        this.defaultVolumeM3 = defaultVolumeM3;
    }

    public BigDecimal getDefaultPrice() {
        return defaultPrice;
    }

    public void setDefaultPrice(BigDecimal defaultPrice) {
        this.defaultPrice = defaultPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}