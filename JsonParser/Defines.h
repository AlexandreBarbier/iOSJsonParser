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

typedef enum{
    parsingTypeInClassWithUrl = 0,
    parsingTypeURL = 1,
}JSonParsingType;

#endif
