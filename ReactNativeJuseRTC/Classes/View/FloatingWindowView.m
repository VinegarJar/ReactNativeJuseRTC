//
//  FloatingWindowView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import "FloatingWindowView.h"


@interface FloatingWindowView ()<RTCWindowViewDelegate>

@end


@implementation FloatingWindowView




- (instancetype)initWithSignalingCall:(NSDictionary*)data {
    self = [super init];
    if (self) {
        
        self.callManagerView = [[RTCWindowView alloc] initWithRTCWindowViewSignalingCall:data];
        self.callManagerView.delegate = self;
      
    }
    return self;
}


//挂断或者拒接
- (void)xxy_endCallButtonHandle{
    if (self.delegate && [self.delegate respondsToSelector:@selector(xxy_endCallButtonOperation)]) {
        [self.delegate xxy_endCallButtonOperation];
    }
}



#pragma mark - 通话 视屏 ...操作
- (void)xxy_startCallManagerWithNumbers{
    
}

@end
