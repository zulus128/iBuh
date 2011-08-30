//
//  QAController.h
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MREntitiesConverter.h"

@interface QAController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    MREntitiesConverter* converter;
    BOOL ppp;
}

- (BOOL)addQAs: (NSString*) url;
- (void)refresh;
- (void)addQuestion:(NSObject*)sender;

@property (nonatomic, retain) UITableViewCell* samplecell;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIImageView* bannerView;

@end
