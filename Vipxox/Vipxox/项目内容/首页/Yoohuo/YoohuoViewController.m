//
//  YoohuoViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/26.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "YoohuoViewController.h"
#import "CategoryViewController.h"
#import "HTM5ViewController.h"
#import "SDCycleScrollView.h"

#import "scrollTwoTableViewCell.h"   //section 0
#import "SectionOneTableViewCell.h"   //section 1
#import "SectionTwoTableViewCell.h"   //section 2
#import "NewHomePageCollectionViewCell.h"
#import "SectionThreeTableViewCell.h"  //section3
#import "SectionFourTableViewCell.h"   //section4
#import "bottomCollectionViewCell.h"


#import "DiscountViewController.h"    //折扣
#import "ZhekouViewController.h"



//#import "StarOriginateViewController.h"   //section0 row1  明星原创
#import "SuperStarViewController.h"    //明星原创
//#import "SYQRCodeViewController.h"  //


#import "H5LinkViewController.h"   //二维码跳转页

#import "UIButton+WebCache.h"


#import "SuperStarViewController.h"

//#import "FoodCategroyViewController.h"   //美食分类

#import "ChaoliuDapeiViewController.h"    //潮流

//#import "GoodsTailsViewController.h"
#import "NewGoodDetailViewController.h"

#import "WLBarcodeViewController.h"     //新的扫2维码
#import "NewSearchViewController.h"   //最新的搜索栏

#import "AdvertiseViewController.h"    //广告位的  主控制器


#define section0Cell  @"scrollTwoTableViewCell"
#define section1Cell  @"SectionOneTableViewCell"
#define section2Cell  @"SectionTwoTableViewCell"
 NSString *const collectionSection2 = @"NewHomePageCollectionViewCell";
#define section3Cell  @"SectionThreeTableViewCell"
#define section4Cell  @"SectionFourTableViewCell"
NSString*const collextionBottom=@"bottomCollectionViewCell";



@interface YoohuoViewController ()<UITableViewDataSource,UITableViewDelegate,CategoryViewControllerDelegate,ChinaSuperMarketViewControllerDelegate,SDCycleScrollViewDelegate,scrollTwoTableViewCellDelegate,SectionOneTableViewCellDelegate,SectionTwoTableViewCellDelegate,SectionThreeTableViewCellDelegate,SectionFourTableViewCellDelegate,UIAlertViewDelegate>;

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CategoryViewController*category;
@property(nonatomic,strong)UIView*cover;   //蒙板
@property(nonatomic,strong)NSString*get;  //接口参数之一   判断男生女生

//@property(nonatomic,strong)NSMutableArray*allDatas;    //保存所有数据

@property(nonatomic,strong)NSArray*arrayCollectionView; //最底部的一大堆collection的数据

//数据拆分


@property(nonatomic,strong)NSArray*Arrayheader;  //抬头广告栏
@property(nonatomic,strong)NSArray*ArrayBottomHeader;  //底部2个

@property(nonatomic,strong)NSArray*Arraysection0fenglei;   //section0 24个分类
@property(nonatomic,strong)NSArray*Arraysection1Pingpai;   //section1  热门品牌
@property(nonatomic,strong)NSArray*Arraysection2Dapei;   //section2   搭配
@property(nonatomic,strong)NSArray*Arraysection3Chaoliu;   //section3   潮流
@property(nonatomic,strong)NSMutableArray*ArraySection4Bottom;    //底部的

@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,assign)NSInteger pagen;

@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)UIImageView*imageView;
@property(nonatomic,strong)NSString *str;

#warning 二维码
@property(nonatomic,strong)NSString *saveQRCode;   //保存二维码

//@property(nonatomic,assign)BOOL NOLogin;  没有登录 刷新

@end

@implementation YoohuoViewController

-(instancetype)init{
    self=[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAll) name:@"HomeAndFoodReload" object:nil];
    }
    return self;
}

-(void)reloadAll{
    [self.tableView headerBeginRefreshing];
    
}

-(CategoryViewController *)category{
    if (!_category) {
  
        _category=[[CategoryViewController alloc]init];
        _category.xcolor=self.xcolor;

        
        _category.view.frame=CGRectMake(-KScreenWidth, 0, KScreenWidth, KScreenHeight);
     
        _category.delegate=self;
        
    }
    return _category;
    
}


-(UIView *)cover{
    if (!_cover) {
        _cover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _cover.backgroundColor=[UIColor blackColor];
        _cover.alpha=0;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenCover)];
        [_cover addGestureRecognizer:tap];
        
      
        
        
    }
    return _cover;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=RGBCOLOR(235, 236, 237, 1);
//        _tableView.backgroundColor=[UIColor redColor];
//        NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    }
    return _tableView;
}

