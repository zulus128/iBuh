//
//  PodController.h
//  iBuh
//
//  Created by naceka on 24.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PodController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    BOOL ppp;
}

@property (nonatomic, retain) UITableViewCell* samplecell;

- (void)refresh;
- (BOOL)addPodcasts: (NSString*) url;

@property (nonatomic, retain) IBOutlet UIImageView* bannerView;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
