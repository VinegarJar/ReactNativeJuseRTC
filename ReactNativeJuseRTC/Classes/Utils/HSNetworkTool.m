//
//  HSNetworkTool.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/9.
//

#import "HSNetworkTool.h"
#import "FloatingWindowUtil.h"

@implementation HSNetworkTool

+ (instancetype)shareInstance
{
    static HSNetworkTool *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HSNetworkTool alloc] init];
        [_sharedInstance configure];
    });
    return _sharedInstance;
}

- (void)configure{
  if(self.requestURL == nil){
    self.requestURL = @"https://m.gooeto120.com/API/user";
  }
}

- (void)requestHTTPMethod:(NSString *)httpMenthod relativePath:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
  if([httpMenthod  isEqual: @"GET"]){
    
    NSMutableString *paramsString = [[NSMutableString alloc] initWithCapacity:0];
    for (int i=0;i<[params allKeys].count;i++) {
        NSString *key = [[params allKeys] objectAtIndex:i];
        [paramsString appendString:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
        if (i < [params allKeys].count-1) {
            [paramsString appendString:@"&"];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.requestURL, relativePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = httpMenthod;
    request.HTTPBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
  
    NSLog(@"%@",request.HTTPBody);
  
     //添加header
    NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    /*
      Authorization: `Bearer ${doctor || ''}`,
           Accept: 'application/json',
           'Content-Type': 'application/json',
           Connection: 'close',
           type: 'getUserData',
           version: $config.juseVersion,
           appType: 'GYTJK',
           phoneType: Platform.OS.toLowerCase(),
    */
  
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
          [mutableRequest setValue:[@"Bearer " stringByAppendingString:token] forHTTPHeaderField:@"Authorization"];
    }
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"close" forHTTPHeaderField:@"Connection"];
    [mutableRequest addValue:@"getUserData" forHTTPHeaderField:@"type"];
    [mutableRequest addValue:@"1.7.0" forHTTPHeaderField:@"version"];
    [mutableRequest addValue:@"GYTJK" forHTTPHeaderField:@"appType"];
    [mutableRequest addValue:@"iOS" forHTTPHeaderField:@"phoneType"];

    request = [mutableRequest copy];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                successBlock(responseObject);
            }
        } else {
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
    
  }else {
    
    //使用苹果自带的类NSJSONSerialization生成json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
  
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
  
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.requestURL, relativePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = httpMenthod;

    [request setHTTPMethod:@"POST"];

    [request setHTTPBody:tempJsonData];

    NSLog(@"%@",request.HTTPBody);
  
     //添加header
    NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    /*
      Authorization: `Bearer ${doctor || ''}`,
           Accept: 'application/json',
           'Content-Type': 'application/json',
           Connection: 'close',
           type: 'getUserData',
           version: $config.juseVersion,
           appType: 'GYTJK',
           phoneType: Platform.OS.toLowerCase(),
    */
  
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
         [mutableRequest setValue:[@"Bearer " stringByAppendingString:token] forHTTPHeaderField:@"Authorization"];
    }
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"close" forHTTPHeaderField:@"Connection"];
    [mutableRequest addValue:@"getUserData" forHTTPHeaderField:@"type"];
    [mutableRequest addValue:@"1.7.0" forHTTPHeaderField:@"version"];
    [mutableRequest addValue:@"GYTJK" forHTTPHeaderField:@"appType"];
    [mutableRequest addValue:@"iOS" forHTTPHeaderField:@"phoneType"];

    request = [mutableRequest copy];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                successBlock(responseObject);
            }
        } else {
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
    
    
  }
   
}

- (void)requestGET:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    [self requestHTTPMethod:@"GET" relativePath:relativePath params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (successBlock) {
            return successBlock(responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (failBlock) {
            return failBlock(error);
        }
    }];
}

- (void)requestPOST:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    [self requestHTTPMethod:@"POST" relativePath:relativePath params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
      
        if (successBlock) {
            return successBlock(responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (failBlock) {
            return failBlock(error);
        }
    }];
}

- (void)requestJsonPost:(NSString *)relativePath params:(NSDictionary *)params successBlock:(HSResponseSuccessBlock)successBlock failBlock:(HSResponseFailBlock)failBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.requestURL, relativePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                successBlock(responseObject);
            }
        } else {
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
}
@end
