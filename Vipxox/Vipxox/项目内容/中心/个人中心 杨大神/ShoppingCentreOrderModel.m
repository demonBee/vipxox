//
//  ShoppingCentreOrderModel.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShoppingCentreOrderModel.h"

@implementation ShoppingCentreOrderModel


-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        
        self.order_id=dict[@"order_id"];
        self.nums=dict[@"nums"];
        self.pic=dict[@"pic"];
        self.price=dict[@"price"];
        self.freight=dict[@"freight"];
        self.status=dict[@"status"];
    }
    return self;
}
@end
