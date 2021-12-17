//
//  FloatingWindowUtil.h
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//呼叫状态
typedef NS_ENUM(NSInteger, RTCCallType) {
    RTCACCEPT = 0,//接听
    RTCCANCEL = 1,//主动取消(含无应答)
    RTCCLOSE  = 2,//挂断
    RTCREJECT = 3,//拒接
    RTCLEAVE  = 4,//有人离开房间
    RTCVIDEOSTATUS =5,//需要更新到后台并且发送自定义消息
    RTCGETTOKEN  = 6,//通知到rn端获取TOKEN
    RTCDESTORY = 99//页面销毁
};




@interface FloatingWindowUtil : NSObject

+ (instancetype)shareInstance;
- (void)signalingCall;
- (void)signalingNotify;
- (void)signalingMutilClientSyncNotify;
@property(nonatomic,copy)NSString *developmentUrl;
@property(nonatomic,assign)BOOL signaDoctor;
@property(nonatomic,copy)NSDictionary *signaUserInfo;
@property (nonatomic, assign) RTCCallType callType;
@end

NS_ASSUME_NONNULL_END
