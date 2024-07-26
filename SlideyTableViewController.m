#import "SlideyTableViewController.h"
#import "SlideyController.h"
#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)

@interface SBApplication
@end

@interface SBApplicationIcon
@end

@implementation SlideyTableViewController

-(id)init{
	self = [super init];
	if(self){

	}
	return self;
}

-(void)loadUp{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"Moduleslist count is: %@", mController);
        return self.slideyController.appsList.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    NSString *appBundleID = [self.slideyController.appsList objectAtIndex:indexPath.row]; //FIXME: put error handling in to make sure we have this!
//	NSLog(@"SLIDEYDEBUG: - SlideyTableViewController - cellForRowAtIndexPath - loading up: %@", appBundleID);
    SlideyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[SlideyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    cell.backgroundView = [[UIView alloc] init];
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

}

	cell.roundCorners = self.slideyController.roundCorners;

  SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:appBundleID];
    SBApplicationIcon *appIconImage = [[objc_getClass("SBApplicationIcon") alloc] initWithApplication:app];
    cell.icon.image = [appIconImage getIconImage:2];
    cell.iconImage = [appIconImage getIconImage:2];
    //cell.iconUnderlay.image = self.slideyController.slideyWindow.backgroundBlurView.image;
    cell.iconUnderlayImage = self.slideyController.slideyWindow.backgroundBlurView.image;
    [appIconImage release];

      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.appLabel.text = [app displayName];
    cell.appName = [app displayName];
    [cell loadUp];
   // NSLog(@"Cell is: %@", cell);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      // NSDictionary *cellDict = [slideyController.appsList objectAtIndex:indexPath.row]; //FIXME: put error handling in to make sure we have this!
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
        /*
        [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   [modulesTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){

                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   [modulesTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(0.95, 0.95);
           
                 }
                 completion:^(BOOL finished){
                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   [modulesTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(1.0, 1.0);
                 } completion:nil];
                 }];
                 }];
                 */
  SlideyTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  CGRect rect = [cell convertRect:cell.frame toView:self.slideyController.slideyWindow];
  //NSLog(@"Cell is :%@", cell);
 // NSLog(@"Rect y is: %f", rect.origin.y);
  [[objc_getClass("SBUIController") sharedInstance] activateApplicationFromSwitcher:[[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:[self.slideyController.appsList objectAtIndex:indexPath.row]]];
  [self.slideyController hide];
 //[self.navigationController showModuleForID:[cellDict objectForKey:@"identifier"] atY:rect.origin.y];
//[self.navigationController showModuleForID:[cellDict objectForKey:@"identifier"]];
      
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return self.slideyController.screenHeight / 3.5;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {

   //Nasty nasty nasty hack to get the blurred background to sort of "show through" as the divider between cells.
  for (NSIndexPath *indexPath in [self.slideyController.slideyWindow.appsTableView indexPathsForVisibleRows]) {
    //Do something with your indexPath. Maybe you want to get your cell,
    // like this:
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SlideyTableCell *cell = [self.slideyController.slideyWindow.appsTableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [self.slideyController.slideyWindow.appsTableView convertRect:[self.slideyController.slideyWindow.appsTableView rectForRowAtIndexPath:indexPath] toView:self.slideyController.slideyWindow];
     
    	    float newHolderX = (rect.origin.x + cell.iconUnderlay.frame.origin.x);
    	float newOffset =  ((newHolderX) / self.slideyController.screenWidth);
     // NSLog(@"SLIDEYDEBUG: scrollView_ - newOffset is: %f", newOffset);
   	cell.iconUnderlay.layer.contentsRect = CGRectMake(newOffset, (rect.origin.y + (cell.contentView.center.y - ((cell.contentView.frame.size.height / 1.05) / 2)))/ self.slideyController.slideyWindow.frame.size.height, 1, 1);   

     // NSLog(@"Y is: %f", rect.origin.y / [modulesTableView superview].frame.size.height);
}
}
@end