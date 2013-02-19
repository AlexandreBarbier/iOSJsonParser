//
//  ViewController.h
//  testJSonParser
//
//  Created by Alexandre Barbier on 2/18/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonParser.h"


@interface ViewController : UITableViewController <JSonParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableViewSource;
@property (nonatomic, weak) IBOutlet UITableView *tv;
@end