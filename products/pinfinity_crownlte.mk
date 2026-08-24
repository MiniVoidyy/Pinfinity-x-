# Pinfinity X - Galaxy Note9 (crownlte)
# Auto-detects whichever base product the synced tree provides.

ifneq ($(wildcard device/samsung/crownlte/aosp_crownlte.mk),)
    PINFINITY_BASE_PRODUCT := device/samsung/crownlte/aosp_crownlte.mk
else ifneq ($(wildcard device/samsung/crownlte/lineage_crownlte.mk),)
    PINFINITY_BASE_PRODUCT := device/samsung/crownlte/lineage_crownlte.mk
else
    PINFINITY_BASE_PRODUCT :=
endif

$(call inherit-product-if-exists, $(PINFINITY_BASE_PRODUCT))
$(call inherit-product, vendor/pinfinity/common.mk)

PRODUCT_NAME := pinfinity_crownlte
PRODUCT_DEVICE := crownlte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-N960F
