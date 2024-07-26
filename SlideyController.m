#import "SlideyController.h"

@implementation SlideyController
@synthesize roundCorners = _roundCorners;
-(id)init{
	self = [super init];
	if(self){
		REDLog(@"SLIDEYDEBUG: SlideyController - init called");
            
			self.showingSlidey = FALSE;
			self.appsList = [[NSMutableArray alloc] init];
			REDLog(@"SLIDEYDEBUG: SlideyController - init finished?");
	}
	return self;
}

-(void)loadUp{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"com.greyd00r.slidey.orientationChangeNotification" object:nil];

	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp called");


            if(!self.slideyTableController){ 
            	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp - making slideyTableController");
             	self.slideyTableController = [[SlideyTableViewController alloc] init]; 
             	self.slideyTableController.slideyController = self;
               	//self.slideyActivator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
               	[self.slideyTableController loadUp];
               	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp - made slideyTableController");

			}

            if(!self.slideyWindow){ 
            	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp - making slideyWindow");
             	self.slideyWindow = [[SlideyWindow alloc] initWithFrame:CGRectMake(self.screenWidth, 0, self.screenWidth, self.screenHeight)]; //[[SlideyWindow alloc] initWithFrame:CGRectMake(screenWidth - visibleEdge,(screenHeight /2) - ((screenHeight / 3) / 2 ), screenWidth, screenHeight / 3)];
               	self.slideyWindow.slideyController = self;
               	self.slideyWindow.slideyTableController = self.slideyTableController;
               //[self.slideyWindow setAutoresizesSubviews:YES];
                
                //[self.slideyWindow.slideyHolder setAutoresizesSubviews:YES];
                //[self.slideyWindow.currentAppView setAutoresizesSubviews:YES];

               	//self.slideyWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                //self.slideyWindow.slideyHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                 //self.slideyWindow.currentAppView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
               	[self.slideyWindow loadUp];
               	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp - made slideyWindow");

			}
            if(!self.slideyActivator){ 
            	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp - making slideyActivator");
             	self.slideyActivator = [[SlideyActivator alloc] initWithFrame:CGRectMake(self.screenWidth - self.visibleEdge, 0, self.visibleEdge, self.screenHeight)]; //[[SlideyWindow alloc] initWithFrame:CGRectMake(screenWidth - visibleEdge,(screenHeight /2) - ((screenHeight / 3) / 2 ), screenWidth, screenHeight / 3)];
               	self.slideyActivator.slideyController = self;
                //self.slideyActivator.rootViewController = self;
                [self.slideyActivator setAutoresizesSubviews:YES];
               	self.slideyActivator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
               	[self.slideyActivator loadUp];
               	REDLog(@"SLIDEYDEBUG: SlideyController - loadUp - made slideyActivator");

			}

/*
[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

                                          
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(didRotate:)
                                             name:@"com.greyd00r.slidey.orientationChangeNotification"
                                           object:nil];
*/

REDLog(@"SLIDEYDEBUG: SlideyController - loadUp finished?");
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	REDLog(@"SLIDEYDEBUG: SlideyController - handleSwipeFrom called : %@", recognizer);
	if(!self.showingSlidey){
		[self show];
	}
	else{
		[self hide];
	}
}

-(void)updateWindowLevels{
	REDLog(@"SLIDEYDEBUG: SlideyController - updateWindowLevels called");
	if(self.slideyWindow) [self.slideyWindow updateWindowLevel];
	if(self.slideyWindow) [self.slideyActivator updateWindowLevel];
}


-(void)layout{

}

