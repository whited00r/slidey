#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGraphics.h>
#import "UIImage+StackBlur.h"
#import <IOSurface/IOSurface.h>
#import <QuartzCore/QuartzCore2.h>
#import <objc/runtime.h>
#import "dlfcn.h"
#import <Foundation/NSDistributedNotificationCenter.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFNotificationCenter.h>
#import "UIImage+LiveBlur.h"

#import "SlideyController.h"

static SlideyController *slideyController;
extern int slideyOrientation = 1;
static float screenWidth = 320;
static float screenHeight = 480;
static float visibleEdge = 15;
static float widthDivisor = 0.40;

static bool debug = true;
static bool roundCorners = false;
static bool blurApp = true;
static bool overrideSwitcher = false;
static bool allowRotation = false;

#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
//#import <sys/sysctl.h>
#import "NSData+Base64.h"
static inline void alertIfNeeded(){
  //NSLog(@"Should show for update check");
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  BOOL shouldAlert = FALSE; //Only alert if both the lockscreen tweak *and* GD7UI are disabled. GD7UI should always be enabled because everything else depends on it so use that as the fallback alert tweak.
  if(![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/liblockscreen.dylib"]){
      if(![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/gd7ui.dylib"]){
        shouldAlert = TRUE;
      }
  }


  if(shouldAlert){
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Grayd00r Error"
                                       message: @"Your acitvation key for Grayd00r is invalid.\n\nIt also seems as though your re-activtion lockscreen is also invalid.\n\nNone of the features of Grayd00r will function until this is resolved.\nPlease re-install Grayd00r using the latest version of the installer from\nhttp://grayd00r.com."
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            [alert release];
  }
  [pool drain];
}

static inline BOOL isSlothSleeping(){
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
NSData* fileData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/com.greyd00r.installerInfo.plist"];
NSData* signatureData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/com.greyd00r.installerInfo.plist.sig"];
//Okay, this is technically not good to do, but it's even worse if I just include the bloody certificate on the device by default because then it just gets replaced easier. Same for keeping it in the keychain perhaps because it isn't sandboxed? Hide it in the binary they said, it will be safer, they said.
NSData* certificateData = [NSData dataFromBase64String:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"MIIC6jCCAdICCQC2Zs0BWO+dxzANBgkqhkiG9w0BAQsFADA3MQswCQYDVQQGEwJV",
@"UzERMA8GA1UECgwIR3JheWQwMHIxFTATBgNVBAMMDGdyYXlkMDByLmNvbTAeFw0x",
@"NTEwMjQyMzEzNTNaFw0yMTA0MTUyMzEzNTNaMDcxCzAJBgNVBAYTAlVTMREwDwYD",
@"VQQKDAhHcmF5ZDAwcjEVMBMGA1UEAwwMZ3JheWQwMHIuY29tMIIBIjANBgkqhkiG",
@"9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsWSkvU26FQlb/IOE/QWKSyt3L5ekj+uvdVQq",
@"Eljo35THov9qKSqTMhdgMGkWDCVnqHsgf0+LjHZcFfz+cI1++1bsHCxvhJvytvYx",
@"uRQmjh0+yAA28729dDCKhawQ5YLHbVC+4tHoyHhvK+Ww0mx+g7Y8bVh+qc1EBf6h",
@"VOrspUvoGHLQYAa15Wbca8mmXVpxuZVfviLskqffKtsPVe7EIx8WwzrI+v9GOXNi",
@"dR/rBJDU91u1AQc5BT9zAOFlLZq4VJLdNNWCs4w58f6260xDiUjMEAKzILhSjmN/",
@"Dys9McYE9Iu3lGPvFn2HCfOOgTg1sv3Hz/mogL5sbjvCCtQnrwIDAQABMA0GCSqG",
@"SIb3DQEBCwUAA4IBAQBLQ+66GOyKY4Bxn9ODiVf+263iLTyThhppHMRguIukRieK",
@"sVvngMd6BQU4N4b0T+RdkZGScpAe3fdre/Ty9KIt/9E0Xqak+Cv+x7xCzEbee8W+",
@"sAV+DViZVes67XXV65zNdl5Nf7rqGqPSBLwuwB/M2mwmDREMJC90VRJBFj4QK14k",
@"FuwtTpNW44NUSQRUIxiZM/iSwy9rqekRRAKWo1s5BOLM3o7ph002BDyFPYmK5UAN",
@"EM/aKFGVMMwhAUHjgej5iEPxPuks+lGY1cKUAgoxbvXJakybosgmDFfSN+DMT7ZU",
@"HbUgWDsLySwU8/+C4vDP0pmMqJFgrna9Wto49JNz"]];//[NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer"];  

//SecCertificateRef certRef = SecCertificateFromPath(@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer");
//SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certRef);



//SecKeyRef publicKey = SecKeyFromCertificate(certRef);

//recoverFromTrustFailure(publicKey);

if(fileData && signatureData && certificateData){


SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData); // load the certificate

SecPolicyRef secPolicy = SecPolicyCreateBasicX509();

SecTrustRef trust;
OSStatus statusTrust = SecTrustCreateWithCertificates( certificateFromFile, secPolicy, &trust);
SecTrustResultType resultType;
OSStatus statusTrustEval =  SecTrustEvaluate(trust, &resultType);
SecKeyRef publicKey = SecTrustCopyPublicKey(trust);


//ONLY iOS6+ supports SHA256! >:(
uint8_t sha1HashDigest[CC_SHA1_DIGEST_LENGTH];
CC_SHA1([fileData bytes], [fileData length], (unsigned char*)sha1HashDigest);

OSStatus verficationResult = SecKeyRawVerify(publicKey,  kSecPaddingPKCS1SHA1,  (const uint8_t *)sha1HashDigest, (size_t)CC_SHA1_DIGEST_LENGTH,  (const uint8_t *)[signatureData bytes], (size_t)[signatureData length]);
CFRelease(publicKey);
CFRelease(trust);
CFRelease(secPolicy);
CFRelease(certificateFromFile);
[pool drain];
if (verficationResult == errSecSuccess){
  return TRUE;
}
else{
  return FALSE;
}



}
[pool drain];
return false;
}

