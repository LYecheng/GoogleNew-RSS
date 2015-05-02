//
//  DetailViewController.m
//  Google News RSS
//
//  Created by Yecheng Li on 02/11/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "SharedNetworking.h"
#import "DetailViewController.h"
#import "bookmarkTableViewController.h"
#import "FileSession.h"

@interface DetailViewController ()<UIWebViewDelegate, UIActionSheetDelegate, NSCoding, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *favoriteArray;

@property (weak, nonatomic) IBOutlet UIWebView *myWebVIew;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *twitterButton;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkIndicator;

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.url isEqualToString:@"http://news.google.com"]) {
        self.favoriteButton.enabled = NO;
        self.twitterButton.enabled = NO;
    }
    
    NSURL* nsURL = [NSURL URLWithString:self.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    self.myWebView.delegate = self;
    [self.myWebView loadRequest:request];
    NSURL *fileURL= [FileSession getListURL];
    
    self.favoriteArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    self.favoriteStar.hidden = YES;
    
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] title];
        if ([title isEqualToString:self.item.title]) {
            self.favoriteStar.hidden = NO;
            break;
        }
    }    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.item!=nil) {
        NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:self.item];
        [defaults setObject:serialized forKey:@"lastItem"];
    }
    
    [defaults setObject:self.url forKey:@"lastUrl"];
    [defaults synchronize];
    
    self.loadingView.layer.cornerRadius = 10;
    self.loadingView.layer.masksToBounds = YES;
    
    [self stateChanged];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(stateChanged)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(stateChanged)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
}

-(void)stateChanged{
    NSLog(@"the state is changed");
    
    BOOL nightMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_nightmode"];
    UINavigationController *detailNavigationController = (UINavigationController *)self.parentViewController;
    if (nightMode == true) {
        [detailNavigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [detailNavigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [detailNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
        [detailNavigationController.navigationBar setNeedsDisplay];
        
        [detailNavigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [detailNavigationController.toolbar setTintColor:[UIColor whiteColor]];
        [detailNavigationController.toolbar setNeedsDisplay];
        
    }
    else{
        [detailNavigationController.navigationBar setTintColor:[UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:1.0]];
        [detailNavigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [detailNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
        [detailNavigationController.navigationBar setNeedsDisplay];
        
        [detailNavigationController.toolbar setBarStyle:UIBarStyleDefault];
        [detailNavigationController.toolbar setTintColor:[UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:1.0]];
        [detailNavigationController.toolbar setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addFavorite:(UIBarButtonItem *)sender {
    if(![SharedNetworking isNetworkAvailable])
    {
        return;
    }
    
    NSInteger flag = 0;
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] title];
        if ([title isEqualToString:self.item.title]) {
            flag = 1;
            break;
        }
    }
    
    if (flag == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Already Liked!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"Item already liked");
    }
    else {
        
        [self.favoriteArray addObject:self.item];
        
        NSURL *fileURL = [FileSession getListURL];
        [FileSession writeData:self.favoriteArray ToList:fileURL];
        self.favoriteStar.hidden = NO;
        
        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"Added to Favorite!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView2 show];
        NSLog(@"Added one item to favorite");
    }
}

#pragma mark-social network implementation

- (IBAction)TweetAboutIt:(UIBarButtonItem *)sender {
    
    if(![SharedNetworking isNetworkAvailable])
    {
        return;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *text = [NSString stringWithFormat:@"great page: %@ ,check it out: %@",self.item.title,self.item.link];
        [twitterPost setInitialText:text];
        [self presentViewController:twitterPost animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.networkIndicator startAnimating];
    self.loadingView.hidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loadingView.hidden = YES;
    [self.networkIndicator stopAnimating];
}

- (void)bookmark:(id)sender sendsURL:(NSURL *)url andUpdateArticleItem:(Article *)article{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.item = article;
    self.favoriteStar.hidden = YES;
    
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] title];
        if ([title isEqualToString:self.item.title]) {
            self.favoriteStar.hidden = NO;
            break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showBookMark"])
    {
        UINavigationController *destination = [segue destinationViewController];
        
        bookmarkTableViewController *bookmarkVC = (bookmarkTableViewController *)[destination topViewController];
        UIPopoverPresentationController *popPC = destination.popoverPresentationController;
        popPC.delegate = self;
        bookmarkVC.delegate = self;
        [bookmarkVC setItemArray:self.favoriteArray];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


@end
