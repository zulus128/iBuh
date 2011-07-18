//
//  TopNewsCell.m
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TopNewsCell.h"
#import "NewsDetailController.h"

@implementation TopNewsCell

@synthesize image = _image;
@synthesize title = _title;
@synthesize rubric = _rubric;
@synthesize nc = _nc;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //NSLog(@"check!");

    self.selected = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    NewsDetailController* detailViewController = [[NewsDetailController alloc] initWithNibName:@"NewsDetailController" bundle:nil];
    self.nc.hidesBottomBarWhenPushed = YES;
    detailViewController.number = 0;
    detailViewController.image.hidden = NO;
    [self.nc.navigationController pushViewController:detailViewController animated:YES];
    self.nc.hidesBottomBarWhenPushed = NO;
    [detailViewController release];
    [self setSelected:NO animated:YES];

}

- (void)dealloc {
    
    [_image release];
    [_title release];
    [_rubric release];
    
    [_nc release];
    
    [super dealloc];
}

@end
