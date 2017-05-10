//
//  NewGoodHeaderView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/27.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailHeaderModel.h"

@class SDCycleScrollView;

@interface NewGoodHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;

@property(nonatomic,strong)DetailHeaderModel*allDatas;

@end
