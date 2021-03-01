TARGET := iphone:clang:latest:7.0
# TARGET := simulator:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
# ARCHS = x86_64 i386
ARCHS = arm64 arm64e
# DEBUG = 0
# FINALPACKAGE = 1


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = tapflash

$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

RED=\033[0;31m
CYAN=\033[0;36m
NC=\033[0m
BOLD=\033[1m

ifneq (,$(filter x86_64 i386,$(ARCHS)))
setup:: clean all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@codesign -f -s - /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	@resim
	@echo 
	@echo -e "${BOLD}Finished Compiling:${NC} ${RED}$(TWEAK_NAME)${NC} ~ ${CYAN}Chr1s${NC}"
endif