//
//  NewsController.m
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsController.h"
#import "Common.h"
#import "Reachability.h"
#import "XMLParser.h"
#import "NewsCell.h"
#import "TopNewsCell.h"
//#import "DelimNewsCell.h"
#import "Item.h"
#import "NewsDetailController.h"
//#import "TopNewsDetailController.h"
#import "TopNewsCell.h"
#import <QuartzCore/CALayer.h>

@implementation NewsController

@synthesize samplecell = _samplecell;
@synthesize tableView = _tableView;
@synthesize topcell = _topcell;
@synthesize time = _time;

@synthesize  indi = _indi;
@synthesize lView = _lView;

@synthesize bannerView = _bannerView;

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
    [_topcell release];
    [_time release];
    
    [_indi release];
    [_lView release];
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //-----------
 /*   UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        titleView.textColor = [UIColor blackColor];
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    titleView.text = self.navigationItem.title;
    [titleView sizeToFit];*/
    //-----------
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[NewsCell class]]) {
            
            self.samplecell = (NewsCell*) currentObject;
            break;
        }
    }

/*    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DelimNewsCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[DelimNewsCell class]]) {
            
            self.delimsamplecell = (DelimNewsCell*) currentObject;
            break;
        }
    }
  */  
     topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopNewsCell" owner:nil options:nil];
     for (id currentObject in topLevelObjects) {
    
         if ([currentObject isKindOfClass:[TopNewsCell class]]) {
     
             self.topcell = (TopNewsCell*) currentObject;
             break;
         }
     }

    [self.view addSubview:self.topcell];
    CGRect r = self.topcell.frame;
    r.origin.y = 31;
    self.topcell.frame = r;
    self.topcell.nc = self;
    //self.topcell.selected = YES;
    //self.topcell.multipleTouchEnabled = YES;
    
    
    
//    _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
 //   _hudView.clipsToBounds = YES;
    //_hudView.layer.cornerRadius = 10.0;
//    [self.view addSubview:_hudView];
    
    self.lView.layer.cornerRadius = 10.0f;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"bannerExists"]) {

        self.bannerView.image = [[Common instance] getBanner];
    }

    hand = NO;
    [self refresh1];
    
//    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  
//    NSLog(@"viewWillAppear");
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
    [self.navigationController.navigationBar setBackgroundImage:image];

/*    UIImage *myImage = [UIImage imageNamed:@"02-redo.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(0.0, 0.0, myImage.size.width, myImage.size.height);
    [myButton addTarget:self action:@selector(refr) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem = bi;
    [bi release];
*/
    UIBarButtonItem* bi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refr)] autorelease];
    self.navigationItem.rightBarButtonItem = bi; 
    
  //   [self refresh:NO];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self.navigationController.navigationBar setBackgroundImage:NULL];

    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"count = %d", [[Common instance] getNewsCount] - 1);
    return [[Common instance] getNewsCount] - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"heightForRowAtIndexPath");

   // if ((indexPath.row == 0) || (indexPath.row == 2))
    //    return self.delimsamplecell.frame.size.height;
    return self.samplecell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // static NSString *CellIdentifier2 = @"DelimNewsCell";
   // static NSString *CellIdentifier1 = @"TopNewsCell";
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell* cell;
    
   /* if ((indexPath.row == 0) || (indexPath.row == 2)) {
        
        cell = (DelimNewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DelimNewsCell" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                
                if ([currentObject isKindOfClass:[DelimNewsCell class]]) {
                    
                    cell = (DelimNewsCell*) currentObject;
                    break;
                }
            }
            // Configure the cell...
            if(indexPath.row == 0)
                ((DelimNewsCell*)cell).title.text = @"Тема дня";
            else
                ((DelimNewsCell*)cell).title.text = @"Главное за сегодня";

        }
    }
    else
    if (indexPath.row == 1) {
        
        cell = (TopNewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
           // NSLog(@"TopNewsCell is nil");
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopNewsCell" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                
                if ([currentObject isKindOfClass:[TopNewsCell class]]) {
                    
                    cell = (TopNewsCell*) currentObject;
                    break;
                }
            }
            // Configure the cell...
            Item* item = [[Common instance] getNewsAt:0];
            ((TopNewsCell*)cell).title.text = item.title;
            ((TopNewsCell*)cell).rubric.text = item.rubric;
            ((TopNewsCell*)cell).image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: item.image]]];
        }
    }else */
        {
            cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
               // NSLog(@"NewsCell is nil");
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
                for (id currentObject in topLevelObjects) {
            
                    if ([currentObject isKindOfClass:[NewsCell class]]) {
                
                        cell = (NewsCell*) currentObject;
                        break;
                    }
                }
            }
            // Configure the cell...
//            Item* item = [[Common instance] getNewsAt:(indexPath.row - ROW_CORRECTION)];
            Item* item = [[Common instance] getNewsAt:(indexPath.row + 1)];
            ((NewsCell*)cell).title.text = item.title;
            ((NewsCell*)cell).rubric.text = item.rubric;
            ((NewsCell*)cell).time.text = [item.date substringWithRange:NSMakeRange(17, 5)];
            
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
//            ((NewsCell*)cell).title.numberOfLines = 3;
//            ((NewsCell*)cell).title.frame = CGRectMake(63,0,200,800);
//            [((NewsCell*)cell).title sizeToFit];
        }

    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
