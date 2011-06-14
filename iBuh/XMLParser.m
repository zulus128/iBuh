//
//  XMLParser.m
//  XMLpars
//
//  Created by вадим on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"
#import "Common.h"

@implementation XMLParser

@synthesize item;

- (XMLParser *) initXMLParser {
	
	[super init];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
  //  NSLog(@"Start Element");
    
	if([elementName isEqualToString:ITEM_TAG]) {

		item = [[Item alloc] init];
	//	NSLog(@"Item alloc");
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
		
	NSString* trimedStr;
	if(currentElementValue)
		trimedStr = [currentElementValue stringByTrimmingCharactersInSet:
						   [NSCharacterSet whitespaceAndNewlineCharacterSet]];


    if([elementName isEqualToString:ITEM_TAG]) {
			
        [[Common instance] addNews:item];
        [item release];
    }
    else
        if([elementName isEqualToString:TITLE_TAG])
            item.title = trimedStr;
            else
                if([elementName isEqualToString:LINK_TAG]) 
                    item.link = trimedStr;
                    else
						if([elementName isEqualToString:RUBRIC_TAG])
							item.rubric = trimedStr;
                            else
                                if([elementName isEqualToString:FULLTEXT_TAG])
                                    item.full_text = trimedStr;
                                    else
                                        if([elementName isEqualToString:DATE_TAG])
                                            item.date = trimedStr;
	
	[currentElementValue release];
	currentElementValue = nil;

}

- (void) dealloc {

	[item release];
	
	[currentElementValue release];
	[super dealloc];
}

@end
