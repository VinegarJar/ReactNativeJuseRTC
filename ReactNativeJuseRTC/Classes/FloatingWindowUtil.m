//
//  FloatingWindowUtil.m
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.
//

#import "FloatingWindowUtil.h"

@implementation FloatingWindowUtil


- (id)copyWithZone:(NSZone *)zone {
    return [[FloatingWindowUtil allocWithZone:zone] init];
}

+ (id)allocWithZone:(NSZone *)zone{
    return [self shareInstance];
}

+ (instancetype)shareInstance{
    static FloatingWindowUtil *floatViewUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatViewUtil = [[FloatingWindowUtil alloc] init];
    });
    return floatViewUtil;
}



@end
