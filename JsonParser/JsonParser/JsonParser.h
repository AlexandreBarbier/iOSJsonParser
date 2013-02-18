//
//  libJsonParser.h
//  libJsonParser
//
//  Created by Alexandre Barbier on 8/17/12.
//  Copyright (c) 2012 Alexandre Barbier. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol JSonParserProtocol <NSObject>
@optional

- (void)parsingFinishWithResult:(NSMutableArray *)result andError:(NSError *)error;

@end
@interface JsonParser : NSObject <JSonParserProtocol>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray* json;
@property (nonatomic, strong) NSError *parseError;
@property (nonatomic, strong) NSError *connectionError;
@property (nonatomic, strong) id <JSonParserProtocol> delegate;

- (id)initWithUrl:(NSString *)Url;
- (id)initWithData:(NSMutableData *)data;
- (void)parseFile:(NSString *)filePath;
- (void)parseData:(NSMutableData *)data;
- (void)parse;
- (void)parseData:(NSMutableData *)data inClass:(NSString *)container withTag:(NSMutableArray *)tags;

@end