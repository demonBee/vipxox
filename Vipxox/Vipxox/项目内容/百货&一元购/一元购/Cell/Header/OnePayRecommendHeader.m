//
//  OnePayRecommendHeader.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayRecommendHeader.h"


@implementation OnePayRecommendHeader

- (void)awakeFromNib {
    [self.recommendCollectionView registerNib:[UINib nibWithNibName:ONEPAYRECOMMENDCELL bundle:nil] forCellWithReuseIdentifier:ONEPAYRECOMMENDCELL];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.announcedArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OnePayReceomdCollectionViewCell * reCell = [collectionView dequeueReusableCellWithReuseIdentifier:ONEPAYRECOMMENDCELL forIndexPath:indexPath];
    reCell.model = self.announcedArr[indexPath.row];
    
    return reCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-2.f)/3,165.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OnePayAnnouncedModel * model = self.announcedArr[indexPath.row];
    self.recommendClickBolck(model.announcedID);
}



@end
