//
//  QACell.m
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QACell.h"


@implementation QACell

@synthesize time = _time;
@synthesize title = _title;
@synthesize quest = _quest;
@synthesize rubric = _rubric;
//@synthesize webview = _webview;
//@synthesize queststring = _queststring;

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

/*-(void) refresh {
    
//    self.webview.hidden = YES;
//    NSLog(@"refresh QACell");
    [self.webview loadHTMLString:self.queststring baseURL:nil];
//    self.quest.text = [self.webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
//    NSLog(@"text1=%@",self.quest.text);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    self.quest.text = [self.webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
//    NSLog(@"text=%@",self.quest.text);
}*/

- (void)dealloc {
    
    [_time release];
    [_title release];
    [_quest release];
    [_rubric release];
//    [_webview release];
//    [_queststring release];
    
    [super dealloc];
}

@end
