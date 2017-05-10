//
//  DepartmentOrderModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepartmentOrderShoppingModel.h"

@interface DepartmentOrderModel : NSObject

@property(nonatomic,strong)NSString*idd;
@property(nonatomic,strong)NSString*order_id;     //订单号
@property(nonatomic,strong)NSString*status_str;   //待发货
@property(nonatomic,strong)NSString*product_num;  //多少件商品
@property(nonatomic,strong)NSString*product_price;   //多少钱

@property(nonatomic,strong)NSArray*product_list;

@end
