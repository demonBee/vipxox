//
//  SuperStarDetailViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SuperStarDetailViewController.h"
#import "SuperStarCollectionViewCell.h"
//#import "GoodsTailsViewController.h"      //详情
#import "NewGoodDetailViewController.h"


#define SUPERSTAR    @"SuperStarCollectionViewCell"
@interface SuperStarDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int pagen;
@end

@implementation SuperStarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dict);
    self.allDatas=[NSMutableArray array];
    self.pagen=10;
    self.pages=0;
    [self makeCollectionView];
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
   
}
-(void)makeCollectionView{
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=ACTUAL_WIDTH(16);
    flowLayout.minimumLineSpacing=ACTUAL_HEIGHT(25);
    flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(160),260-215+ ACTUAL_HEIGHT(215));
    flowLayout.sectionInset=UIEdgeInsetsMake(ACTUAL_HEIGHT(30), ACTUAL_WIDTH(16), ACTUAL_HEIGHT(0), ACTUAL_WIDTH(16));
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
//    self.collectionView.backgroundColor=[UIColor yellowColor];
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];

    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:SUPERSTAR bundle:nil] forCellWithReuseIdentifier:SUPERSTAR];
}

-(void)getDatas{
//    http://www.vipxox.cn/ ?m=appapi&s=home_page&act=home_info&userid=q&get= start&zt=1&id=&pagen=6&pages=0
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"home_info",@"userid":[UserSession instance].uid,@"get":@"start",@"zt":@"1",@"pagen":pagen,@"pages":pages,@"id":self.dict[@"id"]};
   HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [self.allDatas addObjectsFromArray:data[@"data"]];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
      
        // 结束刷新
          [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
    }];
    
    
}

- (void)addHeader
{
    self.pages=0;
    self.allDatas=[NSMutableArray array];
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        [vc getDatas];
        
    } dateKey:@"collection"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
#warning 自动刷新(一进入程序就下拉刷新)
        [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
       __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        vc.pages++;

        // 进入刷新状态就会回调这个Block
        [vc getDatas];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
      
        
    }];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  
    return (self.allDatas.count+1)/2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row=self.allDatas.count%2;
    NSInteger ss=(self.allDatas.count+1)/2;
    if (row!=0&&section==ss-1){
        return 1;
    }else{
        return 2;
    }
    
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:SUPERSTAR forIndexPath:indexPath];
    if (self.allDatas==nil) {
        
    }else{
    NSInteger number=indexPath.section*2+indexPath.row;
    UIImageView*imageView=[cell viewWithTag:1];
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
    
    UILabel*labelTitle=[cell viewWithTag:2];
    labelTitle.text=self.allDatas[number][@"title"];
    
    UILabel*labelPrice=[cell viewWithTag:3];
    labelPrice.text=[NSString stringWithFormat:@"%@%@",[UserSession instance].currency,self.allDatas[number][@"price"]];
//        cell.backgroundColor=[UIColor yellowColor];
    }
    return cell;
   
}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger number=indexPath.section*2+indexPath.row;
    NSLog(@"%@",self.allDatas);
    NSDictionary*dict=self.allDatas[number];
//    GoodsTailsViewController*vc=[[GoodsTailsViewController alloc]init];
//    vc.thisDatas=dict;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        [self makeHeader];
        CGSize size=CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(425));
        return size;
    }
    return CGSizeZero;
}

-(void)makeHeader{
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(425))];
    headView.backgroundColor=[UIColor whiteColor];
    [self.collectionView addSubview:headView];
    
    UIView*grayView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(370), KScreenWidth, ACTUAL_HEIGHT(18))];
    grayView.backgroundColor=RGBCOLOR(236, 236, 236, 1);
//    grayView.backgroundColor=[UIColor redColor];
    [headView addSubview:grayView];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(180))];
//    imageView.backgroundColor=[UIColor blueColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dict[@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x180"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    [headView addSubview:imageView];
    
    UILabel*subTitle=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(135), ACTUAL_HEIGHT(200), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
//    subTitle.text=@"MARCELO BURLON";
    subTitle.text=self.dict[@"descrip_name"];
    subTitle.textAlignment=NSTextAlignmentRight;
//    self.title=@"MARCELO BURLON";
    self.title=self.dict[@"descrip_name"];
    [headView addSubview:subTitle];
    
    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(15), ACTUAL_HEIGHT(255), KScreenWidth-ACTUAL_WIDTH(30), ACTUAL_HEIGHT(90))];
//    textView.backgroundColor=[UIColor grayColor];
    textView.editable=NO;
//    textView.text=@"Marcelo Burlon 擅长将不同领域的事物和谐统一，堪称“先锋时尚”的代名词。Marcelo Burlon自由驰骋于时尚、音乐和艺术之间，并能够将之形成令世人。。";
    textView.text=self.dict[@"descrip_content"];
    [headView addSubview:textView];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(120), ACTUAL_HEIGHT(403), ACTUAL_WIDTH(240), ACTUAL_HEIGHT(15))];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=@"NEW ARRIVAL";
    [headView addSubview:titleLabel];
    
    
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
