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

/*!
 * @interface JsonParser
 * @discussion This class test
 * @description Main class of the parser providing many functions
*/

@interface JsonParser : NSObject


@property(nonatomic,strong) Class                       parsedClass;

/*!
 * @property delegate
 * @description the delegate for the parsing finish method
 */
@property (nonatomic, strong) id <JSonParserDelegate>   delegate;
/*!
 * @property json
 * @description the parsed json never get it except if you are using notification center to get result
 */
@property (nonatomic, strong) NSMutableArray            *json;


@property (nonatomic) Boolean                           *useNotificationCenter;
/*!
 * @method
 * @param Url
 */
- (id)initAndParseUrl:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 * @param Url
 */
- (id)initAndParseInClass:(Class)parsingClass WithURL:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 * @param Url
 */
- (id)initAndParseInClass:(Class)parsingClass WithURLRequest:(NSURLRequest *)Url withDelegate:(id <JSonParserDelegate>)delegate;
/*!
 * @method
 * @param Url
 */
- (id)initAndParseUrlRequest:(NSURLRequest *)Url withDelegate:(id<JSonParserDelegate>)delegate;

/*!
 * @method 
 * @param data
 */
- (id)initAndParseData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 * @param className
 * @description return the result in parsingFinishWithObjectArrayResult:result andError:error;
 */
- (id)initAndParseInClass:(NSString*)className andTag:(NSMutableArray *)tags forURL:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 * @param data
 */
- (id)initAndParseData:(NSMutableData *)data inClasse:(NSString *)class withTag:(NSMutableArray *)tags withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 */
- (void)parseFile:(NSString *)filePath withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 */
- (void)parseData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 * @description return the result in parsingFinishWithObjectArrayResult:result andError:error;
 */
- (void)parseData:(NSMutableData *)data inClass:(NSString *)container withTag:(NSMutableArray *)tags withDelegate:(id <JSonParserDelegate>)delegate;

/*!
 * @method
 * @description return the result in parsingFinishWithObjectArrayResult:result andError:error;
 */
-(void)parsingInClassWithData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate;

@end
