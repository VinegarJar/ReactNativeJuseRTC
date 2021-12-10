//
//  RTCWindowView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import "RTCWindowView.h"
#import "Reachability.h"
#import "RTCAlertView.h"
#import "RTCButtonView.h"
@interface  RTCWindowView ()<UIGestureRecognizerDelegate,RTCAlertViewDelegate>

@property (nonatomic, strong) UIButton *smallScreenButton;
@property (nonatomic, strong) UIButton *closeButton;



//被呼叫or呼叫
@property (assign, nonatomic) BOOL  signalingCall;
/** 未接通时背景视图 */
@property (strong, nonatomic)UIImageView  *bgImageView;
/** 对方头像图片 */
@property (strong, nonatomic)UIImageView *avaImage;

/** 底部按钮容器视图 */
@property (strong, nonatomic) RTCButtonView *btnContainerView;
@end


@implementation RTCWindowView



- (instancetype)initWithRTCWindowViewSignalingCall:(BOOL)signalingCall{
    self = [super init];
    if (self) {
        _signalingCall = signalingCall;
        [self initWithsubviewsfloatingWindow];
    }
    return self;
}


//添加基本手势
- (void)addGestureToWindowView{
    //视图点击手势
    UITapGestureRecognizer * callViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callViewTapHandle:)];
    [self addGestureRecognizer:callViewTap];
    //视图右拖动手势
    UIPanGestureRecognizer *callPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandle:)];
   callPanGesture.delegate = self;
    [self addGestureRecognizer:callPanGesture];

}


-(void)initWithsubviewsfloatingWindow{
    self.backgroundColor = kRGBA(0, 0, 0, .8);
//    self.backgroundColor = [UIColor whiteColor];
    [self addSubviews];
    [self addGestureToWindowView];
}



- (void)addSubviews{

    //切换button
    self.smallScreenButton = [self xxy_floatingWindowViewButton];

    [self.smallScreenButton setImage:[UIImage bundleForImage:@"cut_normal"] forState:UIControlStateNormal];

    self.smallScreenButton.tag = 10000;
    self.smallScreenButton.frame = CGRectMake(50, 30, 50 , 50);
    [self addSubview:self.smallScreenButton];
    


    
    
    if (_signalingCall) { // 视频通话时,被呼叫UI初始化
        if ([self internetStatus]) {
            RTCAlertView *alertVie = [[ RTCAlertView alloc]initWithAlertView];
            alertVie.delegate = self;
            [self addSubview:alertVie];
        }
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(50, 300, 100, 100);
        [self addSubview:effectView];
    }else{ // 视频通话时,呼叫UI初始化
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
//          self->_portraitImageView.transform = CGAffineTransformIdentity;
//          self->_nickNameLabel.transform = CGAffineTransformIdentity;
//          self->_connectLabel.transform = CGAffineTransformIdentity;
//          self->_swichBtn.transform = CGAffineTransformIdentity;
          self->_btnContainerView.transform = CGAffineTransformIdentity;
        [self addSubview:self.btnContainerView];
        }];
    }];
   
}


//小窗口全部视图隐藏
-(void)hide{
    self.btnContainerView.hidden = YES;
}

-(void)show{
    self.btnContainerView.hidden = NO;
}


//底部按钮视图区域
- (RTCButtonView *)btnContainerView{
    if (!_btnContainerView) {
        _btnContainerView = [[RTCButtonView alloc]initWithFrame:CGRectMake(0, ScreenH-ContainerH, ScreenW, ContainerH) signaCall:_signalingCall];
        [_btnContainerView.swichBtn addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView.hangupBtn addTarget:self action:@selector(hangupClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView.answerBtn addTarget:self action:@selector(answerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnContainerView;
}


#pragma mark -- RTCButton点击事件
// 切换前后摄像头
- (void)switchClick{
     [NERtcEngine.sharedEngine switchCamera];
}

//挂断视频通话或者拒接
- (void)hangupClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endCallButtonHandle)]) {
        [self.delegate endCallButtonHandle];
    }
}

