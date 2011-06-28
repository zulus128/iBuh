//
//  Tweet.h
//  iCodeOauth
//
//  Created by Collin Ruffenach on 9/14/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {

	NSDictionary *contents;
}

-(id)initWithTweetDictionary:(NSDictionary*)_contents;

-(NSString*)tweet;
-(NSString*)author;

@end
