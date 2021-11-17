CC=xc8
PROG=vendor_basic.hex
SRCUSB=\
src/usb/usb_descriptors.c\
src/usb/usb_device.c\
src/usb/usb_device_generic.c
SRCBSP=\
src/bsp/buttons.c\
src/bsp/leds.c
SRC=\
src/app_device_vendor_basic.c\
src/app_led_usb_status.c\
src/usb_events.c\
src/main.c\
src/system.c
OBJUSB= usb.lpp
OBJBSP= bsp.lpp
INC_DIR = -Iinc/bsp -Iinc/usb -Iinc
CHIP=18f4550
OPTIONS=--chip=$(CHIP) $(INC_DIR) --OPT=all --WARNFORMAT="warn: [%a] [%n] [%l] [%f] %s"

build: $(PROG) clean
$(PROG): usb.lpp bsp.lpp
	$(CC) $(OPTIONS) $(SRC) $(OBJUSB) $(OBJBSP) -O$(PROG)
$(OBJUSB):
	$(CC) $(OPTIONS) $(SRCUSB) --output=lpp -O$(OBJUSB)
$(OBJBSP):
	$(CC) $(OPTIONS) $(SRCBSP) --output=lpp -O$(OBJBSP)
flash: $(PROG)
	pk2cmd -M -PPIC$(CHIP) -Y  -F$(PROG)
clean: 
	rm -f  *.p1 *.d *.as *.hxl *.sym *.sdb *.pre *.cof *.cmf *.obj startup*
cleanx: clean 
	rm -f $(PROG) *.lpp

.PHONY: build clean flash cleanx