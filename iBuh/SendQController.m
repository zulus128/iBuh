//
//  SendQController.m
//  iBuh
//
//  Created by naceka on 20.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendQController.h"
#import "Common.h"

@implementation SendQController

@synthesize qu = _qu;
@synthesize qu_url = _qu_url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_qu release];
    [_qu_url release];
    
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
    
    NSURL* url = [[NSURL alloc] initWithString:SENDQ_URL];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    [self.qu loadRequest:urlRequest];
    
    [urlRequest release];
    [url release];
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

@end
