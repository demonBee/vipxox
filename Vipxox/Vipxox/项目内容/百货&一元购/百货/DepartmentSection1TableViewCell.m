//
//  DepartmentSection1TableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentSection1TableViewCell.h"
#import "DepartmentCollectionViewCell.h"

#import "goodsModel.h"

#define DEPARTMENTCCELL   @"DepartmentCollectionViewCell"

@implementation DepartmentSection1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIButton*Topbutton=[self viewWithTag:1];
   
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(140), 180-130+ACTUAL_HEIGHT(130));
      flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
//    flowLayout.sectionInset=UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(193), KScreenWidth,180-130+ACTUAL_HEIGHT(130)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
//    self.collectionView.scrollEnabled=YES;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:DEPARTMENTCCELL bundle:nil] forCellWithReuseIdentifier:DEPARTMENTCCELL];
   
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allDatasModel.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:DEPARTMENTCCELL forIndexPath:indexPath];
    if (_allDatasModel.count<1) {
        return cell;
    }
    
    NSInteger number=indexPath.row;
    goodsModel*model=_allDatasModel[number];
    
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.image=nil;
    imageView.backgroundColor=[UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UILabel*titleLabel=[cell viewWithTag:2];
    titleLabel.text=model.name;
    
    UILabel*priceLabel=[cell viewWithTag:3];
    NSString*price=model.price;
    CGFloat aa=[price floatValue];
    
    priceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,aa];
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf=self;
    NSInteger number=indexPath.row;
    goodsModel*model=_allDatasModel[number];

    
    if (_collectionViewBlock) {
        _collectionViewBlock(model.goodsID);
    }
    
}

- (IBAction)bigButton:(id)sender {
    
    if (_buttonBlock) {
        _buttonBlock(_tableIndexPath);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --set

-(void)setAllDatasModel:(NSArray *)allDatasModel{
    _allDatasModel=allDatasModel;
    [self.collectionView reloadData];
    
}



@end
