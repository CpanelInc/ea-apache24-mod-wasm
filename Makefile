OBS_PROJECT := EA4
OBS_PACKAGE := ea-apache24-mod-wasm
DISABLE_BUILD := repository=CentOS_6.5_standard repository=CentOS_7 repository=CentOS_8 repository=xUbuntu_20.04
include $(EATOOLS_BUILD_DIR)obs.mk
