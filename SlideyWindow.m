#import "SlideyWindow.h"
#import "SlideyController.h"
#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)

@implementation SlideyWindow


-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		REDLog(@"SLIDEYDEBUG: SlideyWindow - init called");
		self.backgroundColor = [UIColor clearColor];



    
    	self.currentAppView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
  
    	[self addSubview:self.currentAppView];

    	self.slideyHolder = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width * 0.30, frame.size.height)];
    	self.slideyHolder.backgroundColor = [UIColor clearColor];
    	[self addSubview:self.slideyHolder];

    	
    	self.backgroundBlurView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 0.30, frame.size.height)];
   
    	//self.backgroundBlurView.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    	
    	[self.slideyHolder addSubview:self.backgroundBlurView];

    	dimView = [[UIView alloc] initWithFrame:CGRectMake(0,0, frame.size.width * 0.30, frame.size.height)];
    	dimView.backgroundColor = [UIColor blackColor];
    	dimView.alpha = 0.7;
    	[self.slideyHolder addSubview:dimView];
    


    	self.appsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 0.30, frame.size.height)];
  		self.appsTableView.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.0f];
  		[self.appsTableView setShowsVerticalScrollIndicator:FALSE];
    	//self.appsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    	[self.appsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   	

    	[self.slideyHolder addSubview:self.appsTableView];
		REDLog(@"SLIDEYDEBUG: SlideyWindow - loadUp finished?");

	}
	return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    REDLog(@"SLIDEYDEBUG: SlideyWindow - layoutSubviews called");
self.slideyHolder.frame = CGRectMake(self.slideyHolder.frame.origin.x, 0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
self.backgroundBlurView.frame = CGRectMake(0, 0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
dimView.frame = CGRectMake(0,0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
//self.appsTableView.frame = CGRectMake(0, 0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
        //self.appsTableView.dataSource = self.slideyController.slideyTableController;
        //self.appsTableView.delegate = self.slideyController.slideyTableController;
            //[self.appsTableView reloadData];
            
}

-(void)loadUp{
REDLog(@"SLIDEYDEBUG: SlideyWindow - loadUp called");
self.slideyHolder.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
self.backgroundBlurView.frame = CGRectMake(0, 0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
dimView.frame = CGRectMake(0,0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
self.appsTableView.frame = CGRectMake(0, 0, self.frame.size.width * self.slideyController.widthDivisor, self.frame.size.height);
        self.appsTableView.dataSource = self.slideyController.slideyTableController;
        self.appsTableView.delegate = self.slideyController.slideyTableController;
            [self.appsTableView reloadData];
}

-(void)updateImages{
    	self.backgroundBlurView.contentMode = UIViewContentModeTopLeft; 
    	self.backgroundBlurView.clipsToBounds = YES;
    	self.backgroundBlurView.layer.masksToBounds = YES;

}

-(void)updateWindowLevel{
	REDLog(@"SLIDEYDEBUG: SlideyWindow - updateWindowLevel called");
	self.windowLevel = 100000.0f;
    self.userInteractionEnabled = TRUE;
    self.hidden = NO;
}



-(void)dealloc{
	[self.currentAppView release];
	[self.backgroundBlurView release];
	[self.slideyHolder release];
    [dimView release];
	[super dealloc];
}


@end