//
//  WiFiCell.h
//  iБухгалтерия
//
//  Created by вадим on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WiFiCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UISwitch* sw;

- (IBAction) switchChanged:(id)sender;

@end
