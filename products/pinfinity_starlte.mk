# Pinfinity X - Galaxy S9 (starlte)
# Auto-detects whichever base product the synced tree provides.

ifneq ($(wildcard device/samsung/starlte/aosp_starlte.mk),)
    PINFINITY_BASE_PRODUCT := device/samsung/starlte/aosp_starlte.mk
else ifneq ($(wildcard device/samsung/starlte/lineage_starlte.mk),)
    PINFINITY_BASE_PRODUCT := device/samsung/starlte/lineage_starlte.mk
else
    PINFINITY_BASE_PRODUCT :=
endif

$(call inherit-product-if-exists, $(PINFINITY_BASE_PRODUCT))
$(call inherit-product, vendor/pinfinity/common.mk)

PRODUCT_NAME := pinfinity_starlte
PRODUCT_DEVICE := starlte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G960F
