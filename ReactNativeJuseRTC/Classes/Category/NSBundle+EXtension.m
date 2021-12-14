//
//  NSBundle+EXtension.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/11.
//

#import "NSBundle+EXtension.h"

@implementation NSBundle (EXtension)

+(NSBundle*)getBundleResource{
    
    
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    if (associateBundleURL) {
        associateBundleURL = [[associateBundleURL URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
        associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
       associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];

        if (associateBundleURL) {
            return [NSBundle bundleWithURL:associateBundleURL];
        }
    }
 
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RCTResource" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
  
}


@end
