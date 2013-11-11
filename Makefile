XCODETOOLSDIR=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
GHC=i386-apple-darwin11-ghc

all: GLStandalone

GLStandalone: GLStandalone.hs libglsa.a
	$(GHC) --make $< -o $@ -L. -lglsa -framework UIKit -framework Foundation -framework OpenGLES -framework QuartzCore

%.o: %.m
	$(XCODETOOLSDIR)/clang -arch i386 \
  -mios-simulator-version-min=7.0 \
  -fobjc-abi-version=2 \
  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk \
  -c $< -o $@

libglsa.a: glsa.o EAGLView.o
	$(XCODETOOLSDIR)/ar rcs libglsa.a glsa.o EAGLView.o

clean:
	rm -f GLStandalone GLStandalone.hi *.o *.a
