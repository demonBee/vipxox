//
//  SectionFourTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionFourTableViewCellDelegate <NSObject>
-(NSInteger)bottomCollectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section;

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView withTable:(NSIndexPath*)tableViewIndexPath;

-(UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath withTable:(NSIndexPath*)tableViewIndexPath;

-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath withTable:(NSIndexPath*)tableViewIndexPath;

@end

@interface SectionFourTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)NSIndexPath*tableViewIndexPath;

@property(nonatomic,strong)NSArray*allDatas;    //所有数据

@property(nonatomic,assign)id<SectionFourTableViewCellDelegate>delegate;

@end
