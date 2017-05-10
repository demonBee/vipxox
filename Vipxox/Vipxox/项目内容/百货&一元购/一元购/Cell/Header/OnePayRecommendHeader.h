//
//  OnePayRecommendHeader.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnePayReceomdCollectionViewCell.h"

#import "OnePayAnnouncedModel.h"

#define ONEPAYRECOMMENDCELL @"OnePayReceomdCollectionViewCell"
@interface OnePayRecommendHeader : UICollectionReusableView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,copy)void(^recommendClickBolck)(NSString  *);

@property (weak, nonatomic) IBOutlet UICollectionView *recommendCollectionView;
@property (nonatomic,strong)NSMutableArray * announcedArr;

@end
