include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Slidey
Slidey_FILES = Slidey.mm
Slidey_INSTALL_PATH = /Library/PreferenceBundles
Slidey_FRAMEWORKS = UIKit
Slidey_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Slidey.plist$(ECHO_END)
