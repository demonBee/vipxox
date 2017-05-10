//
//  TransportOrderModel.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportOrderModel : NSObject
@property(nonatomic,assign)BOOL selectState;   //是否被电击

@property(nonatomic,strong)NSString*order_sn;
@property(nonatomic,strong)NSString*logi_num;
@property(nonatomic,strong)NSString*logi_name;
@property(nonatomic,strong)NSString*pkgprice;
@property(nonatomic,strong)NSString*status;

@property(nonatomic,assign)BOOL accordingPayButton;


-(instancetype)initWithShopDict:(NSDictionary*)dict;

@end