//static OSStatus SecKeyRawVerify;
static inline BOOL isSlothAlive(){

if(!isSlothSleeping()){ //Don't want to pass this off as valid if the user didn't actually install via the grayd00r installer from the website.
  alertIfNeeded();
  return FALSE;
}

NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//Go from NSString to NSData
NSData *udidData = [[NSString stringWithFormat:@"%@-%@-%c%c%c%@-%@%c%c%@%@%c",[[UIDevice currentDevice] uniqueIdentifier],@"I",'l','i','k',@"e",@"s",'l','o',@"t",@"h",'s'] dataUsingEncoding:NSUTF8StringEncoding];
uint8_t digest[CC_SHA1_DIGEST_LENGTH];
CC_SHA1(udidData.bytes, udidData.length, digest);
NSMutableString *hashedUDID = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//To NSMutableString to calculate hash

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [hashedUDID appendFormat:@"%02x", digest[i]];
    }

//Then back to NSData for use in verification. -__-. I probably could skip a couple steps here...
NSData *hashedUDIDData = [hashedUDID dataUsingEncoding:NSUTF8StringEncoding];
NSData* signatureData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/com.greyd00r.activationKey"];

//Okay, this is technically not good to do, but it's even worse if I just include the bloody certificate on the device by default because then it just gets replaced easier. Same for keeping it in the keychain perhaps because it isn't sandboxed? Hide it in the binary they said, it will be safer, they said.
NSData* certificateData = [NSData dataFromBase64String:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"MIIDJzCCAg+gAwIBAgIJAPyR9ASSBbF9MA0GCSqGSIb3DQEBCwUAMCoxETAPBgNV",
@"BAoMCEdyYXlkMDByMRUwEwYDVQQDDAxncmF5ZDAwci5jb20wHhcNMTUxMDI4MDEy",
@"MjQyWhcNMjUxMDI1MDEyMjQyWjAqMREwDwYDVQQKDAhHcmF5ZDAwcjEVMBMGA1UE",
@"AwwMZ3JheWQwMHIuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA",
@"94OZ2u2gJfdWgqWKV7yDY5pJXLZuRho6RO2OJtK04Xg3gUk46GBkYLo+/Z33rOvs",
@"XA041oAINRmdaiTDRa5VbGitQMYfObMz8m0lHQeb4/wwOasRMgAT2WCcKVulwpCG",
@"C7PiotF3F85VAuqJsbu1gxjJaQGIgR2L35LTR/fQq3N5+2+bsc0wUbPcLk7uhyYJ",
@"tna+CYRc+3qGRsv/t8MYF0T7LU2xwCcGV0phmr3er5ocAj9X57i92zYGMPlz8kMZ",
@"HfXqMova0prF9vuN7mo54kY+SF2rp/G/v+u5MicONpXwY6adJ0eIuXFjqsUjKTi6",
@"4Bjzhvf+Z6O5TARJzdVMqwIDAQABo1AwTjAdBgNVHQ4EFgQUDBxB98iHJnBsonVM",
@"LHF5WVXvhqgwHwYDVR0jBBgwFoAUDBxB98iHJnBsonVMLHF5WVXvhqgwDAYDVR0T",
@"BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEA4tyP/hMMJBYVFhRmdjAj9wnCr31N",
@"7tmyksLR76gqfLJL3obPDW+PIFPjdhBWNjcjNuw/qmWUXcEkqu5q9w9uMs5Nw0Z/",
@"prTbIIW861cZVck5dBlTkzQXySqgPwirXUKP/l/KrUYYV++tzLJb/ete2HHYwAyA",
@"2kl72gIxdqcXsChdO5sVB+Fsy5vZ2pw9Qan6TGkSIDuizTLIvbFuWw53MCBibdDn",
@"Y+CY2JrcX0/YYs4BSk5P6w/VInU5pn6afYew4XO7jRrGyIIPRJyR3faULqOLkenG",
@"Z+VNoXdO4+FShkEEfHb+Y8ie7E+bB0GBPb9toH/iH4cVS8ddaV3KiLkkJg=="]];//[NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer"];  

