//
//  DiscountViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DiscountViewController.h"
#import "bottomCollectionViewCell.h"
#import "FoodCaregoryCollectionViewCell.h"
#import "ChooseViewController.h"
#import "SDCycleScrollView.h"

@interface DiscountViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>


@property(nonatomic,assign)BOOL isShuaixuan;   //是筛选和 不是筛选。。
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout*flowLayout;

@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int pagen;

@property(nonatomic,strong)NSMutableArray* collectionViewAllDatas;    //所有的数据
@property(nonatomic,strong)NSArray*titleAndImageAllDatas;     //title和image


@property(nonatomic,strong)NSString*naviTitle;  //navi title 上的标题(需要作为参数)


//-------- 折扣
@property(nonatomic,strong)NSMutableArray*allButton;
@property(nonatomic,strong)NSString*whichZhekou;   //1-3折
@property(nonatomic,strong)NSArray* zhekouPic;  //折扣的图片
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;  //轮播图

//－－－－－－－全球包邮
@property(nonatomic,strong)NSString*location;   //产地国家

// --------分类
@property(nonatomic,strong)NSMutableArray*saveThreeButtons;   //保存所有的按钮    //品牌也用他
@property(nonatomic,strong)NSString*threeButtonName;      //3个按钮的名字
@property(nonatomic,strong)NSString*threeButtonValue;    //3个按钮的值

@property(nonatomic,strong)NSString*whoThouchIn;         //哪一类点进来的  key
@property(nonatomic,strong)NSString*WhoValues;      // 哪一类点进去的值    Value
//-------品牌
@property(nonatomic,strong)UIImageView*imageViewTop;  //头部的图片

//------筛选
@property(nonatomic,strong)NSArray*sixParams;   //筛选里面的6个参数

@end


#define  FOODCAREGORY   @"FoodCaregoryCollectionViewCell"

@implementation DiscountViewController


#pragma mark---  那个6个参数的选择吊用
-(void)shuaxinn:(NSNotification*)NSNotification{
    NSLog(@"%@",NSNotification.userInfo[@"key"][2]);   //0--5
    //通过 这6个值  给后台调借口   刷新collectionView
    self.sixParams=NSNotification.userInfo[@"key"];
//        self.cate=thisIsShaixuan;
    //这个是筛选
    self.isShuaixuan=YES;
    
      self.collectionViewAllDatas=[NSMutableArray array];
    self.pages=0;
    [self jiekouForshuaxin];


  

    
}

#pragma mark ---- 刷新接口
-(void)jiekouForshuaxin{
    
//    	http://www.vipxox.cn/?m=appapi&s=home_page&act=get_products&pages＝0&pagen＝5&colorname＝蓝色
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"sex":_sixParams[0],@"catname":_sixParams[2],@"colorname":_sixParams[3],@"brandname":_sixParams[1],@"location":_sixParams[5],@"price_area":_sixParams[4],@"pagen":pagen,@"pages":pages,@"m":@"appapi",@"s":@"home_page",@"act":@"get_products",@"uid":[UserSession instance].uid};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
      
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [self.collectionViewAllDatas addObjectsFromArray:data[@"data"][@"list"]];
            [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionViewAllDatas=[NSMutableArray array];   //collectionView 的所有数据

//      self.view.backgroundColor=[UIColor blueColor];
//    [self.navigationController.navigationBar.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [self creatCollectionView];
    [self getDatas];
    self.pagen=10;
    self.pages=0;
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
    
    if (self.cate==isfenlei||self.cate==isPingpai||self.cate==isChaoliu) {
        //  默认tag0 被选中
        for (int i=0; i<self.saveThreeButtons.count; i++) {
            UIButton*button=self.saveThreeButtons[i];
            if (button.tag==0) {
                button.selected=YES;
                [self touchthisButton:button];
            }
        }

    }
 
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shuaxinn:) name:@"tongzhipianyiheshuaxin" object:nil];
    
    
}

