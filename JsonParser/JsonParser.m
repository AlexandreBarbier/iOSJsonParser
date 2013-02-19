//
//  libJsonParser.m
//  libJsonParser
//
//  Created by Alexandre Barbier on 8/17/12.
//  Copyright (c) 2012 Alexandre Barbier. All rights reserved.
//

#import "JsonParser.h"
#import "JsonParsedClassBase.h"

@implementation JsonParser


#pragma mark - Initialisation

- (id)initWithUrl:(NSString *)Url
{
    self = [super init];
    [self setParsingType:parsingTypeURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:kParsingFinishEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:kLoadDataEvent object:nil];    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
	NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection isProxy];
    _responseData = [[NSMutableData alloc]init];
    _json = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithClass:(NSString*)className andTag:(NSMutableArray *)tags forURL:(NSString *)Url{
    self = [super init];
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

- (id)initWithData:(NSMutableData *)data{
    self = [super init];
    _responseData = data;
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
    _parseError = error;
    if ([self delegate] != nil)
        [[self delegate] parsingFinishWithResult:_json andError:_parseError];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
}

- (void)parseFile:(NSString *)filePath
{
    _responseData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error;
        _json = [NSJSONSerialization
                JSONObjectWithData:_responseData
                options:kNilOptions
                error:&error];
        _parseError = error;
        if ([self delegate] != nil)
            [[self delegate] parsingFinishWithResult:_json andError:_parseError];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
    });
    
}

- (void)parseData:(NSMutableData *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSError* error;
                       _json = [NSJSONSerialization
                               JSONObjectWithData:data
                               options:kNilOptions
                               error:&error];
                       _parseError = error;
                       if ([self delegate] != nil)
                           [[self delegate] parsingFinishWithResult:_json andError:_parseError];
                       else
                           [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:nil];
                   });
}

- (void)parseData:(NSMutableData *)data inClass:(NSString *)container withTag:(NSMutableArray *)tags
{
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
            NSMutableArray *realTag = [[NSMutableArray alloc] init];
            for (NSDictionary *a in _json)
            {
                NSMutableArray *values = [[NSMutableArray alloc] init];
                
                for (NSString *arg in tags)
                {
                    if ([a valueForKey:arg]!= nil){
                        [values addObject:[a valueForKey:arg]];
                        [realTag addObject:arg];
                    }
                }
                if (values != nil){
                    NSDictionary *param = [[NSDictionary alloc]initWithObjects:values forKeys:realTag];
                    [realTag removeAllObjects];
                    if (param != nil){
                        id obj = [[containerClass alloc] initWithDictionary:param];
                        [returnArray addObject:obj];
                    }
                }
            }
            if ([self delegate] != nil)
                [[self delegate] parsingFinishWithResult:returnArray andError:_parseError];
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:kParsingFinishEvent object:returnArray];
            }
        });
}

- (void)parseInClass:(NSString *)container withTag:(NSMutableArray *)tags
{
    
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
            NSMutableArray *realTag = [[NSMutableArray alloc] init];
            for (NSDictionary *a in _json)
            {
                NSMutableArray *values = [[NSMutableArray alloc] init];
                
                for (NSString *arg in tags)
                {
                    @try {
                        if ([a valueForKey:arg]!= nil){
                            [values addObject:[a valueForKey:arg]];
                            [realTag addObject:arg];
                        }
                    }
                    @catch (NSException *exception) {
                        
                    }
                
                }
                if (values != nil){
                    NSDictionary *param = [[NSDictionary alloc]initWithObjects:values forKeys:realTag];
                    [realTag removeAllObjects];
                    if (param != nil){
                        id obj = [[containerClass alloc] initWithDictionary:param];
                        [returnArray addObject:obj];
                    }
                }
            }
            if ([self delegate] != nil)
                [[self delegate] parsingFinishWithResult:returnArray andError:_parseError];
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
            [[self delegate] parsingFinishWithResult:_json andError:_parseError];
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
            [self parseInClass:[self className] withTag:[self tags]];
            break;
        case parsingTypeURL:
            [self parseUrl];
            break;
        default:
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoadDataEvent object:nil];
            break;
    }
}

@end
