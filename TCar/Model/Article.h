//
//  Article.h
//  TCar
//
//  Created by ap2 on 2017/11/21.
//  Copyright © 2017年 ap2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
@property (nonatomic, copy) NSString *articleID;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@end