//接听视频通话操作
- (void)answerClick{
    _btnContainerView.swichBtn.hidden = NO;
    [_btnContainerView.answerBtn removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        [self->_btnContainerView setHangupBtnframe];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
          self->_btnContainerView.hangupBtn.transform = CGAffineTransformIdentity;

        }];
    }];
}


#pragma mark -- Events
//切换视图  全屏或小窗口
- (void)callViewTapHandle:(UITapGestureRecognizer *)callViewTap{
    if (self->_state==RTCWindowFloatingWindow) {
 
        [UIView animateWithDuration:.3f animations:^{
            
            self.frame = ScreenBounds;
        } completion:^(BOOL finished) {
            //点击屏幕 全屏状态 设置小窗口操作按钮
            [self show];
            self->_state =  RTCWindowDefault;
        }];
    }else{

        NSLog(@"什么时候触发---------->>>>>进去全屏幕,,,我在屏幕上勒");
//        [self.audioPlayer play];
        
    }
}


//拖动视图
- (void)swipePanGestureHandle:(UIPanGestureRecognizer *)recognizer{
    

    
    if (self->_state==RTCWindowFloatingWindow) {
        switch (recognizer.state) {
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled :{
                [self endPanPlayerViewWhenWindow];
            }
            break;
            case UIGestureRecognizerStateChanged:{
              
                
                CGPoint translation = [recognizer translationInView:self];
                CGPoint center = CGPointMake(recognizer.view.center.x+ translation.x,
                             recognizer.view.center.y + translation.y);
               //限制屏幕范围：
                center.y = MAX(recognizer.view.frame.size.height/2, center.y);
                center.y = MIN([UIApplication sharedApplication].delegate.window.size.height - recognizer.view.frame.size.height/2, center.y);
                center.x = MAX(recognizer.view.frame.size.width/2, center.x);
                center.x = MIN([UIApplication sharedApplication].delegate.window.size.width - recognizer.view.frame.size.width/2,center.x);
                recognizer.view.center = center;
                [recognizer setTranslation:CGPointZero inView:[UIApplication sharedApplication].delegate.window];
                
            }
            break;
            default:
            break;
        }
    }else{
        NSLog(@"------全屏幕窗口-------");
    }
      
   
    
}




- (void)endPanPlayerViewWhenWindow{

    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = self.center;
        self.center = center;
    }];
    
}


- (UIButton *)xxy_floatingWindowViewButton{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(xxy_floatingWindowButtonWithSender:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)xxy_floatingWindowButtonWithSender:(UIButton *)sender{
    UIButton * button = sender;

    if (10000 == button.tag) {
//        weakify(self)
        [UIView animateWithDuration:0.3 animations:^{
//            __strong typeof(weak_self) strongSelf = weak_self;

            [self hide];
            self.frame = CGRectMake(ScreenW-WindowDisplayWidth-20, 20, WindowDisplayWidth, WindowDisplayHeight);
          
        }completion:^(BOOL finished) {

            self->_state = RTCWindowFloatingWindow;
     
        }];
    }

    if (10002 == button.tag) {//拒绝
        if (self.delegate && [self.delegate respondsToSelector:@selector(endCallButtonHandle)]) {
            [self.delegate endCallButtonHandle];
        }
    }
}





-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        // 1. 获取资源URL
        // 2. 根据资源URL, 创建 AVAudioPlayer 对象
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL bundleForMusic:@"avchat_ring"] error:nil];
        _audioPlayer.numberOfLoops = -1;
        //3. 准备播放(音乐播放的内存空间的开辟等功能)  不写这行代码直接播放也会默认调用prepareToPlay
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}


//呼叫信息设置显示
-(void)signalingCallinfor:(NSDictionary *)data{
    
    
}


//获取网络状态
-(BOOL)internetStatus {
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    BOOL net = YES;
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = NO;
            break;
            
        case ReachableViaWWAN:
             net = YES;
            //net = [self getNetType ];   //判断具体类型
            break;
            
        case NotReachable:
            net = YES;
        default:
            break;
    }
 
    return net;
    
}

//提示框上取消视频通话功能
-(void)cancelCallHandle{
    
}

@end
