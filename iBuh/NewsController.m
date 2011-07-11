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
#import "DelimNewsCell.h"
#import "Item.h"
#import "NewsDetailController.h"
//#import "TopNewsDetailController.h"

@implementation NewsController

@synthesize samplecell = _samplecell;
@synthesize delimsamplecell = _delimsamplecell;
@synthesize tableView = _tableView;

@synthesize image = _image;
@synthesize titl = _titl;
@synthesize rubric = _rubric;

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
    [_delimsamplecell release];
    
    [_tableView release];
    
    [_image release];
    [_titl release];
    [_rubric release];
    
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

    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DelimNewsCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[DelimNewsCell class]]) {
            
            self.delimsamplecell = (DelimNewsCell*) currentObject;
            break;
        }
    }
    
    
    [self refresh];
    
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

    UIImage *myImage = [UIImage imageNamed:@"02-redo.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(0.0, 0.0, myImage.size.width, myImage.size.height);
    [myButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem = bi;
    [bi release];

}

- (void)viewWillDisappear:(BOOL)animated
{

    [self.navigationController.navigationBar setBackgroundImage:NULL];

    [super viewWillDisappear:animated];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    //NSLog(@"check!");
    NewsDetailController* detailViewController = [[NewsDetailController alloc] initWithNibName:@"NewsDetailController" bundle:nil];
    Item* item = [[Common instance] getNewsAt:0];
    
    self.hidesBottomBarWhenPushed = YES;
    
    // Pass the selected object to the new view controller.
    detailViewController.citem = item;
    [self.navigationController pushViewController:detailViewController animated:YES];

    detailViewController.image.hidden = NO;

    self.hidesBottomBarWhenPushed = NO;

    [detailViewController release];

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
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
     
   // int row = (indexPath.row == 1)?0:indexPath.row - ROW_CORRECTION;
    Item* item = [[Common instance] getNewsAt:/*row*/(indexPath.row + 1)];
    
    self.hidesBottomBarWhenPushed = YES;
    
    // Pass the selected object to the new view controller.
    detailViewController.citem = item;
    [self.navigationController pushViewController:detailViewController animated:YES];

    self.hidesBottomBarWhenPushed = NO;

    detailViewController.image.hidden = YES;
    
 //   detailViewController.titl.text = item.title;
 //   detailViewController.rubric.text = item.rubric;
 //   [detailViewController.fulltext loadHTMLString:item.full_text baseURL:nil];
    
    [detailViewController release];
     
}

- (void)refresh {
    
    NSLog(@"refresh");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	if ([[Reachability reachabilityWithHostName:MENU_URL_FOR_REACH] currentReachabilityStatus] == NotReachable) {
		
		UIAlertView* dialog = [[UIAlertView alloc] init];
		[dialog setTitle:@"Убедитесь в наличии Интернета!"];
		[dialog setMessage:@"Невозможно загрузить новости."];
		[dialog addButtonWithTitle:@"OK"];
		[dialog show];
		[dialog release];
        
        [self addPreloadedNews];
        [self.tableView reloadData];
		
	}else {
        
        [[Common instance] clearNews];
        [self addNews:TOPMENU_URL];
        [self addNews:MENU_URL];
        [self.tableView reloadData];

        [[Common instance] saveNewsPreload];
        
        
	}
    
    if([[Common instance] getNewsCount]) {
        
        Item* item = [[Common instance] getNewsAt:0];
        self.titl.text = item.title;
        self.rubric.text = item.rubric;
        self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: item.image]]];
        [Common instance].img = self.image.image;
    }
        
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)addPreloadedNews {
    
    [[Common instance] clearNews];
    [[Common instance] clearQAs];
    [[Common instance] clearPodcasts];
    
    [[Common instance] loadPreloaded];
}


- (void)addNews: (NSString*) url {
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;//[[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //        [error release];
    NSString *myStr = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1251\"" withString:@""];
    NSData* aData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:aData];
    XMLParser* parser = [[XMLParser alloc] initXMLParser:TYPE_NEWS];
    [xmlParser setDelegate:parser];    
    
    for (int i = 0; i < 5; i++) {
        
        BOOL success = [xmlParser parse];	
        
        if(success) {
            
            NSLog(@"No Errors");
//            [self.tableView reloadData];
            break;
        }
        else {
            
            //NSLog(@"Error! Possibly xml version is not new");
            NSLog(@"Parser error: %@", [[xmlParser parserError] localizedDescription]);
        }
    }

}


@end