- (void)addHeader
{
   
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
         vc.pages=0;
        vc.collectionViewAllDatas=[NSMutableArray array];   //collectionView 的所有数据

#warning  可能出错的地方
        if (self.isShuaixuan==YES) {
            //筛选刷新
            [vc jiekouForshuaxin];
        }else if (self.cate==isZhekou){
            
           [vc zheKouJiekou];
        }else if (self.cate==thisIsGrobalSend){
            
            [vc globalSend];
        }
        else{
              [vc jiekou];
        }
       
//                 [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView headerEndRefreshing];


        
    } dateKey:@"collection"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
       __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.pages++;
        if (self.isShuaixuan==YES) {
            //筛选刷新
            [vc jiekouForshuaxin];

        }else if (self.cate==isZhekou){
            [vc zheKouJiekou];

            
        }else if (self.cate==thisIsGrobalSend){
            [vc globalSend];
        }
        
        else{
            [vc jiekou];

        }
        

        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//                    [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        
    }];
}


-(void)getDatas{

    switch (self.cate) {
        case isZhekou:
            //需要改title
//             self.title=@"折扣专区";
            [self creatZhekouMainView];

            break;
        case isfenlei:
//            self.title=@"分类";
            [self creatFengleiMainView];
            break;
        case isPingpai:
//            self.title=@"品牌";
            [self creatPingpaiAndChaoliuMainView];   //品牌和潮流共用
            
            break;
        case isChaoliu:
//            self.title=@"潮流";
            [self creatPingpaiAndChaoliuMainView];
            break;
        case thisIsGrobalSend:
            //            self.title=@"潮流";
            [self creatGrobalSend];   //类似折扣专区
            break;

        default:
            break;
    }
   
    NSLog(@"%ld",(long)self.cate);
//此处 有接口  写个方法写接口
    
    
}

//接口
-(void)jiekou{
//    http://www.vipxox.com/? m=appapi&s=home_page&act=get_products&by_new=yes&catid=2
//    http://www.vipxox.cn/?m=appapi&s=home_page&act=get_products&by_new=yes&catid=28
  
    switch (self.cate) {
        case isZhekou:
            
            break;
        case isfenlei:
            self.whoThouchIn=@"catid";
            //分类和品牌  id 的值    两者拼成一个参数
            self.WhoValues= self.allDatas[@"id"];

            break;
        case isPingpai:
            self.whoThouchIn=@"brandid";
            //分类和品牌  id 的值    两者拼成一个参数
            self.WhoValues= self.allDatas[@"id"];

            break;
        case isChaoliu:
//            self.whoThouchIn=   这个值是allDatas 里面的act
            self.whoThouchIn=self.allDatas[@"act"];
          self.WhoValues=self.allDatas[@"v"];
            break;

        default:
            break;
    }
    NSLog(@"%ld",(long)self.cate);
    NSLog(@"%@",self.allDatas);
       //潮流的
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];

//    NSLog(@"%@",self.allDatas);
//
//
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"get_products",self.threeButtonName:self.threeButtonValue,self.whoThouchIn:self.WhoValues,@"pages":pages,@"pagen":pagen ,@"keyy":self.allDatas[@"id"],@"uid":[UserSession instance].uid};
    HttpManager*manager=[[HttpManager alloc]init];
    NSLog(@"%@",params);
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
     
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
//            self.collectionViewAllDatas=[data[@"data"][@"list"] mutableCopy];
            [self.collectionViewAllDatas addObjectsFromArray:data[@"data"][@"list"]];
           
            self.titleAndImageAllDatas=data[@"data"][@"top"];
             NSLog(@"%@",self.titleAndImageAllDatas[0][@"name"]);
//            self.title=self.titleAndImageAllDatas[0][@"name"];
//            if (self.cate==isPingpai||self.cate==isChaoliu) {
//                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.titleAndImageAllDatas[0][@"img"]] placeholderImage:nil];
//                
//            }
            [self refreshThis];
            [self.collectionView reloadData];
            
        }
        
    }];
}

