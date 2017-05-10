//
//  AffirmOrderTableViewCell.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/22.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AffirmOrderTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *introduceLabel;
@property(nonatomic,strong)UILabel *courierLimitedLabel;
@property(nonatomic,strong)UILabel *dayLabel;

@property(nonatomic,strong)UIButton*imageHook;

@property(nonatomic,strong)UIImageView *courierImageView;

@end
