//
//  showResultsViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "showResultsViewController.h"
#import "FoodCaregoryCollectionViewCell.h"   //用处最广  筛选都用它
//#import "GoodsTailsViewController.h"   //商品详情  迟早要替换掉
#import "NewGoodDetailViewController.h"



#define CCELL  @"FoodCaregoryCollectionViewCell"
@interface showResultsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation showResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.titleStr;
    [self setCollectionView];
    
}

-(void)setCollectionView{
    UICollectionViewFlowLayout*flowlayout=[[UICollectionViewFlowLayout alloc]init];
    UICollectionView*collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowlayout];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:CCELL bundle:nil] forCellWithReuseIdentifier:CCELL];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatas.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FoodCaregoryCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL forIndexPath:indexPath];
    
    NSDictionary*dict=self.allDatas[indexPath.row];
    
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView.alpha=0.3;
            imageView.transform=CGAffineTransformMakeScale(0.3, 0.3);
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.alpha=1.0;
                imageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
            }];
            
        }
        
        
    }];
    
    UILabel*label=[cell viewWithTag:2];
    label.text=dict[@"title"];
    
    UILabel*money=[cell viewWithTag:3];
    money.text=[NSString stringWithFormat:@"%@%@",[UserSession instance].currency,dict[@"price"]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict=self.allDatas[indexPath.row];
//    GoodsTailsViewController*vc=[[GoodsTailsViewController alloc]init];
//    vc.thisDatas=dict;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((KScreenWidth-48)/2, 264-214+ACTUAL_HEIGHT(214));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
