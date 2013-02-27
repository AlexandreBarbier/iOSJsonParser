//
//  Defines.h
//  JsonParser
//
//  Created by Alexandre Barbier on 2/19/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#ifndef JsonParser_Defines_h
#define JsonParser_Defines_h

#define kParsingFinishEvent @"ParsingFinish"
#define kLoadDataEvent @"LoadData"


@protocol JSonParsedClass<NSObject>

@required

- (id)initWithDictionary:(NSDictionary *)params;
+ (NSArray *)getTags;
@end


typedef enum
{
    parsingTypeInClassWithUrl = 0,
    parsingTypeURL = 1,
    parsingClassWithUrl = 2
    
}JSonParsingType;

#endif
