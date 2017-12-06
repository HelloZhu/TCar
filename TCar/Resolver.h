//
//  Resolver.h
//  TCar
//
//  Created by ap2 on 2017/11/20.
//  Copyright © 2017年 ap2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resolver : NSObject

+ (NSString *)resolverWithKeyWord:(NSString *)keyWord previousCount:(NSInteger)previousCount forward:(NSInteger)forwardCount;

@end
