XCWORKSPACE=./ISS\ Barometer.xcworkspace
ifeq ($(wildcard file1),)
    PODCMD=update
else
    PODCMD=install
endif

default:
	pod $(PODCMD)
	open $(XCWORKSPACE)
