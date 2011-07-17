//
//  QACell.h
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QACell : UITableViewCell /*<UIWebViewDelegate>*/ {
    
}

@property (nonatomic, retain) IBOutlet UILabel* time;
@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* quest;
//@property (nonatomic, retain) IBOutlet UIWebView* webview;
//@property (nonatomic, retain) NSString* queststring;

//-(void) refresh;
//- (void)webViewDidFinishLoad:(UIWebView *)webView;

@end
