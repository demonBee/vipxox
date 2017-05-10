//
//  DepartmentOrderShoppingModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmentOrderShoppingModel : NSObject

//@property(nonatomic,strong)NSString*idd;
@property(nonatomic,strong)NSString*pid;    // 存的时候 key  用id
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*pic;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*num;
@property(nonatomic,strong)NSString*attr_options;     //商品属性
@property(nonatomic,strong)NSString*pingjia;  //未评价


@end