//自动登录接口
-(void)autoLogin{
    NSUserDefaults*defaults= [NSUserDefaults standardUserDefaults];
    NSString*account=[defaults objectForKey:AUTOLOGIN];
    NSString*code=[defaults objectForKey:AUTOLOGINCODE];

    if ([[defaults objectForKey:ISTHIRDLOGIN] isEqualToString:@"YES"]) {
        //这2个 没有值   就是没登录过
        NSDictionary*params=[defaults objectForKey:ISTHIRDPARAMS];
        NSString*strUrl=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
       HttpManager*manager=[[HttpManager alloc]init];
        
        
        [manager getDataFromNetworkWithUrl:strUrl parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                //直接登录   说明已经绑定过了  微信 直接登录
                
                NSDictionary*user=data[@"data"][@"user"];
                NSArray*address=data[@"data"][@"address"];
                
                UserSession*session=[UserSession instance];
                [session setValuesForKeysWithDictionary:user];
                session.address=address;
                //已经登录改为yes
                session.isLogin=YES;
                
#warning ---这里的自动登录  要变成第三方  自动登录
                
                //自动登录
                NSUserDefaults*Nsuser=[NSUserDefaults standardUserDefaults];
                [Nsuser setObject:@"YES" forKey:ISTHIRDLOGIN];
                [Nsuser setObject:params forKey:ISTHIRDPARAMS];
                
#warning 自动刷新(一进入程序就下拉刷新)
                [self.tableView headerBeginRefreshing];


                
            }else{
                [JRToast showWithText:data[@"errormsg"]];
                //密码错误的话
                NSUserDefaults*user= [NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:ISTHIRDLOGIN];
                [user removeObjectForKey:ISTHIRDPARAMS];
                UserSession*session=[UserSession instance];
                session=nil;

                
                
            }

            
            
        }];
        
        
    }else if (account&&code){
    
    //接口
    //        http://www.vipxox.cn/? m=appapi&s=login&user=baobao&pwd=123456
    NSString*url=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"login",@"user":account,@"pwd":code};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:url parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            NSDictionary*user=data[@"data"][@"user"];
            NSArray*address=data[@"data"][@"address"];
            
            UserSession*session=[UserSession instance];
            
            [session setValuesForKeysWithDictionary:user];
            session.address=address;
            session.isLogin=YES;
            
#warning 自动刷新(一进入程序就下拉刷新)
            [self.tableView headerBeginRefreshing];

       
        }else{
            //密码错误的话
            NSUserDefaults*user= [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:AUTOLOGIN];
            [user removeObjectForKey:AUTOLOGINCODE];
            UserSession*session=[UserSession instance];
            session=nil;
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            


            //            XXTabBarController*vc= [[XXTabBarController alloc]init];
            //            [self presentViewController:vc animated:YES completion:nil];
            
           
        }
        
        
    }];

    }else{
        //不登录啊。。

        
    }
    
    
}
-(void)getColor{
#warning 颜色
    if (_xcolor==0) {
        [self.navigationController.navigationBar setBarTintColor:ManColor];

    }else if (_xcolor==1){
        [self.navigationController.navigationBar setBarTintColor:YooPink];

    }else if (_xcolor==2){
        [self.navigationController.navigationBar setBarTintColor:BoyColor];

    }else if (_xcolor==3){
        [self.navigationController.navigationBar setBarTintColor:NorthAmercia];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark  ---   刚登录时候的广告   点击的话 跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];



    
    
     [self autoLogin];
  
    self.pagen=10;
    self.pages=-1;    //下拉后从0 开始

   
    
    [self makeNaviButton];
    [self.view addSubview:self.tableView];
//    self.tableView.estimatedRowHeight=300;
//    self.tableView.rowHeight=UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchGuangjie:) name:@"gotoHtml" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchSixcate:) name:@"gotosixCategroy" object:nil];
//    self.tableView.backgroundColor=[UIColor yellowColor];
    [self setupRefresh];  //刷新
    self.cate=0;    //男生
   
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:section0Cell bundle:nil] forCellReuseIdentifier:section0Cell];
    [self.tableView registerNib:[UINib nibWithNibName:section1Cell bundle:nil] forCellReuseIdentifier:section1Cell];
    [self.tableView registerNib:[UINib nibWithNibName:section2Cell bundle:nil] forCellReuseIdentifier:section2Cell];
    [self.tableView registerNib:[UINib nibWithNibName:section3Cell bundle:nil] forCellReuseIdentifier:section3Cell];
    [self.tableView registerNib:[UINib nibWithNibName:section4Cell bundle:nil] forCellReuseIdentifier:section4Cell];
    
//        self.navigationController.navigationBar.alpha=0.1;
  }

