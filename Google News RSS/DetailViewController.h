//
//  DetailViewController.h
//  Google News RSS
//
//  Created by Yecheng Li on 02/11/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookmarkTableViewController.h"
#import "Social/Social.h"
#import "Article.h"

@interface DetailViewController : UIViewController<bookmarkToWebviewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) Article *item;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteStar;

@end