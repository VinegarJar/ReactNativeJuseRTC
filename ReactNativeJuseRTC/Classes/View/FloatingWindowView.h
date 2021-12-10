//
//  FloatingWindowView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import <Foundation/Foundation.h>
#import "RTCWindowView.h"

NS_ASSUME_NONNULL_BEGIN


@interface FloatingWindowView : NSObject

//通话视图管理view
@property (nonatomic, strong) RTCWindowView *callRTCView;


- (instancetype)initWithSignalingCall:(BOOL)signalingCall;

- (void)setupRTCEngine;


@end

NS_ASSUME_NONNULL_END
