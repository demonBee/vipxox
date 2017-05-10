//
//  ChaoliuDapeoTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChaoliuDapeoTableViewCell.h"
#import "ChaoliuCollectionViewCell.h"
#import "ChaoliuDapeiViewController.h"

#define chaoliuCollectionCell   @"ChaoliuCollectionViewCell"

@interface ChaoliuDapeoTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,ChaoliuDapeiViewControllerDelegate>
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)NSArray*allDatas;    //所有商品的数据

@end

@implementation ChaoliuDapeoTableViewCell

-(void)DelegateForCellSendDatas:(NSArray *)array{
    NSLog(@"%@",array);
    self.allDatas=array;
       [self.collectionView reloadData];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //暂时的
        
        
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=ACTUAL_WIDTH(15);
        flowLayout.minimumInteritemSpacing=ACTUAL_HEIGHT(15);
        flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(160), ACTUAL_HEIGHT(260));
        flowLayout.sectionInset=UIEdgeInsetsMake(ACTUAL_HEIGHT(16), ACTUAL_WIDTH(15), ACTUAL_HEIGHT(16), ACTUAL_WIDTH(15));
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.height) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.scrollEnabled=NO;
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            
        }];
        
        
        [self.collectionView registerNib:[UINib nibWithNibName:chaoliuCollectionCell bundle:nil] forCellWithReuseIdentifier:chaoliuCollectionCell];
        
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (self.allDatas.count+1)/2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger ss=(self.allDatas.count+1)/2;
    NSInteger row=self.allDatas.count%2;
    
    if (section==ss-1&&row!=0) {
        return 1;
    }else{
        return 2;
    }
    
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChaoliuCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:chaoliuCollectionCell forIndexPath:indexPath];
//    cell.backgroundColor=[UIColor greenColor];
    NSInteger number=indexPath.section*2+indexPath.row;
    
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;

    [imageView sd_setImageWithURL:[NSURL URLWithString:self.allDatas[number][@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_160x215"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView.alpha=0.3;
            CGFloat scale = 0.3;
            imageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.alpha=1;
                CGFloat scale = 1.0;
                imageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    
    UILabel*label1=[cell viewWithTag:2];
    label1.text=self.allDatas[number][@"title"];
    
    CGFloat aa=[self.allDatas[number][@"price"] floatValue];
    UILabel*label2=[cell viewWithTag:3];
    label2.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,aa];
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger number=indexPath.section*2+indexPath.row;
    NSDictionary*dict=self.allDatas[number];
    
    if ([self.delegate respondsToSelector:@selector(DelegateForTiaozhuan:)]) {
        [self.delegate DelegateForTiaozhuan:dict];
    }
    
}

@end
