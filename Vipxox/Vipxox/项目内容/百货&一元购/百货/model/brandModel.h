//
//  brandModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface brandModel : NSObject

@property(nonatomic,strong)NSString*brandID;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*logo;
@property(nonatomic,strong)NSString*descriptionn;

@property(nonatomic,strong)NSString*number;   //自己加的品牌下 有多少件商品


@property(nonatomic,strong)NSArray*prolist;    //商品列表
@end
