//
//  QAController.m
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QAController.h"
#import "QACell.h"
#import "XMLParser.h"
#import "Common.h"
#import "Reachability.h"
#import "SendQController.h"
//#import "NewsDetailController.h"
#import "QADetailController.h"

@implementation QAController

@synthesize samplecell = _samplecell;
@synthesize bannerView = _bannerView;
@synthesize tableView = _tableView;

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_samplecell release];
    [_tableView release];
    [_bannerView release];
    
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

    converter = [[MREntitiesConverter alloc] init];
    
 //   UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
 //   [self.navigationController.navigationBar setBackgroundImage:image];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"QACell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[QACell class]]) {
            
            self.samplecell = (QACell*) currentObject;
            break;
        }
    }
    
    //[self refresh];
    
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addQuestion:)] autorelease];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"bannerExists"])
        return;
    
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint location=[touch locationInView:touch.view];
    
    //NSLog(@"loc y = %f", location.y);
    if(location.y < 320)
        return;
    
    NSLog(@"go banner!");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[Common instance].bannerLink]];
    
}

- (void)addQuestion:(NSObject*)sender {

    NSLog(@"addQuestion");
    SendQController *detailViewController = [[SendQController alloc] initWithNibName:@"SendQController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [converter release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
    //[self.navigationController.navigationBar setBackgroundImage:image];

//    UIButton *btnAdd = [UIButton buttonWithType:/*UIBarButtonSystemItemCompose*/UIButtonTypeContactAdd];  
//    [btnAdd addTarget:self action:@selector(addQuestion:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnItemAdd = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addQuestion:)]autorelease];
//    UIBarButtonItem* btnItemAdd = [[[UIBarButtonItem alloc] initWithCustomView:btnAdd] autorelease];  
    self.navigationItem.rightBarButtonItem = btnItemAdd; 

        [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:NULL];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Common instance] getQAsCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.samplecell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QACell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        // NSLog(@"TopNewsCell is nil");
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"QACell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            
            if ([currentObject isKindOfClass:[QACell class]]) {
                
                cell = (QACell*) currentObject;
                break;
            }
        }
        // Configure the cell...

        Item* item = [[Common instance] getQAAt:indexPath.row];
        ((QACell*)cell).title.text = item.title;
        ((QACell*)cell).quest.text = [converter convertEntiesInString: item.description];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:usLocale];
        [usLocale release];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *gmtDate = [formatter dateFromString:item.date];
        formatter.dateFormat = @"dd.MM";
        NSString* s = [formatter stringFromDate:gmtDate];
        [formatter release];
        
        //[dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"]; 

        NSLog(@"1 - %@", item.date);
        NSLog(@"2 - %@", [gmtDate description]);
        
        ((QACell*)cell).time.text = s;//[item.date substringWithRange:NSMakeRange(17, 5)];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QADetailController* detailViewController = [[QADetailController alloc] initWithNibName:@"QADetailController" bundle:nil];
    
   // Item* item = [[Common instance] getQAAt:indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
  //  detailViewController.citem = item;
    detailViewController.number = indexPath.row;
    [self.navigationController pushViewController:detailViewController animated:YES];    
    self.hidesBottomBarWhenPushed = NO;
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refresh {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    BOOL b = [[Reachability reachabilityWithHostName:MENU_URL_FOR_REACH] currentReachabilityStatus];    
    if (([[Common instance] isOnlyWiFi] && (b != ReachableViaWiFi))
        || (![[Common instance] isOnlyWiFi] && (b == NotReachable))) {

		
		UIAlertView* dialog = [[UIAlertView alloc] init];
		[dialog setTitle:@"Убедитесь в наличии Интернета!"];
		[dialog setMessage:@"Невозможно загрузить данные."];
		[dialog addButtonWithTitle:@"OK"];
		[dialog show];
		[dialog release];
		
	}else {
        
        [[Common instance] clearQAs];
        
        if([self addQAs:QAMENU_URL])
            [[Common instance] saveQAsPreload];
		
	}
    
    [[Common instance] refreshBanner];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"bannerExists"]) {
  //      if (!ppp) {

        self.bannerView.hidden = NO;
        self.bannerView.image = [[Common instance] getBanner];
        CGRect f = self.bannerView.frame;
        f.origin.y = 323;
        self.bannerView.frame = f;
        f = CGRectMake(0, 0, 320, 323);
        self.tableView.frame = f;
    }
    else {
        
        self.bannerView.hidden = YES;
        CGRect f = CGRectMake(0, 0, 320, 367);
        self.tableView.frame = f;
        
    }
    ppp = !ppp;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)addQAs: (NSString*) url {
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;//[[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //        [error release];
    if (responseData == nil) {
        // Check for problems
        if (error != nil) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:@"Ошибка Интернет-подключения"];
            [dialog setMessage:[error localizedDescription]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
            [dialog release];
            return NO;
        }
    }

    NSString *myStr = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1251\"" withString:@""];
    NSData* aData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:aData];
    XMLParser* parser = [[XMLParser alloc] initXMLParser:TYPE_QAS];
    [xmlParser setDelegate:parser];    
    
    for (int i = 0; i < 5; i++) {
        
        BOOL success = [xmlParser parse];	
        
        if(success) {
            
            NSLog(@"QA No Errors");
            [self.tableView reloadData];
            break;
        }
        else {
            
            //NSLog(@"Error! Possibly xml version is not new");
            NSLog(@"Parser error: %@", [[xmlParser parserError] localizedDescription]);
            return NO;
            
        }
    }
    return YES;   
}

@end
