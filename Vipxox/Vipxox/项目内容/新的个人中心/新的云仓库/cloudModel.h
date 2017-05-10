//
//  cloudModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cloudModel : NSObject
@property(nonatomic,assign)BOOL selectState;   //是否被电击

@property(nonatomic,strong)NSString*attr_desc;
@property(nonatomic,strong)NSString*idd;
@property(nonatomic,strong)NSString*num;
@property(nonatomic,strong)NSString*order_id;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*pro_pic;
@property(nonatomic,strong)NSString*pro_url;
@property(nonatomic,strong)NSString*s_type;
@property(nonatomic,strong)NSString*status;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*volume;
@property(nonatomic,strong)NSString*weight;


@property(nonatomic,assign)BOOL isSelected;   //选中和不选中

-(instancetype)initWithShopDict:(NSDictionary*)dict;
@end
