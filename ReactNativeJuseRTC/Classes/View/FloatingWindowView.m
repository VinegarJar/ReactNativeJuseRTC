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




- (instancetype)initWithSignalingCall:(NSDictionary*)data{
    self = [super init];
    if (self) {
        self.callRTCView = [[RTCWindowView alloc] initWithRTCWindowViewSignalingCall:data];
    }
    return self;
}


#pragma mark - 通话视屏初始化SDK
- (void)setupRTCEngine{
    
}


@end