//刷新标题
-(void)refreshThis{
//    self.title=self.titleAndImageAllDatas[0][@"name"];
    //图片是自己的   然而title 是主控制器的  需要代理出去
    self.naviTitle=self.titleAndImageAllDatas[0][@"name"];
    if ([self.delegate respondsToSelector:@selector(DelegateForTitle:)]) {
        [self.delegate DelegateForTitle:self.titleAndImageAllDatas[0][@"name"]];
    }
    if (self.cate==isPingpai) {
//         [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.allDatas[@"pic"]] placeholderImage:nil];
        
        [self.imageViewTop sd_setImageWithURL:[NSURL URLWithString:self.allDatas[@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x116"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                self.imageViewTop.alpha=0.3;
                CGFloat scale = 0.3;
                self.imageViewTop.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageViewTop.alpha=1;
                    CGFloat scale = 1.0;
                    self.imageViewTop.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
    }
    
    
    if (self.cate==isChaoliu) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.titleAndImageAllDatas[0][@"img"]] placeholderImage:nil];
        [self.imageViewTop sd_setImageWithURL:[NSURL URLWithString:self.titleAndImageAllDatas[0][@"img"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x116"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                self.imageViewTop.alpha=0.3;
                CGFloat scale = 0.3;
                self.imageViewTop.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageViewTop.alpha=1;
                    CGFloat scale = 1.0;
                    self.imageViewTop.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
        
    }
//    [self.collectionView reloadData];

}
#pragma mark -------------品牌 和 潮流 共用的一个   带图
-(void)creatPingpaiAndChaoliuMainView{
    self.saveThreeButtons=[NSMutableArray array];
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(156))];
//    mainView.backgroundColor=[UIColor blueColor];
    [self.collectionView addSubview:mainView];
    //底上的线
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(155), KScreenWidth, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [mainView addSubview:lineView];
    
    
    self.imageViewTop=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(116))];
    self.imageViewTop.backgroundColor=[UIColor whiteColor];
    self.imageViewTop.contentMode=UIViewContentModeScaleAspectFit;

    
    if (self.cate==isPingpai) {
        [self.imageViewTop sd_setImageWithURL:self.allDatas[@"pic"] placeholderImage:[UIImage imageNamed:@"placeholder_375x116"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                self.imageViewTop.alpha=0.3;
                CGFloat scale = 0.3;
                self.imageViewTop.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageViewTop.alpha=1;
                    CGFloat scale = 1.0;
                    self.imageViewTop.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
    }else{
        //潮流
        
    }
    [mainView addSubview:self.imageViewTop];
    
    for (int i=0; i<3; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/3*i, ACTUAL_HEIGHT(0)+ACTUAL_HEIGHT(116), KScreenWidth/3, ACTUAL_HEIGHT(40))];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        button.tag=i;
        [button addTarget:self action:@selector(touchthisButton:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
      
        [mainView addSubview:button];
        [self.saveThreeButtons addObject:button];
        if (i==0) {
//            [button setTitle:@"最新" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_new"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_new_selected"] forState:UIControlStateSelected];

            
        }else if (i==1){
//            [button setTitle:@"价格" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_price"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_price_selected"] forState:UIControlStateSelected];

            
        }else if (i==2){
//            [button setTitle:@"折扣" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_zhekou"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_zhekou_selected"] forState:UIControlStateSelected];

            
        }
        
        
    }

    
    
}


#pragma  mark ------------分类     不带图
-(void)creatFengleiMainView{
        self.saveThreeButtons=[NSMutableArray array];
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(40))];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.collectionView addSubview:mainView];
    //底上的线
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(39), KScreenWidth, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [mainView addSubview:lineView];

    
    for (int i=0; i<3; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/3*i, ACTUAL_HEIGHT(0), KScreenWidth/3, ACTUAL_HEIGHT(40))];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
           button.tag=i;
        [button addTarget:self action:@selector(touchthisButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [mainView addSubview:button];
        [self.saveThreeButtons addObject:button];
        if (i==0) {
            //            [button setTitle:@"最新" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_new"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_new_selected"] forState:UIControlStateSelected];
            
            
        }else if (i==1){
            //            [button setTitle:@"价格" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_price"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_price_selected"] forState:UIControlStateSelected];
            
            
        }else if (i==2){
            //            [button setTitle:@"折扣" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_zhekou"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"home_zhekou_selected"] forState:UIControlStateSelected];
            
            
        }
        
        
    }
  
    
}