-(void)show{
	if([[objc_getClass("SBAwayController") sharedAwayController] isLocked]){ //Don't do this while locked, obviously!
		return;
	}
        REDLog(@"SLIDEYDEBUG: - SlideyController - show - screenWidth: %f, screenHeight: %f", self.screenWidth, self.screenHeight);
	[self.slideyWindow.appsTableView scrollRectToVisible:CGRectMake(0, self.slideyWindow.appsTableView.contentSize.height - self.slideyWindow.appsTableView.bounds.size.height, self.slideyWindow.appsTableView.bounds.size.width, self.slideyWindow.appsTableView.bounds.size.height) animated:YES];
	[self.slideyWindow.appsTableView reloadData]; //FIXME/TODO: This reloads all the cells at once. Maybe it's a bad idea because of lag/performance hits here, but otherwise the icon underlays don't update at the moment.
	self.slideyWindow.currentAppView.hidden = FALSE;
		float holderY = (self.screenWidth - 0);
    	float offset =  (holderY)/ self.screenWidth;
	    float newHolderY = (self.screenWidth - (self.screenWidth * self.widthDivisor));
    	float newOffset =  (newHolderY)/ self.screenWidth;
    	//(rect.origin.y + (cell.contentView.frame.size.height - 6.5))/ [scrollView_ superview].frame.size.height
   	self.slideyWindow.backgroundBlurView.layer.contentsRect = CGRectMake(offset, 0.0, 1, 1);
    	NSLog(@"SLIDEYDEBUG: SlideyWindow - updateImages called - contentsRect is %f", offset);
	self.slideyWindow.currentAppView.image = self.blurApp ? [UIImage liveBlurForScreenWithQuality:4 interpolation:4 blurRadius:15] : [UIImage liveSnapshotOfScreen];
  self.slideyWindow.currentAppView.alpha = 0.0;
	self.slideyWindow.currentAppView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
	self.slideyWindow.slideyHolder.frame = CGRectMake(self.screenWidth, 0, self.screenWidth * self.widthDivisor, self.screenHeight);
	self.slideyWindow.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);

	//self.slideyWindow.backgroundBlurView.frame = CGRectMake(self.screenWidth, 0, self.screenWidth * self.widthDivisor, self.screenHeight);
	self.slideyWindow.backgroundBlurView.image = self.blurApp ? self.slideyWindow.currentAppView.image : [UIImage liveBlurForScreenWithQuality:4 interpolation:4 blurRadius:15]; //Why duplicate the image blurring process?
	[self.slideyWindow updateImages];

	[UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                
                  // self.moduleName.frame = CGRectMake(70,0,190, 50);
					self.slideyActivator.frame = CGRectMake(0, 0, self.screenWidth - (self.screenWidth * self.widthDivisor), self.screenHeight);
					//self.slideyWindow.currentAppView.frame = CGRectMake(-(self.screenWidth * self.widthDivisor), 0, self.screenWidth, self.screenHeight);
          self.slideyWindow.currentAppView.alpha = 1.0; 
                  	self.slideyWindow.slideyHolder.frame = CGRectMake(self.screenWidth - (self.screenWidth * self.widthDivisor), 0, self.screenWidth * self.widthDivisor, self.screenHeight);
                  	self.slideyWindow.backgroundBlurView.layer.contentsRect = CGRectMake(newOffset, 0.0, 1, 1);
                  // self.icon.transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){
                 	self.showingSlidey = TRUE;
                 }];
}


-(void)hide{
        REDLog(@"SLIDEYDEBUG: - SlideyController - hide - screenWidth: %f, screenHeight: %f", self.screenWidth, self.screenHeight);
	//self.slideyWindow.currentAppView.hidden = TRUE;
		float holderY = (self.screenWidth - 0);
    	float offset =  (holderY)/ self.screenWidth;

	[UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                
                  // self.moduleName.frame = CGRectMake(70,0,190, 50);
                  self.slideyWindow.currentAppView.alpha = 0.0;
					self.slideyActivator.frame = CGRectMake(self.screenWidth - self.visibleEdge, 0, self.visibleEdge, self.screenHeight);
                   	self.slideyWindow.slideyHolder.frame = CGRectMake(self.screenWidth, 0, self.screenWidth * self.widthDivisor, self.screenHeight);
                   	self.slideyWindow.backgroundBlurView.layer.contentsRect = CGRectMake(offset, 0.0, 1, 1);
                  // self.icon.transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){
                 	self.showingSlidey = FALSE;
                 	self.slideyWindow.frame = CGRectMake(self.screenWidth, 0, self.screenWidth * self.widthDivisor, self.screenHeight);
                 }];
}

