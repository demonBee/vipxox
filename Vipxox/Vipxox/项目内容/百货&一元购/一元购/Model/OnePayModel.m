//
//  OnePayModel.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayModel.h"

@implementation OnePayModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"adv":[OnePayAdvModel class],@"shop":[OnePayShopModel class],@"announced":[OnePayAnnouncedModel class]};
}

@end