#pragma mark  ---除了折扣 其他都用到它  

-(void)touchthisButton:(UIButton*)sender{
    self.isShuaixuan=NO;
    if (sender.selected) {
        sender.selected=NO;
        switch (sender.tag) {
            case 0:
                self.threeButtonName=@"by_new";
                self.threeButtonValue=@"yes";
                break;
            case 1:
                self.threeButtonName=@"by_price";
                self.threeButtonValue=@"a";
                break;
            case 2:
                self.threeButtonName=@"by_discount";
                self.threeButtonValue=@"a";
                break;
   
            default:
                break;
        }
        
        self.pages=0;
        self.collectionViewAllDatas=[NSMutableArray array];
//        //吊用接口
        [self jiekou];
        
        
        
    }else{
        sender.selected=YES;
        switch (sender.tag) {
            case 0:
                self.threeButtonName=@"by_new";
                self.threeButtonValue=@"yes";
                break;
            case 1:
                self.threeButtonName=@"by_price";
                self.threeButtonValue=@"d";
                break;
            case 2:
                self.threeButtonName=@"by_discount";
                self.threeButtonValue=@"d";
                break;
                
            default:
                break;
        }
        self.collectionViewAllDatas=[NSMutableArray array];
        self.pages=0;
        //吊用接口
        [self jiekou];

        
        
    }
    
    
}
#pragma mark   ------------全球包邮
-(void)creatGrobalSend{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(225))];
    [self.collectionView addSubview:mainView];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(180))];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;

    
    [mainView addSubview:imageView];
    
    self.allButton=[NSMutableArray array];
    UIView*buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(180), KScreenWidth, 44)];
    buttonView.backgroundColor=[UIColor whiteColor];
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, KScreenWidth, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [buttonView addSubview:lineView];
    [mainView addSubview:buttonView];
    
    NSArray*array=@[@"日本",@"韩国",@"中国",@"美国"];
    for (int i=0; i<array.count; i++) {
        UIButton*button=[UIButton buttonWithType:0];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.frame=CGRectMake(KScreenWidth/4*i, 0, KScreenWidth/4, ACTUAL_HEIGHT(44));
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        button.tag=i;
#warning button0  被选中
        if (button.tag==0) {
            //只是被选中 不会触发方法
            button.selected=YES;
            self.location=@"日本";
            self.pagen=10;
            self.pages=0;
            [self globalSend];
            
        }
        
        
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.allButton addObject:button];
        [buttonView addSubview:button];
    }
    //3条竖线
    for (int i=0; i<array.count-1; i++) {
        UIView*shuView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/4+KScreenWidth/4*i, ACTUAL_HEIGHT(10), 1, ACTUAL_HEIGHT(20))];
        shuView.backgroundColor=[UIColor grayColor];
        [buttonView addSubview:shuView];
        
    }
}

-(void)globalSend{
//    	http://www.vx.dev/? m=appapi&s=home_page&act=home_info&get=global_shipping
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"home_info",@"get":@"global_shipping",@"location":self.location,@"pagen":pagen,@"pages":pages,@"uid":[UserSession instance].uid};
    
    HttpManager*manger=[[HttpManager alloc]init];
    [manger getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [self.collectionViewAllDatas addObjectsFromArray:data[@"data"][@"list"]];
            self.zhekouPic=data[@"data"][@"top"];
            [self zhekouRefreshPic];
            
        }
        
        
        [self.collectionView reloadData];
        
    }];

    
}

