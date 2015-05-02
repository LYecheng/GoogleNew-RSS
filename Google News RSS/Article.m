//
//  Article.m
//  Google News RSS
//
//  Created by Yecheng Li on 02/20/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "Article.h"

@implementation Article

//Implement the encoding method
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [encoder encodeObject:self.contentSnippet forKey:@"contentSnippet"];
    [encoder encodeObject:self.link forKey:@"link"];
}

//implement the decoding method
- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.contentSnippet = [decoder decodeObjectForKey:@"contentSnippet"];
    self.publishedDate = [decoder decodeObjectForKey:@"publishedDate"];
    self.link = [decoder decodeObjectForKey:@"link"];
    
    return self;
}

@end

