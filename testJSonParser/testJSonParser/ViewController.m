//
//  ViewController.m
//  testJSonParser
//
//  Created by Alexandre Barbier on 2/18/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#import "ViewController.h"
#import "Response.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableData *dat = [[NSMutableData alloc] initWithContentsOfFile:@"/Users/alexandre/Developement/iOS/TestInApp/testJSonParser/testJSonParser/File.json"];
    JsonParser *p = [[JsonParser alloc] initWithData:dat];
    [p parseData:dat inClass:@"Response" withTag:[[NSMutableArray alloc] initWithObjects:@"likesNumber",@"authorName",@"date", nil]];
    [p setDelegate:self];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)parsingFinishWithResult:(NSMutableArray *)result andError:(NSError *)error{
    [self setTableViewSource:result];
    [[self tv] reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self tableViewSource] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] init];
    [[cell textLabel] setText:[((Response *)[[self tableViewSource] objectAtIndex:indexPath.row]) authorName]];
    return  cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
