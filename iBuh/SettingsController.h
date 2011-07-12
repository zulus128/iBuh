//
//  SettingsController.h
//  iБухгалтерия
//
//  Created by naceka on 12.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UISwitch* wifii;

- (IBAction) switchChanged:(id)sender;

@end
