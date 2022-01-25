//
//  RTCWindowView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import <UIKit/UIKit.h>
#import "UIView+XXYViewFrame.h"
#import "FloatConfig.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSURL+URLxtension.h"
#import "StringToDic.h"
#import "RTCButtonView.h"


typedef NS_ENUM(NSInteger, RTCWindowState) {
    RTCWindowDefault = 0,//默认
    RTCWindowFloatingWindow = 1//小窗口
};

@protocol RTCWindowViewDelegate <NSObject>
//结束通话
- (void)endCallButtonHandle:(NSString*)titleLabel;
//接受通话请求
- (void)acceptCallHandle;
//通话销毁
- (void)destroyCallHandle;
// 无应答
- (void)noAnswerCallHandle;
// 对方正忙
- (void)delayMethodCallHandle;

//主动取消通话发送通知到rn端 @"CLOSE
//主动拒绝通话发送通知到rn端 @"REJECT"
//主动接受通话发送通知到rn端 @"ACCEPT"
//发送通知到rn端 页面销毁   @"DESTORY"
//无应答发送通知到rn端      @"CANCEL"
//有人离开房间             @"LEAVE"
//视频状态,需要更新到后台并且发送自定义消息 @"VIDEO_STATUS"
//发送通知到rn端获取TOKEN  @"GET_TOKEN"

@end


@interface RTCWindowView : UIView
/** 底部按钮容器视图 */
@property (strong, nonatomic) RTCButtonView *btnContainerView;
@property (nonatomic, weak) id<RTCWindowViewDelegate>delegate;

@property (nonatomic, assign) RTCWindowState state;

- (instancetype)initWithRTCWindowViewSignalingCall:(BOOL)signalingCall;

@property (nonatomic, strong)  AVAudioPlayer *audioPlayer;/** 播放铃声player */

-(void)signalingUserInfo:(NSDictionary *)userInfo startorDuration:(BOOL)startorDuration;
-(void)setCallinfoToken:(NSDictionary *)callinfo;
- (void)setupRTCEngine;
- (void)signalingMutilClientSyncNotify;
- (void)signalingNotifyJoinWithEventType:(NSString *)eventType controlType:(NSString *)controlType;
- (void)hangupClick;
@end

