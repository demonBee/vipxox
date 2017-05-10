//
//  tableDelegate.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SectionTwoTableViewCellDelegate <NSObject>

- (NSInteger)SectionTwoTableViewCell:(UICollectionView *)SectionTwoTableViewCell numberOfItemsInTableViewIndexPath:(NSIndexPath *)tableViewIndexPath;

- (UICollectionViewCell *)SectionTwoTableViewCell:(UICollectionView *)SectionTwoTableViewCell cellForItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath;

- (CGSize)SectionTwoTableViewCell:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)SectionTwoTableViewCell:(UICollectionView *)SectionTwoTableViewCell didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath;



-(void)Twobutton:(UIButton*)sender;
@end
@interface tableDelegate : NSObject

@end
