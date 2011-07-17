//
//  QAController.h
//  iBuh
//
//  Created by вадим on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MREntitiesConverter.h"

@interface QAController : UITableViewController {
    
    MREntitiesConverter* converter;
}

- (void)addQAs: (NSString*) url;
- (void)refresh;
- (void)addQuestion:(NSObject*)sender;

@property (nonatomic, retain) UITableViewCell* samplecell;

@end
