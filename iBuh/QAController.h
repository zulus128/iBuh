//
//  QAController.h
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QAController : UITableViewController {
    
}

- (void)addQAs: (NSString*) url;
- (void)refresh;

@property (nonatomic, retain) UITableViewCell* samplecell;

@end
