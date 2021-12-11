//
//  RTCButton.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//

#import "RTCButton.h"

@implementation RTCButton


- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)noHandleImageName{
    self = [super init];
    if (self) {
        [self.button setImage:[UIImage bundleForImage:noHandleImageName] forState:UIControlStateNormal];
        [self.title setText:title];
    }
    return self;
}


-(UILabel*)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15.0f];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.frame = CGRectMake(0, 5+RTCBtnWidth, RTCBtnWidth, RTCTextHeight);
        [self addSubview:_title];
    }
    return  _title;
}


- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor clearColor];
        _button.frame =  CGRectMake(0, 0, RTCBtnWidth,  RTCBtnWidth);
        [self addSubview:_button];
    }
    return _button;
}


@end
