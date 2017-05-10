//
//  ShopCarTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNumberView.h"

@protocol  ShopCarTableViewCellDelegate<NSObject>

-(void)delegateForShowChoose:(UIButton*)sender;

@end

@interface ShopCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,assign)NSInteger shuliang;  //一开始 有多少个

@property(nonatomic,strong) AddNumberView*addView;  //那个＋ － 按钮
@property(nonatomic,strong)UIButton*buttonChoose;
@property(nonatomic,strong)id<ShopCarTableViewCellDelegate>delegate;
@end


