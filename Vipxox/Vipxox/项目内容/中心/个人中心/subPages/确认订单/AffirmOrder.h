//
//  AffirmOrder.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/23.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AffirmOrder : NSObject

@property(nonatomic,assign)BOOL selected;

@property(nonatomic,strong)NSString*idd;

@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*shprice;
@property(nonatomic,strong)NSString*logo;
@property(nonatomic,strong)NSString*line_t;
@property(nonatomic,strong)NSString*mail_x;
@property(nonatomic,strong)NSString*timeliness_least;
@property(nonatomic,strong)NSString*timeliness_most;
@property(nonatomic,strong)NSString*code;

-(instancetype)initWithShopDict:(NSDictionary*)dict;

@end
