//
//  SystemImageViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/4/6.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SystemImageViewController.h"

@interface SystemImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSMutableArray *allDatas;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)UICollectionView * collect;
@property(nonatomic,strong)NSString *imageViewStr;

@end

@implementation SystemImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeNavi];
    self.title=@"请选择头像";
    
    [self makeView];
    
    // www.vipxox.cn/?m=appapi&s=membercenter&act=Personal_Center&zt=Personal_Center&uid=
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"Personal_Center",@"zt":@"classic",@"uid":[UserSession instance].uid};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            
            self.allDatas=data[@"data"];
            self.urlStr=data[@"herf"];
            [self.collect reloadData];
        }
    }];

}


-(void)makeView{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(ACTUAL_WIDTH(115), ACTUAL_HEIGHT(115));
    layout.minimumInteritemSpacing=ACTUAL_WIDTH(10);
    layout.minimumLineSpacing=ACTUAL_HEIGHT(10);
    //创建collectionView 通过一个布局策略layout来创建
    _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:layout];
    //代理设置
    _collect.delegate=self;
    _collect.dataSource=self;
    //注册item类型 这里使用系统的类型
    [_collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.view addSubview:_collect];
}

//-(void)makeNavi{
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(30),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"请选择头像";
//    titleLabel.textAlignment=1;
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:titleLabel];
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//}
//
//-(void)dismissTo{
//      [self.navigationController popViewControllerAnimated:YES];
//}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatas.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), ACTUAL_WIDTH(115), ACTUAL_HEIGHT(115))];
    NSString *str=[NSString stringWithFormat:@"%@%@",self.urlStr,self.allDatas[indexPath.item]];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_115x115"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView1.alpha=0.3;
            CGFloat scale = 0.3;
            imageView1.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView1.alpha=1;
                CGFloat scale = 1.0;
                imageView1.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    [cell addSubview:imageView1];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.imageViewStr=[NSString stringWithFormat:@"%@%@",self.urlStr,self.allDatas[indexPath.item]];
    
    //www.vipxox.cn/?m=appapi&s=membercenter&act=Personal_Center&logo=&zt=up_img&uid=
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"Personal_Center",@"logo":self.allDatas[indexPath.item],@"zt":@"up_img",@"uid":[UserSession instance].uid};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            [JRToast showWithText:@"修改成功！"];
//            if ([self.delegate respondsToSelector:@selector(delegateForBack4:)]) {
//                [self.delegate delegateForBack4:self.imageViewStr];
//            }
            [UserSession instance].logo=self.imageViewStr;
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:@"修改失败！"];
        }
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