#pragma mark  ---------------折扣 包括接口
-(void)creatZhekouMainView{
    self.allButton=[NSMutableArray array];
//    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(180))];
//    _imageView.backgroundColor=[UIColor redColor];
//    [self.collectionView addSubview:_imageView];
    // 创建不带标题的图片轮播器
//    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
//                        [UIImage imageNamed:@"h2.jpg"],
//                        [UIImage imageNamed:@"h3.jpg"],
//                        [UIImage imageNamed:@"h4.jpg"]
//                        ];

//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(180)) imagesGroup:images];
//    cycleScrollView.delegate = self;
//    cycleScrollView.autoScrollTimeInterval = 3.0;
//    [self.collectionView addSubview:cycleScrollView];

    
    
    UIView*buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(180), KScreenWidth, 44)];
    buttonView.backgroundColor=[UIColor whiteColor];
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, KScreenWidth, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [buttonView addSubview:lineView];
    [self.collectionView addSubview:buttonView];
    
    NSArray*array=@[@"1-3折",@"4-6折",@"7-9折",@"ALL"];
    for (int i=0; i<array.count; i++) {
        UIButton*button=[UIButton buttonWithType:0];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.frame=CGRectMake(KScreenWidth/4*i, 0, KScreenWidth/4, ACTUAL_HEIGHT(44));
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        button.tag=i;
#warning button0  被选中
        if (button.tag==0) {
            //只是被选中 不会触发方法
            button.selected=YES;
            self.whichZhekou=@"1-3";
            self.pagen=10;
            self.pages=0;
            [self zheKouJiekou];
            
        }
        
        
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.allButton addObject:button];
        [buttonView addSubview:button];
    }
    
    for (int i=0; i<array.count-1; i++) {
        UIView*shuView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/4+KScreenWidth/4*i, ACTUAL_HEIGHT(10), 1, ACTUAL_HEIGHT(20))];
        shuView.backgroundColor=[UIColor grayColor];
        [buttonView addSubview:shuView];
        
    }
    
}

// 折扣和品牌都用到了他
-(void)touchButton:(UIButton*)sender{
    self.isShuaixuan=NO;
    for (int i=0; i<self.allButton.count; i++) {
        UIButton*button=self.allButton[i];
        button.selected=NO;
    }
    
    if (sender.selected==YES) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
        if (self.cate==isZhekou) {
            //折扣
            switch (sender.tag) {
                case 0:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    self.whichZhekou=@"1-3";
                    break;
                case 1:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    
                    self.whichZhekou=@"4-6";
                    
                    break;
                case 2:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    
                    self.whichZhekou=@"7-9";
                    
                    break;
                case 3:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    
                    self.whichZhekou=@"all";
                    
                    break;
                    
                default:
                    break;
            }
             [self zheKouJiekou];

        }else if (self.cate==thisIsGrobalSend){
            //全球包邮
            switch (sender.tag) {
                case 0:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    self.location=@"日本";
                    break;
                case 1:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    
                    self.location=@"韩国";
                    
                    break;
                case 2:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    
                    self.location=@"中国";
                    
                    break;
                case 3:
                    self.collectionViewAllDatas=[NSMutableArray array];
                    
                    self.location=@"美国";
                    
                    break;
                    
                default:
                    break;
            }
            
            [self globalSend];

        }
        
        
       
        
       
        
    }
    
}

-(void)zheKouJiekou{

//    http://www.vipxox.cn/? m=appapi&s=home_page&act=home_info&get=discount_area&discount=yes&d_area=1-3&pagen=10&pages=0
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"home_info",@"get":@"discount_area",@"discount":@"yes",@"d_area":self.whichZhekou,@"pagen":pagen,@"pages":pages,@"uid":[UserSession instance].uid};
    
    HttpManager*manger=[[HttpManager alloc]init];
    [manger getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [self.collectionViewAllDatas addObjectsFromArray:data[@"data"][@"list"]];
            self.zhekouPic=data[@"data"][@"top"];
            [self zhekouRefreshPic];
            
        }
        
        
        [self.collectionView reloadData];

    }];
    
    
}

