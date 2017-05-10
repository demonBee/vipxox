//
//  OnePayModel.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnePayAdvModel.h"
#import "OnePayShopModel.h"
#import "OnePayAnnouncedModel.h"

@interface OnePayModel : NSObject

@property (nonatomic,strong)NSArray * adv;
@property (nonatomic,strong)NSArray * shop;
@property (nonatomic,strong)NSArray * announced;

@end
