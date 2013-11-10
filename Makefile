XCODETOOLSDIR=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

%.o: %.m
	$(XCODETOOLSDIR)/clang -arch i386 \
  -mios-simulator-version-min=7.0 \
  -fobjc-abi-version=2 \
  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk \
  $< -o $@
 

libglsa.a: glsa.o
	$(XCODETOOLSDIR)/ar rcs libglsa.a glsa.o

clean:
	rm -f GLStandalone GLStandalone.hi GLStandalone.o glsa.o libglsa.a