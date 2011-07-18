//
//  QADetailController.h
//  iБухгалтерия
//
//  Created by вадим on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Item.h"
#import "FBConnect.h"
#import <MessageUI/MessageUI.h>
#import "MyDetailController.h"

@interface QADetailController : MyDetailController < UIActionSheetDelegate, FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate > {
    
    int fontsize;
    UISegmentedControl *segmentedControl;
}

@property (nonatomic, retain) IBOutlet UILabel* titl;
//@property (nonatomic, retain) IBOutlet UILabel* rubric;
@property (nonatomic, retain) IBOutlet UIWebView* q;
@property (nonatomic, retain) IBOutlet UIWebView* a;
//@property (nonatomic, retain) Item* citem;

- (IBAction)fontplus: (id)sender;
- (IBAction)fontminus: (id)sender;
- (IBAction)share: (id)sender;
- (IBAction)fav: (id)sender;
- (void) refrFont;
- (void) update;
- (void) segmentAction:(id)sender;

@end
