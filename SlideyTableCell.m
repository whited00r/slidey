#import "SlideyTableCell.h"
#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)

@interface SBIconView

+(CGSize)defaultIconSize;

@end

static BOOL canAddLayerMask = FALSE;
@interface UIView (RoundCorners)
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size;

@end

@implementation UIView (RoundCorners)
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size {
if(size.width == 0){
    self.layer.mask = nil;
    self.layer.shouldRasterize = FALSE;

    self.layer.cornerRadius = size.width;
    return;
}
else{
self.clipsToBounds = YES;
self.layer.cornerRadius = size.width;
self.layer.shouldRasterize = FALSE;
return;
}

/*
NSLog(@"Setting corner radius!");
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];

CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = self.bounds;
maskLayer.path = maskPath.CGPath;

self.layer.mask = maskLayer;
self.layer.shouldRasterize = TRUE;
[maskLayer release];
[pool drain];
*/
}

@end


@implementation SlideyTableCell
@synthesize roundCorners = _roundCorners;
-(id)initWithStyle:(UITableViewStyle*)UITableViewCellStyleDefault reuseIdentifier:(NSString*)cellIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(self){
    // Create & position UI elements
   // self.moduleID = [[NSString alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    CGSize iconSizes = (CGSize)[objc_getClass("SBIconView") defaultIconSize];
   	float iconSize = iconSizes.width;//self.frame.size.height;
    
    paddingDivisor = self.frame.size.width / iconSize;
    underlaySizeDivisor = 3.2;
    iconSizeDivisor = 2.0;





    //self.iconUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(54, 10, 1, 30)]; //Well, it is more of a divider between the icon and the module name label now.
    self.iconUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,iconSize / underlaySizeDivisor,iconSize / underlaySizeDivisor)]; //This is the actual icon underlay
   // self.iconUnderlay.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.iconUnderlay.contentMode = UIViewContentModeTopLeft; 

    self.iconUnderlay.layer.masksToBounds = YES;
    self.iconUnderlay.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.iconUnderlay];

    self.cellDim = [[UIView alloc] initWithFrame:CGRectMake(0,0,iconSize, iconSize)];

    self.cellDim.backgroundColor = [UIColor darkGrayColor];
    self.cellDim.alpha = 0.5;
    [self.contentView addSubview:self.cellDim];


    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0,iconSize, iconSize)];
   
   // self.icon.image = [self iconImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    //self.icon.clipsToBounds = YES;
    //self.icon.layer.cornerRadius = 10;
    [self.contentView addSubview:self.icon];

    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
	self.appLabel.frame = CGRectMake( 0 ,0,self.frame.size.width, 50);
    self.appLabel = [[UILabel alloc] init];
    self.appLabel.frame = CGRectMake( 0 ,0,self.frame.size.width, 50);
    self.appLabel.alpha = 0.9;
    self.appLabel.textColor = [UIColor whiteColor];
    self.appLabel.backgroundColor = [UIColor clearColor];
    self.appLabel.font = [UIFont systemFontOfSize:12.0];
    self.appLabel.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:self.appLabel];
   
    }
    

    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    /*
    [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   self.transform=CGAffineTransformMakeScale(1.05, 1.05);
                   //self.backgroundColor = [UIColor colorWithPatternImage:[self blurredBackgroundImage]];
           
                 }
                 completion:nil];
*/


}




-(void)loadUp{



//float iconSize = self.contentView.frame.size.height / iconSizeDivisor;
if(self.contentView.frame.size.height > self.contentView.frame.size.width){
	//iconSize = self.contentView.frame.size.width / iconSizeDivisor;
}

   CGSize iconSizes = (CGSize)[objc_getClass("SBIconView") defaultIconSize];
    float iconSize = iconSizes.width;//self.frame.size.height;

    paddingDivisor = 0.5+((self.frame.size.width / 2) / iconSize);
    
    underlaySizeDivisor = 1.0+((self.frame.size.height / 2) / iconSize);
    iconSizeDivisor = 2.0;
    //NSLog(@"PADDINGDIVISOR: %f - UNDERLAYSIZEDIVISOR:", paddingDivisor, underlaySizeDivisor);

float underlaySize = iconSize * underlaySizeDivisor;
if(self.contentView.frame.size.height > self.contentView.frame.size.width){
	underlaySize = iconSize * underlaySizeDivisor;
}
self.iconUnderlay.image = self.iconUnderlayImage;
self.iconUnderlay.frame = CGRectMake(0,0,iconSize * paddingDivisor, underlaySize);
//REDLog(@"SLIDEYDEBUG: SlideyTableCell - loadUp - iconSize is %f", iconSize);
self.icon.frame = CGRectMake(0,0,iconSize, iconSize);
self.icon.center = self.contentView.center;
self.iconUnderlay.center = self.contentView.center;
self.cellDim.frame = self.iconUnderlay.frame;
self.appLabel.frame = CGRectMake( 0 ,self.contentView.center.y + (iconSize / 3.5),self.frame.size.width, 50);


//have to do this last mates!

    if(self.roundCorners){
        if(self.iconUnderlay.layer.mask == nil) [self.iconUnderlay setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight radius:CGSizeMake(10.0, 10.0)];
        if(self.cellDim.layer.mask == nil) [self.cellDim setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight radius:CGSizeMake(10.0, 10.0)];
        /*
        self.iconUnderlay.clipsToBounds = YES;
        self.iconUnderlay.layer.cornerRadius = 10;
        self.cellDim.clipsToBounds = YES;
        self.cellDim.layer.cornerRadius = 10;
        */
    } 
    else{
        [self.iconUnderlay setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight radius:CGSizeMake(0.0, 0.0)];
        [self.cellDim setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight radius:CGSizeMake(0.0, 0.0)];
        //self.iconUnderlay.clipsToBounds = FALSE;
        //self.iconUnderlay.layer.cornerRadius = 0;
        //self.cellDim.clipsToBounds = FALSE;
        //self.cellDim.layer.cornerRadius = 0;
    }
}
@end