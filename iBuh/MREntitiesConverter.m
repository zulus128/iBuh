//
//  MREntitiesConverter.m
//  iБухгалтерия
//
//  Created by вадим on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MREntitiesConverter.h"

@implementation MREntitiesConverter

@synthesize resultString;

- (id)init {
    
    if([super init]) {
        //resultString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
    
    [self.resultString appendString:s];
}

- (NSString*)convertEntiesInString:(NSString*)s {
    
    resultString = [[NSMutableString alloc] init];
    
    if(s == nil) {
        NSLog(@"ERROR : Parameter string is nil");
    }
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
    NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[[NSXMLParser alloc] initWithData:data] autorelease];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    return [NSString stringWithFormat:@"%@",[resultString autorelease]];
}
- (void)dealloc {
   // [resultString release];
    [super dealloc];
}
@end
