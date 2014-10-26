# The rockchip rk30sdk board
include device/rockchip/rk30sdk/BoardConfig.mk
$(call inherit-product, device/rockchip/rk30sdk/device.mk)

PRODUCT_BRAND := rk30sdk
PRODUCT_DEVICE := rk30sdk
PRODUCT_NAME := rk30sdk
PRODUCT_MODEL := rk30sdk
PRODUCT_MANUFACTURER := rockchip

PRODUCT_PACKAGES += \
    configd \
    otad \

PRODUCT_PROPERTY_OVERRIDES += \
			persist.service.logcat.enable = 1 \
			ro.product.platform = MatchStick \
			ro.product.version = 201401010000 \
			ro.product.ota.host = www.rockchip.com:2300
