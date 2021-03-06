//
//  NewsDetailController.h
//  iBuh
//
//  Created by naceka on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import <MessageUI/MessageUI.h>
#import "MyDetailController.h"

@interface NewsDetailController : MyDetailController < UIActionSheetDelegate, FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate >{
  
    int fontsize;
    UISegmentedControl *segmentedControl;
    
    BOOL ppp;
}

@property (nonatomic, retain) IBOutlet UILabel* titl;
@property (nonatomic, retain) IBOutlet UILabel* rubric;
@property (nonatomic, retain) IBOutlet UIWebView* fulltext;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* favButton;
@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet UIImageView* arrow;

@property (nonatomic, retain) IBOutlet UIImageView* bannerView;

- (IBAction)fontplus: (id)sender;
- (IBAction)fontminus: (id)sender;
- (IBAction)share: (id)sender;
- (IBAction)fav: (id)sender;
- (void) refrFont;
- (void) segmentAction:(id)sender;
- (void) update;
- (void) validTable;

- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
