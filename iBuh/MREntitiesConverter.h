//
//  MREntitiesConverter.h
//  iБухгалтерия
//
//  Created by вадим on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface MREntitiesConverter : NSObject <NSXMLParserDelegate> {
    
    NSMutableString* resultString;
}

@property (nonatomic, retain) NSMutableString* resultString;

- (NSString*)convertEntiesInString:(NSString*)s;

@end
