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
	}
	return self;	
}

- (void) dealloc {
    
	[news release];
    
	[super dealloc];
}

- (void)clearNews {
    
    [news removeAllObjects];
}

- (void)addNews: (Item*)item {
   
    [news addObject:item];
    NSLog(@"Item added, title: %@", item.title);
}

@end
