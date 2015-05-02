//
//  Article.h
//  Google News RSS
//
//  Created by Yecheng Li on 02/20/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Article : NSObject<NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *publishedDate;
@property (strong,nonatomic) NSString *contentSnippet;
@property (strong,nonatomic) NSString *link;

@end