//
//  OneYuanModel.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneYuanModel : NSObject

@property (nonatomic,copy)NSString * oneYuanID;
@property (nonatomic,copy)NSString * userid;
@property (nonatomic,copy)NSString * number;//User购买上限
@property (nonatomic,copy)NSString * status;// 1待开奖2开奖中3中4待收货
@property (nonatomic,copy)NSString * pic;
@property (nonatomic,copy)NSString * user_code;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * prize_winner;
@property (nonatomic,copy)NSString * num;//User购买次数
@property (nonatomic,copy)NSString * pid;

@end
