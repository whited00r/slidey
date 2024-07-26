#import <Preferences/Preferences.h>

@interface SlideyListController: PSListController {
}
@end

@implementation SlideyListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Slidey" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
