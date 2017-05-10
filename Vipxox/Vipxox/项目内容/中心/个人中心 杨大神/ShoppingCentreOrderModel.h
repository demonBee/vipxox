//
//  ShoppingCentreOrderModel.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCentreOrderModel : NSObject

@property(nonatomic,strong)NSString*order_id;
@property(nonatomic,strong)NSString*nums;
@property(nonatomic,strong)NSString*pic;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*freight;
@property(nonatomic,strong)NSString*status;

-(instancetype)initWithShopDict:(NSDictionary*)dict;
@end
