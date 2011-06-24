//
//  XMLParser.h
//  XMLpars
//
//  Created by вадим on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

enum item_types {
    
    TYPE_NEWS,
    TYPE_QAS,
    TYPE_PCS
};

@interface XMLParser : NSObject <NSXMLParserDelegate> {

	NSMutableString* currentElementValue;
    int itype;
}

- (XMLParser *) initXMLParser: (int) type;

@property (nonatomic, retain) Item* item;

@end
