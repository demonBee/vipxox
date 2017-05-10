//
//  SectionFourTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SectionFourTableViewCell.h"
#import "bottomCollectionViewCell.h"
#import "YoohuoViewController.h"

#define bottomCell  @"bottomCollectionViewCell"

@interface SectionFourTableViewCell()<YoohuoViewControllerDelegate>

@end

@implementation SectionFourTableViewCell

//-(void)DelegateCollectionToReload{
//    [self.collectionView reloadData];
//}

- (void)awakeFromNib {

    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
//    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing=22;
    flowLayout.minimumInteritemSpacing=22;
    flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(162), 263-214+ACTUAL_HEIGHT(214));
    flowLayout.sectionInset=UIEdgeInsetsMake(ACTUAL_HEIGHT(22), ACTUAL_WIDTH(12), 0, ACTUAL_WIDTH(12));
    
    UICollectionView*collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(34), KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator=NO;
    collectionView.showsVerticalScrollIndicator=NO;
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.scrollEnabled=NO;
    [collectionView registerNib:[UINib nibWithNibName:bottomCell bundle:nil] forCellWithReuseIdentifier:bottomCell];
    collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView=collectionView;


    [self.contentView addSubview:collectionView];

//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.top).offset(34);
//        make.left.mas_equalTo(self.left).offset(0);
//        make.right.mas_equalTo(self.right).offset(0);
//        //        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
//        //        make.height.mas_equalTo(self.height-34);
//        make.bottom.mas_equalTo(self.mas_bottom);
//        
//    }];

    

}

-(void)layoutSubviews{
    [super layoutSubviews];
//    collectionView 的frame 由tableViewCell的高决定
    self.collectionView.frame=self.contentView.frame;
    
//    NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.delegate bottomCollectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.delegate numberOfSectionsInCollectionView:(UICollectionView*)collectionView withTable:(NSIndexPath*)self.tableViewIndexPath];
    
    
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath withTable:(NSIndexPath*)self.tableViewIndexPath];
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath withTable:(NSIndexPath*)self.tableViewIndexPath];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
