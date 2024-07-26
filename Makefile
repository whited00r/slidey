GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.1.19
include $(THEOS)/makefiles/common.mk
ARCHS= armv7

TWEAK_NAME = Slidey
Slidey_FILES = Tweak.xm NSData+Base64.m UIImage+StackBlur.m UIImage+LiveBlur.m UIImage+Resize.m SlideyWindow.m SlideyController.m SlideyActivator.m SlideyTableCell.m SlideyTableViewController.m
Slidey_FRAMEWORKS = UIKit CoreGraphics Foundation QuartzCore CoreFoundation Security

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += slidey
include $(THEOS_MAKE_PATH)/aggregate.mk