#pragma mark -------只有折扣专区和  全球包邮  有 才有  轮播图
-(void)zhekouRefreshPic{
    [self.cycleScrollView removeFromSuperview];
    //zhekouPic 里面［0］［img］    还有［0］［@“name”］
    NSArray*allImages=self.zhekouPic[0][@"img"];
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(180)) imagesGroup:allImages andPlaceholder:@"placeholderx375x180"];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3.0;
        [self.collectionView addSubview:_cycleScrollView];

    self.naviTitle=self.zhekouPic[0][@"name"];
    if ([self.delegate respondsToSelector:@selector(DelegateForTitle:)]) {
        [self.delegate DelegateForTitle:self.naviTitle];
    }
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
}


#pragma mark ----------------   collectionView
-(void)creatCollectionView{
    _flowLayout=[[UICollectionViewFlowLayout alloc]init];
    _flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
//    flowLayout.minimumLineSpacing=10;
//    _flowLayout.minimumInteritemSpacing=ACTUAL_WIDTH(16);
    _flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(161),267-214+ ACTUAL_HEIGHT(214));
    _flowLayout.sectionInset=UIEdgeInsetsMake(ACTUAL_HEIGHT(10), ACTUAL_WIDTH(18), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(18));
    
    //ACTUAL_HEIGHT(288)
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, KScreenHeight-64) collectionViewLayout:_flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
//    self.collectionView.showsVerticalScrollIndicator=NO;
//    self.collectionView.backgroundColor=RGBCOLOR(235, 236, 237, 1);
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:FOODCAREGORY bundle:nil] forCellWithReuseIdentifier:FOODCAREGORY];
    
    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.collectionViewAllDatas==nil) {
        return 0;
    }else{
        NSLog(@"%lu",(self.collectionViewAllDatas.count+1)/2);
        return (self.collectionViewAllDatas.count+1)/2;
       
        

    }
   }
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.collectionViewAllDatas==nil) {
        return 0;
    }else{
        NSInteger row=self.collectionViewAllDatas.count%2;
        NSInteger ss=(self.collectionViewAllDatas.count+1)/2;
        
        if (row!=0&&section==ss-1) {
            return 1;
        }else{
            return 2;
        }
        
    }
     }
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FoodCaregoryCollectionViewCell*cell=[self.collectionView dequeueReusableCellWithReuseIdentifier:FOODCAREGORY forIndexPath:indexPath];
    
    if (self.collectionViewAllDatas.count==0) {
        return cell;
    }else{
    NSLog(@"%@",self.collectionViewAllDatas);
    NSLog(@"%@",indexPath);
    NSInteger number=indexPath.section*2+indexPath.row;
    NSDictionary*dict=self.collectionViewAllDatas[number];
    
    
    UIImageView*imageView=[cell viewWithTag:1];
        imageView.backgroundColor=[UIColor whiteColor];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_162x214"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    UILabel*title=[cell viewWithTag:2];
        imageView.backgroundColor=[UIColor whiteColor];
//    title.text=[NSString stringWithFormat:@"%@",dict[@"name"]];
    title.text=dict[@"title"];
    UILabel*money=[cell viewWithTag:3];
    CGFloat aa=[dict[@"price"] floatValue];
    money.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,aa];
//    cell.backgroundColor=[UIColor greenColor];
    
    return cell;
    }
}

//head 多高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
     CGSize sizeZhekou=CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(224));
    CGSize sizeFenglei=CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(40));
    CGSize sizePingpai=CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(156));
    CGSize sizeGlobal=CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(225));
    if (section==0) {
        switch (self.cate) {
            case isZhekou:
               return sizeZhekou;
            case isfenlei:
                return sizeFenglei;

            case isPingpai:
                return sizePingpai;
            case isChaoliu:
               return sizePingpai;
            case thisIsGrobalSend:
                return sizeGlobal;
//            case thisIsShaixuan:
//                // 移除轮播图
//                return CGSizeMake(0, 0);

            default:
                break;
        }

        
    }
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu %lu",indexPath.section,indexPath.row);
    //数据也一起给过去
    NSInteger number=indexPath.section*2+indexPath.row;
    NSDictionary*dict=self.collectionViewAllDatas[number];
    if ([self.delegate respondsToSelector:@selector(DelegateMainControllerPush:)]) {
        [self.delegate DelegateMainControllerPush:dict];
    }

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
