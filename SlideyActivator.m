#import "SlideyActivator.h"

#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)


@implementation SlideyActivator


-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Slidey.bundle/SlideyGrab.png"]]; //Too lazy to make a whole .deb layout for this thing right now...
		//self.backgroundColor = [UIColor greenColor];
	}
	return self;
}

-(void)updateWindowLevel{
	REDLog(@"SLIDEYDEBUG: SlideyActivator - updateWindowLevel called");
	self.windowLevel = 100001.0f;
    self.userInteractionEnabled = TRUE;
    self.hidden = NO;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	if(self.swipeIt){
		//[self.swipeIt setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft)]; //Maybe check orientation here, or somewhere else, and then change swipe direction to match orentation?
	}
}

-(void)loadUp{

	if(!self.swipeIt){
    	self.swipeIt = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    	self.swipeIt.cancelsTouchesInView = FALSE;
    	[self addGestureRecognizer:self.swipeIt];
	}
    [self.swipeIt setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft)];
   

}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
	[self.slideyController handleSwipeFrom:recognizer];
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

if ([touch.view isKindOfClass:[UIButton class]] || [[objc_getClass("UIKeyboard") activeKeyboard] isOnScreen]) {
    return FALSE;
}
return TRUE;
}

*/


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];

    // If the hitView is THIS view, return nil and allow hitTest:withEvent: to
    // continue traversing the hierarchy to find the underlying view.
    if (hitView == self) {
      //  return nil;
    }
    if ([objc_getClass("UIKeyboard") isOnScreen]) {
    	return nil;
	}
    // Else return the hitView (as it could be one of this view's buttons):
    return hitView;
}


 - (BOOL)shouldAutorotate{
        return YES;
    }

-(void)dealloc{
	[super dealloc];
	[self.swipeIt release]; 
}

@end