//
//  NewsDetailController.h
//  iBuh
//
//  Created by naceka on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "FBConnect.h"
#import <MessageUI/MessageUI.h>

@interface NewsDetailController : UIViewController < UIActionSheetDelegate, FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate >{
  
    int fontsize;
}

@property (nonatomic, retain) IBOutlet UILabel* titl;
@property (nonatomic, retain) IBOutlet UILabel* rubric;
//@property (nonatomic, retain) IBOutlet UITextView* fulltext;
@property (nonatomic, retain) IBOutlet UIWebView* fulltext;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem* fontplusButton;

@property (nonatomic, retain) Item* citem;

@property (nonatomic, retain) IBOutlet UIImageView* image;

- (IBAction)fontplus: (id)sender;
- (IBAction)fontminus: (id)sender;
- (IBAction)share: (id)sender;
- (IBAction)fav: (id)sender;

- (void) refrFont;

@end
