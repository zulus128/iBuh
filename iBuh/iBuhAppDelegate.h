//
//  iBuhAppDelegate.h
//  iBuh
//
//  Created by вадим on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//git push -u origin master

#import <UIKit/UIKit.h>

@interface iBuhAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
