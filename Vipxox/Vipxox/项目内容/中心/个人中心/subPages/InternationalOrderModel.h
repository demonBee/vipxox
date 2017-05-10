//
//  InternationalOrderModel.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalOrderModel : NSObject

@property(nonatomic,strong)NSString*order_id;
@property(nonatomic,strong)NSString*logistics_code;
@property(nonatomic,strong)NSString*weight;
@property(nonatomic,strong)NSString*to_country;
@property(nonatomic,strong)NSString*amount_pro;
@property(nonatomic,strong)NSString*status_desc;

@property(nonatomic,strong)NSString*idd;


-(instancetype)initWithShopDict:(NSDictionary*)dict;

@end
