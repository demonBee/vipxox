//
//  ShoppingCarHeaderView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarHeaderView : UITableViewHeaderFooterView

@property(nonatomic,copy)void(^selectAllBlock)(BOOL value);

@property(nonatomic,strong)void(^ToBuyBlock)();






@end
