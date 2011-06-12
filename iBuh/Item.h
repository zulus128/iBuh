//
//  Item.h
//  iMenu
//
//  Created by вадим on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject {

}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* rubric;
@property (nonatomic, retain) NSString* full_text;
@property (nonatomic, retain) NSString* date;

@end
