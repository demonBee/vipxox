//
//  BuyOrderModel.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "BuyOrderModel.h"

@implementation BuyOrderModel

-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        
        
        self.mall_logo=dict[@"mall_logo"];
        self.order_id=dict[@"order_id"];
        self.pro_pic=dict[@"pro_pic"];
        self.title=dict[@"title"];
        self.price=dict[@"price"];
        self.num=dict[@"num"];
        self.attr_desc=dict[@"attr_desc"];
        self.allprice=dict[@"allprice"];
        self.status=dict[@"status"];
        
        self.idd=dict[@"id"];
        
    }
    return self;
}

@end