-(void)updateApps{
	NSArray *recentDisplayIDs = [[objc_getClass("SBAppSwitcherModel") sharedInstance] valueForKey:@"recentDisplayIdentifiers"];

 
    NSMutableArray *tempIDs = [NSMutableArray arrayWithArray:recentDisplayIDs];
    NSArray *removeIDs = [[NSArray alloc] initWithObjects:@"com.apple.AdSheet", @"com.apple.DemoApp", @"com.apple.iphoneos.iPodOut", @"com.apple.TrustMe", @"com.apple.webapp", @"com.apple.WebSheet", @"com.apple.nike", @"com.apple.NewsStand", @"com.apple.Newsstand", @"com.apple.newsstand", @"com.apple.FieldTest", @"com.apple.fieldtest", nil];
    
    for(NSString *removeableID in removeIDs){
    if([tempIDs containsObject:removeableID]){
    	[tempIDs removeObject:removeableID];
    }
	}

    self.appsList = [[tempIDs reverseObjectEnumerator] allObjects];
    [removeIDs release];
    [self.slideyWindow.appsTableView reloadData];

    REDLog(@"SLIDEYDEBUG: - SlideyController -  %@ updateApps is : %@", self.slideyWindow.appsTableView, self.appsList);
}


-(void)removeRecentApp:(NSString*)bundleID{
	if([self.appsList indexOfObject:bundleID] > -1){
		[self.appsList removeObject:bundleID];
	}
	[self.slideyWindow.appsTableView reloadData];
}

-(void)addRecentApp:(NSString*)bundleID{
	if([self.appsList indexOfObject:bundleID] > -1){
		[self.appsList removeObject:bundleID];
	}
	[self.appsList insertObject:bundleID atIndex:0];
	[self.slideyWindow.appsTableView reloadData];
}

-(void)didRotate:(UIInterfaceOrientation)orientation{

    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  //NSLog(@"SLIDEYDEBUG: didRotate: %@", notification);
//UIInterfaceOrientation orientation = [[[notification valueForKey:@"userInfo"] objectForKey:@"orientation"] intValue];
  REDLog(@"SLIDEYDEBUG: - SlideyController - didRotate: %ld", orientation);
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            // do something for portrait orientation
        	REDLog(@"SLIDEYDEBUG - SlideyController - didRotate is now in portrait");
          [self.slideyActivator.swipeIt setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
           	REDLog(@"SLIDEYDEBUG - SlideyController - didRotate is now in landscape");
            [self.slideyActivator.swipeIt setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown)];
            break;

        default:
            break;
    }

CGRect screenFrame = [[UIScreen mainScreen] bounds];
self.screenWidth = screenFrame.size.width;
self.screenHeight = screenFrame.size.height;
float angleRadians = 0;
switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            angleRadians = 180;
            self.screenWidth = screenFrame.size.width;
            self.screenHeight = screenFrame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angleRadians = -90;
            self.screenWidth = screenFrame.size.height;
            self.screenHeight = screenFrame.size.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angleRadians = 90;
            self.screenHeight = screenFrame.size.width;
            self.screenWidth = screenFrame.size.height;
            break;
        case UIInterfaceOrientationPortrait:
        default:
            angleRadians = 0;
            self.screenWidth = screenFrame.size.width;
            self.screenHeight = screenFrame.size.height;
            break;
    }

    //[self willAnimateRotationToInterfaceOrientation:orientation duration:1.0];
      REDLog(@"SLIDEYDEBUG: - SlideyController - didRotate - screenWidth: %f, screenHeight: %f", self.screenWidth, self.screenHeight);
    //[UIView animateWithDuration:0.3f animations:^{


        self.slideyWindow.transform = CGAffineTransformMakeRotation(angleRadians * M_PI / 180.0f);
        self.slideyWindow.frame = CGRectMake(self.slideyWindow.frame.origin.x, 0, self.screenWidth, self.screenHeight);
        //self.slideyWindow.slideyHolder.transform = CGAffineTransformMakeRotation(angleRadians);
        //self.slideyWindow.slideyHolder.frame = CGRectMake(self.slideyWindow.slideyHolder.frame.origin.x, 0, self.screenWidth, self.screenHeight);
        //self.slideyWindow.currentAppView.transform = CGAffineTransformMakeRotation(angleRadians);
        self.slideyWindow.currentAppView.frame = CGRectMake(self.slideyWindow.currentAppView.frame.origin.x, 0, self.screenWidth, self.screenHeight);
        self.slideyActivator.transform = CGAffineTransformMakeRotation(angleRadians * M_PI / 180.0f);
        self.slideyActivator.frame = CGRectMake(self.screenWidth - self.visibleEdge, 0, self.visibleEdge, self.screenHeight);
        
   // } completion:nil];
}

/*
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return TRUE;
}

-(BOOL)shouldAutorotate{
  return TRUE;
}

-(NSUInteger)supportedInterfaceOrientations{
  return UIInterfaceOrientationMaskAll;
}
*/


@end