//
//  DetailHeaderModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailHeaderModel : NSObject
 //创建4个字典对应的key   labelTitle   images    priceLabel     marketLabel

@property(nonatomic,strong)NSString*labelTitle;
@property(nonatomic,strong)NSArray*images;
@property(nonatomic,strong)NSString*priceLabel;
@property(nonatomic,strong)NSString*marketLabel;

@end
