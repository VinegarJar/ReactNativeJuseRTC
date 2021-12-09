//
//  RTCWindowView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import "RTCWindowView.h"


@interface  RTCWindowView ()<UIGestureRecognizerDelegate>



@end

@implementation RTCWindowView


- (instancetype)initWithRTCWindowViewSignalingCall:(NSDictionary*)data{
    self = [super init];
    if (self) {

        [self xxy_setupSubviewsFloatingWindow];
    }
    return self;
}


- (void)xxy_setupSubviewsFloatingWindow{
    self.backgroundColor = kRGBA(0, 0, 0, .8);
//    self.backgroundColor = [UIColor  whiteColor];
    //添加视图
    [self xxy_setupSubviews];
    //设置手势
    [self xxy_setBaseConfig];
}

- (void)xxy_setupSubviews{

    //切换button
    self.smallScreenButton = [self xxy_floatingWindowViewButton];

    [self.smallScreenButton setImage:[UIImage bundleForImage:@"cut_normal"] forState:UIControlStateNormal];

    self.smallScreenButton.tag = 10000;
    self.smallScreenButton.frame = CGRectMake(kXXYScreenW-50, 30, 50 , 50);
    [self addSubview:self.smallScreenButton];
    

    //拒绝button
    UIImage *refuseBT = [UIImage imageNamed:@"btn_guaduan_normal"];
    self.closeButton = [self xxy_floatingWindowViewButton];
    self.closeButton.tag = 10002;
    [self.closeButton setTitle:@"拒绝" forState:UIControlStateNormal];
//    [self.closeButton setBackgroundImage:refuseBT forState:UIControlStateNormal];
    self.closeButton.frame = CGRectMake(100, 30, 50 , 50 );
    [self addSubview:self.closeButton];
    

    
}

//添加基本手势
- (void)xxy_setBaseConfig{
    //视图点击手势
    UITapGestureRecognizer * callViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xxy_callViewTapHandle:)];
    [self addGestureRecognizer:callViewTap];
    //视图右拖动手势
    UIPanGestureRecognizer *callPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(xxy_swipePanGestureHandle:)];
   callPanGesture.delegate = self;
    [self addGestureRecognizer:callPanGesture];


}



#pragma mark -- Events
//切换视图  全屏或小窗口
- (void)xxy_callViewTapHandle:(UITapGestureRecognizer *)callViewTap{
    if (self.state==RTCWindowFloatingWindow) {
 
        [UIView animateWithDuration:.3f animations:^{
            
            self.frame = kXXYScreenBounds;
            [self xxy_removeSmallButton];
      
        } completion:^(BOOL finished) {
            //点击屏幕 全屏状态 设置小窗口操作按钮
            [self xxy_setupSubviews];
  
            self->_state =  RTCWindowDefault;
        }];
    }else{

        NSLog(@"什么时候触发---------->>>>>进去全屏幕,,,我在屏幕上勒");
        
    }
}


//拖动视图
- (void)xxy_swipePanGestureHandle:(UIPanGestureRecognizer *)recognizer{
    

    

    if (self.state==RTCWindowFloatingWindow) {
        switch (recognizer.state) {
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled :{
                [self endPanPlayerViewWhenWindow];
            }
            break;
            case UIGestureRecognizerStateChanged:{
              
                
                CGPoint translation = [recognizer translationInView:self];
                CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                                recognizer.view.center.y + translation.y);
            // 限制屏幕范围：
                newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
                newCenter.y = MIN([UIApplication sharedApplication].delegate.window.size.height - recognizer.view.frame.size.height/2, newCenter.y);
                newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
                newCenter.x = MIN([UIApplication sharedApplication].delegate.window.size.width - recognizer.view.frame.size.width/2,newCenter.x);
                recognizer.view.center = newCenter;
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
        weakify(self)
        [UIView animateWithDuration:0.3 animations:^{
            __strong typeof(weak_self) strongSelf = weak_self;
            [strongSelf xxy_removeSmallButton];
            
            self.frame = CGRectMake(kXXYScreenW-KWindowDisplayWidth1-20, 20, KWindowDisplayWidth1, KWindowDisplayHeight1);
          
//            [self addSubview:self.smallScreenButton];
            
            self.smallScreenButton = [self xxy_floatingWindowViewButton];
//            self.smallScreenButton.backgroundColor = [UIColor orangeColor];
//            [self.smallScreenButton setTitle:@"切换" forState:UIControlStateNormal];
            [self.smallScreenButton setImage:[UIImage bundleForImage:@"cut_normal"] forState:UIControlStateNormal];
//            UIImage *image = kGetImage(@"btn_-cut_hujiao_normal");
//            [self.smallScreenButton setBackgroundImage:image forState:UIControlStateNormal];
            self.smallScreenButton.tag = 10000;
            self.smallScreenButton.frame = CGRectMake(KWindowDisplayWidth1-50, 30, 50 , 50);
            [self addSubview:self.smallScreenButton];
            
            
        }completion:^(BOOL finished) {

            self->_state = RTCWindowFloatingWindow;
        }];
    }

    if (10002 == button.tag) {//拒绝
        if (self.delegate && [self.delegate respondsToSelector:@selector(xxy_endCallButtonHandle)]) {
            [self.delegate xxy_endCallButtonHandle];
        }
    }
}


//移除小窗口button
- (void)xxy_removeSmallButton{
//    self.smallScreenButton .hidden = YES;
    [self.smallScreenButton removeFromSuperview];
    self.smallScreenButton = nil;
    

    //
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;

}
@end
