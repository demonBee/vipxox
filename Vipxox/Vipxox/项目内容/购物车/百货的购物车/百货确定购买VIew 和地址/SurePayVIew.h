//
//  SurePayVIew.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/12.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurePayVIew : UIView
@property(nonatomic,strong)void(^cancelBlock)();
@property(nonatomic,strong)void(^sureBlock)(NSString*money,NSString*idd);

@property(nonatomic,strong)void(^changeAddressBlock)();

@property(nonatomic,strong)NSDictionary*allDatas;
@end