#pragma mark  -------   点击广告位
- (void)pushToAd {
    
    AdvertiseViewController *adVc = [[AdvertiseViewController alloc] init];
    adVc.adUrl=[kUserDefaults objectForKey:@"adUrl"];
    [self.navigationController pushViewController:adVc animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//    self.navigationController.navigationBar.layer.masksToBounds = YES;

    self.navigationController.navigationBarHidden=NO;
      [self getColor];
}
-(void)getDatas{
    //
    self.pages=-1;
    
//    http://www.vipxox.cn/?m=appapi&s=home_page&act=home_info&get=boys
//    http://www.vipxox.cn/?m=appapi&s=home_page&act=home_info&get=life_style
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    if (self.cate==isMan) {
        self.get=@"boys";
    }else if (self.cate==isGirl){
        self.get=@"girls";
    }else if (self.cate==isBabyBoy){
       self.get=@"kids";
    }else if (self.cate==isNorthAmerica){
        self.get=@"life_style";
    }
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"home_info",@"get":self.get,@"uid":[UserSession instance].uid};
//    NSLog(@"%@",[UserSession instance].uid);
//    NSLog(@"%@",[UserSession instance].currency);
   HttpManager*manger= [[HttpManager alloc]init];
[manger getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
    NSLog(@"%@",data);
    
    self.ArrayBottomHeader=[NSArray array];
    self.Arrayheader=[NSArray array];
    self.Arraysection0fenglei=[NSArray array];
    self.Arraysection1Pingpai=[NSArray array];
    self.Arraysection2Dapei=[NSArray array];
    self.Arraysection3Chaoliu=[NSArray array];
    self.ArraySection4Bottom=[NSMutableArray array];

    if ([data[@"errorCode"] isEqualToString:@"0"]) {
      
        
        self.Arrayheader=data[@"data"][@"adv_top"][@"con_list"];   //头 3
        self.ArrayBottomHeader=data[@"data"][@"adv_ymlup"];   //头底  2ge
        
        self.Arraysection0fenglei=data[@"data"][@"c_catinfo"];   // 分类 1
        self.Arraysection1Pingpai=data[@"data"][@"brand"];     //    1
//        self.Arraysection1Pingpai=nil;
        self.Arraysection2Dapei=data[@"data"][@"adv_branddown"];    //搭配1
        self.Arraysection3Chaoliu=data[@"data"][@"adv_tjdpdown"];    //6个类
    
//        self.ArraySection4Bottom=data[@"data"][@"youmaylike"];  //底部  1
        [self.ArraySection4Bottom addObjectsFromArray:data[@"data"][@"youmaylike"]];
        
//         self.allDatas=[NSMutableArray array]; 
//        [self.allDatas addObjectsFromArray:self.Arraysection0fenglei];
//        [self.allDatas addObjectsFromArray:self.Arraysection1Pingpai];
//        [self.allDatas addObjectsFromArray:self.Arraysection2Dapei];
//        [self.allDatas addObjectsFromArray:self.Arraysection3Chaoliu];
//        [self.allDatas addObjectsFromArray:self.ArraySection4Bottom];
        
//        NSLog(@"%lu",(unsigned long)self.allDatas.count);
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }else{
        [JRToast showWithText:data[@"errorMessage"]];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        return;
    }
    
    

    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
}];
    
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];

    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableView.headerRefreshingText = @"正在刷新中";
//    
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tableView.footerRefreshingText = @"正在加载中";
}

#pragma mark 开始进入刷新状态-------   上啦刷新
- (void)headerRereshing
{
    // 1.添加假数据
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        // 刷新表格
    self.pages=-1;
     [self getDatas];
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
 
}


//#pragma mark -----带菊花的下拉刷新
//-(void)headerBeginWithJuhua{
//    self.pages=-1;
//
//    
//}

//下拉刷新
- (void)footerRereshing
{
    
    
#warning 需要接口  只给底部的加数据
//    self.ArraySection4Bottom
    
//    http://www.vipxox.cn/? m=appapi&s=home_page&act=cat4pages&get=boys&pages=0&pagen=10
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*strWho=[[NSString alloc]init];
    if (self.cate==isMan) {
        strWho=@"boys";
    }else if (self.cate==isGirl){
        strWho=@"girls";
    }else if (self.cate==isBabyBoy){
        strWho=@"kids";
    }else if (self.cate==isNorthAmerica){
        strWho=@"Life_style";
    }
    self.pages++;
    NSString*pages=[NSString stringWithFormat:@"%ld",(long)self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"cat4pages",@"get":strWho,@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid};
    
    HttpManager *manger=[[HttpManager alloc]init];
    [manger getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSLog(@"%lu",(unsigned long)self.ArraySection4Bottom.count);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
//            for (int i=0; i<[data[@"data"] count]; i++) {
//                NSDictionary*dict=data[@"data"][i];
//                [self.ArraySection4Bottom[0] addObject:dict];
//            }
            NSArray*array=data[@"data"];
                 NSLog(@"%@",[self.ArraySection4Bottom[0] class]);
            NSMutableArray*mutableArray=[self.ArraySection4Bottom[0] mutableCopy];
            
            [mutableArray addObjectsFromArray:array];
            self.ArraySection4Bottom[0]=[mutableArray copy];
//
//            NSMutableArray*mutableArray=(NSMutableArray*)self.ArraySection4Bottom[0];
//            [mutableArray addObjectsFromArray:array];
            
//            NSMutableArray*mutableArray=[self.ArraySection4Bottom[0] mutableCopy];
//            [mutableArray addObjectsFromArray:array];
         
            NSLog(@"%lu",(unsigned long)self.ArraySection4Bottom.count);
            
            // 刷新表格
            [self.tableView reloadData];
            if ([self.delegate respondsToSelector:@selector(DelegateCollectionToReload)]) {
                [self.delegate DelegateCollectionToReload];
            }
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView footerEndRefreshing];
            

            
        }else{
            [self.tableView footerEndRefreshing];
        }
        
        
    }];
          }



-(void)makeNaviButton{

    
//    UIView*leftNaviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ACTUAL_WIDTH(60), ACTUAL_HEIGHT(30))];
//    leftNaviView.backgroundColor=[UIColor greenColor];

    UIButton*fenlei=[UIButton buttonWithType:0];
    fenlei.frame=CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(5), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(18));
    [fenlei setBackgroundImage:[UIImage imageNamed:@"home_caidan"] forState:UIControlStateNormal];
    [fenlei addTarget:self action:@selector(touchFenlei:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*item0=[[UIBarButtonItem alloc]initWithCustomView:fenlei];
//    [leftNaviView addSubview:fenlei];
    
    UIButton*sousou=[UIButton buttonWithType:0];
    sousou.frame=CGRectMake(ACTUAL_WIDTH(38), ACTUAL_HEIGHT(5), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20));
    [sousou setBackgroundImage:[UIImage imageNamed:@"home_sousuosuo"] forState:UIControlStateNormal];
    [sousou addTarget:self action:@selector(touchSousou) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*item1=[[UIBarButtonItem alloc]initWithCustomView:sousou];
//    [leftNaviView addSubview:sousou];
    
//    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:leftNaviView];
    //,item1  隐藏
    
    //来个 搜索
    UIBarButtonItem*sousuo=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_sousuosuo"] style:UIBarButtonItemStylePlain target:self action:@selector(touchSousousou)];
    
    
    self.navigationItem.leftBarButtonItems=@[item0,sousuo];
    
    
    
#pragma mark 标题LOGO
//    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(135), ACTUAL_HEIGHT(6), ACTUAL_WIDTH(105), ACTUAL_HEIGHT(27))];
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ACTUAL_WIDTH(82), ACTUAL_HEIGHT(24))];
    _imageView.image=[UIImage imageNamed:@"home_title"];
