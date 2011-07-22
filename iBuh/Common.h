//
//  Common.h_
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//[dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"]; 


#import <Foundation/Foundation.h>
#import "Item.h"

#import "FBConnect.h"

#define MENU_URL_FOR_REACH @"www.buhgalteria.ru"
#define MENU_URL @"http://www.buhgalteria.ru/rss/iphoneapp/iphonenews.php"
#define TOPMENU_URL @"http://www.buhgalteria.ru/rss/iphoneapp/iphoneday.php"
#define QAMENU_URL @"http://www.buhgalteria.ru/rss/iphoneapp/iphonefaq.php"
#define SENDQ_URL @"http://www.buhgalteria.ru/addq/iphone.php"
#define PODCAST_URL @"http://www.buhgalteria.ru/rss/iphoneapp/iphonepodcast.php"

#define EMAIL_URL @"http://www.buhgalteria.ru/iphoneapp/mailget.php?email=%@"

#define ITEM_TAG @"item"
#define TITLE_TAG @"title"
#define LINK_TAG @"link"
#define ITUNESLINK_TAG @"ituneslink"
#define RUBRIC_TAG @"rubric"
#define FULLTEXT_TAG @"full-text"
#define DATE_TAG @"pubDate"
#define IMAGE_TAG @"enclosure"
#define DESCRIPTION_TAG @"description"

#define START_FONT 100
#define STEP_FONT 10
#define MIN_FONT 30
#define MAX_FONT 250

enum item_types {
    
    TYPE_NEWS,
    TYPE_QAS,
    TYPE_PCS
};

@interface UINavigationBar (UINavigationBarCategory)
-(void) setBackgroundImage:(UIImage*)image;
@end

@interface Common : NSObject {
 
    NSMutableArray* news;
    NSMutableArray* qas;
    NSMutableArray* pcs;
    NSMutableDictionary* favs;
    NSMutableDictionary* prels;
    int correction;
}

@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* prelfilePath;

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) UIImageView *aTabBarBackground;
@property (nonatomic, retain) IBOutlet UIImage* img;

+ (Common*)instance;

+ (void) saveImage: (UIImage*)img;
+ (UIImage*) loadImage;

- (void)clearNews;
- (void)addNews: (Item*)item;
- (int) getNewsCount;
- (Item*) getNewsAt: (int)num;

- (void)clearQAs;
- (void)addQA: (Item*)item;
- (int) getQAsCount;
- (Item*) getQAAt: (int)num;

- (void) saveFav: (Item*) item;

- (int) getFavNewsCount;
- (Item*) getFavNewsAt: (int)num;
- (void) delFavNewsAt: (int)num;

- (void)clearPodcasts;
- (void)addPodcast: (Item*)item;
- (int) getPodcastsCount;
- (Item*) getPodcastAt: (int)num;

- (void) loadPreloaded;
- (void) saveNewsPreload;
- (void) saveQAsPreload;
- (void) savePodcastsPreload;

- (void) sort: (NSMutableArray*) a;

- (BOOL) isOnlyWiFi;
- (void) setOnlyWiFi: (BOOL)b;


@end
