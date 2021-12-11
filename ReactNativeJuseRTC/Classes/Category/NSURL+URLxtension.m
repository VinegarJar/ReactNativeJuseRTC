//
//  NSURL+URLxtension.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
// NSBundle

#import "NSURL+URLxtension.h"
#import "NSBundle+EXtension.h"
@implementation NSURL (URLxtension)


+ (NSURL *)bundleForMusic:(NSString *)name {
    NSString *music = [NSString stringWithFormat:@"%@.mp3", name];
    return  [[NSBundle getBundleResource]URLForResource:music withExtension:nil];
}


@end
