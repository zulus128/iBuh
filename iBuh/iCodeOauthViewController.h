//
//  iCodeOauthViewController.h
//  iCodeOauth
//
//  Created by Collin Ruffenach on 9/14/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface iCodeOauthViewController : UIViewController <SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *tableView;
	IBOutlet UITextField *textfield;

	SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textfield;

-(IBAction)updateStream:(id)sender;
-(IBAction)tweet:(id)sender;

@end

