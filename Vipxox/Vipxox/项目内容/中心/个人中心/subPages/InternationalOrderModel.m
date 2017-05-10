//
//  InternationalOrderModel.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "InternationalOrderModel.h"

@implementation InternationalOrderModel

-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        
        self.order_id=dict[@"order_id"];
        self.logistics_code=dict[@"logistics_code"];
        self.weight=dict[@"weight"];
        self.to_country=dict[@"to_country"];
        self.amount_pro=dict[@"amount_pro"];
        self.status_desc=dict[@"status_desc"];
        
        self.idd=dict[@"id"];
        
    }
    return self;
}

@end
