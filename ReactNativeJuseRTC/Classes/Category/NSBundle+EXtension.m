//
//  NSBundle+EXtension.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/11.
//

#import "NSBundle+EXtension.h"

@implementation NSBundle (EXtension)

+(NSBundle*)getBundleResource{
    
    //直接读取ReactNativeJuseRTC
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"ReactNativeJuseRTC"  withExtension:@"bundle"];
    if (associateBundleURL) {
        associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
        NSAssert(associateBundleURL, @"取不到关联BundleURL");
        return [NSBundle bundleWithURL:associateBundleURL];
    }

    //第二种方式读取
    NSURL *bundlePath = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    bundlePath = [[bundlePath URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
    bundlePath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
    bundlePath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"RCTResource" withExtension:@"bundle"];
    NSAssert(bundlePath, @"取不到关联bundle");
    return bundlePath?[NSBundle bundleWithURL:bundlePath]:nil;
}



+(NSBundle*)getBundleResourceURL{
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    associateBundleURL = [[associateBundleURL URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
    associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
   associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:associateBundleURL];
}


@end
