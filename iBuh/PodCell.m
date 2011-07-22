//
//  QACell.m
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PodCell.h"


@implementation PodCell

@synthesize title = _title;
@synthesize descr = _descr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc {
    
    [_title release];
    [_descr release];
    
    [super dealloc];
}

@end
