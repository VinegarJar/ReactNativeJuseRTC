//
//  JCViewController.m
//  ReactNativeJuseRTC
//
//  Created by 15885460 on 12/08/2021.
//  Copyright (c) 2021 15885460. All rights reserved.
//

#import "JCViewController.h"
#import "FloatingWindowUtil.h"

@interface JCViewController ()

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(100, 100, 100, 100);
//    button.titleLabel.text = @"跳转视频通话";
    [ button  setTitle:@"跳转视频通话"  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchesButtonWithSender:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    

}

- (void)touchesButtonWithSender:(UIButton *)sender{
   
    [[FloatingWindowUtil shareInstance] startSignalingCall:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
