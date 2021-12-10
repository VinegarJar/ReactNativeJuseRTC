//
//  NSURL+URLxtension.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//

#import "NSURL+URLxtension.h"

@implementation NSURL (URLxtension)

+(NSBundle*)getBundleResource{
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    associateBundleURL = [[associateBundleURL URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
    associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
   associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
   return [NSBundle bundleWithURL:associateBundleURL];
}


+ (NSURL *)bundleForMusic:(NSString *)name {
    NSString *music = [NSString stringWithFormat:@"%@.mp3", name];
    return  [[self getBundleResource]URLForResource:music withExtension:nil];
}


@end
