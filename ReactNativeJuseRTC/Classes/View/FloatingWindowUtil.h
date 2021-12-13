//
//  FloatingWindowUtil.h
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatingWindowUtil : NSObject

+ (instancetype)shareInstance;

- (void)startSignalingCall:(BOOL)signalingCall;
@property(nonatomic,copy)NSString *developmentUrl;
@property(nonatomic,copy)NSDictionary *signaUserInfo;

@end

NS_ASSUME_NONNULL_END
