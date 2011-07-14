//
//  Common.m
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@implementation UINavigationBar (UINavigationBarCategory)

-(void)setBackgroundImage:(UIImage*)image{
    if(image == NULL){ //might be called with NULL argument
  //      NSLog(@"%@",[self subviews]);
        [[Common instance].aTabBarBackground removeFromSuperview];
        return;
    }
 //   UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    [Common instance].aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    [self addSubview:[Common instance].aTabBarBackground];
    [self sendSubviewToBack:[Common instance].aTabBarBackground];
//    [aTabBarBackground release];
}

@end

@implementation Common

@synthesize filePath = _filePath;
@synthesize prelfilePath = _prelfilePath;
@synthesize aTabBarBackground = _aTabBarBackground;

@synthesize facebook;
@synthesize img = _img;

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
        
        self.aTabBarBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"top-logo-sample.png"]];
        
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

        self.prelfilePath = [docpath stringByAppendingPathComponent:@"preload.plist"];
		
        fe = [[NSFileManager defaultManager] fileExistsAtPath:self.prelfilePath];
		if(!fe) {
            
            NSLog(@"NO preload.plist FILE !!! Creating...");
            NSString *appFile = [[NSBundle mainBundle] pathForResource:@"preload" ofType:@"plist"];
			NSError *error;
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager copyItemAtPath:appFile toPath:self.prelfilePath error:&error];
			
		}
        
        prels = [[NSMutableDictionary alloc] initWithContentsOfFile:self.prelfilePath];

	}
	return self;	
}

+ (void) saveImage: (UIImage*)img {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/main.png",docpath];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(img)];
    [data1 writeToFile:pngFilePath atomically:YES];

}

+ (UIImage*) loadImage {

    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/main.png",docpath]];
}

- (void) dealloc {
    
	[news release];
    [qas release];
    [pcs release];
    
    [_filePath release];
    [_prelfilePath release];
    [_aTabBarBackground release];
    [_img release];
    
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
                                                            
                                                            [NSNumber numberWithInt:item.type],
                                                            
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
                                                              @"Type",
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
    it.type = [[obj objectForKey:@"Type"] intValue];
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

- (void) sort: (NSMutableArray*) a {

    for (int i = 0; i < (a.count - 1); i++) {
        for (int j = i + 1; j < a.count; j++) {
            NSString* n1 = (NSString*)[a objectAtIndex:i];
            NSString* n2 = (NSString*)[a objectAtIndex:j];
//            NSLog(@"i=%d, j=%d, n1 = %@, n2 = %@", i, j, n1, n2);
            if ([n1 caseInsensitiveCompare:n2] == NSOrderedDescending) {
                [a exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
 //   NSLog(@"a=%@", a);
}

- (void) loadPreloaded {
    
//    NSArray* arr = [prels allValues];
    NSMutableArray* arr1 = [[prels allKeys] mutableCopy];
    [self sort:arr1];
    //NSLog(@"arr=%@", arr);
 //   NSLog(@"arr1=%@", arr1);
    for (int i = 0; i < arr1.count; i++) {

        id obj = [prels objectForKey:[arr1 objectAtIndex:i]];
        Item* it = [[Item alloc] init];
        it.type = [[obj objectForKey:@"Type"] intValue];
        it.title = [obj objectForKey:@"Title"];
        it.link = [obj objectForKey:@"Link"];
        it.ituneslink = [obj objectForKey:@"Ituneslink"];
        it.rubric = [obj objectForKey:@"Rubric"];
        it.full_text = [obj objectForKey:@"Fulltext"];
        it.date = [obj objectForKey:@"Date"];
        it.image = [obj objectForKey:@"Image"];
        it.description = [obj objectForKey:@"Descr"];

        switch (it.type) {
            case TYPE_NEWS:
                [self addNews:it];                
                break;
            case TYPE_QAS:
                [self addQA:it];                
                break;
            case TYPE_PCS:
                [self addPodcast:it]; 
                break;
                
            default:
                break;
        }
        [it release];

    }
    
}

- (void) saveNewsPreload {
    
    NSArray* arr = [prels allKeys];
    NSArray* arr1 = [prels allValues];
    for (int i = 0; i < arr1.count; i++) {
    
        id obj = [arr1 objectAtIndex:i];
        if ([[obj objectForKey:@"Type"] intValue] == TYPE_NEWS) 
            [prels removeObjectForKey:[arr objectAtIndex:i]];
    }
    
    for (int i = 0; i < news.count; i++) {
      
        Item* item = (Item*)[news objectAtIndex:i];
        NSDictionary *f = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                                [NSNumber numberWithInt:item.type],
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
                                                               @"Type",
                                                               @"Title",
                                                               @"Link",
                                                               @"Ituneslink",
                                                               @"Rubric",
                                                               @"Fulltext",
                                                               @"Date",
                                                               @"Image",
                                                               @"Descr",
                                                               nil]];
        [prels setObject:f forKey:[NSString stringWithFormat:@"News%04d", i]]; 
    }

    [prels writeToFile:self.prelfilePath atomically: YES];
}

- (void) saveQAsPreload {
    
    NSArray* arr = [prels allKeys];
    NSArray* arr1 = [prels allValues];
    for (int i = 0; i < arr1.count; i++) {
        
        id obj = [arr1 objectAtIndex:i];
        if ([[obj objectForKey:@"Type"] intValue] == TYPE_QAS) 
            [prels removeObjectForKey:[arr objectAtIndex:i]];
    }
    
    for (int i = 0; i < qas.count; i++) {
        
        Item* item = (Item*)[qas objectAtIndex:i];
        NSDictionary *f = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                                [NSNumber numberWithInt:item.type],
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
                                                               @"Type",
                                                               @"Title",
                                                               @"Link",
                                                               @"Ituneslink",
                                                               @"Rubric",
                                                               @"Fulltext",
                                                               @"Date",
                                                               @"Image",
                                                               @"Descr",
                                                               nil]];
        [prels setObject:f forKey:[NSString stringWithFormat:@"QAs%04d", i]]; 
    }
    
    [prels writeToFile:self.prelfilePath atomically: YES];

}

- (void) savePodcastsPreload {
    
    
    NSArray* arr = [prels allKeys];
    NSArray* arr1 = [prels allValues];
    for (int i = 0; i < arr1.count; i++) {
        
        id obj = [arr1 objectAtIndex:i];
        if ([[obj objectForKey:@"Type"] intValue] == TYPE_PCS) 
            [prels removeObjectForKey:[arr objectAtIndex:i]];
    }
    
    for (int i = 0; i < pcs.count; i++) {
        
        Item* item = (Item*)[pcs objectAtIndex:i];
        NSDictionary *f = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                                [NSNumber numberWithInt:item.type],
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
                                                               @"Type",
                                                               @"Title",
                                                               @"Link",
                                                               @"Ituneslink",
                                                               @"Rubric",
                                                               @"Fulltext",
                                                               @"Date",
                                                               @"Image",
                                                               @"Descr",
                                                               nil]];
        [prels setObject:f forKey:[NSString stringWithFormat:@"PCS%04d", i]]; 
    }
    
    [prels writeToFile:self.prelfilePath atomically: YES];
}

- (BOOL) isOnlyWiFi {
    
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"onlyWiFi"];
}

- (void) setOnlyWiFi: (BOOL)b {
	
	[[NSUserDefaults standardUserDefaults] setBool:b forKey:@"onlyWiFi"];
    
}

@end
