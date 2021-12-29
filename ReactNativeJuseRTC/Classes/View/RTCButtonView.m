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
    [self addSubview:self.timerLabel];
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

//接听操作,显示切换按钮,倒计时
-(void)removeAnswerButton{
    _swichBtn.hidden = NO;
    _timerLabel.hidden = NO;
    [_answerBtn removeFromSuperview];
}


-(void)replaceHangupButtonframe{
    CGFloat paddingX =  (self.frame.size.width - RTCViewWidth) / 2;
    CGFloat paddingY = [self getpaddingY];
    _hangupBtn.frame = CGRectMake(paddingX, paddingY, RTCViewWidth, RTCViewHeight);
    _hangupBtn.title.text = @"挂断";
}

- (UILabel*)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.text = @"00:00";
        _timerLabel.font = [UIFont systemFontOfSize:17.0f];
        _timerLabel.textColor = [UIColor whiteColor];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat paddingX =  (self.frame.size.width - RTCViewWidth) / 2;
        CGFloat paddingY = [self getpaddingY];
        _timerLabel.frame = CGRectMake(paddingX, paddingY-RTCTextHeight-5, RTCViewWidth, RTCTextHeight);
        _timerLabel.hidden = YES;
    }
    return _timerLabel;
}

-(void)startTimers{
    //计时器
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(start:) userInfo:nil repeats:YES];
    //放在主运行----(主要是解决在界面上进行的其它操作导致计时器停止的问题)
    [[NSRunLoop mainRunLoop] addTimer:self->_myTimer forMode:NSDefaultRunLoopMode];
}


//计时器计数
-(void)start:(NSTimer *)timer{
    _seconds ++;
    NSString *str = [self getMMSSFromSS:[NSString stringWithFormat:@"%ds",_seconds]];
    _timerLabel.text = [NSString stringWithString:str];
}


-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
      //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}


@end
