//
//  ShoppingModel.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShoppingModel.h"

@implementation ShoppingModel

-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {

        self.selectState=[dict[@"selectState"]boolValue];   //是否被点中
        
        self.idd=dict[@"id"];
        self.num=dict[@"num"];
        self.title=dict[@"title"];
        self.price=dict[@"price"];
        self.pro_pic=dict[@"pro_pic"];
        self.attr_desc=dict[@"attr_desc"];
        self.s_type=dict[@"s_type"];
        self.sku_id=dict[@"sku_id"];
        self.freight_price=dict[@"freight_price"];
        self.kx=dict[@"kx"];
        self.pz=dict[@"pz"];
        self.qd=dict[@"qd"];
        self.f_address=dict[@"f_address"];
        self.s_time=dict[@"s_time"];
        self.pro_url=dict[@"pro_url"];
        self.pid=dict[@"pid"];
        
        
        
        
        
        
        
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
