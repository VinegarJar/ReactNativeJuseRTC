//
//  RTCButtonView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//

#import "RTCButtonView.h"

@implementation RTCButtonView



- (instancetype)initWithFrame:(CGRect)frame signaCall:(BOOL)signaCall
{
    self = [super initWithFrame:frame];
    if (self) {
        _signaCall = signaCall;
        [self addSubviews];
    }
    return self;
}



-(void)addSubviews{
    
    [self addSubview:self.hangupBtn];
    if (_signaCall) {
        [self addSubview:self.answerBtn];
    }
    [self addSubview:self.swichBtn];
}

- (RTCButton *)swichBtn{
    if (!_swichBtn) {
        _swichBtn = [[RTCButton alloc]initWithTitle:@"切换" imageName:@"switch"];
        CGFloat paddingX = [self getpaddingX];
        CGFloat paddingY = [self getpaddingY];
        _swichBtn.frame = CGRectMake(paddingX * 3, paddingY, RTCViewWidth, RTCViewHeight);
        _swichBtn.hidden = YES;
    }
    return _swichBtn;
}

- (RTCButton *)hangupBtn{
    if (!_hangupBtn) {
        if (_signaCall) {
            _hangupBtn = [[RTCButton alloc] initWithTitle:@"拒绝" imageName:@"hangup"];
        } else {
            _hangupBtn = [[RTCButton alloc] initWithTitle:@"取消" imageName:@"hangup"];
        }
        CGFloat paddingX;
        if (_signaCall) {
            paddingX = [self getpaddingX];
        }else{
            paddingX =  (self.frame.size.width - RTCViewWidth) / 2;
        }
        
        CGFloat paddingY = [self getpaddingY];
        _hangupBtn.frame = CGRectMake(paddingX, paddingY, RTCViewWidth, RTCViewHeight);
    }
    return _hangupBtn;
}


- (RTCButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [[RTCButton alloc] initWithTitle:@"接听" imageName:@"answer"];
        CGFloat paddingX = [self getpaddingX];
        CGFloat paddingY = [self getpaddingY];
        _answerBtn.frame = CGRectMake(paddingX * 2 + RTCViewWidth, paddingY,RTCViewWidth, RTCViewHeight);
    }
    return _answerBtn;
}

-(CGFloat )getpaddingX{
    return (ScreenW -RTCViewWidth * 2) / 3;
}

-(CGFloat )getpaddingY{
    return (ContainerH - RTCViewWidth) / 3;
}


-(void)setHangupBtnframe{
    CGFloat paddingX =  (self.frame.size.width - RTCViewWidth) / 2;
    CGFloat paddingY = [self getpaddingY];
    _hangupBtn.frame = CGRectMake(paddingX, paddingY, RTCViewWidth, RTCViewHeight);
}

@end
