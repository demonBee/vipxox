//
//  ChaoliuDapeoTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChaoliuDapeoTableViewCellDelegate <NSObject>
//让主控制器 跳转到商品详情
-(void)DelegateForTiaozhuan:(NSDictionary*)dict;

@end
@interface ChaoliuDapeoTableViewCell : UITableViewCell
@property(nonatomic,assign)id<ChaoliuDapeoTableViewCellDelegate>delegate;
@end
