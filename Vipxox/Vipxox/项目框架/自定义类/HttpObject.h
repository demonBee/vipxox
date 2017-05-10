//
//  HttpObject.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum OnePayType{
    OnePayType_Home,//一元购商城首页
    OnePayType_SHOP_DETAIL,//一元购商品详情
    OnePayType_SHOP_PAY,//一元商品一元购买
    OnePayType_LIST,//一元购夺宝列表
    OnePayType_GETPRIZE,//一元购中奖这添加地址
}kOnePayType;

@interface HttpObject : NSObject

#pragma mark - 单例
+ (id)manager;

//POST请求
- (void)postDataWithType:(kOnePayType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(NSError *error))fail;

//GET请求
- (void)getDataWithType:(kOnePayType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

@end
