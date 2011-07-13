//
//  NewsController.h
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_CORRECTION 2

@interface NewsController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

- (void)refresh: (BOOL)hand;
- (void)refr;
- (void)addNews: (NSString*) url;
- (void)addPreloadedNews;

@property (nonatomic, retain) UITableViewCell* samplecell;
@property (nonatomic, retain) UITableViewCell* delimsamplecell;
@property (nonatomic, retain) UITableView* tableView;

@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet UILabel* titl;
@property (nonatomic, retain) IBOutlet UILabel* rubric;
@property (nonatomic, retain) IBOutlet UILabel* time;

@end
