//
//  ShoppingCarADDView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarADDView : UIView
@property(nonatomic,strong)NSString*currentStr;
@property(nonatomic,strong)void(^AddBlock)(NSInteger number);
@property(nonatomic,strong)void(^SubBlock)(NSInteger number);

@end
