#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# API levels
BOARD_API_LEVEL := 202404
PRODUCT_SHIPPING_API_LEVEL := 35

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Rootdir
PRODUCT_PACKAGES += \
    Erase_LPD_Record.sh \
    NfcFelica.sh \
    VibCali_ship.sh \
    Vib_efuse_get.sh \
    WifiMac.sh \
    WifiSARPower.sh \
    amp_cal.sh \
    asus_super_hash_check.sh \
    asus_ufs_check.sh \
    asus_ufs_init.sh \
    asus_ufs_shutdown.sh \
    audio_codec_status.sh \
    bat_serial_number_backup.sh \
    bat_serial_number_backup2.sh \
    bat_serial_number_restore.sh \
    bat_serial_number_restore2.sh \
    battery_activate_date_restore.sh \
    boot_vib.sh \
    cat_pcbid.sh \
    change_adsp_dump.sh \
    check_vendor_key.sh \
    coresight_reset_source_sink.sh \
    cos_charger_limit_backup.sh \
    cos_charger_limit_restore.sh \
    create_pcbid.sh \
    cscclearlog.sh \
    firmware_version.sh \
    game_type_edge.sh \
    gauge_fw_compare.sh \
    gf_ver.sh \
    grip_cal.sh \
    grip_chip_status_check.sh \
    grip_fpc_check.sh \
    grip_fpc_check_ndt.sh \
    grip_fpc_check_snt.sh \
    grip_get_vendor.sh \
    grip_read_fw_status.sh \
    grip_read_i2c_status.sh \
    grip_vib_request.sh \
    hallsensor_status.sh \
    headset_status.sh \
    inbox_headset_status.sh \
    init.asus.changebinder.sh \
    init.asus.check_asdf.sh \
    init.asus.check_last.sh \
    init.asus.check_ocp.sh \
    init.asus.zram.sh \
    init.class_main.sh \
    init.crda.sh \
    init.kernel.init_boot-memory.sh \
    init.kernel.post_boot-memory.sh \
    init.kernel.post_boot-sun.sh \
    init.kernel.post_boot-sun_5_2.sh \
    init.kernel.post_boot-sun_6_0.sh \
    init.kernel.post_boot-sun_default_6_2.sh \
    init.kernel.post_boot.sh \
    init.mdm.sh \
    init.qcom.class_core.sh \
    init.qcom.coex.sh \
    init.qcom.early_boot.sh \
    init.qcom.efs.sync.sh \
    init.qcom.post_boot.sh \
    init.qcom.sdio.sh \
    init.qcom.sensors.sh \
    init.qcom.sh \
    init.qcom.usb.sh \
    init.qcrild.sh \
    init.qti.display_boot.sh \
    init.qti.kernel.debug-sun.sh \
    init.qti.kernel.debug.sh \
    init.qti.kernel.early_debug-sun.sh \
    init.qti.kernel.early_debug.sh \
    init.qti.kernel.sh \
    init.qti.media.sh \
    init.qti.qcv.sh \
    init.qti.write.sh \
    is_hdcp_valid.sh \
    is_keybox_valid.sh \
    magnetometer_accessory_detect.sh \
    magnetometer_accessory_installed.sh \
    mic_record.sh \
    mount_apd.sh \
    paymentKeyCheck.sh \
    qca6234-service.sh \
    rcv_amp_cal_val.sh \
    read_device_ssn.sh \
    savelogmtp.sh \
    select_mic.sh \
    select_output.sh \
    sensors_factory_init.sh \
    shutdown_debug.sh \
    spk_amp_cal_val.sh \
    ssr_cfg.sh \
    system_dlkm_modprobe.sh \
    touch_ver.sh \
    ufs_info.sh \
    vendor_modprobe.sh \
    vendor_savelogs.sh \
    verify_soter.sh \
    vib_i2c_err_bk.sh \
    vib_load_cali.sh \
    vib_load_efuse.sh \

PRODUCT_PACKAGES += \
    fstab.qcom \
    init.asus.debugtool.rc \
    init.asus.rc \
    init.qcom.factory.rc \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.qti.kernel.rc \
    init.qti.kernel.target.rc \
    init.qti.ufs.rc \
    init.target.rc \
    init.recovery.qcom.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_VENDOR_RAMDISK_OUT)/first_stage_ramdisk/fstab.qcom

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/asus/ASUSAI2501/ASUSAI2501-vendor.mk)
