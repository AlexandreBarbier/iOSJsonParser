//
//  JsonParsedClassBase.m
//  JsonParser
//
//  Created by Alexandre Barbier on 2/19/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#import "JsonParsedClassBase.h"


@implementation JsonParsedClassBase

-(id)initWithDictionary:(NSDictionary *)params{
    self = [super init];
    return self;
}

+(NSArray *)getTags{
    return [NSArray arrayWithObject:nil];
}
@end
