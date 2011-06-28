//
//  TwitterController.h
//  iBuh
//
//  Created by naceka on 28.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface TwitterController : UIViewController {
    
	SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textfield;

-(IBAction)updateStream:(id)sender;
-(IBAction)tweet:(id)sender;

@end
