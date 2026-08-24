# Pinfinity X - Galaxy S9+ (star2lte)
# Auto-detects whichever base product the synced tree provides.

ifneq ($(wildcard device/samsung/star2lte/aosp_star2lte.mk),)
    PINFINITY_BASE_PRODUCT := device/samsung/star2lte/aosp_star2lte.mk
else ifneq ($(wildcard device/samsung/star2lte/lineage_star2lte.mk),)
    PINFINITY_BASE_PRODUCT := device/samsung/star2lte/lineage_star2lte.mk
else
    PINFINITY_BASE_PRODUCT :=
endif

$(call inherit-product-if-exists, $(PINFINITY_BASE_PRODUCT))
$(call inherit-product, vendor/pinfinity/common.mk)

PRODUCT_NAME := pinfinity_star2lte
PRODUCT_DEVICE := star2lte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G965F
