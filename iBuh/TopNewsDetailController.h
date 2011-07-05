//
//  TopNewsDetailController.h
//  iБухгалтерия
//
//  Created by вадим on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "FBConnect.h"
#import <MessageUI/MessageUI.h>

@interface TopNewsDetailController : UIViewController < UIActionSheetDelegate, FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate >{
    
    int fontsize;
}

@property (nonatomic, retain) IBOutlet UILabel* titl;
@property (nonatomic, retain) IBOutlet UILabel* rubric;
@property (nonatomic, retain) IBOutlet UIWebView* fulltext;

@property (nonatomic, retain) Item* citem;

- (IBAction)fontplus: (id)sender;
- (IBAction)fontminus: (id)sender;
- (IBAction)share: (id)sender;
- (IBAction)fav: (id)sender;

- (void) refrFont;

@end
