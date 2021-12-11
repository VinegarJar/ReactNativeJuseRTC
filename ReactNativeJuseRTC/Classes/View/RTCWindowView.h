//
//  RTCWindowView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import <UIKit/UIKit.h>
#import "UIView+XXYViewFrame.h"
#import "Config.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSURL+URLxtension.h"




typedef NS_ENUM(NSInteger, RTCWindowState) {
    RTCWindowDefault = 0,//默认
    RTCWindowFloatingWindow = 1//小窗口
};

@protocol RTCWindowViewDelegate <NSObject>

- (void)endCallButtonHandle;

@end


@interface RTCWindowView : UIView

@property (nonatomic, weak) id<RTCWindowViewDelegate>delegate;

@property (nonatomic, assign) RTCWindowState state;

- (instancetype)initWithRTCWindowViewSignalingCall:(BOOL)signalingCall;

@property (nonatomic, strong)  AVAudioPlayer *audioPlayer;/** 播放铃声player */

@property (copy, nonatomic) NSString            *roomID;
@property (copy, nonatomic) NSString            *userID;
@property (copy, nonatomic) NSString            *token;

-(void)signalingCallinfor:(NSDictionary *)data;
- (void)setupRTCEngine;
@end

