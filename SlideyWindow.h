#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGraphics.h>
#import "UIImage+StackBlur.h"
#import <IOSurface/IOSurface.h>
#import <QuartzCore/QuartzCore2.h>
#import <objc/runtime.h>
#import "UIImage+LiveBlur.h"



@class SlideyController, SlideyTableController;
@interface SlideyWindow : UIWindow{
	UIView *dimView;
	
}

@property (nonatomic, assign) SlideyController *slideyController;
@property (nonatomic, assign) SlideyTableController *slideyTableController;
@property (strong, nonatomic) UIImageView* backgroundBlurView;
@property (strong, nonatomic) UIView *slideyHolder;
@property (strong, nonatomic) UIImageView *currentAppView;
@property (strong, nonatomic) UITableView *appsTableView;

@end