//SecCertificateRef certRef = SecCertificateFromPath(@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer");
//SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certRef);



//SecKeyRef publicKey = SecKeyFromCertificate(certRef);

//recoverFromTrustFailure(publicKey);

if(hashedUDIDData && signatureData && certificateData){


SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData); // load the certificate

SecPolicyRef secPolicy = SecPolicyCreateBasicX509();

SecTrustRef trust;
OSStatus statusTrust = SecTrustCreateWithCertificates( certificateFromFile, secPolicy, &trust);
SecTrustResultType resultType;
OSStatus statusTrustEval =  SecTrustEvaluate(trust, &resultType);
SecKeyRef publicKey = SecTrustCopyPublicKey(trust);


//ONLY iOS6+ supports SHA256! >:(
uint8_t sha1HashDigest[CC_SHA1_DIGEST_LENGTH];
CC_SHA1([hashedUDIDData bytes], [hashedUDIDData length], (unsigned char*)sha1HashDigest);

OSStatus verficationResult = SecKeyRawVerify(publicKey,  kSecPaddingPKCS1SHA1, (const uint8_t*)sha1HashDigest, (size_t)CC_SHA1_DIGEST_LENGTH,  (const uint8_t *)[signatureData bytes], (size_t)[signatureData length]);
CFRelease(publicKey);
CFRelease(trust);
CFRelease(secPolicy);
CFRelease(certificateFromFile);
[pool drain];

if (verficationResult == errSecSuccess){

  return TRUE;
}
else{
  alertIfNeeded();
  return FALSE;
}



}
[pool drain];
alertIfNeeded();
return false;
}



