//
//  DetailCommitModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailCommitModel : NSObject
// 旧版  userimg user con  score  attr create_time  没有 赞字段 多了个属性字段
@property(nonatomic,strong)NSString*userimg;
@property(nonatomic,strong)NSString*user;
@property(nonatomic,strong)NSString*con;
@property(nonatomic,strong)NSString*score;
@property(nonatomic,strong)NSString*create_time;

@property(nonatomic,strong)NSString*zan;
@property(nonatomic,strong)NSString*attr;
@property(nonatomic,strong)NSString*idd;


@end
