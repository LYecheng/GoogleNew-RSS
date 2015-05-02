//
//  BookmarkTableViewController.h
//  Google News RSS
//
//  Created by Yecheng Li on 02/11/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@protocol bookmarkToWebviewDelegate <NSObject>

-(void)bookmark:(id)sender sendsURL:(NSURL*)url andUpdateArticleItem:(Article*)article;

@end


@interface bookmarkTableViewController : UITableViewController

@property (weak, nonatomic) id<bookmarkToWebviewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *ItemArray;

@end

