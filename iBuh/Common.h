//
//  Common.h_
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

#define MENU_URL_FOR_REACH @"www.buhgalteria.ru"
#define MENU_URL @"http://www.buhgalteria.ru/rss/iphoneapp/iphonenews.php"

#define ITEM_TAG @"item"
#define TITLE_TAG @"title"
#define LINK_TAG @"link"
#define RUBRIC_TAG @"rubric"
#define FULLTEXT_TAG @"full-text"
#define DATE_TAG @"pubDate"

@interface Common : NSObject {
 
    NSMutableArray* news;
}

+ (Common*)instance;

- (void)clearNews;

- (void)addNews: (Item*)item;
- (int) getNewsCount;
- (Item*) getNewsAt: (int)num;


@end
