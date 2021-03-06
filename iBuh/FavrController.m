//
//  FavrController.m
//  iBuh
//
//  Created by вадим on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavrController.h"
#import "FavrCell.h"
#import "Item.h"
#import "Common.h"
#import "NewsDetailController.h"
#import "QADetailController.h"

@implementation FavrController

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

//    UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
//    [self.navigationController.navigationBar setBackgroundImage:image];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FavrCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[FavrCell class]]) {
            
            self.samplecell = (FavrCell*) currentObject;
            break;
        }
    }
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
    //NSLog(@"appear");
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
    //[self.navigationController.navigationBar setBackgroundImage:image];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    UIImage *image = [UIImage imageNamed: @"top-logo-sample.png"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.samplecell.frame.size.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

    return @"Удалить";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[Common instance] getFavNewsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavrCell";
    
    UITableViewCell *cell = (FavrCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FavrCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            
            if ([currentObject isKindOfClass:[FavrCell class]]) {
                
                cell = (FavrCell*) currentObject;
                break;
            }
        }
    }
    // Configure the cell...
    Item* item = [[Common instance] getFavNewsAt:indexPath.row];
    ((FavrCell*)cell).title.text = item.title;
    ((FavrCell*)cell).rubric.text = (item.type == TYPE_NEWS)?item.rubric:@"";
    ((FavrCell*)cell).arrow.hidden = !(item.type == TYPE_NEWS);
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView beginUpdates];
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [[Common instance] delFavNewsAt:indexPath.row];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
    
    [tableView endUpdates];

}


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Item* item = [[Common instance] getFavNewsAt:indexPath.row];

    MyDetailController* detailViewController;
    
    switch (item.type) {
        
        case TYPE_NEWS:
        default:
            detailViewController = [[NewsDetailController alloc] initWithNibName:@"NewsDetailController" bundle:nil];
            break;

        case TYPE_QAS:
            detailViewController = [[QADetailController alloc] initWithNibName:@"QADetailController" bundle:nil];                
            break;
            
    }

    
    self.hidesBottomBarWhenPushed = YES;
    detailViewController.citem = item;
    detailViewController.number = -1;
    [self.navigationController pushViewController:detailViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
