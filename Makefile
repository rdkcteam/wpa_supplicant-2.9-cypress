
include ${PROJ_PRERULE_MAK_FILE}

SUBDIRS += wpa_supplicant
ifeq ($(SUPPORT_WIRELESS_AP), yes)
SUBDIRS += hostapd
endif

BIN		= wpa_cli
BIN2		= wpa_supplicant
BIN3		= hostapd

APP_TARGET += $(BIN)
APP_TARGET += $(BIN2)
ifeq ($(SUPPORT_WIRELESS_AP), yes)
APP_TARGET += $(BIN3)
endif

.PHONY: $(BIN1) $(BIN2) $(BIN3)

all: subdir $(APP_TARGET) install

subdir:
	for i in `echo $(SUBDIRS)`; do \
		$(MAKE) -C $$i clean; $(MAKE) -C $$i all || exit 1; \
        done
	

$(BIN):
	$(STRIPCMD) wpa_supplicant/$@


$(BIN2):
	$(STRIPCMD) wpa_supplicant/$@

$(BIN3):
	$(STRIPCMD) hostapd/$@	
	
clean: uninstall
	@for i in `echo $(SUBDIRS)`; do \
                $(MAKE) -C $$i $@ || exit 1; \
        done

install:
	$(INSTALL) -D wpa_supplicant/$(BIN) $(PROJ_INSTALL)/usr/local/bin/$(BIN)
	$(INSTALL) -D wpa_supplicant/$(BIN2) $(PROJ_INSTALL)/usr/local/bin/$(BIN2)
ifeq ($(SUPPORT_WIRELESS_AP), yes)
	$(INSTALL) -D hostapd/$(BIN3) $(PROJ_INSTALL)/usr/local/bin/$(BIN3)
endif

uninstall:
	$(RM) -f $(PROJ_INSTALL)/usr/local/bin/$(BIN)
	$(RM) -f $(PROJ_INSTALL)/usr/local/bin/$(BIN2)
ifeq ($(SUPPORT_WIRELESS_AP), yes)
	$(RM) -f $(PROJ_INSTALL)/usr/local/bin/$(BIN3)
endif

