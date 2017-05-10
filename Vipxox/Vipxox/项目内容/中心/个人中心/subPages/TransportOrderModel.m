//
//  TransportOrderModel.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "TransportOrderModel.h"

@implementation TransportOrderModel

-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        
        self.order_sn=dict[@"order_sn"];
        self.logi_num=dict[@"logi_num"];
        self.logi_name=dict[@"logi_name"];
        self.pkgprice=dict[@"pkgprice"];
        self.status=dict[@"status"];
        
        
    }
    return self;
}

@end
