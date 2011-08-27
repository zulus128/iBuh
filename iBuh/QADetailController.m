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
@synthesize favButton = _favButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
        fontsize = [userDefaults integerForKey:@"qafont"];
        if(!fontsize)
            fontsize = START_FONT;
        [userDefaults setInteger:fontsize forKey:@"qafont"];

    }
    return self;
}

- (void)dealloc {
    
    [_titl release];
    [_q release];
    [_a release];
    [_favButton release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    segmentedControl.hidden = (self.number < 0);
    self.favButton.enabled = (self.number >= 0);

    
}

#pragma mark - View lifecycle
- (void) update {

    Item* citem = (self.number < 0)?self.citem:[[Common instance] getQAAt:self.number];
    self.navigationItem.hidesBackButton = NO;
    self.titl.text = citem.title;
    //    self.rubric.text = self.citem.rubric;
    
    self.a.hidden = YES;
    self.q.hidden = YES;

    NSString* contentHTML = [NSString stringWithFormat:@"<html> \n"
                             "<head> \n"
                             "<style type=\"text/css\"> \n"
                             "body {font-family: \"%@\"; font-size: %@; font-style:oblique;}\n"
                             "</style> \n"
                             "</head> \n"
                             "<body align=""left"">%@</body> \n"
                             "</html>", @"helvetica", [NSNumber numberWithInt:12], citem.description];
    [self.q loadHTMLString: contentHTML baseURL:nil];
    
    contentHTML = [NSString stringWithFormat:@"<html> \n"
                   "<head> \n"
                   "<style type=\"text/css\"> \n"
                   "body {font-family: \"%@\"; font-size: %@;}\n"
                   "</style> \n"
                   "</head> \n"
                   "<body align=""left"">%@</body> \n"
                   "</html>", @"helvetica", [NSNumber numberWithInt:15], citem.full_text];
    [self.a loadHTMLString: contentHTML baseURL:nil];
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSLog(@"finishLoad");
    [self refrFont];
    webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
    //NSLog(@"loadError");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"arr-left.png"],
                                             [UIImage imageNamed:@"arr-right.png"],
                                             nil]];
    
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 80, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
    
    // defaultTintColor = [segmentedControl.tintColor retain];    // keep track of this for later
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
    
    [self update];
    
    self.navigationItem.title = @"Вопрос-ответ";

    
}

-(void)segmentAction:(id)sender {
    
    if([sender selectedSegmentIndex] == 0) {
        
        if(self.number > 0) {
            
            self.number--;
            [self update];
        }
    }
    else {
        
        if(self.number < ([[Common instance] getQAsCount] - 1)) {
            
            self.number++;
            [self update];
        }
        
    }
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
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];  
        [userDefaults setInteger:fontsize forKey:@"qafont"];

        [self refrFont];
    }
}

- (IBAction)fontminus: (id)sender {
    
    NSLog(@"fontminus");
    
    if(fontsize > MIN_FONT) {
        
        fontsize -= STEP_FONT;
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];  
        [userDefaults setInteger:fontsize forKey:@"qafont"];

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
  
    Item* citem = (self.number < 0)?self.citem:[[Common instance] getQAAt:self.number];
    
    switch (buttonIndex) {
        case 0: {
            NSLog(@"email");
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:citem.title];
            //            [controller setSubject:@" "];
            
            NSString* str = [NSString stringWithFormat:@"Мобильное приложение Бухгалтерия:<br />Вопрос:<br /> %@<br />Ответ:<br /> %@<br /> Ссылка на источник: %@", citem.description, citem.full_text, citem.link];
            
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
            
            NSString* str = [NSString stringWithFormat:@"Мобильное приложение Бухгалтерия:<br />Вопрос:<br /> %@<br />Ответ:<br />%@", citem.description, citem.full_text];
            NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:                
                                        citem.title, @"name",
                                        //self.citem.title, @"caption",
                                        citem.link, @"href",
                                        str, @"description",
                                        nil];
            
            NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           //                                           @"165c51ec9fc4c91dbcd4ddba7d4a989b", @"api_key",
//                                           @"9c70a4861ca225eb7558a03bd762d6ac", @"api_key",
                                           @"d599b3ff0852226f1792b946ea7198a3", @"api_key",
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
            twitController.citem = citem;
            [twitController release];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error
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
    Item* citem = (self.number < 0)?self.citem:[[Common instance] getQAAt:self.number];
    if (buttonIndex == 1){
        
        NSLog(@"Ok");
        [[Common instance] saveFav:citem];
    }
}

- (void) refrFont {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	fontsize = [userDefaults integerForKey:@"qafont"];
    
    int entireSize = [[self.q stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	int scrollPosition = [[self.q stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", 
                fontsize - 10];
    [self.q stringByEvaluatingJavaScriptFromString:jsString];
    [jsString release];
	int entireSize1 = [[self.q stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	int scrollPosition1 = (double) entireSize1 * scrollPosition / entireSize; 
	[self.q stringByEvaluatingJavaScriptFromString: [NSString  stringWithFormat:@"window.scrollTo(0,%d);", scrollPosition1]];
    
	entireSize = [[self.a stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	scrollPosition = [[self.a stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
	jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontsize];
    [self.a stringByEvaluatingJavaScriptFromString:jsString];
    [jsString release];
	entireSize1 = [[self.a stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] intValue];
	scrollPosition1 = (double) entireSize1 * scrollPosition / entireSize; 
	[self.a stringByEvaluatingJavaScriptFromString: [NSString  stringWithFormat:@"window.scrollTo(0,%d);", scrollPosition1]];


}

@end
