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
#import "Item.h"

@implementation NewsController

@synthesize samplecell = _samplecell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_samplecell release];
    
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
        
        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
            
            self.samplecell = (NewsCell*) currentObject;
            break;
        }
    }
    
    [self refresh];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    return [[Common instance] getNewsCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"heightForRowAtIndexPath");

    return self.samplecell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";

    //NSLog(@"cellForRowAtIndexPath");
    
    NewsCell* cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
  //      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                
                cell = (NewsCell*) currentObject;
                break;
            }
        }
    }
    
    // Configure the cell...
    Item* item = [[Common instance] getNewsAt:indexPath.row];
    cell.title.text = item.title;
    cell.rubric.text = item.rubric;
    
    NSLog(@"item.date = %@", item.date);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"EEE, dd MMM yyyy, hh:mm:ss"];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSDate *date = [dateFormat dateFromString:item.date];
    [dateFormat release];
    NSLog(@"date = %@", [date description]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    //Optionally for time zone converstions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    cell.time.text = [formatter stringFromDate:date];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)refresh {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	if ([[Reachability reachabilityWithHostName:MENU_URL_FOR_REACH] currentReachabilityStatus] == NotReachable) {
		
		UIAlertView* dialog = [[UIAlertView alloc] init];
		[dialog setTitle:@"Убедитесь в наличии Интернета!"];
		[dialog setMessage:@"Невозможно загрузить новости."];
		[dialog addButtonWithTitle:@"OK"];
		[dialog show];
		[dialog release];
		
	}else {
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:MENU_URL]];
        
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        [error release];
 /*       NSString *result = [[[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding] autorelease];
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[result dataUsingEncoding:NSWindowsCP1251StringEncoding]]; 
   */  
        NSString *myStr = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
        myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1251\"" withString:@""];
        NSData* aData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:aData];
        
    //    NSURL *url = [[[NSURL alloc] initWithString:MENU_URL]autorelease];
    //    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];	
        XMLParser* parser = [[XMLParser alloc] initXMLParser];
        [xmlParser setDelegate:parser];
        
        [[Common instance] clearNews];
        
		for (int i = 0; i < 5; i++) {
			
			BOOL success = [xmlParser parse];	
            
            if(success) {
                
                NSLog(@"No Errors");
                [self.tableView reloadData];
                break;
            }
            else {
            
                //NSLog(@"Error! Possibly xml version is not new");
                NSLog(@"Parser error: %@", [[xmlParser parserError] localizedDescription]);
            }
		}
		
	}
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

@end
