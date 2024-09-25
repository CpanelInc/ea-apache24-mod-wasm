OBS_PROJECT := EA4-experimental
OBS_PACKAGE := ea-apache24-mod-wasm
DISABLE_BUILD := repository=CentOS_6.5_standard repository=CentOS_7
include $(EATOOLS_BUILD_DIR)obs.mk
