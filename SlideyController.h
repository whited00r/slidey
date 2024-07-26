#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGraphics.h>
#import "UIImage+StackBlur.h"
#import <IOSurface/IOSurface.h>
#import <QuartzCore/QuartzCore2.h>
#import <objc/runtime.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import "UIImage+LiveBlur.h"

#import "SlideyActivator.h"
#import "SlideyWindow.h"
#import "SlideyTableViewController.h"


#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)


#define prefsPlist @"/var/mobile/Library/Preferences/com.greyd00r.slidey.plist"
//@class SlideyTableViewController;
@interface SlideyController : NSObject {
	bool _roundCorners;
}
@property (nonatomic, assign) bool showingSlidey;
@property (nonatomic, assign) bool roundCorners;
@property (nonatomic, assign) bool debug;
@property (nonatomic, assign) bool blurApp;
@property (nonatomic, assign) float screenWidth;
@property (nonatomic, assign) float screenHeight;
@property (nonatomic, assign) float visibleEdge;
@property (nonatomic, assign) float widthDivisor;
@property (strong, nonatomic) SlideyWindow* slideyWindow;
@property (strong, nonatomic) SlideyActivator* slideyActivator;
@property (strong, nonatomic) SlideyTableViewController* slideyTableController;
@property (strong, nonatomic) NSMutableArray* appsList;

-(id)init;
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
-(void)updateWindowLevels;
-(void)loadUp;
-(void)show;
-(void)hide;
-(void)didRotate:(UIInterfaceOrientation)orientation;
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end