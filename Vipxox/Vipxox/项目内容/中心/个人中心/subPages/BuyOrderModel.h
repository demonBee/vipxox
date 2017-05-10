//
//  BuyOrderModel.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyOrderModel : NSObject

@property(nonatomic,strong)NSString*mall_logo;
@property(nonatomic,strong)NSString*order_id;
@property(nonatomic,strong)NSString*pro_pic;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*num;
@property(nonatomic,strong)NSString*attr_desc;
@property(nonatomic,strong)NSString*allprice;
@property(nonatomic,strong)NSString*status;

@property(nonatomic,strong)NSString*idd;


-(instancetype)initWithShopDict:(NSDictionary*)dict;
@end
