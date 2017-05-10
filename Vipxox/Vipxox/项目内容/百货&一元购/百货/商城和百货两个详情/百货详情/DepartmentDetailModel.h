//
//  DepartmentDetailModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "brandModel.h"

@interface DepartmentDetailModel : NSObject

@property(nonatomic,strong)NSString*detailID;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*market_price;

@property(nonatomic,strong)NSString*pic;
@property(nonatomic,strong)NSArray*pic_more;    //图片的数组
@property(nonatomic,strong)brandModel*brand;
@property(nonatomic,strong)NSDictionary*dianping;
@property(nonatomic,strong)NSArray*tuijian;



@end
