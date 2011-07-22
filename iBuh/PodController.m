//
//  PodController.m
//  iBuh
//
//  Created by naceka on 24.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PodController.h"
#import "Reachability.h"
#import "Common.h"
#import "XMLParser.h"
#import "PodCell.h"

@implementation PodController

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

 //   UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
 //   [self.navigationController.navigationBar setBackgroundImage:image];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PodCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[PodCell class]]) {
            
            self.samplecell = (PodCell*) currentObject;
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
    
    //UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
    //[self.navigationController.navigationBar setBackgroundImage:image];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[Common instance] getPodcastsCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.samplecell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"PodCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // NSLog(@"TopNewsCell is nil");
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PodCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            
            if ([currentObject isKindOfClass:[PodCell class]]) {
                
                cell = (PodCell*) currentObject;
                break;
            }
        }
        // Configure the cell...
        Item* item = [[Common instance] getPodcastAt:indexPath.row];
        //NSLog(@"descr = %@",item.description);
        //NSLog(@"title = %@",item.title);
        ((PodCell*)cell).title.text = item.description;
        ((PodCell*)cell).descr.text = item.title;

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
    Item* item = [[Common instance] getPodcastAt:indexPath.row];
    NSLog(@"item.ituneslink = %@", item.ituneslink);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.ituneslink]];
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
        
        [[Common instance] clearPodcasts];
        
        if([self addPodcasts:PODCAST_URL])
            [[Common instance] savePodcastsPreload];
	}
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)addPodcasts: (NSString*) url {
    
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
    XMLParser* parser = [[XMLParser alloc] initXMLParser:TYPE_PCS];
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
