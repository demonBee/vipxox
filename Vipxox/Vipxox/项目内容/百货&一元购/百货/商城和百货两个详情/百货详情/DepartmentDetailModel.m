//
//  DepartmentDetailModel.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentDetailModel.h"
#import "goodsModel.h"

@implementation DepartmentDetailModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"detailID":@"id"};
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"tuijian":goodsModel.class};
    
}

@end
