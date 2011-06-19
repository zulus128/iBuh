//
//  NewsController.h
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_CORRECTION 2

@interface NewsController : UITableViewController {
    
}

- (void)refresh;
- (void)addNews: (NSString*) url;

@property (nonatomic, retain) UITableViewCell* samplecell;
@property (nonatomic, retain) UITableViewCell* delimsamplecell;

@end
