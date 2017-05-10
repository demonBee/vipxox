//
//  cloudModel.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "cloudModel.h"

@implementation cloudModel

-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        
        
        self.attr_desc=dict[@"attr_desc"];
        self.idd=dict[@"id"];
        self.num=dict[@"num"];
        self.order_id=dict[@"order_id"];
        self.price=dict[@"price"];
        self.pro_pic=dict[@"pro_pic"];
        self.pro_url=dict[@"pro_url"];
        self.s_type=dict[@"s_type"];

        self.status=dict[@"status"];
        self.title=dict[@"title"];
        self.volume=dict[@"volume"];
        self.weight=dict[@"weight"];
        
        
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
