//
//  TopNewsCell.m
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TopNewsCell.h"


@implementation TopNewsCell

@synthesize image = _image;
@synthesize title = _title;
@synthesize rubric = _rubric;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    
    [_image release];
    [_title release];
    [_rubric release];
    
    [super dealloc];
}

@end
