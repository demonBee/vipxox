//
//  BrandViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "BrandViewController.h"
#import "BrandCollectionViewCell.h"
#import "brandModel.h"
#import "goodsModel.h"

#import "DepartmentDetailViewController.h"

#define BRANDCCELL   @"BrandCollectionViewCell"

@interface BrandViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*collectionView;


@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;

@property(nonatomic,strong)brandModel*bModel;   //总共一个model
@property(nonatomic,strong)NSMutableArray*allDatasModel;  //model 里面的一个数组也是model

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pagen=10;
    self.pages=0;
    
    
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;

    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
    self.collectionView.alwaysBounceVertical=YES;
    [self.collectionView registerNib:[UINib nibWithNibName:BRANDCCELL bundle:nil] forCellWithReuseIdentifier:BRANDCCELL];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];

    
}

#pragma mark--  UI
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        vc.pages=0;
        [vc getDatas];
        
        
        
    } dateKey:@"collection"];
    
#warning 自动刷新(一进入程序就下拉刷新)
        [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        vc.pages++;
        [vc getDatas];
      
        
        
        

}];
    
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.allDatasModel.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:BRANDCCELL forIndexPath:indexPath];
    goodsModel*model=self.allDatasModel[indexPath.row];
    
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.backgroundColor=[UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    UILabel*titleLabel=[cell viewWithTag:2];
    titleLabel.text=model.name;
    
    UILabel*priceLabel=[cell viewWithTag:3];
    NSString*str=model.price;
    CGFloat aa=[str floatValue];
    priceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,aa];
    
    
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DepartmentDetailViewController*vc=[[DepartmentDetailViewController alloc]init];
    goodsModel*model=self.allDatasModel[indexPath.row];
    vc.dictJiekou=@{@"id":model.goodsID};
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, ACTUAL_WIDTH(8), 10, ACTUAL_WIDTH(8));
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(ACTUAL_WIDTH(172), ACTUAL_HEIGHT(160)+90);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (_bModel.descriptionn!=nil&&![_bModel.descriptionn isEqualToString:@""]) {
        CGFloat strHeight=[_bModel.descriptionn boundingRectWithSize:CGSizeMake(KScreenWidth-15-20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;

        return CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(190)+strHeight+10);
    }
    return CGSizeMake(KScreenWidth,ACTUAL_HEIGHT(180));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView*headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView.backgroundColor=RGBCOLOR(243, 243, 243, 1);
    
    
    
    if (_bModel.logo!=nil) {
        
        UIImageView*imageView=[headerView viewWithTag:88];
        if (!imageView) {
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(180))];
            imageView.tag=88;
            imageView.backgroundColor=[UIColor whiteColor];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
//            imageView.backgroundColor=[UIColor greenColor];
            [headerView addSubview:imageView];

        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_bModel.logo] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
        }];
        
    }
    
    if (_bModel.descriptionn!=nil) {
        
        UILabel*contentLabel=[headerView viewWithTag:99];
        if (!contentLabel) {
            contentLabel=[[UILabel alloc]init];
            contentLabel.tag=99;
            contentLabel.numberOfLines=0;
            contentLabel.font=[UIFont systemFontOfSize:14];
            [headerView addSubview:contentLabel];

            
        }
        
        contentLabel.text=_bModel.descriptionn;
        CGFloat strheight=[_bModel.descriptionn boundingRectWithSize:CGSizeMake(KScreenWidth-15-20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        contentLabel.frame=CGRectMake(15, ACTUAL_HEIGHT(190), KScreenWidth-15-20, strheight);

}
    
    
    
    return headerView;
    
}


#pragma mark  --- data
-(void)getDatas{
//    http://www.vipxox.cn/?  m=app&s=baihuo&act=bplist&bid=762&pages=0&pagen=10
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    
    NSDictionary*dict=@{@"m":@"app",@"s":@"baihuo",@"act":@"bplist"
                        ,@"bid":self.bid,@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:dict compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            if ([pages isEqualToString:@"0"]) {
                [self.allDatasModel removeAllObjects];
            }
            
            brandModel*model=[brandModel yy_modelWithDictionary:data[@"data"]];
            self.bModel=model;
            
            //title
            self.title=self.bModel.name;
            
            for (goodsModel*model in self.bModel.prolist) {
                [self.allDatasModel addObject:model];
            }
            
       
            [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        
    }];
    
    
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

#pragma mark  ----set
-(NSMutableArray *)allDatasModel{
    if (!_allDatasModel) {
        _allDatasModel=[NSMutableArray array];
    }
    return _allDatasModel;
    
}


@end
