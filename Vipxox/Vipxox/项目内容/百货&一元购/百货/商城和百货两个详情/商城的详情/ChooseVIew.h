//
//  ChooseVIew.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseVIew : UIView
+(instancetype)creatVCWithFrame:(CGRect)rect;

@property(nonatomic,copy)void(^ImmediatelyBlock)();
@property(nonatomic,copy)void(^addCarBlock)();
@end
