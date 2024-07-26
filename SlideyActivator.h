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



@class SlideyController;
@interface SlideyActivator : UIWindow <UIGestureRecognizerDelegate>{
	SlideyController *_slideyController;
}
@property (nonatomic, assign) SlideyController *slideyController;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeIt;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end