//    [self.view addSubview:imageView];
//    UIBarButtonItem*titleItem=[[UIBarButtonItem alloc]initWithCustomView:imageView];
//    self.navigationItem.titleView=titleItem;
//    [self.navigationController.navigationBar addSubview:imageView];
    NSLog(@"%@",NSStringFromCGRect(self.navigationItem.titleView.frame));
    self.navigationItem.titleView=_imageView;
    _str=@"1";
   
//    self.navigationItem.titleView.backgroundColor=[UIColor blackColor];
    
    
    UIButton*saosao=[UIButton buttonWithType:0];
    saosao.frame=CGRectMake(ACTUAL_WIDTH(338), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(18));
//    saosao.backgroundColor=[UIColor blackColor];
    [saosao addTarget:self action:@selector(touchSaosao) forControlEvents:UIControlEventTouchUpInside];
    [saosao setBackgroundImage:[UIImage imageNamed:@"homw_saoyisao"] forState:UIControlStateNormal];
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithCustomView:saosao];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    
    
    
}
#pragma mark  --- 搜索
-(void)touchSousousou{
    NewSearchViewController*vc=[[NewSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}





//-------------－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


#pragma mark ----------扫描二维码
-(void)touchSaosao{
    
    WLBarcodeViewController *vc=[[WLBarcodeViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        
        if (isScceed) {
            NSLog(@"扫描后的结果~%@",str);
            self.saveQRCode=str;
            //扫描结果   0 有id 跳商品详情（某宝自己的界面）    －1 一维码无id 不跳      －2二维码 跳网页
            //小罗 接口
//            www.vipxox.cn/?    m=appapi&s=home_page&act=69_code&uid=q&code=
            NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
            NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"69_code",@"uid":[UserSession instance].uid,@"code":self.saveQRCode};
            HttpManager*manager=[[HttpManager alloc]init];
            [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
                NSLog(@"%@",data);
                if ([data[@"errorCode"] isEqualToString:@"0"]) {
                    //扫描的结果  后台有数据  传回来 id
                    NSDictionary*dict=@{@"id":data[@"data"]};
//                    GoodsTailsViewController *vc=[[GoodsTailsViewController alloc]init];
//                    vc.thisDatas=dict;
//                    [self.navigationController pushViewController:vc animated:YES];

                    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                }else if ([data[@"errorCode"] isEqualToString:@"-1"]){
                    //扫描结果后台无数据  是一维码   直接提示 没有
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:self.saveQRCode delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    
                    
                }else if ([data[@"errorCode"] isEqualToString:@"-2"]){
                    //扫描结果后台 无数据   是二维码   直接跳转到网页
                    // －2
                    NSString*strr=[NSString stringWithFormat:@"可能存在风险，是否打开此链接?\n %@",str];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开链接", nil];
                    [alert show];

                    
                    
                }else{
                    [JRToast showWithText:@"666"];
                }
                
                
                
                
            }];
            
            
            
            
            
        }else{
            NSLog(@"扫描后的结果~%@",str);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果" message:@"无法识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    
    
    
    [self presentViewController:vc animated:YES completion:nil];

    
   
    
}

-(void)aa{
    //扫描二维码
    //    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    //    qrcodevc.xcolor=self.xcolor;
    //
    //    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
    //
    //        if (0) {
    //
    //        } else {
    //            NSLog(@"%@",qrString);
    //            H5LinkViewController *h5LinkVC = [[H5LinkViewController alloc]init];
    //            h5LinkVC.h5LinkString = qrString;
    //            [self.navigationController pushViewController:h5LinkVC animated:YES];
    //        }
    //
    //
    //        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    //    };
    //
    //    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
    ////        self.saomiaoLabel.text = @"fail~";
    //        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    //    };
    //
    //    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
    //        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    ////        self.saomiaoLabel.text = @"cancle~";
    //    };
    //    [self presentViewController:qrcodevc animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //没有0 的 只有1
    if (buttonIndex==1) {
        H5LinkViewController *h5LinkVC = [[H5LinkViewController alloc]init];
        h5LinkVC.h5LinkString = self.saveQRCode;
       [self.navigationController pushViewController:h5LinkVC animated:YES];
        
    }
    
    
}

//---------－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－




#pragma mark---- delegate   Category 点击分类 给类赋值
-(void)touchCategory:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    [self hiddenCover];
   
//    TMGoodsDetailsViewController*vc=[[TMGoodsDetailsViewController alloc]init];
//    TMAppDelegate*delegate=(TMAppDelegate*)[UIApplication sharedApplication].delegate;
//    [delegate.navigationController pushViewController:vc animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
//折扣专区

            ZhekouViewController*vc=[[ZhekouViewController alloc]init];
            vc.xColor=self.xcolor;
            vc.disCount.cate=isZhekou;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row==1){
            //明星原创
            SuperStarViewController*vc=[[SuperStarViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row==2){
            //全球包邮
            ZhekouViewController*vc=[[ZhekouViewController alloc]init];
            vc.xColor=self.xcolor;
            vc.disCount.cate=thisIsGrobalSend;
            [self.navigationController pushViewController:vc animated:YES];

            
        }
        
        
    }else{
                    self.tableView.contentOffset=CGPointMake(0, -ACTUAL_HEIGHT(64));
        if (indexPath.row==0) {
            self.xcolor=0;
              [self getColor];
        }else if (indexPath.row==1){
            self.xcolor=1;
              [self getColor];
        }else if (indexPath.row==2){
            self.xcolor=2;
              [self getColor];
        }else if (indexPath.row==3){
            self.xcolor=3;
              [self getColor];
        }else{
            self.xcolor=0;
        }
        //分类
        self.cate=indexPath.row;
        NSLog(@"%lu %ld",self.cate,(long)self.cate);
        
        
      
        [self getDatas];

    }
    
    
    
}

//逛街
-(void)touchGuangjie:(NSNotification*)notification{
    NSLog(@"%@",notification.userInfo);
    NSArray*array=@[@"https://m.taobao.com/",@"https://www.tmall.com/?20150717&spm=a1z15.419.3393.10417&ad_id=1001316003c39ff113fc&jlogid=a1612385918114",@"https://jhs.m.taobao.com/m/index.htm?ali_trackid=2:mm_112166890_11564880_41498639:1455613876_252_79033039&e=t_2j5VGY7Cpw4vFB6t2Z2iperVdZeJviEViQ0P1Vf2kguMN8XjClAoJzSI_o08m1JgcT6S_-S_Z8_kO29cX47Zwk2wUJlqzS_TuKgXWM7uEGD54UZTmdHqb6h-auVgdyXhvQRrBlV3hCMC_a1h2zjZVCizm7Zzl_Rj9GX61gdwb32BOLOBoyQFWbCY77MCk9&type=2",@"http://m.jd.com/?cu=true&utm_source=baidu-pinzhuan&utm_medium=cpc&utm_campaign=t_288551095_baidupinzhuan&utm_term=ba6fb982ce824f8382e493214bab3b10_0_2a6a4ce4a86d438cb5a701446e05a1fa",@"http://m.dangdang.com/touch/?unionid=P324389-m-1&_utm_brand_id=10871",@"http://m.shishangqiyi.com/",@"http://m.suning.com"];
    [self hiddenCover];
    NSIndexPath*index=notification.userInfo[@"key"];
    NSString*str=array[index.row];
    HTM5ViewController*vc=[[HTM5ViewController alloc]init];
    vc.strHtml=str;
    [self.navigationController pushViewController:vc animated:YES];


}

#warning  华人超市。。。
//跳转到6个美食界面
-(void)touchSixcate:(NSNotification*)notification{
    NSLog(@"%@",notification.userInfo);
    [self hiddenCover];

      NSIndexPath*index=notification.userInfo[@"key"];
    NSLog(@"%lu",index.row);
      NSInteger xx=index.row;
    if (index.row==0) {
        xx=0;
    }else{
        xx=index.row;
    }
  


#pragma mark -- --   美食取消
//        FoodCategroyViewController*vc=[[FoodCategroyViewController alloc]init];
//        vc.whichC=xx;
//        [self.navigationController pushViewController:vc animated:YES];
    
//  //接口
////    http://www.vipxox.net/? m=appapi&s=home_page&act=home_snacks_zy&zt=category&uid=q
//    NSString*strUrl=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
//NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"home_snacks_zy",@"zt":@"category",@"uid":[UserSession instance].uid};
//   HttpManager*manager=[[HttpManager alloc]init];
//    [manager getDataFromNetworkWithUrl:strUrl parameters:params compliation:^(id data, NSError *error) {
//        NSLog(@"%@",data);
//        if ([data[@"errorCode"] isEqualToString:@"0"]) {
//            NSLog(@"%lu",rrr);
//                NSDictionary*dict= data[@"data"][rrr];
//            FoodCategroyViewController*vc=[[FoodCategroyViewController alloc]init];
//                vc.dict=dict;
//            [self.navigationController pushViewController:vc animated:YES];
//
//            
//        }else{
//            [JRToast showWithText:data[@"errorMessage"]];
//        }
//        
//        
//    }];
    

    

    
    
}


#pragma mark  ---- touch button
-(void)touchFenlei:(UIButton*)sender{
//    if (sender.selected) {
//        sender.selected=NO;
//    }else{
//        sender.selected=YES;
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self.cover];
      [window addSubview:self.category.view];
    
//    CategoryViewController*category=[[CategoryViewController alloc]init];
//    category.view.frame=CGRectMake(0, 0, ACTUAL_WIDTH(250), KScreenHeight);
//    [_cover addSubview:category.view];

    
        CGRect rect=CGRectMake(-KScreenWidth+ACTUAL_WIDTH(250), 0, KScreenWidth, KScreenHeight);
        [UIView animateWithDuration:0.5 animations:^{
            self.category.view.frame=rect;
            self.cover.alpha=0.5;
            
        }];
        
    [self tabBarGo];
    
//    }
    
}

- (void)hiddenCover{
    CGRect rect=CGRectMake(-KScreenWidth, 0, KScreenWidth, KScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.category.view.frame=rect;
        self.cover.alpha=0;

    }];
     [self tabBarGohome];
    //通知分类控制器移除 覆盖的view
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeCategory" object:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeCateVC:) userInfo:nil repeats:NO];

    
}
-(void)removeCateVC:(NSTimer*)timer{
    [self.category.view removeFromSuperview];
    [self.category dismissViewControllerAnimated:NO completion:nil];
    self.category=nil;
    timer=nil;
    [timer invalidate];
    
}

