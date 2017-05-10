//
//  SectionTwoTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SectionTwoTableViewCell.h"
#import "NewHomePageCollectionViewCell.h"
#import "YoohuoViewController.h"
#import "UIButton+WebCache.h"

#define COLLECTIONCELL   @"NewHomePageCollectionViewCell"

@interface SectionTwoTableViewCell()

@property(nonatomic,strong)UICollectionView*collectionView;

@end

@implementation SectionTwoTableViewCell

//-(void)DelegateForSectionTwoCell:(NSArray *)array{
//    NSLog(@"%@",array);
//    if (array==nil) {
//        
//    }else{
//    UILabel*label=[self viewWithTag:10];
//    label.text=array[0][0];
//    UILabel*label2=[self viewWithTag:11];
//    label2.text=array[0][1];
//    
//    UIButton*button=[self viewWithTag:20];
//    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:array[1][0][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_165x165"]];
//    
//    UIButton*button2=[self viewWithTag:21];
//    [button2 sd_setBackgroundImageWithURL:[NSURL URLWithString:array[1][1][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_165x165"]];
//    
//    }
//    
//}


-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    
    if (_allDatas==nil) {
        
    }else{
        UILabel*label=[self viewWithTag:10];
//        label.height=40;
        label.text=_allDatas[0][0];
        UILabel*label2=[self viewWithTag:11];
        label2.text=_allDatas[0][1];
        
        UIButton*button=[self viewWithTag:20];
        button.backgroundColor=[UIColor whiteColor];
        button.imageView.contentMode=UIViewContentModeScaleAspectFit;

        [button sd_setImageWithURL:[NSURL URLWithString:_allDatas[1][0][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_165x165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                button.alpha=0.3;
                CGFloat scale = 0.3;
                button.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    button.alpha=1;
                    CGFloat scale = 1.0;
                    button.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
        
        UIButton*button2=[self viewWithTag:21];
        button2.backgroundColor=[UIColor whiteColor];
        button2.imageView.contentMode=UIViewContentModeScaleAspectFit;

        [button2 sd_setImageWithURL:[NSURL URLWithString:_allDatas[1][1][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_165x165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                button2.alpha=0.3;
                CGFloat scale = 0.3;
                button2.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    button2.alpha=1;
                    CGFloat scale = 1.0;
                    button2.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
        
    }

//    [self layoutIfNeeded];
//         UILabel*label2=[self viewWithTag:11];
//    self.collectionView.frame=CGRectMake(0, label2.bottom+10, KScreenWidth, ACTUAL_WIDTH(82));
}


-(void)layoutSubviews{
    [super layoutSubviews];
      UILabel*label2=[self viewWithTag:11];
    NSLog(@"layout   %@",NSStringFromCGRect(label2.frame));
    self.collectionView.frame=CGRectMake(0, label2.bottom+10, KScreenWidth, ACTUAL_WIDTH(82));
    
}


- (void)awakeFromNib {
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumInteritemSpacing=15;
    flowLayout.minimumLineSpacing=16;
    flowLayout.sectionInset=UIEdgeInsetsMake(0, 15, 0, 15);
    flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(82), ACTUAL_HEIGHT(82));
    
    
    

   

    
    UICollectionView*collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_WIDTH(82)) collectionViewLayout:flowLayout];
    self.collectionView=collectionView;
//    self.contentView.bottom=collectionView.bottom
//    [self setSize:CGSizeMake(KScreenWidth, collectionView.bottom)];
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(collectionView.bottom);
//    }];
    
    collectionView.backgroundColor=[UIColor whiteColor];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.showsHorizontalScrollIndicator=NO;
    [self.contentView addSubview:collectionView];

    [collectionView registerNib:[UINib nibWithNibName:COLLECTIONCELL bundle:nil] forCellWithReuseIdentifier:COLLECTIONCELL];
    

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.delegate SectionTwoTableViewCell:collectionView numberOfItemsInTableViewIndexPath:self.tableViewIndexPath];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate SectionTwoTableViewCell:collectionView cellForItemAtContentIndexPath:indexPath inTableViewIndexPath:self.tableViewIndexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate SectionTwoTableViewCell:collectionView didSelectItemAtContentIndexPath:indexPath inTableViewIndexPath:self.tableViewIndexPath];
    
}


- (IBAction)touchTwoButtons:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(Twobutton:)]) {
        [self.delegate Twobutton:sender];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
