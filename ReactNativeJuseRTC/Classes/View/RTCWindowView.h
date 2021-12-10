//
//  RTCWindowView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import <UIKit/UIKit.h>
#import "UIView+XXYViewFrame.h"
#import "UIImage+TExtension.h"
#import "Config.h"
#import <NERtcSDK/NERtcSDK.h>
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

- (instancetype)initWithRTCWindowViewSignalingCall:(NSDictionary*)data;

@property (nonatomic, strong)  AVAudioPlayer *audioPlayer;/** 播放铃声player */




@end

