//
//  Common.m
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
		}
	}
	return instance;
}

- (id) init{	
	
	self = [super init];
	if(self !=nil) {

        news = [[NSMutableArray alloc] init];
        qas = [[NSMutableArray alloc] init];
	}
	return self;	
}

- (void) dealloc {
    
	[news release];
    [qas release];
    
	[super dealloc];
}

- (void)clearNews {
    
    [news removeAllObjects];
}

- (void)addNews: (Item*)item {
   
    [news addObject:item];
    NSLog(@"Item added, title: %@", item.title);
}

- (int) getNewsCount {

    return [news count];
}

- (Item*) getNewsAt: (int)num {
    
    return [news objectAtIndex:num];
}

- (void)clearQAs {
    
    [qas removeAllObjects];
}

- (void)addQA: (Item*)item {
    
    [qas addObject:item];
    NSLog(@"QA Item added, title: %@", item.title);
}

- (int) getQAsCount {
    
    return [qas count];
}

- (Item*) getQAAt: (int)num {
    
    return [qas objectAtIndex:num];
}

@end