//     if ((indexPath.row == 0) || (indexPath.row == 2))
//         return;
    
    NewsDetailController* detailViewController = [[NewsDetailController alloc] initWithNibName:@"NewsDetailController" bundle:nil];
     
//    Item* item = [[Common instance] getNewsAt:/*row*/(indexPath.row + 1)];
    self.hidesBottomBarWhenPushed = YES;
//    detailViewController.citem = item;
    detailViewController.number = indexPath.row + 1;
    [self.navigationController pushViewController:detailViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    detailViewController.image.hidden = YES;
    [detailViewController release];
     
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refr {
    
    [self refresh:YES];
}

- (void)refresh: (BOOL)hnd {

    hand = hnd;
    [self.lView setHidden:NO];
    [self.indi setHidden:NO];
    [self.indi startAnimating];
    [self performSelector:@selector(refresh1) withObject:nil afterDelay:0.0];
  //  [self refresh1:self];
}

- (void)refresh1 {
    
    NSLog(@"refresh hand = %d", hand);
    
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    BOOL b = [[Reachability reachabilityWithHostName:MENU_URL_FOR_REACH] currentReachabilityStatus];    
    if (([[Common instance] isOnlyWiFi] && (b != ReachableViaWiFi))
        || (![[Common instance] isOnlyWiFi] && (b == NotReachable))) {
    
		UIAlertView* dialog = [[UIAlertView alloc] init];
		[dialog setTitle:@"Убедитесь в наличии Интернета!"];
		[dialog setMessage:@"Невозможно загрузить новости."];
		[dialog addButtonWithTitle:@"OK"];
		[dialog show];
		[dialog release];
        
        [self addPreloadedNews];
        
        Item* item = [[Common instance] getNewsAt:0];
        self.topcell.title.text = item.title;
        self.topcell.rubric.text = item.rubric;
        self.topcell.image.image = [Common loadImage];
        [Common instance].img = self.topcell.image.image;
        
        [self.tableView reloadData];
		
	}else {
        
        [[Common instance] clearNews];
        if(![self addNews:TOPMENU_URL]) {
            
            [self addPreloadedNews];
            
            Item* item = [[Common instance] getNewsAt:0];
            self.topcell.title.text = item.title;
            self.topcell.rubric.text = item.rubric;
            self.topcell.image.image = [Common loadImage];
            [Common instance].img = self.topcell.image.image;
            
            [self.tableView reloadData];
            hand = NO;

        }
        else    
            if(![self addNews:MENU_URL]) {
        
                [self addPreloadedNews];
                
                Item* item = [[Common instance] getNewsAt:0];
                self.topcell.title.text = item.title;
                self.topcell.rubric.text = item.rubric;
                self.topcell.image.image = [Common loadImage];
                [Common instance].img = self.topcell.image.image;
                
                [self.tableView reloadData];
                hand = NO;

            }
            else {
        
                [self.tableView reloadData];
                //[sender reloadData];
                //[_tableView reloadData];
                [[Common instance] saveNewsPreload];

                if([[Common instance] getNewsCount]) {
            
                    Item* item = [[Common instance] getNewsAt:0];
                    self.topcell.title.text = item.title;
                    self.topcell.rubric.text = item.rubric;
                    self.topcell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: item.image]]];
                    [Common instance].img = self.topcell.image.image;
            
                    [Common saveImage:self.topcell.image.image];
                }
            }
    
        
        if (hand) {
            
            NSDate *now = [NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd.MM в hh:mm";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            self.time.text = [NSString stringWithFormat:@"Обновлено: %@", [dateFormatter stringFromDate:now]];
            [dateFormatter release];
            
        }
        else
            self.time.text = @"";
    
	}
    
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indi stopAnimating];
    [self.lView setHidden:YES];

    [[Common instance] refreshBanner];
}

- (void)addPreloadedNews {
    
    [[Common instance] clearNews];
    [[Common instance] clearQAs];
    [[Common instance] clearPodcasts];
    
    [[Common instance] loadPreloaded];
}


- (BOOL)addNews: (NSString*) url {
    
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

    BOOL success = YES;
    
    for (int i = 0; i < 5; i++) {
        
    NSString *myStr = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1251\"" withString:@""];
    NSData* aData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:aData];
    XMLParser* parser = [[XMLParser alloc] initXMLParser:TYPE_NEWS];
    [xmlParser setDelegate:parser];    
        
        success = [xmlParser parse];	
        
        if(success) {
            
            NSLog(@"News - No Errors");
//            [self.tableView reloadData];
            break;
        }
        else {
            
            //NSLog(@"Error! Possibly xml version is not new");
            NSLog(@"News - Parser error: %@", [[xmlParser parserError] localizedDescription]);
            success = NO;
            //return NO;
        }
    }

    return success;
}


@end
