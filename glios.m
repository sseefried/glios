#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EAGLView.h"

char *_labelText; // global variable. Bad!

@interface AppDelegate : UIResponder<UIApplicationDelegate>
  @property (nonatomic, retain) UIWindow *window;
  @property (nonatomic, retain) EAGLView *eaglView;
  @property (nonatomic, retain) EAGLContext *glContext;
@end

@implementation AppDelegate

@synthesize window;
@synthesize eaglView;
@synthesize glContext;

- ( BOOL ) application: ( UIApplication * ) application
           didFinishLaunchingWithOptions: ( NSDictionary * ) launchOptions {

  CGRect bounds  = [ [ UIScreen mainScreen ] bounds ];
  self.window    = [ [ [ UIWindow alloc] initWithFrame: bounds] autorelease];
  self.eaglView  = [ [ [ EAGLView alloc ] initWithFrame: bounds ] autorelease ];
  self.glContext = [ [ [ EAGLContext alloc ] initWithAPI:kEAGLRenderingAPIOpenGLES1 ] autorelease ];

  if (!self.glContext) {
    NSLog(@"Failed to create ES context");
  } else if (![EAGLContext setCurrentContext:self.glContext]) {
    NSLog(@"Failed to set ES context current");
  }

  [ self.eaglView setContext:self.glContext ];


  [ self.window addSubview: eaglView ];
  [ self.window makeKeyAndVisible ];

  [ self.eaglView setFramebuffer ];
  [ self.eaglView presentFramebuffer ];

  return YES;
}
@end



int glsa(void)
{
  char *args[] = {};
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain( 0, args, nil, @"AppDelegate" );
  [pool release];
  return retVal;
}