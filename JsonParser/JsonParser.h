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
 * @protocol JSonParserDelegate
 * @description Implement this protocol if you want to use delegate to receive parsing result
*/
@protocol JSonParserDelegate <NSObject>

@optional

- (void)parsingFinishWithJsonResult:(NSMutableArray *)result andError:(NSError *)error;
- (void)parsingFinishWithObjectArrayResult:(NSMutableArray *)result andError:(NSError *)error;

@end

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
/*!
 * @method
 * @param Url
 */
- (id)initAndParseUrl:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate;


- (id)initAndParseInClass:(Class)cl WithURL:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate;

- (id)initAndParseInClass:(Class)cl WithURLRequest:(NSURLRequest *)Url withDelegate:(id <JSonParserDelegate>)delegate;
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
