//
//  libJsonParser.m
//  libJsonParser
//
//  Created by Alexandre Barbier on 8/17/12.
//  Copyright (c) 2012 Alexandre Barbier. All rights reserved.
//

#import "libJsonParser.h"

@implementation libJsonParser
@synthesize responseData, json, connectionError, parseError;

#pragma mark - Initialisation

-(id)initWithUrl:(NSString *)Url
{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ParsingFinishEvent:) name:@"ParsingFinish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData:) name:@"LoadData" object:nil];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
	NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection isProxy];
    responseData = [[NSMutableData alloc]init];
    json = [[NSMutableArray alloc] init];
    return self;
}

- (void)ParsingFinishEvent:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ParsingFinish" object:nil];
}
- (void)LoadData:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoadData" object:nil];
}


-(id)initWithData:(NSMutableData *)data{
    self = [super init];
    responseData = data;
    return self;
}
#pragma mark - parsing

-(void)parseUrl
{
    NSError* error;
    json = [NSJSONSerialization
            JSONObjectWithData:responseData
            options:kNilOptions
            error:&error];
        parseError = error;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ParsingFinish" object:nil];
}

-(void)parseFile:(NSString *)filePath
{
    responseData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error;
        json = [NSJSONSerialization
                JSONObjectWithData:responseData
                options:kNilOptions
                error:&error];
            parseError = error;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ParsingFinish" object:nil];
    });
    
}

-(void)parseData:(NSMutableData *)data
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSError* error;
                       json = [NSJSONSerialization
                               JSONObjectWithData:data
                               options:kNilOptions
                               error:&error];
                       parseError = error;
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"ParsingFinish" object:nil];
                   });
}

-(void)parseData:(NSMutableData *)data inClass:(NSString *)container withTag:(NSMutableArray *)tags
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* error;
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:&error];
        
        Class containerClass = NSClassFromString(container);
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        for (NSDictionary *a in json)
        {
            
            NSMutableArray *values = [[NSMutableArray alloc] init];
            for (NSString *arg in tags)
            {
                [values addObject:[a valueForKey:arg]];
            }
            NSDictionary *param = [[NSDictionary alloc]initWithObjects:values forKeys:tags];
            id obj = [[containerClass alloc] initWithDictionary:param];
            [returnArray addObject:obj];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ParsingFinish" object:returnArray];
    });
}

-(void)parse
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error;
        json = [NSJSONSerialization
                JSONObjectWithData:responseData
                options:kNilOptions
                error:&error];
            parseError = error;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ParsingFinish" object:nil];
    });
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
     UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                          message:@"Check your connectivity"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [errorAlert show];
    connectionError = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadData" object:nil];
}
@end
