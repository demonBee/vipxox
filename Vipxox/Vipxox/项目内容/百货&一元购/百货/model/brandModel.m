//
//  brandModel.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "brandModel.h"
#import "goodsModel.h"

@implementation brandModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"brandID":@"id",@"descriptionn":@"description"};
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"prolist":goodsModel.class};
    
}

@end
