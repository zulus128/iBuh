//
//  QADetailController.m
//  iБухгалтерия
//
//  Created by вадим on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QADetailController.h"
#import "iCodeOauthViewController.h"
#import "Common.h"

@implementation QADetailController

@synthesize titl = _titl;
@synthesize q = _q;
@synthesize a = _a;
//@synthesize citem = _citem;

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
    [_q release];
    [_a release];
//    [_citem release];
    
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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = NO;
    self.titl.text = self.citem.title;
//    self.rubric.text = self.citem.rubric;
    
    NSString* contentHTML = [NSString stringWithFormat:@"<html> \n"
                             "<head> \n"
                             "<style type=\"text/css\"> \n"
                             "body {font-family: \"%@\"; font-size: %@;}\n"
                             "</style> \n"
                             "</head> \n"
                             "<body align=""justify"">%@</body> \n"
                             "</html>", @"helvetica", [NSNumber numberWithInt:12], self.citem.description];
    [self.q loadHTMLString: contentHTML baseURL:nil];
    
    contentHTML = [NSString stringWithFormat:@"<html> \n"
                             "<head> \n"
                             "<style type=\"text/css\"> \n"
                             "body {font-family: \"%@\"; font-size: %@;}\n"
                             "</style> \n"
                             "</head> \n"
                             "<body align=""justify"">%@</body> \n"
                             "</html>", @"helvetica", [NSNumber numberWithInt:15], self.citem.full_text];
    [self.a loadHTMLString: contentHTML baseURL:nil];
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
            
            NSString* str = [NSString stringWithFormat:@"From iБухгалтерия:<br />Вопрос:<br /> %@<br />Ответ:<br /> %@<br /> Link: %@", self.citem.description, self.citem.full_text, self.citem.link];
            
            [controller setMessageBody:str isHTML:YES]; 
            [self presentModalViewController:controller animated:YES];
            [controller release];
            
            break;
        }
        case 1: {
            NSLog(@"facebook");
            //            [Common instance].facebook = [[Facebook alloc] initWithAppId:@"209264682449638"];
            [Common instance].facebook = [[Facebook alloc] initWithAppId:@"236302699730602"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] 
                && [defaults objectForKey:@"FBExpirationDateKey"]) {
                [Common instance].facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                [Common instance].facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            
            // if (![[Common instance].facebook isSessionValid]) {
            //     [[Common instance].facebook authorize:nil delegate:self];
            // }
            
            
            SBJSON *jsonWriter = [[SBJSON new] autorelease];
            
            NSString* str = [NSString stringWithFormat:@"From iБухгалтерия:<br />Вопрос:<br /> %@<br />Ответ:<br />%@", self.citem.description, self.citem.full_text];
            NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:                
                                        self.citem.title, @"name",
                                        //self.citem.title, @"caption",
                                        self.citem.link, @"href",
                                        str, @"description",
                                        nil];
            
            NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           //                                           @"165c51ec9fc4c91dbcd4ddba7d4a989b", @"api_key",
                                           @"9c70a4861ca225eb7558a03bd762d6ac", @"api_key",
                                           @"Что я думаю?", @"user_message_prompt",
                                           attachmentStr, @"attachment",
                                           nil];
            
            [[Common instance].facebook dialog:@"stream.publish" andParams:params andDelegate:self];
            //[[Common instance].facebook dialog:@"feed" andParams:params andDelegate:self];
            
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

- (IBAction)fav: (id)sender {
    
    //    NSLog(@"fav");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Внимание" 
                                                    message:@"Добавить в избранное?"
                                                   delegate:self 
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Добавить",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        
        NSLog(@"Ok");
        [[Common instance] saveFav:self.citem];
    }
}

- (void) refrFont {
    
	//[aIndicator startAnimating];
    
	int entireSize = [[self.a stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	int scrollPosition = [[self.a stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
    //	NSLog(@"b4 ent = %d, scrollp = %d", entireSize, scrollPosition);
	
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", 
                          fontsize];
    [self.a stringByEvaluatingJavaScriptFromString:jsString];
    [jsString release];
    
	int entireSize1 = [[self.a stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	int scrollPosition1 = (double) entireSize1 * scrollPosition / entireSize; 
    //	NSLog(@"af ent = %d, scrollp = %d", entireSize1, scrollPosition1);
    
    //	[Common instance].maxPos = entireSize1;
	[self.a stringByEvaluatingJavaScriptFromString: [NSString  stringWithFormat:@"window.scrollTo(0,%d);", scrollPosition1]];
    //	[Common instance].scrollPos = scrollPosition1;
    
	//[aIndicator stopAnimating];
    
	
}

@end
