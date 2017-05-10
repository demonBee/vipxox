//
//  NewPersionCenterSection1TableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/19.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewPersionCenterSection1TableViewCell.h"
#import "Section1CollectionViewCell.h"

#define COLLECTIONCELL  @"Section1CollectionViewCell"


@interface NewPersionCenterSection1TableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView*collectionView;

@end
@implementation NewPersionCenterSection1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing=1;
    flowLayout.minimumInteritemSpacing=1;
    flowLayout.itemSize=CGSizeMake((KScreenWidth-3)/3, (KScreenWidth-3)/3*106/124);
//    flowLayout.itemSize=CGSizeMake(60, 60);
    
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=RGBCOLOR(247, 247, 247, 1);
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.scrollEnabled=NO;
    [self.contentView addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:COLLECTIONCELL bundle:nil] forCellWithReuseIdentifier:COLLECTIONCELL];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
//               make.left.mas_equalTo(self.left);
//                make.right.mas_equalTo(self.right);
//                make.top.mas_equalTo(self.top);
//                make.bottom.mas_equalTo(self.bottom);

    }];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Section1CollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:COLLECTIONCELL forIndexPath:indexPath];
    NSBundle*bundle=[InternationalLanguage bundle];

    if (indexPath.row==0) {
               cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"internationalOrder" value:nil table:@"Language"]];
        
    }else if (indexPath.row==1){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"cloudHouse" value:nil table:@"Language"]];

    }else if (indexPath.row==2){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"trans" value:nil table:@"Language"]];

    }else if (indexPath.row==3){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"collection" value:nil table:@"Language"]];

    }else if (indexPath.row==4){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"currenturyChoose" value:nil table:@"Language"]];
        
    }else if (indexPath.row==5){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"address" value:nil table:@"Language"]];
        
    }else if (indexPath.row==6){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"pay" value:nil table:@"Language"]];
        
    }else if (indexPath.row==7){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"getMoney" value:nil table:@"Language"]];
        
    }else if (indexPath.row==8){
        cell.imageView.image=[UIImage imageNamed:[bundle localizedStringForKey:@"accountPay" value:nil table:@"Language"]];
        
    }





    
    
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger number=indexPath.row;
    if (self.collectionCellBlock) {
        self.collectionCellBlock(number);
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
