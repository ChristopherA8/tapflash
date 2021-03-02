#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>


// PLEASE READ BEFORE ROASTING ME //
// 				  //
// This tweak could be way better //
// optimized, and not use global  //
// variabled etc..		  //
// I wrote this for a friend and  //
// kind of forgot about it.	  //
// : )    that is all		  //
// Hope you like it		  //
//				  //
////////////////////////////////////

@interface SBVolumeControl
-(void)checkForPress;
@end

@interface AVFlashlight
-(BOOL)setFlashlightLevel:(float)arg1 withError:(id*)arg2 ;
@end

static BOOL flashlightEnabled = NO;

void toggleFlashlight() {
	static AVFlashlight *flashlight = [[%c(AVFlashlight) alloc] init];

    if (flashlightEnabled) {
        [flashlight setFlashlightLevel:0 withError:nil];
        flashlightEnabled = NO;
    } else {
        [flashlight setFlashlightLevel:1 withError:nil];
        flashlightEnabled = YES;
    }

}


// woe, don't write code like this pls
BOOL inc = NO;
BOOL dec = NO;

%hook SBVolumeControl
-(void)increaseVolume {
	inc = YES;
	%orig;
	[self checkForPress];
}
-(void)decreaseVolume {
	dec = YES;
	%orig;
	[self checkForPress];
}
%new
-(void)checkForPress {
	if (inc == YES && dec == YES) {
		toggleFlashlight();
		inc = NO;
		dec = NO;
	}
	dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.3);
	dispatch_after(delay, dispatch_get_main_queue(), ^(void){
		inc = NO;
		dec = NO;
	});
}
%end
