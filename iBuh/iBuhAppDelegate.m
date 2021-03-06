//
//  iBuhAppDelegate.m
//  iBuh
//
//  Created by –≤–∞–і–Є–Љ on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iBuhAppDelegate.h"
#import "Common.h"

/*@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
    
//    NSString* sss = self.topItem.title;
//    NSLog(@"--- %@, %i",sss, [sss length]);
    if (self.topItem.title.length) {
        [super drawRect:rect];
        return;
    }
    UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
*/

@implementation iBuhAppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize startController=_startController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
 //   self.window.rootViewController = self.tabBarController;
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	NSString* cr = [userDefaults stringForKey:@"email"];
    
    //if(!cr.length)
    //    self.window.rootViewController = self.startController;
    //else
        self.window.rootViewController = self.tabBarController;
    
//    self.tabBarController
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_startController release];
    
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
- (IBAction)up: (id)sender {
    
	[self setViewMovedUp:YES];
}

- (IBAction)down: (id)sender {
	
	[self setViewMovedUp:NO];
}

-(void)setViewMovedUp:(BOOL)movedUp {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
	
    CGRect rect = self.startController.view.frame;
    if (movedUp) {
        
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else {

        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.startController.view.frame = rect;
	
    [UIView commitAnimations];
}

- (BOOL)validateEmailWithString:(NSString*)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	
    if (![self validateEmailWithString:textField.text]) {
		UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                 message:@"Введен некорректный адрес" delegate:nil cancelButtonTitle:@"Закрыть" otherButtonTitles:nil];
		[errorAlertView show];
		[errorAlertView release];
        
        return NO;
	} 
    
    [textField resignFirstResponder];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];  
    [userDefaults setObject:textField.text forKey:@"email"];  
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString* emailurl = [NSString stringWithFormat:EMAIL_URL,textField.text];
    NSLog(@"email URL = %@", emailurl);
 
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailurl]];
    
    [request setURL:[NSURL URLWithString:emailurl]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;//[[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    [error release];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"email sent response = %@", responseString);
    
    self.window.rootViewController = self.tabBarController;
    
	return NO;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [[Common instance].facebook handleOpenURL:url]; 
}

@end
