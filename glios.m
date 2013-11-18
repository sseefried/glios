#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EAGLView.h"

/* sseefried: Ick. Global variables required to create this API */

NSAutoreleasePool *gliosPool;
EAGLView          *gliosEAGLView;
EAGLContext       *gliosEAGLContext;
NSDate            *gliosStartTime;

void (*gliosDisplayCallback)(void);

double gliosElapsedTime(void) {
  return -([ gliosStartTime timeIntervalSinceNow ]);
}

int gliosGetWindowHeight(void) {
  CGRect rect = [ gliosEAGLView bounds ];
  return rect.size.height;
}

int gliosGetWindowWidth(void) {
  CGRect rect = [ gliosEAGLView bounds ];
  return rect.size.width;
}

void gliosDraw(void) {
  [ gliosEAGLView setFramebuffer ];
  gliosDisplayCallback();
  [ gliosEAGLView presentFramebuffer ];
}

void gliosSetDisplayCallback(void (*displayCallback)(void)) {
  gliosDisplayCallback = displayCallback;
}

void gliosLog(char *s) {
  NSLog(@"%s", s);
}

void gliosInit(void) {
  gliosStartTime = [ NSDate date ];

  gliosPool = [[NSAutoreleasePool alloc] init];
  CGRect bounds  = [ [ UIScreen mainScreen ] bounds ];
  gliosEAGLView = [ [ [ EAGLView alloc ] initWithFrame: bounds ] autorelease ];
  gliosEAGLContext = [ [ [ EAGLContext alloc ] initWithAPI:kEAGLRenderingAPIOpenGLES1 ] autorelease ];

  if (!gliosEAGLContext) {
    NSLog(@"Failed to create ES context");
  } else if (![EAGLContext setCurrentContext:gliosEAGLContext]) {
    NSLog(@"Failed to set ES context current");
  }

  [ gliosEAGLView setContext: gliosEAGLContext ];
  [ gliosEAGLView setFramebuffer ];
}

void gliosMainLoop(void)
{
  char *args[] = {};
  UIApplicationMain( 0, args, nil, @"AppDelegate" );
  [gliosPool release];
}

// Precondition: gliosInit must have been called.
void gliosPostRedisplay(void) {
  [ gliosEAGLView setNeedsDisplayInRect: [ [ UIScreen mainScreen ] bounds ] ];
}

/*******************************************************************/

@interface AppDelegate : UIResponder<UIApplicationDelegate>
  @property (nonatomic, retain) UIWindow      *window;
  @property (nonatomic, retain) EAGLView      *eaglView;
  @property (nonatomic, retain) CADisplayLink *displayLink;
@end

@implementation AppDelegate

@synthesize window;
@synthesize eaglView;
@synthesize displayLink;

//
// Precondition: gliosInit must have been called
//
- ( BOOL ) application: ( UIApplication * ) application
           didFinishLaunchingWithOptions: ( NSDictionary * ) launchOptions {
  self.eaglView  = gliosEAGLView;

  /*
   * It does not seem possible to successfully create a main window unless it is
   * done in this method. This means that Gloss' flow of "opening a window" and
   * only then "entering main loop" cannot possibly work for the iOS backend.
   */
  CGRect bounds  = [ [ UIScreen mainScreen ] bounds ];
  self.window    = [ [ [ UIWindow alloc] initWithFrame: bounds] autorelease];


  [ self.window addSubview: eaglView ];
  [ self.window makeKeyAndVisible ];

  self.displayLink = [ CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame) ];
  [ self.displayLink setFrameInterval: 1 ];
  [ self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode ];

  return YES;
}

- (void)drawFrame
{
  gliosDraw();
}

@end

/**********************************************************/

