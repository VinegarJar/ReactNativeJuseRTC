//
//  RTCAlertView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//

#import "RTCAlertView.h"
#import "Reachability.h"
#import "Config.h"

@interface RTCAlertView ()
@property (strong, nonatomic) UIView*tipsView;
@property (strong, nonatomic) UIView *alertView;
@end


@implementation RTCAlertView

- (instancetype)initWithAlertView
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self addSubviews];
      
    }
    return self;
}



- (void)addSubviews{
    
    _tipsView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_tipsView];
    _tipsView.backgroundColor = [UIColor blackColor];
    _tipsView.alpha = 0.5;
    
    
    //创建提示框view
    _alertView = [[UIView alloc] init];
    _alertView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    //设置圆角半径
    _alertView.layer.cornerRadius = 6.0;
    [self addSubview:_alertView];
    _alertView.center = _tipsView.center;
    _alertView.bounds = CGRectMake(0, 0, ScreenBounds.size.width * 0.75, ScreenBounds.size.width * 0.75 * 3/ 4);
    
    //创建操作提示 label
    UILabel * label = [[UILabel alloc] init];
    [_alertView addSubview:label];
    label.text = @"提示";
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:8/255.0 green:121/255.0 blue:245/255.0 alpha:1];
    CGFloat lblWidth = _alertView.bounds.size.width;
    CGFloat lblHigth = 22;
    label.frame = CGRectMake(0, 30, lblWidth, lblHigth);
    
    //创建message label
    UILabel * lblMessage = [[UILabel alloc] init];
    lblMessage.textColor = [UIColor colorWithRed:27/255.0 green:28/255.0 blue:51/255.0 alpha:1];
    [_alertView addSubview:lblMessage];
    lblMessage.text = @"在移动网络环境下会影响视频通话质量，并产生手机流量，你确实继续吗？";
    lblMessage.font = [UIFont systemFontOfSize:16];
    lblMessage.textAlignment = 0;
    lblMessage.numberOfLines = 4; //最多显示两行Message
    CGFloat margin = 10;
    CGFloat msgX = margin;
    CGFloat msgY = lblHigth + 40;
    CGFloat msgW = _alertView.bounds.size.width - 2 * margin;
    CGFloat msgH = 64;
    lblMessage.frame = CGRectMake(msgX, msgY, msgW, msgH);
    
    //创建确定 取消按钮
    CGFloat buttonWidth = (_alertView.bounds.size.width - 4 * margin) * 0.5;
    CGFloat buttonHigth = 36;
    UIButton * btnCancel = [[UIButton alloc] init];
    [_alertView addSubview:btnCancel];
    [btnCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(margin, _alertView.bounds.size.height - margin - buttonHigth - 20, buttonWidth, buttonHigth);
    btnCancel.layer.borderWidth =  0.5f;
    btnCancel.layer.borderColor =  [UIColor grayColor].CGColor;
    btnCancel.layer.cornerRadius = buttonHigth/2;
    btnCancel.tag = 0;
    [btnCancel addTarget:self action:@selector(cancelClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    //确定按钮
    UIButton * btnConfirm = [[UIButton alloc] init];
    btnConfirm.tag = 1;
    [_alertView addSubview:btnConfirm];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setTitle:@"继续" forState:UIControlStateNormal];
    [btnConfirm setBackgroundColor:[UIColor colorWithRed:8/255.0 green:121/255.0 blue:245/255.0 alpha:1]];
    btnConfirm.frame = CGRectMake(_alertView.bounds.size.width - margin - buttonWidth, _alertView.bounds.size.height - margin - buttonHigth - 20, buttonWidth, buttonHigth);
    btnConfirm.layer.cornerRadius = buttonHigth/2;
    btnConfirm.layer.masksToBounds = YES;
    [btnConfirm addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
}



/** 点击确定 or 取消触发事件 */
-(void)didClickBtnConfirm:(UIButton *)sender{

    [self removeSubviews];
}

-(void)cancelClickBtnConfirm:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelCallHandle)]) {
        [self.delegate cancelCallHandle];
    }
    [self removeSubviews];
}


-(void)removeSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self  removeFromSuperview];
}

@end
