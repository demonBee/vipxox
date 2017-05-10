//
//  DepartmentOrderModel.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentOrderModel.h"



@implementation DepartmentOrderModel


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"idd":@"id"};
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"product_list":[DepartmentOrderShoppingModel class]};
    
}

@end
