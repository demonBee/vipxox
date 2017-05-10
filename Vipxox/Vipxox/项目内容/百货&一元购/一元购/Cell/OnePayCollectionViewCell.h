//
//  OnePayCollectionViewCell.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnePayShopModel.h"
#import "OnePayDrawView.h"

@interface OnePayCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy)void(^payNowBolck)();
@property (nonatomic,strong)OnePayShopModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet OnePayDrawView *onePayDrawView;


@end