static void loadPrefs() {
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.greyd00r.slidey.plist"];
 	REDLog(@"SLIDEYDEBUG: loadPrefs - called");
	debug = [settings objectForKey:@"debug"] ? [[settings objectForKey:@"debug"] boolValue] : NO;
	roundCorners = [settings objectForKey:@"roundCorners"] ? [[settings objectForKey:@"roundCorners"] boolValue] : NO;
  blurApp = [settings objectForKey:@"blurApp"] ? [[settings objectForKey:@"blurApp"] boolValue] : NO;
  overrideSwitcher = [settings objectForKey:@"overrideSwitcher"] ? [[settings objectForKey:@"overrideSwitcher"] boolValue] : NO;
  allowRotation = [settings objectForKey:@"allowRotation"] ? [[settings objectForKey:@"allowRotation"] boolValue] : NO;
	if(slideyController){
		slideyController.debug = debug;
		slideyController.roundCorners = roundCorners;
    slideyController.blurApp = blurApp;
		REDLog(@"SLIDEYDEBUG: loadPrefs - settings is: %@", settings);
	} 
	
	//[settings release];
}
 
%ctor {

//FIXME/TODO: Put in preference file check to see if it even exists, and if not create one and populate it with default values.





 
}




%hook SBAwayView

-(id)initWithFrame:(CGRect)frame{

  if(!isSlothAlive()){
    return %orig;
  }
  
   loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.greyd00r.slidey.prefsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
 

CGRect screenFrame = [[UIScreen mainScreen] bounds];
screenWidth = screenFrame.size.width;
screenHeight = screenFrame.size.height;

if(!slideyController){
 
  //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	slideyController = [[SlideyController alloc] init];

    slideyController.screenWidth = screenWidth;
    slideyController.screenHeight = screenHeight;
    slideyController.visibleEdge = visibleEdge;
    slideyController.roundCorners = roundCorners;
    slideyController.blurApp = blurApp;
    slideyController.widthDivisor = widthDivisor;
    slideyController.debug = debug;
    [slideyController loadUp];
    [slideyController updateApps];
    if(allowRotation) slideyController.slideyActivator.backgroundColor = [UIColor greenColor];

}


//[[NSNotificationCenter defaultCenter] addObserver:slideyController  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];

[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *block) {

			//[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            if(!slideyController.showingSlidey){
 				[slideyController updateWindowLevels];
            }
            else{
             	[slideyController hide];
            }
        }];


	return %orig;
}

%end



//Hopefully this handles all the hooks needed to keep the activation method up top in all windows as the UIApplicationDidFinishLaunching thing doesn't seem to work right on iOS 6 :(
/*
%hook SBApplication
- (void)didActivate{
    
 
    %orig;
   // //NSLog(@"Launched %@ class: %@", [self displayIdentifier], [self class]);
   // if([disabledApps containsObject:[self displayIdentifier]]){
    //	[cardsScroll hideForApp];
   // }
 if(slideyController){
             if(!slideyController.showingSlidey){
 				[slideyController updateWindowLevels];

            }
            else{
             	[slideyController hide];
            }
        };
    
}

- (void)activate{
   
    %orig;
    //NSLog(@"Activate Launched %@ class: %@", [self displayIdentifier], [self class]);
    if(slideyController){
                if(!slideyController.showingSlidey){
 				[slideyController updateWindowLevels];
 				   [slideyController updateApps];
            }
            else{
             	[slideyController hide];
             	   [slideyController updateApps];
            }
        };
}



- (void)_setHasBeenLaunched{
    %orig;
    if(slideyController){
                if(!slideyController.showingSlidey){
 				[slideyController updateWindowLevels];

            }
            else{
             	[slideyController hide];
            }
        };
}

- (void)didAnimateActivation{
    %orig;
    if(slideyController){
                if(!slideyController.showingSlidey){
 				[slideyController updateWindowLevels];

            }
            else{
             	[slideyController hide];
            }
        };
}

- (void)didLaunch:(id)arg1{
    %orig;
    //NSLog(@"Launched %@ class: %@", arg1, [arg1 class]);
    if(slideyController){

             if(!slideyController.showingSlidey){
     
 				[slideyController updateWindowLevels];
            }
            else{
             	[slideyController hide];

            }
        };
}


%end
*/

