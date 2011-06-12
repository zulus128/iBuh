//
//  Item.m
//  iMenu
//
//  Created by вадим on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@implementation Item

@synthesize title, link, rubric, full_text, date;

- (void) dealloc {
	
    //	NSLog(@"Item dealloc");
 	self.title = nil;
	self.link = nil;
	self.rubric = nil;
	self.full_text = nil;
	self.date = nil;
	
	[super dealloc];
}

@end
