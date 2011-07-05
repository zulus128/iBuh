//
//  iCodeOauthViewController.m
//  iCodeOauth
//
//  Created by Collin Ruffenach on 9/14/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "iCodeOauthViewController.h"
#import "Tweet.h"

@implementation iCodeOauthViewController

@synthesize tableView;
@synthesize textfield;
@synthesize citem = _citem;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {

	if(_engine) return;
	
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"WhoqwNifQnIu64ldldFZMA";
	_engine.consumerSecret = @"vOj9apnlgj1mtTujhHOTglxfNF1M5GstmamV25tI";
	
    
    textfield.text = [NSString stringWithFormat:@"%@ %@ Link: %@", @"From iБухгалтерия: ",self.citem.title,self.citem.link];
    
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		tweets = [[NSMutableArray alloc] init];
		[self updateStream:nil];
	}
}

#pragma mark IBActions

-(IBAction)updateStream:(id)sender {
	
	[_engine getFollowedTimelineSinceID:1 startingAtPage:1 count:100];
}

-(IBAction)tweet:(id)sender {
	
	[textfield resignFirstResponder];
	[_engine sendUpdate:[textfield text]];
	[self updateStream:nil];
}

#pragma mark UITableViewDataSource Methods 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(!cell) {
	
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:identifier];
		//[cell setBackgroundColor:[UIColor clearColor]];
	}
	
	[cell.textLabel setNumberOfLines:7];
	[cell.textLabel setText:[(Tweet*)[tweets objectAtIndex:indexPath.row] tweet]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 150;
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	
	tweets = [[NSMutableArray alloc] init];
	[self updateStream:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
}

#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {

	NSLog(@"Request Suceeded: %@", connectionIdentifier);
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
	
	tweets = [[NSMutableArray alloc] init];
	
	for(NSDictionary *d in statuses) {
		
		NSLog(@"See dictionary: %@", d);
		
		Tweet *tweet = [[Tweet alloc] initWithTweetDictionary:d];
		[tweets addObject:tweet];
		[tweet release];
	}
	
	[self.tableView reloadData];
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {

	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {

	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [_citem release];
    
    [super dealloc];
}

@end
