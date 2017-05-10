//
//  SectionTwoTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tableDelegate.h"



@interface SectionTwoTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)id<SectionTwoTableViewCellDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *tableViewIndexPath;


@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;


@property(nonatomic,strong)NSArray*allDatas;   //所有数据
@end
