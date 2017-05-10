//
//  OnePayReceomdCollectionViewCell.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnePayShopModel.h"

@interface OnePayReceomdCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)OnePayShopModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end
