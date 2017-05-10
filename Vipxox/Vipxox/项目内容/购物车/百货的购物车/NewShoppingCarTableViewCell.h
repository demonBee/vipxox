//
//  NewShoppingCarTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewShoppingCarTableViewCell : UITableViewCell

@property(nonatomic,copy)void(^CellButtonBlock)(BOOL yesOrNo);

@property(nonatomic,copy)void(^CellDeleteBlock)();
@end
