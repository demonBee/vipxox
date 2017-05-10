//
//  DepartmentSection1TableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentSection1TableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSIndexPath*tableIndexPath;

@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)void(^buttonBlock)(NSIndexPath*tableIndexPath);
@property(nonatomic,strong)void(^collectionViewBlock)(NSString*idd);


@property(nonatomic,strong)NSArray*allDatasModel;
@end
