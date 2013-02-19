//
//  Response.m
//  testJSonParser
//
//  Created by Alexandre Barbier on 2/19/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#import "Response.h"

@implementation Response

-(id)initWithDictionary:(NSDictionary *)params{
    self = [super initWithDictionary:params];
    for (NSString* key in [params keyEnumerator])
    {
        if ([key isEqualToString:@"date"])
            [self setDate:[params valueForKey:key]];
        else if ([key isEqualToString:@"authorName"])
            [self setAuthorName:[params valueForKey:key]];
        else if ([key isEqualToString:@"likesNumber"])
            [self setLikesNumber:[params valueForKey:key]];
    }
    return self;
}

@end
