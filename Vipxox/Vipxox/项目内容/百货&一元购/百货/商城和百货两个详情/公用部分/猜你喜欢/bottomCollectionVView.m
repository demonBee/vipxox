//
//  bottomCollectionVView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "bottomCollectionVView.h"
#import "GuessLikeCCollectionViewCell.h"
#import "GuessLikeModel.h"


#define GUESSCCELL  @"GuessLikeCCollectionViewCell"

@interface bottomCollectionVView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*collectionView;

@property(nonatomic,strong)NSMutableArray*modelAllDatas;  //model的所有数据

@end
@implementation bottomCollectionVView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame: frame];
    if (self) {
      
        [self creatCollectionView:frame];
        
    }
    return self;
}

-(void)creatCollectionView:(CGRect)frame{
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:GUESSCCELL bundle:nil] forCellWithReuseIdentifier:GUESSCCELL];
    
    
}

-(void)setAllDatas:(NSArray *)allDatas{
    //要的就4个key        pic id  price   title
    _allDatas=allDatas;
    
//    for (NSDictionary*dict in _allDatas) {
//        
//        GuessLikeModel*model=[GuessLikeModel yy_modelWithDictionary:dict];
//        [self.modelAllDatas addObject:model];
//    }
    
    [self.modelAllDatas addObjectsFromArray:_allDatas];
    MyLog(@"%@",self.modelAllDatas);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelAllDatas.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GuessLikeCCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:GUESSCCELL forIndexPath:indexPath];
    
    //          pic id  price   title
   GuessLikeModel*model=_modelAllDatas[indexPath.row];
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    if ([model.pic isKindOfClass:[NSNull class]]) {
      
    }else{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    }
    
    
    UILabel*label=[cell viewWithTag:2];
    label.text=model.title;
    
    UILabel*labelMOney=[cell viewWithTag:3];
    NSString*num=model.price;
    CGFloat number=[num floatValue];
    labelMOney.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,number];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(delegateFromCollectionTouch:andIndexPath:andthisRowDict:)]) {
        GuessLikeModel*model=self.modelAllDatas[indexPath.row];
//        [GuessLikeModel yy_modelWithJSON:model];
       NSDictionary*dict= [model yy_modelToJSONObject];
        
        [self.delegate delegateFromCollectionTouch:self.tag andIndexPath:indexPath andthisRowDict:dict];
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat with =(KScreenWidth-50)/3;
    return CGSizeMake(with, 170-with+ACTUAL_HEIGHT(with));

}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 20, 15);
}


#pragma mark  ----set   get


-(NSMutableArray *)modelAllDatas{
    if (!_modelAllDatas) {
        _modelAllDatas=[NSMutableArray array];
    }
    return _modelAllDatas;

    
}

@end
