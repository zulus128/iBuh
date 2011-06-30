//
//  NewsDetailController.m
//  iBuh
//
//  Created by naceka on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailController.h"
#import "Common.h"
#import "iCodeOauthViewController.h"

@implementation NewsDetailController

@synthesize titl = _titl;
@synthesize rubric = _rubric;
@synthesize fulltext = _fulltext;
//@synthesize fontplusButton = _fontplusButton;
@synthesize citem = _citem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fontsize = START_FONT;
    }
    return self;
}

- (void)dealloc {

    [_titl release];
    [_rubric release];
    [_fulltext release];
//    [_fontplusButton release];
    [_citem release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = NO;
    self.titl.text = self.citem.title;
    self.rubric.text = self.citem.rubric;
    
    NSString* contentHTML = [NSString stringWithFormat:@"<html> \n"
                        "<head> \n"
                        "<style type=\"text/css\"> \n"
                        "body {font-family: \"%@\"; font-size: %@;}\n"
                        "</style> \n"
                        "</head> \n"
                        "<body align=""justify"">%@</body> \n"
                        "</html>", @"helvetica", [NSNumber numberWithInt:15], self.citem.full_text];
    [self.fulltext loadHTMLString: contentHTML baseURL:nil];
    
//    self.hidesBottomBarWhenPushed = YES;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)fontplus: (id)sender {
    
    NSLog(@"fontplus");
    
    if(fontsize < MAX_FONT) {
        
        fontsize += STEP_FONT;
        [self refrFont];
    }
}

- (IBAction)fontminus: (id)sender {
    
    NSLog(@"fontminus");
    
    if(fontsize > MIN_FONT) {
    
        fontsize -= STEP_FONT;
        [self refrFont];
    }

    
}

- (IBAction)share: (id)sender {
    
   // NSLog(@"share");

    UIActionSheet *asheet = [[UIActionSheet alloc] 
                             initWithTitle:@"Поделиться с друзьями" 
                             delegate:self 
                             cancelButtonTitle:@"Отмена" 
                             destructiveButtonTitle:nil 
                             otherButtonTitles:@"Email", @"Facebook", @"Twitter"
                             , nil];
    
    [asheet showInView:[self.view superview]]; 
  //  [asheet setFrame:CGRectMake(0, 117, 320, 383)];
    [asheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0: {
            NSLog(@"email");
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:self.citem.title];
//            [controller setSubject:@" "];
            [controller setMessageBody:self.citem.full_text isHTML:YES]; 
            [self presentModalViewController:controller animated:YES];
            [controller release];
            
            break;
        }
        case 1: {
            NSLog(@"facebook");
            [Common instance].facebook = [[Facebook alloc] initWithAppId:@"209264682449638"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] 
                && [defaults objectForKey:@"FBExpirationDateKey"]) {
                [Common instance].facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                [Common instance].facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            
            //if (![[Common instance].facebook isSessionValid]) {
            //    [[Common instance].facebook authorize:nil delegate:self];
            //}
            
            
            SBJSON *jsonWriter = [[SBJSON new] autorelease];
            
//            NSString* text = [NSString stringWithFormat:@"%@ Link: %@", self.citem.full_text, self.citem.link];
           // NSLog(@"text = %@", text);
            NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:                
                                        self.citem.title, @"name",
                                        //self.citem.title, @"caption",
                                        self.citem.link, @"href",
                                        self.citem.full_text, @"description",
                                        nil];
            
            NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"165c51ec9fc4c91dbcd4ddba7d4a989b", @"api_key",
                                           @"Что я думаю?", @"user_message_prompt",
                                           attachmentStr, @"attachment",
                                           nil];
            
            
            [[Common instance].facebook dialog:@"stream.publish" andParams:params andDelegate:self];
            
            break;
        }
        case 2: {
            NSLog(@"twitter");
            
            iCodeOauthViewController* twitController = [[iCodeOauthViewController alloc] initWithNibName:@"iCodeOauthViewController" bundle:nil];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:twitController animated:YES];
            //self.hidesBottomBarWhenPushed = NO;
            twitController.citem = self.citem;
            [twitController release];

            break;
        }
            
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)fbDidLogin {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[Common instance].facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[Common instance].facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

- (IBAction)fav: (id)sender {
    
//    NSLog(@"fav");
    
    [[Common instance] saveFav:self.citem];

}

- (void) refrFont {
    
	//[aIndicator startAnimating];
    
	int entireSize = [[self.fulltext stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	int scrollPosition = [[self.fulltext stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
    //	NSLog(@"b4 ent = %d, scrollp = %d", entireSize, scrollPosition);
	
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", 
                          fontsize];
    [self.fulltext stringByEvaluatingJavaScriptFromString:jsString];
    [jsString release];
    
	int entireSize1 = [[self.fulltext stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	int scrollPosition1 = (double) entireSize1 * scrollPosition / entireSize; 
    //	NSLog(@"af ent = %d, scrollp = %d", entireSize1, scrollPosition1);
    
//	[Common instance].maxPos = entireSize1;
	[self.fulltext stringByEvaluatingJavaScriptFromString: [NSString  stringWithFormat:@"window.scrollTo(0,%d);", scrollPosition1]];
//	[Common instance].scrollPos = scrollPosition1;
    
	//[aIndicator stopAnimating];
    
	
}

@end