%hook SBUIController
-(BOOL)clickedMenuButton{ 
  if(slideyController && slideyController.showingSlidey){
    [slideyController hide];
    return TRUE;
 }
else{
 return %orig; 
}

}

-(BOOL)handleMenuDoubleTap{
  if(slideyController && slideyController.showingSlidey){
    [slideyController hide];
    return TRUE; 
}
else{
  if(slideyController && overrideSwitcher && !slideyController.showingSlidey){
    [slideyController show];
    return TRUE;
  }
  else{
    return %orig;
  }
}
return %orig;
}



%end




%hook SpringBoard
-(void)frontDisplayDidChange {
    //iOS3.2-5
    %orig;
 // if(slideyController) [slideyController handleRotation:orientation];
   // CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), UPDATE_ORIENTATION_NOTI, NULL, NULL, true);
}

- (void)noteInterfaceOrientationChanged:(int)orientation {
    //iOS3.2-5
    %orig;
      if(slideyController && allowRotation) [slideyController didRotate:orientation];
    //CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), UPDATE_ORIENTATION_NOTI, NULL, NULL, true);
}

-(void)noteInterfaceOrientationChanged:(int)orientation duration:(double)duration {
    //iOS6
    %orig;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC / 5);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(slideyController && allowRotation) [slideyController didRotate:orientation];
       // CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), UPDATE_ORIENTATION_NOTI, NULL, NULL, true);
    });
}

%end

/*
%hook UIApplication
- (void)_notifyDidChangeStatusBarFrame:(struct CGRect)arg1{
  %orig;
UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];


   if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
         REDLog(@"SLIDEYDEBUG - handleRotation - didRotate is now in landscape");
    } else if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        REDLog(@"SLIDEYDEBUG - handleRotation - didRotate is now in portrait");
    } 
    slideyOrientation = interfaceOrientation;
//CFMutableDictionaryRef dictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
 // CFDictionaryAddValue(dictionary, @"key of string", @1);
  CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("com.greyd00r.slidey.orientationChangeNotification"), [NSString stringWithFormat:@"%ld",interfaceOrientation], NULL, true);
  //CFRelease(dictionary);


    NSDictionary* notificationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:interfaceOrientation], @"orientation",
                                          nil];

        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greyd00r.slidey.orientationChangeNotification" object:nil userInfo:[notificationInfo copy]]; //Seriously there has to be a better way to get the oreintation of the device than this. All methods I have tried thus far just return springboard oreintation though, which is not helpful.
       
REDLog(@"SLIDEYDEBUG: interfaceOrientation is: %ld, %ld", interfaceOrientation, slideyOrientation);

}


%end

%hook UIApplication
- (void)_reportAppLaunchFinished{
    %orig;
    if(slideyController){
                if(!slideyController.showingSlidey){
 				[slideyController updateWindowLevels];
            }
            else{
             	[slideyController hide];
            }
        };
}


%end
*/



%hook SBAppSwitcherModel

- (void)remove:(id)app{
	  	%orig;
if(slideyController){
                if(!slideyController.showingSlidey){
        [slideyController updateWindowLevels];
           [slideyController updateApps];
            }
            else{
              [slideyController hide];
                 [slideyController updateApps];
            }
        };

}

-(void)addToFront:(id)app{
		%orig;
if(slideyController){
                if(!slideyController.showingSlidey){
        [slideyController updateWindowLevels];
           [slideyController updateApps];
            }
            else{
              [slideyController hide];
                 [slideyController updateApps];
            }
        };
  
}


%end


