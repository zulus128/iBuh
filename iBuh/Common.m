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

@synthesize facebook;

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
        pcs = [[NSMutableArray alloc] init];
        
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
    
        favs = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];

	}
	return self;	
}

- (void) dealloc {
    
	[news release];
    [qas release];
    [pcs release];
    
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

- (void)clearPodcasts {
    
    [pcs removeAllObjects];
}

- (void)addPodcast: (Item*)item {
    
    [pcs addObject:item];
    NSLog(@"Podcast Item added, title: %@", item.title);
}

- (int) getPodcastsCount {
    
    return [pcs count];
}

- (Item*) getPodcastAt: (int)num {
    
    return [pcs objectAtIndex:num];
}

- (void) saveFav: (Item*) item {
	
	int cnt = [[favs objectForKey:@"count"] intValue];
    NSLog(@"count = %i", cnt);
    cnt++;
    [favs setValue:[NSNumber numberWithInt:cnt] forKey:@"count"];
    NSDictionary *f = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                            item.title == nil?@"":item.title,
                                                            item.link == nil?@"":item.link,    
                                                            item.ituneslink == nil?@"":item.ituneslink,    
                                                            item.rubric == nil?@"":item.rubric,
                                                            item.full_text == nil?@"":item.full_text,
                                                            item.date == nil?@"":item.date,
                                                            item.image == nil?@"":item.image,
                                                            item.description == nil?@"":item.description,
                                                            nil]
                                                     forKeys:[NSArray arrayWithObjects:
                                                              @"Title",
                                                              @"Link",
                                                              @"Ituneslink",
                                                              @"Rubric",
                                                              @"Fulltext",
                                                              @"Date",
                                                              @"Image",
                                                              @"Descr",
                                                              nil]];
	[favs setObject:f forKey:[NSString stringWithFormat:@"Favourite%d", cnt]]; 
	[favs writeToFile:self.filePath atomically: YES];
}

- (int) getFavNewsCount {

    correction = [favs count];
    //NSLog(@"count = %i", [favs count] - 1);
    return correction - 1;
}

- (Item*) getFavNewsAt: (int)num {
    
    //NSLog(@"num = %i", num);
//    NSLog(@"%@",[favs allValues]);
    NSArray* arr = [favs allValues];
    id obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    if([obj isKindOfClass:[NSNumber class]]) {
        
        correction = num;
      //  NSLog(@"correction = %i", correction);
        obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    }
    
    Item* it = [[Item alloc] init];
    it.title = [obj objectForKey:@"Title"];
    it.link = [obj objectForKey:@"Link"];
    it.ituneslink = [obj objectForKey:@"Ituneslink"];
    it.rubric = [obj objectForKey:@"Rubric"];
    it.full_text = [obj objectForKey:@"Fulltext"];
    it.date = [obj objectForKey:@"Date"];
    it.image = [obj objectForKey:@"Image"];
    it.description = [obj objectForKey:@"Descr"];

    return [it autorelease];
}

- (void) delFavNewsAt: (int)num {
    
    [self getFavNewsAt:num];
    
    //NSLog(@"delete num = %i", num);
    //NSLog(@"correction1 = %i", correction);
    //NSLog(@"%@",[favs allKeys]);
    NSArray* arr = [favs allKeys];
    id obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    [favs removeObjectForKey:obj];
    int cnt = [[favs objectForKey:@"count"] intValue];
    cnt--;
    [favs setValue:[NSNumber numberWithInt:cnt] forKey:@"count"];

    [favs writeToFile:self.filePath atomically: YES];
}


@end
