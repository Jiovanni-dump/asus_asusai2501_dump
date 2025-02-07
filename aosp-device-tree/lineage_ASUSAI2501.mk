#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from ASUSAI2501 device
$(call inherit-product, device/asus/ASUSAI2501/device.mk)

PRODUCT_DEVICE := ASUSAI2501
PRODUCT_NAME := lineage_ASUSAI2501
PRODUCT_BRAND := asus
PRODUCT_MODEL := ASUSAI2501
PRODUCT_MANUFACTURER := asus

PRODUCT_GMS_CLIENTID_BASE := android-asus

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="qssi_64-user 15 AQ3A.240829.003 35.1810.1810.243-0 release-keys"

BUILD_FINGERPRINT := asus/ZWWAI2501/ASUSAI2501:15/AQ3A.240829.003/35.1810.1810.243-0:user/release-keys
