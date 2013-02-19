//
//  JsonParser.h
//  JsonParser
//
//  Created by Alexandre Barbier on 8/17/12.
//  Copyright (c) 2012 Alexandre Barbier. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Defines.h"
@protocol JSonParsedClass<NSObject>

@required
@property (nonatomic, strong) NSMutableArray *tags;
- (id) initWithDictionary:(NSDictionary *)params;
@end


@protocol JSonParserDelegate <NSObject>

@required
- (void)parsingFinishWithResult:(NSMutableArray *)result andError:(NSError *)error;

@end

@interface JsonParser : NSObject

@property (nonatomic, strong) NSMutableData             *responseData;
@property (nonatomic, strong) NSMutableArray            *json;
@property (nonatomic, strong) NSError                   *parseError;
@property (nonatomic, strong) NSError                   *connectionError;
@property (nonatomic, strong) id <JSonParserDelegate>   delegate;
@property (nonatomic) JSonParsingType                   parsingType;
@property(nonatomic, strong) NSString                   *className;
@property (nonatomic, strong) NSMutableArray            *tags;


- (id)initWithUrl:(NSString *)Url;
- (id)initWithData:(NSMutableData *)data;
- (id)initWithClass:(NSString*)className andTag:(NSMutableArray *)tags forURL:(NSString *)Url;

- (void)parseFile:(NSString *)filePath;
- (void)parseData:(NSMutableData *)data;
- (void)parseData:(NSMutableData *)data inClass:(NSString *)container withTag:(NSMutableArray *)tags;

@end
