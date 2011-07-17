//
//  WiFiCell.m
//  iБухгалтерия
//
//  Created by вадим on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiFiCell.h"
#import "Common.h"

@implementation WiFiCell

@synthesize sw;

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

- (IBAction) switchChanged:(id)sender {
    
    UISwitch* switchControl = (UISwitch*)sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    [[Common instance] setOnlyWiFi:switchControl.on];
}

- (void)dealloc
{
    [super dealloc];
}

@end
