//
//  FloatingWindowView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import "FloatingWindowView.h"

@interface FloatingWindowView ()

@end


@implementation FloatingWindowView


- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startCallWithSignaling:(BOOL)signalingCall{
     self.callRTCView = [[RTCWindowView alloc] initWithRTCWindowViewSignalingCall:signalingCall];
    //通话视屏初始化SDK
    [self.callRTCView setupRTCEngine];
}


@end
