XCODETOOLSDIR=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
GHC=i386-apple-darwin11-ghc

all: GLStandalone VertexArrayTest

GLStandalone: GLStandalone.hs libglios.a
	$(GHC) --make $< -o $@ -package gloss -L. -lglios -framework UIKit -framework Foundation -framework OpenGLES -framework QuartzCore

VertexArrayTest: VertexArrayTest.hs libglios.a
	$(GHC) --make $< -o $@ -package gloss -L. -lglios -framework UIKit -framework Foundation -framework OpenGLES -framework QuartzCore

%.o: %.m
	$(XCODETOOLSDIR)/clang -arch i386 \
  -mios-simulator-version-min=7.0 \
  -fobjc-abi-version=2 \
  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk \
  -c $< -o $@

libglios.a: glios.o EAGLView.o
	$(XCODETOOLSDIR)/ar rcs libglios.a glios.o EAGLView.o

clean:
	rm -f GLStandalone GLStandalone.hi *.o *.a
