//
//  NewsCell.m
//  iBuh
//
//  Created by вадим on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavrCell.h"


@implementation FavrCell

//@synthesize time = _time;
@synthesize title = _title;
@synthesize rubric = _rubric;
@synthesize arrow = _arrow;

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
    
//    [_time release];
    [_title release];
    [_rubric release];
    [_arrow release];
    
    [super dealloc];
}

@end
