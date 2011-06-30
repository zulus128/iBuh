//
//  iBuhAppDelegate.h
//  iBuh
//
//  Created by вадим on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

///Users/YOURUSER/Library/Developer/Xcode/DerivedData/YOURPROJECTNAME_SOMETHINGSOMETHING/Build/Products


//git push origin master
//pass: vaddav123

//http://www.icodeblog.com/2010/09/16/dealing-with-the-twitter-oauth-apocalypse/
//http://gitready.com/beginner/2009/01/19/ignoring-files.html

#import <UIKit/UIKit.h>

#define kOFFSET_FOR_KEYBOARD 20.0

@interface iBuhAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITextFieldDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIViewController* startController;

- (IBAction)up: (id)sender;
- (IBAction)down: (id)sender;
-(void)setViewMovedUp:(BOOL)movedUp;

@end
