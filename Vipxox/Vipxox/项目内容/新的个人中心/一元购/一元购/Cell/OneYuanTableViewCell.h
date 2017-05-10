//
//  OneYuanTableViewCell.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneYuanModel.h"

@interface OneYuanTableViewCell : UITableViewCell

@property (nonatomic,strong)OneYuanModel * model;

@property(nonatomic,copy)void(^rePayBlock)(NSInteger);

@property (weak, nonatomic) IBOutlet UIButton *payAgainBTN;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;//期号

@property (weak, nonatomic) IBOutlet UILabel *joinCountLabel;//参与次数

@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;//获得者



@end
