//
//  libJsonParser.m
//  libJsonParser
//
//  Created by Alexandre Barbier on 8/17/12.
//  Copyright (c) 2012 Alexandre Barbier. All rights reserved.
//

#import "JsonParser.h"
#import "JsonParsedClassBase.h"

@interface JsonParser()

@property (nonatomic, strong) NSMutableData             *responseData;
@property (nonatomic, strong) NSError                   *parseError;
@property (nonatomic, strong) NSError                   *connectionError;
@property (nonatomic) JSonParsingType                   parsingType;
@property (nonatomic, strong) NSString                  *className;
@property (nonatomic, strong) NSMutableArray            *tags;

@end

@implementation JsonParser


#pragma mark - Initialisation

- (id)initAndParseUrl:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    [self setDelegate:delegate];
    [self setParsingType:parsingTypeURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection isProxy];
    _responseData = [[NSMutableData alloc]init];
    _json = [[NSMutableArray alloc] init];
    [self parse];
    return self;
}

- (id)initAndParseUrlRequest:(NSURLRequest *)Url withDelegate:(id<JSonParserDelegate>)delegate{
    self = [super init];
    [self setDelegate:delegate];
    [self setParsingType:parsingTypeURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:Url delegate:self];
    [connection isProxy];
    _responseData = [[NSMutableData alloc]init];
    _json = [[NSMutableArray alloc] init];
    return self;
}



- (id)initAndParseInClass:(NSString*)className andTag:(NSMutableArray *)tags forURL:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    [self setDelegate:delegate];
    [self setParsingType:parsingTypeInClassWithUrl];
    [self setClassName:className];
    [self setTags:tags];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
	NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection isProxy];
    _responseData = [[NSMutableData alloc]init];
    _json = [[NSMutableArray alloc] init];
    return self;
}

- (id)initAndParseInClass:(Class)parsingClass WithURL:(NSString *)Url withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    [self setDelegate:delegate];
    [self setParsedClass:parsingClass];
    [self setParsingType:parsingClassWithUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
	NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection isProxy];
    _responseData = [[NSMutableData alloc]init];
    _json = [[NSMutableArray alloc] init];
    return self;
}

- (id)initAndParseInClass:(Class)parsingClass WithData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    [self setDelegate:delegate];
    [self setParsedClass:parsingClass];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];
    _responseData = data;
    _json = [[NSMutableArray alloc] init];
    [self parsingInClassWithData:_responseData withDelegate:[self delegate]];
    return self;
}

- (id)initAndParseInClass:(Class)parsingClass WithURLRequest:(NSURLRequest *)Url withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    [self setDelegate:delegate];
    [self setParsedClass:parsingClass];
    [self setParsingType:parsingClassWithUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];
	NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:Url delegate:self];
    [connection isProxy];
    _responseData = [[NSMutableData alloc]init];
    _json = [[NSMutableArray alloc] init];
    return self;
}

- (id)initAndParseData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    _responseData = data;
    [self setDelegate:delegate];
    [self parse];
    return self;
}

- (id)initAndParseData:(NSMutableData *)data inClasse:(NSString *)class withTag:(NSMutableArray *)tags withDelegate:(id <JSonParserDelegate>)delegate
{
    self = [super init];
    _responseData = data;
    [self setDelegate:delegate];
    [self parseInClass:class withTag:tags withDelegate:delegate];
    return self;
}



#pragma mark - parsing

- (void)parseUrl 
{
    NSError* error;
    _json = [NSJSONSerialization
            JSONObjectWithData:_responseData
            options:kNilOptions
            error:&error];
    if (![NSJSONSerialization isValidJSONObject:_json])
        [NSException raise:@"Invalid Json format" format:@"JSON parsed is not valid"];
    _parseError = error;
    if ([self delegate] != nil)
        [[self delegate] parsingFinishWithJsonResult:_json andError:_parseError];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
}

- (void)parseFile:(NSString *)filePath withDelegate:(id <JSonParserDelegate>)delegate
{
    _responseData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    [self setDelegate:delegate];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error;
        _json = [NSJSONSerialization
                JSONObjectWithData:_responseData
                options:kNilOptions
                error:&error];
        if (![NSJSONSerialization isValidJSONObject:_json])
            [NSException raise:@"Invalid Json format" format:@"JSON parsed is not valid"];
        _parseError = error;
        if ([self delegate] != nil)
            [[self delegate] parsingFinishWithJsonResult:_json andError:_parseError];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
    });
    
}

