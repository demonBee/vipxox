//
//  HttpObject.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "HttpObject.h"

@implementation HttpObject

+ (id)manager
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static HttpObject *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}


- (void)postDataWithType:(kOnePayType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
        case OnePayType_Home:
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,HTTP_ONEPAY_HOME];
            break;
        case OnePayType_SHOP_DETAIL:
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,HTTP_ONEPAY_SHOP_DETAIL];
            break;
        case OnePayType_LIST:
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,HTTP_ONEPAY_LIST];
            break;
        case OnePayType_GETPRIZE:
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,HTTP_ONEPAY_GETPRIZE];
            break;
            //URLStr建立
        default:
            break;
    }

//    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpManager * manager= [[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:pragram compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]||[data[@"errorMessage"] isEqualToString:@"操作成功"]) {
            success(data);
        }else{
            fail(error);
        }
        
    }];


}

- (void)getDataWithType:(kOnePayType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
        case OnePayType_SHOP_PAY:
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,HTTP_ONEPAY_SHOP_PAY];
            break;
        case OnePayType_GETPRIZE:
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,HTTP_ONEPAY_GETPRIZE];
            break;
        //URLStr建立
        default:
            break;
    }
    
    HttpManager * manager= [[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:pragram compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]||[data[@"errorMessage"] isEqualToString:@"操作成功"]) {
            success(data);
        }else{
            fail(data,error);
        }
        
    }];
}

@end
