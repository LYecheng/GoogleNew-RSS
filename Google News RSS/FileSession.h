//
//  FileSession.h
//  Google News RSS
//
//  Created by Yecheng Li on 02/20/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSession : NSObject

+(NSURL *)getListURL;

+(void)writeData:(id)object ToList:(NSURL*)url;

+(NSArray *)readDataFromList:(NSURL*)url;

@end