- (void)parseData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate
{
    [self setDelegate:delegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSError* error;
                       _json = [NSJSONSerialization
                               JSONObjectWithData:data
                               options:kNilOptions
                               error:&error];
                       if (![NSJSONSerialization isValidJSONObject:_json])
                           [NSException raise:@"Invalid Json format" format:@"JSON parsed is not valid"];
                       _parseError = error;
                       if ([self delegate] != nil)
                           [[self delegate] parsingFinishWithJsonResult:_json andError:_parseError];
                       else
                           [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
                   });
}

-(void)parsingInClassWithData:(NSMutableData *)data withDelegate:(id <JSonParserDelegate>)delegate
{
    if ([self delegate] == nil)
        [self setDelegate:delegate];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* error;
       
        _json = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:kNilOptions
                 error:&error];
        
        if (![NSJSONSerialization isValidJSONObject:_json])
            [NSException raise:@"Invalid Json format" format:@"JSON parsed is not valid"];
        
        if ([[self parsedClass] conformsToProtocol:@protocol(JSonParsedClass)])
        {
            NSMutableArray *returnArray = [[NSMutableArray alloc] init];
            for (NSDictionary *a in _json)
            {
                if (a != nil){
                    id obj = [[[self parsedClass] alloc] initWithDictionary:a];
                    [returnArray addObject:obj];
                }
            }
            if ([self delegate] != nil)
                [[self delegate] parsingFinishWithObjectArrayResult:returnArray andError:_parseError];
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:returnArray];
        }
    });
}

- (void)parseData:(NSMutableData *)data inClass:(NSString *)container withTag:(NSMutableArray *)tags withDelegate:(id <JSonParserDelegate>)delegate
{
    [self setDelegate:delegate];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* error;
        _json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:&error];
        Class containerClass = NSClassFromString(container);
        if ([containerClass conformsToProtocol:@protocol(JSonParsedClass)])
        {
            NSMutableArray *returnArray = [[NSMutableArray alloc] init];
            for (NSDictionary *a in _json)
            {
                if (a != nil){
                    id obj = [[containerClass alloc] initWithDictionary:a];
                    [returnArray addObject:obj];
                }
            }
            if ([self delegate] != nil)
                [[self delegate] parsingFinishWithObjectArrayResult:returnArray andError:_parseError];
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:returnArray];
            }
        });
}

- (void)parseInClass:(NSString *)container withTag:(NSMutableArray *)tags withDelegate:(id <JSonParserDelegate>)delegate
{
    [self setDelegate:delegate];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* error;
        _json = [NSJSONSerialization
                 JSONObjectWithData:_responseData
                 options:kNilOptions
                 error:&error];
        Class containerClass = NSClassFromString(container);
        if ([containerClass conformsToProtocol:@protocol(JSonParsedClass)])
        {
            NSMutableArray *returnArray = [[NSMutableArray alloc] init];
            for (NSDictionary *a in _json)
            {
                if (a != nil){
                    id obj = [[containerClass alloc] initWithDictionary:a];
                    [returnArray addObject:obj];
                }
            }
            if ([self delegate] != nil)
                [[self delegate] parsingFinishWithObjectArrayResult:returnArray andError:_parseError];
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:returnArray];
        }
    });
}

- (void)parse
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error;

        _json = [NSJSONSerialization
                JSONObjectWithData:_responseData
                options:kNilOptions
                error:&error];
        _parseError = error;
        if ([self delegate] != nil)
            [[self delegate] parsingFinishWithJsonResult:_json andError:_parseError];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
    });
}

#pragma mark - EventHandler

- (void)ParsingFinishEvent:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kParsingFinishEvent object:nil];
}

- (void)LoadData:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoadDataEvent object:nil];
}


#pragma mark - Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                         message:@"Check your connectivity"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
    _connectionError = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    switch ([self parsingType]) {
        case parsingTypeInClassWithUrl:
            [self parseInClass:[self className] withTag:[self tags] withDelegate:[self delegate]];
            break;
        case parsingTypeURL:
            [self parseUrl];
            break;
        case parsingClassWithUrl:
            [self parsingInClassWithData:_responseData withDelegate:[self delegate]];
        default:
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoadDataEvent object:nil];
            break;
    }
}

@end