//发送请求  tabBar 偏移
-(void)tabBarGo{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YoohooGo" object:nil];
    
}
//发送通知  tabBar 回来
-(void)tabBarGohome{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YoohooGohome" object:nil];
}
#pragma mark  ----tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%lu",(unsigned long)self.Arraysection2Dapei.count);
    
    return self.Arraysection0fenglei.count+self.Arraysection1Pingpai.count+self.Arraysection2Dapei.count+self.Arraysection3Chaoliu.count+self.ArraySection4Bottom.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.textLabel.text=@"666";
    }
    NSInteger row0=self.Arraysection0fenglei.count;
    NSInteger row1=self.Arraysection1Pingpai.count;
    NSInteger row2=self.Arraysection2Dapei.count;
    NSInteger row3=self.Arraysection3Chaoliu.count;
    NSInteger row4=self.ArraySection4Bottom.count;
    
    if (indexPath.section>=0&&indexPath.section<row0) {
        //0
        scrollTwoTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:section0Cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
        cell.allDatas=self.Arraysection0fenglei;

              return cell;

        
    }else if (indexPath.section>=row0&&indexPath.section<row0+row1){
        //1
        SectionOneTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:section1Cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
             cell.delegate=self;
        cell.allDatas=self.Arraysection1Pingpai[indexPath.section-row0];
        
//        self.delegate=cell;
//        if ([self.delegate respondsToSelector:@selector(DelegateForSectionOneCell:)]) {
//            [self.delegate DelegateForSectionOneCell:self.Arraysection1Pingpai[indexPath.section-row0]];
//        }
        
    
        
        return cell;

    }else if (indexPath.section>=row0+row1&&indexPath.section<row0+row1+row2){
        //2   潮流
        SectionTwoTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:section2Cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.tableViewIndexPath=indexPath;
        cell.delegate=self;
        
        cell.allDatas=self.Arraysection2Dapei[indexPath.section-row0-row1];
        
        
//        self.delegate=cell;
//        if ([self.delegate respondsToSelector:@selector(DelegateForSectionTwoCell:)]) {
//            [self.delegate DelegateForSectionTwoCell:self.Arraysection2Dapei[indexPath.section-row0-row1]];
//            
//        }
        return cell;

    }else if (indexPath.section>=row0+row1+row2&&indexPath.section<row0+row1+row2+row3){
        //3
        SectionThreeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:section3Cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
        self.delegate=cell;
        if ([self.delegate respondsToSelector:@selector(DelegateForSectionThreeCell:)]) {
            NSLog(@"%lu",indexPath.section-row0-row1-row2);
            [self.delegate DelegateForSectionThreeCell:self.Arraysection3Chaoliu[indexPath.section-row0-row1-row2]];
        }
        
        return cell;
        
    }else if (indexPath.section>=row0+row1+row2+row3&&indexPath.section<row0+row1+row2+row3+row4){
        //4
       
        
        SectionFourTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:section4Cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
//        self.delegate=cell;
        cell.tableViewIndexPath=indexPath;
        [cell.collectionView reloadData];
        
        return cell;


    }
    
    
    return cell;
}

