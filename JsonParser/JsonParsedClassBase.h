//
//  JsonParsedClassBase.h
//  JsonParser
//
//  Created by Alexandre Barbier on 2/19/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JSonParsedClass<NSObject>
@required
- (id)initWithDictionary:(NSDictionary *)params;
@end

@interface JsonParsedClassBase : NSObject <JSonParsedClass>

@end
