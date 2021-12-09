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

/**
  屏幕窗口状态
 -  FloatWindowViewDefaultt: 默认
 -  FloatWindowViewFloatingWindow: 小窗口
 */

//
typedef NS_ENUM(NSInteger, RTCWindowState) {
    RTCWindowDefault = 0,
    RTCWindowFloatingWindow = 1
};


@protocol RTCWindowViewDelegate <NSObject>



- (void)xxy_endCallButtonHandle;


@end


@interface RTCWindowView : UIView

@property (nonatomic, weak) id<RTCWindowViewDelegate>delegate;

@property (nonatomic, assign) RTCWindowState state;
//操作superview
@property (nonatomic, strong) UIView *superConcentView;

//小窗口button
@property (nonatomic, strong) UIButton *smallScreenButton;

//结束按钮
@property (nonatomic, strong) UIButton *closeButton;

- (instancetype)initWithRTCWindowViewSignalingCall:(NSDictionary*)data;


@end