//section1 代理加载图片
-(void)cellDelegateToAddPhoto:(NSArray *)allButtons{
    for (int i=0; i<allButtons.count; i++) {
        
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    NSInteger row0=self.Arraysection0fenglei.count;
    NSInteger row1=self.Arraysection1Pingpai.count;
    NSInteger row2=self.Arraysection2Dapei.count;
    NSInteger row3=self.Arraysection3Chaoliu.count;
    NSInteger row4=self.ArraySection4Bottom.count;

    
    if (indexPath.section>=0&&indexPath.section<row0) {
        return ACTUAL_HEIGHT(355);
    }else if (indexPath.section>=row0&&indexPath.section<row0+row1){
        return ACTUAL_HEIGHT(228);
    }else if (indexPath.section>=row0+row1&&indexPath.section<row0+row1+row2){
//        return ACTUAL_HEIGHT(377);
//        return UITableViewAutomaticDimension;
        return (377-82-165-30)+ACTUAL_HEIGHT((82+165));
    }else if (indexPath.section>=row0+row1+row2&&indexPath.section<row0+row1+row2+row3){
        return ACTUAL_HEIGHT(490);
    }else if (indexPath.section>=row0+row1+row2+row3&&indexPath.section<row0+row1+row2+row3+row4){
        
#warning －－－－ 需要考虑到 刷新 增加数据后  高度的变化
//        NSInteger aa= self.arrayCollectionView.count/2;
//        if (self.arrayCollectionView.count%2==0) {
//            NSLog(@"%f",ACTUAL_HEIGHT(34)+ACTUAL_HEIGHT(286)*aa);
//            return ACTUAL_HEIGHT(34)+ACTUAL_HEIGHT(286)*aa;
//        }else{
//            NSLog(@"%f",ACTUAL_HEIGHT(34)+ACTUAL_HEIGHT(286)*(aa+1));
//
//            return ACTUAL_HEIGHT(34)+ACTUAL_HEIGHT(286)*(aa+1);
//        }
       
//        NSUInteger cc=(NSUInteger)[self.ArraySection4Bottom[0] count];
        NSArray*array=self.ArraySection4Bottom[0];
        
       NSInteger aa= ([array count]+1)/2;
//        return ACTUAL_HEIGHT(34)+ACTUAL_HEIGHT(286)*aa;
        
        return  (263-214+ACTUAL_HEIGHT(214)+ACTUAL_HEIGHT(22))*aa+34;
    }

    
    
    return ACTUAL_HEIGHT(490);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger row0=self.Arraysection0fenglei.count;
    NSInteger row1=self.Arraysection1Pingpai.count;
    NSInteger row2=self.Arraysection2Dapei.count;
    NSInteger row3=self.Arraysection3Chaoliu.count;
    NSInteger row4=self.ArraySection4Bottom.count;

    
    if (section==0) {
        return ACTUAL_HEIGHT(199);
    }else if (section==row0+row1+row2+row3){
        if (self.cate==isMan||self.cate==isGirl) {
            return ACTUAL_HEIGHT(134);

        }else{
            return ACTUAL_HEIGHT(17);
        }
        
           }
    return ACTUAL_HEIGHT(17);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger row0=self.Arraysection0fenglei.count;
    NSInteger row1=self.Arraysection1Pingpai.count;
    NSInteger row2=self.Arraysection2Dapei.count;
    NSInteger row3=self.Arraysection3Chaoliu.count;
    NSInteger row4=self.ArraySection4Bottom.count;

    
    if (section==0) {
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0,0 , KScreenWidth,ACTUAL_HEIGHT(199) )];
        mainView.backgroundColor=RGBCOLOR(235, 236, 237, 1);
        
        //ACTUAL_HEIGHT(181)
        NSMutableArray*allImages=[NSMutableArray array];
        for (int i=0; i<self.Arrayheader.count; i++) {
            [allImages addObject:self.Arrayheader[i][@"picName"]];
        }
        
//        NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
//                            [UIImage imageNamed:@"h2.jpg"],
//                            [UIImage imageNamed:@"h3.jpg"],
//                            [UIImage imageNamed:@"h4.jpg"]
//                            ];

        // 创建不带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth,ACTUAL_HEIGHT(180)) imagesGroup:allImages andPlaceholder:@"placeholder_375x180"];
        cycleScrollView.delegate = self;
        cycleScrollView.autoScrollTimeInterval = 3.0;
        
        [mainView addSubview:cycleScrollView];

        
        return mainView;
        NSLog(@"%ld",(long)self.cate);
    }else if (section==row0+row1+row2+row3){
        if (self.cate==isMan||self.cate==isGirl) {
            
            UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(138))];
            mainView.backgroundColor=RGBCOLOR(235, 236, 237, 1);
            
            
            UIButton*button=[UIButton buttonWithType:0];
            button.frame=CGRectMake(ACTUAL_WIDTH(14), ACTUAL_HEIGHT(23), ACTUAL_WIDTH(165), ACTUAL_HEIGHT(96));
            button.tag=0;
