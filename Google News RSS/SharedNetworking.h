//
//  SharedNetworking.h
//  Google News RSS
//
//  Created by Yecheng Li on 02/11/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

// Create a singleton class named SharedNetworking that will handle your API requests

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedNetworking : NSObject

+(id)sharedSharedWorking;

+ (BOOL)isNetworkAvailable;

-(void)getFeedForURL:(NSString*)url
             success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
             failure:(void (^)(void))failureCompletion;

@end
