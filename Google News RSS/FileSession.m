//
//  FileSession.m
//  Google News RSS
//
//  Created by Yecheng Li on 02/20/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "Article.h"
#import "FileSession.h"

@implementation FileSession

+(NSURL *)getListURL
{
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    NSURL* file = [docs URLByAppendingPathComponent:@"articles.plist"];
    
    return file;
}

+(void)writeData:(id)object ToList:(NSURL*)url{
    NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:object];
    [sessionData writeToURL:url atomically:NO];
}

+(NSArray *)readDataFromList:(NSURL*)url {
    NSData* data = [[NSData alloc] initWithContentsOfURL:url];
    NSArray *dataRetrived = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return dataRetrived;
}


@end