//            button.backgroundColor=[UIColor greenColor];
            [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:button];
            
            UIButton*button2=[UIButton buttonWithType:0];
            button2.frame=CGRectMake(ACTUAL_WIDTH(195), ACTUAL_HEIGHT(23), ACTUAL_WIDTH(165), ACTUAL_HEIGHT(96));
            button2.tag=1;
//            button2.backgroundColor=[UIColor yellowColor];
            [button2 addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:button2];
            button.backgroundColor=[UIColor whiteColor];
            button.imageView.contentMode=UIViewContentModeScaleAspectFit;

            [button sd_setImageWithURL:[NSURL URLWithString:self.ArrayBottomHeader[0][0][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_165x96"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
            button2.backgroundColor=[UIColor whiteColor];
            button2.imageView.contentMode=UIViewContentModeScaleAspectFit;

              [button2 sd_setImageWithURL:[NSURL URLWithString:self.ArrayBottomHeader[0][1][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_165x96"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
            
            
            
            return mainView;

        }
        
    }
    
    
    return nil;
}

#pragma mark section 0 点击触发的代理      cell  热门品类
-(void)touchSectionZero:(UIButton *)sender{
    NSLog(@"cell  %ld",(long)sender.tag);
    ZhekouViewController*vc=[[ZhekouViewController alloc]init];
    vc.xColor=self.xcolor;
    vc.disCount.cate=isfenlei;

    vc.disCount.allDatas=self.Arraysection0fenglei[0][sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - SDCycleScrollViewDelegate     section0   header点击事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
}
#pragma mark  --------各个cell 的点击事件
 //section 1
-(void)touchSectionOne:(UIButton *)sender{
//    NSLog(@"%lu",sender.tag);
    NSLog(@"%@",self.Arraysection1Pingpai[0]);
    
    ZhekouViewController*vc=[[ZhekouViewController alloc]init];
    vc.disCount.allDatas=self.Arraysection1Pingpai[0][sender.tag];
    vc.disCount.cate=isPingpai;
    vc.xColor=self.xcolor;
    [self.navigationController pushViewController:vc animated:YES];
}

//section 2
-(void)Twobutton:(UIButton *)sender{
    NSLog(@"%lu",sender.tag);
    
//    self.Arraysection2Dapei
    // 20 和21
    if (sender.tag==20) {
        ChaoliuDapeiViewController*vc=[[ChaoliuDapeiViewController alloc]init];
        vc.dict=self.Arraysection2Dapei[0][1][0];
        [self.navigationController pushViewController: vc animated:YES];

    }else{
        ChaoliuDapeiViewController*vc=[[ChaoliuDapeiViewController alloc]init];
        vc.dict=self.Arraysection2Dapei[0][1][1];
        [self.navigationController pushViewController: vc animated:YES];

    }
    
    
}

#pragma mark ------section2 下面的所有按钮  不包括上面2个
-(void)SectionTwoTableViewCell:(UICollectionView *)SectionTwoTableViewCell didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    NSLog(@"%ld",(long)contentIndexPath.row);
    //0   1 2
    ChaoliuDapeiViewController*vc=[[ChaoliuDapeiViewController alloc]init];
    vc.dict=self.Arraysection2Dapei[0][2][contentIndexPath.row];
    [self.navigationController pushViewController: vc animated:YES];
    
    
    
}


//section 3
-(void)touchImageButton:(UIButton *)sender andThisCellAllDatas:(NSArray *)array{
    NSLog(@"%lu",sender.tag);
    NSLog(@"%@",array);
//      NSArray*sixDict=array[0][@"con_list"];
    
    ZhekouViewController*vc=[[ZhekouViewController alloc]init];
    vc.disCount.cate=isChaoliu;
    vc.disCount.allDatas=array[0][@"con_list"][sender.tag];
    vc.xColor=self.xcolor;
    [self.navigationController pushViewController:vc animated:YES];

   
}

//最后一行的header 的2个button
-(void)touchBottomButton:(UIButton*)sender{
    NSLog(@"%lu",sender.tag);
    if (sender.tag==0) {
        //
        SuperStarViewController*vc=[[SuperStarViewController alloc]init];
        vc.cate=ischaoliu;
       [self.navigationController pushViewController:vc animated:YES];

        
    }else{
        //明星
        SuperStarViewController*vc=[[SuperStarViewController alloc]init];
        vc.cate=isMingxing;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   collectionview 的代理
-(NSInteger)SectionTwoTableViewCell:(UICollectionView *)SectionTwoTableViewCell numberOfItemsInTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    NSInteger row0=self.Arraysection0fenglei.count;
    NSInteger row1=self.Arraysection1Pingpai.count;

    NSArray*array=self.Arraysection2Dapei[tableViewIndexPath.section-row0-row1][2];
    return [array count];
}

-(UICollectionViewCell*)SectionTwoTableViewCell:(UICollectionView *)SectionTwoTableViewCell cellForItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    NSLog(@"%@",tableViewIndexPath);
    NSInteger row0=self.Arraysection0fenglei.count;
    NSInteger row1=self.Arraysection1Pingpai.count;

    NewHomePageCollectionViewCell *cell;
    {
        cell = (NewHomePageCollectionViewCell *)[SectionTwoTableViewCell dequeueReusableCellWithReuseIdentifier:collectionSection2 forIndexPath:contentIndexPath];
//        cell.imageView0.backgroundColor=[UIColor yellowColor];
        cell.backgroundColor=[UIColor whiteColor];
        [cell.imageView0 sd_setImageWithURL:self.Arraysection2Dapei[tableViewIndexPath.section-row0-row1][2][contentIndexPath.row][@"picName"] placeholderImage:[UIImage imageNamed:@"placeholder_82x82"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                cell.imageView0.alpha=0.3;
                CGFloat scale = 0.3;
                cell.imageView0.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    cell.imageView0.alpha=1;
                    CGFloat scale = 1.0;
                    cell.imageView0.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
        
        
        return cell;
}
    return cell;
}


#pragma mark   -----bottom 的collectionview
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView withTable:(NSIndexPath *)tableViewIndexPath{
//    NSLog(@"%lu",([self.ArraySection4Bottom[0] count]+2)/2);
    NSArray*array=self.ArraySection4Bottom[0];
    return ([array count]+1)/2;
}

-(NSInteger)bottomCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arrayRow=self.ArraySection4Bottom[0];
    NSArray *arraySS=self.ArraySection4Bottom[0];
    NSInteger row=[arrayRow count]%2;
    NSInteger ss=([arraySS count]+1)/2;
    
    if (row!=0&&section==ss-1) {
        return 1;
    }else{
        return 2;
    }
    
    
   }

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath withTable:(NSIndexPath *)tableViewIndexPath{
    bottomCollectionViewCell *cell;
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:collextionBottom forIndexPath:indexPath];
    NSLog(@"%@",tableViewIndexPath);
    NSArray*array=self.ArraySection4Bottom[0];
    NSInteger number=indexPath.section*2+indexPath.row;
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:array[number][@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_162x214"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    UILabel*label0=[cell viewWithTag:2];
    label0.text=array[number][@"title"];
    UILabel*label1=[cell viewWithTag:3];
    CGFloat pricee=[array[number][@"price"] floatValue];
    label1.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,pricee];
    
    
    return cell;
    
}
#pragma mark  ----- 最后一行的点击
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath withTable:(NSIndexPath *)tableViewIndexPath{
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    NSInteger number=indexPath.section*2+indexPath.row;
    NSLog(@"%@",self.ArraySection4Bottom[0]);
 
    NSDictionary*dict=self.ArraySection4Bottom[0][number];
//    GoodsTailsViewController *vc=[[GoodsTailsViewController alloc]init];
//    vc.thisDatas=dict;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
    [self.navigationController pushViewController:vc animated:YES];
    

}





/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
