//
//  NSString+Resolver.m
//  TCar
//
//  Created by ap2 on 2017/11/20.
//  Copyright © 2017年 ap2. All rights reserved.
//

#import "NSString+Resolver.h"

@implementation NSString (Resolver)

- (NSString *)resolverWithKeyWord:(NSString *)keyWord previousCount:(NSInteger)previousCount forward:(NSInteger)forwardCount
{
    NSRange range = [self rangeOfString:keyWord options:NSCaseInsensitiveSearch];
    
    NSInteger prevIndex = range.location - previousCount;
    
    if (prevIndex < 0) {
        prevIndex = 0;
    }
    
    NSInteger lastIndex = range.location;
    if ((forwardCount + range.location) < self.length) {
        lastIndex = (forwardCount + range.location);
    }else{
        lastIndex = (self.length - 1);
    }
    
    NSInteger len = lastIndex - prevIndex;
    
    range = NSMakeRange(prevIndex, len);
    
    NSString *target = [self substringWithRange:range];
    
    
    return target;
}

@end
