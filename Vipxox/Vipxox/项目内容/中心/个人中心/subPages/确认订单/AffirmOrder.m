//
//  AffirmOrder.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/23.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "AffirmOrder.h"

@implementation AffirmOrder

-(instancetype)initWithShopDict:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        
        self.selected=NO;
        
        self.idd=dict[@"id"];
        self.name=dict[@"name"];
        self.shprice=dict[@"shprice"];
        self.logo=dict[@"logo"];
        self.line_t=dict[@"line_t"];
        self.mail_x=dict[@"mail_x"];
        self.timeliness_least=dict[@"timeliness_least"];
        self.timeliness_most=dict[@"timeliness_most"];
        self.code=dict[@"code"];

    }
    return self;
}

name;
//@property(nonatomic,strong)NSString*shprice;
//@property(nonatomic,strong)NSString*logo;
//@property(nonatomic,strong)NSString*line_t;
//@property(nonatomic,strong)NSString*mail_x;
//@property(nonatomic,strong)NSString*timeliness_least;
//@property(nonatomic,strong)NSString*timeliness_most;

@end
