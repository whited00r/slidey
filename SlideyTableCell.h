#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface SlideyTableCell : UITableViewCell{
	bool _roundCorners;
	float paddingDivisor;
	float iconSizeDivisor;
	float underlaySizeDivisor;
}
@property (nonatomic, assign) bool roundCorners;
@property (strong, nonatomic) UILabel* appLabel;
@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UIImageView* iconUnderlay;
@property (strong, nonatomic) UIView* cellDim;
@property (strong, nonatomic) UILabel* appName;
@property (strong, nonatomic) UIImage* iconImage;
@property (strong, nonatomic) UIImage* iconUnderlayImage;

@end