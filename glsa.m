#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

char *_labelText; // global variable. Bad!

@interface AppDelegate : UIResponder<UIApplicationDelegate>
@end



@implementation AppDelegate
- ( BOOL ) application: ( UIApplication * ) application
           didFinishLaunchingWithOptions: ( NSDictionary * ) launchOptions {
  UIWindow *window = [ [ [ UIWindow alloc ] initWithFrame: 
    [ [ UIScreen mainScreen ] bounds ] ] init ];
  window.backgroundColor = [ UIColor whiteColor ];
  UILabel *label = [ [ UILabel alloc ] init ];
  label.text = [[[NSString alloc] initWithUTF8String:_labelText] init];
  label.center = CGPointMake( 100, 100 );
  [ label sizeToFit ];
  [ window addSubview: label ];
  [ window makeKeyAndVisible ];
  [ label release ];
  return YES;
}
@end



int glsa( char *labelText )
{
  char *args[] = {};
  _labelText = labelText;
  int retVal = UIApplicationMain( 0, args, nil, @"AppDelegate" );
  return retVal;
}