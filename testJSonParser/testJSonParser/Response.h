//
//  Response.h
//  testJSonParser
//
//  Created by Alexandre Barbier on 2/19/13.
//  Copyright (c) 2013 Alexandre Barbier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonParsedClassBase.h"
/*
 "likesNumber": 9,
 "bookConcerned_id": 2,
 "bookTitle": "Correspondance",
 "type": "SA_B_ReadingStart",
 "authorName": "Arthur Rimbaud",
 "author_id": 2,
 "date": 1353909605,
 "visualArray": [
 {
 "picto-bd": "http://dev.omts.fr/reaaad/book_004.png",
 "picto-hd": "http://dev.omts.fr/reaaad/book_004@2x.png",
 "full-bd": "http://dev.omts.fr/reaaad/book_004_high.png",
 "full-hd": "http://dev.omts.fr/reaaad/book_004_high@2x.png"
 }
 ]
 */
@interface Response : JsonParsedClassBase

@property (nonatomic) NSNumber *likesNumber;
@property (nonatomic) NSNumber *bookConcerned_id;
@property (nonatomic) NSNumber *author_id;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *bookTitle;
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSMutableArray *visualArray;

-(id)initWithDictionary:(NSDictionary *)params;


@end
