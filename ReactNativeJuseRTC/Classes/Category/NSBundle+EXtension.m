//
//  NSBundle+EXtension.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/11.
//

#import "NSBundle+EXtension.h"

@implementation NSBundle (EXtension)

+(NSBundle*)getBundleResource{
    
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"ReactNativeJuseRTC"  withExtension:@"bundle"];
    if (associateBundleURL) {
        associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
        return [NSBundle bundleWithURL:associateBundleURL];
    }
    
    NSURL *doctorURL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    doctorURL = [associateBundleURL URLByAppendingPathComponent:@"ReactNativeJuseRTC"];
    doctorURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
    doctorURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:doctorURL];
}



+(NSBundle*)getBundleResourceURL{
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    associateBundleURL = [[associateBundleURL URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
    associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
   associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:associateBundleURL];
}


@end
