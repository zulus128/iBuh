//
//  Common.m
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@implementation Common

@synthesize filePath = _filePath;

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
        
 		NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* docpath = [sp objectAtIndex: 0];
        self.filePath = [docpath stringByAppendingPathComponent:@"favourites.plist"];
		BOOL fe = [[NSFileManager defaultManager] fileExistsAtPath:self.filePath];
		if(!fe) {
            
            NSLog(@"NO favourites.plist FILE !!! Creating...");
            NSString *appFile = [[NSBundle mainBundle] pathForResource:@"favourites" ofType:@"plist"];
			NSError *error;
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager copyItemAtPath:appFile toPath:self.filePath error:&error];
			
		}
            else
            favs = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];

	}
	return self;	
}

- (void) dealloc {
    
	[news release];
    [qas release];
    
    [_filePath release];
    
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

- (void) saveFav: (Item*) item {
	
	int cnt = [[favs objectForKey:@"count"] intValue];
    NSLog(@"count = %i", cnt);
//    [params setObject:val forKey:name];
//	NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString* docpath = [sp objectAtIndex: 0];
//	NSString* filePath = [docpath stringByAppendingPathComponent:@"params.plist"];
	[favs writeToFile:self.filePath atomically: YES];
}

//- (NSString*) getParam: (NSString*) name {
    
//    return [params objectForKey:name];
	
//}

@end
