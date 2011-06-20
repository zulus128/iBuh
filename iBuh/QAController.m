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

@implementation QAController

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
    
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"QACell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[QACell class]]) {
            
            self.samplecell = (QACell*) currentObject;
            break;
        }
    }
    
    [self refresh];
    
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(addQuestion:)] autorelease];
    
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
        ((QACell*)cell).quest.text = item.description;
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
        
        [[Common instance] clearQAs];
        [self addQAs:QAMENU_URL];
		
	}
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)addQAs: (NSString*) url {
    
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
        }
    }
    
}

@end
