#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "SlideyTableCell.h"
//#import "SlideyController.h"

@class SlideyController;
@interface SlideyTableViewController : NSObject <UITableViewDelegate, UITableViewDataSource>{
	
}
@property (nonatomic, assign) SlideyController *slideyController;
@end