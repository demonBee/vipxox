//
//  NewPersonCenterViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/18.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewPersonCenterViewController.h"
#import "SystemSettingViewController.h"
#import "SecretaryMessageViewController.h"
#import "EnterAPPViewController.h"     //登录注册 控制器

#import "SystemImageViewController.h"    //系统自带的头像
#import "VPImageCropperViewController.h"    //拍照
#import "ImageCache.h"   //用于获得 string
#import "PersonalSignViewController.h"   //个性签名控制器


#import "NewPersonCenterSection0TableViewCell.h"    //cell 0
#import "NewPersionCenterSection1TableViewCell.h"    //cell  1

#define SECTION0   @"NewPersonCenterSection0TableViewCell"
#define SECTION1   @"NewPersionCenterSection1TableViewCell"
#define ORIGINAL_MAX_WIDTH 640.0f

//#import "CloudWareHouseViewController.h"     //废物
#import "NewCloudWareViewController.h"
   //新的云仓库


#import "InternationalOrderViewController.h"
#import "TMAddressViewController.h"
#import "MyCollectionViewController.h"
#import "ChooseCurrencyKindViewController.h"
#import "TransportAddressViewController.h"
#import "ExpenseRecordViewController.h"
#import "WithdrawDespositViewController.h"
#import "AccountRechargeViewController.h"
#import "CalTransViewController.h"      //计算运费
#import "OneYuanPurchaseViewController.h"    //新的个人中心

#import "NewDepartmentOrderViewController.h"   //百货个人中心


#import "ShoppingCentreOrderViewController.h"
#import "BuyOrderViewController.h"
#import "TransportOrderViewController.h"


#import "DepartShoppingCarViewController.h"

@interface NewPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView*headerContentView;
@property(nonatomic,strong)UIImageView*headerImageView;
@property (nonatomic, assign) CGFloat scale;
@property(nonatomic,strong)UIVisualEffectView*visualEffectView;    //蒙版效果

@property(nonatomic,strong)UIImageView*headImageView;    //头像
@property(nonatomic,strong)UILabel*titleLabel;          //个性签名
@property(nonatomic,strong)UIView*bottomMoneyView;       //钱的底视图
@property(nonatomic,strong)NSMutableArray*saveAllLabel;   //3个钱label
@property(nonatomic,strong)UIButton*loginButton;     //如果没有登录的话  加个 登录 button

@end

CGFloat const HeaderHeight=290.0;

@implementation NewPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
//    [self.view insertSubview:self.tableView atIndex:0];
   // [self.view bringSubviewToFront:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:SECTION0 bundle:nil] forCellReuseIdentifier:SECTION0];
    [self.tableView registerNib:[UINib nibWithNibName:SECTION1 bundle:nil] forCellReuseIdentifier:SECTION1];

    self.view.backgroundColor=[UIColor whiteColor];
    
    [self makeHeaderView];
    
//    [self setupRefresh];
    
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
      [self.tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.tableView headerEndRefreshing];
    
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
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:nil];
    


}

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];

    //判断 是否登录
    if ([UserSession instance].isLogin==NO) {
        //没有登录
        _headImageView.hidden=YES;
        _titleLabel.hidden=YES;
        _bottomMoneyView.hidden=YES;
        self.loginButton.hidden=NO;
        
        
        
    }else{
        _headImageView.hidden=NO;
        _titleLabel.hidden=NO;
        _bottomMoneyView.hidden=NO;
          self.loginButton.hidden=YES;

        //登录了
        //需要个 接口 改变钱
        [self jiekouGetMoney];
        
        
        
        //个信签名
        
        self.titleLabel.text=[UserSession instance].personality;
        
        //头像
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"placeholder_376x376"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.headImageView.alpha=0.3;
            self.headImageView.transform=CGAffineTransformMakeScale(0.3, 0.3);
            
            [UIView animateWithDuration:0.3 animations:^{
                self.headImageView.alpha=1.0;
                self.headImageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                
            }];
            }];

        
    }
    
    

    
}

//接口 得到钱。。
-(void)jiekouGetMoney{
    //        http://www.vipxox.net/? m=appapi&s=membercenter&act=Personal_Center&zt=cash&uid=1
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"Personal_Center",@"zt":@"cash",@"uid":[UserSession instance].uid};
    
    HttpManager*manager= [[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UserSession *user=[UserSession instance];
            user.cash=data[@"data"][@"cash"];
            user.point=data[@"data"][@"point"];
            user.unreachable=data[@"data"][@"unreachable"];
            
            NSLog(@"%@",user.cash);
            NSLog(@"%@",user.point);
            NSLog(@"%@",user.unreachable);
            
            
            UILabel*label1=self.saveAllLabel[0];
            CGFloat cash=[user.cash floatValue];
            label1.text=[NSString stringWithFormat:@"%@%.2f",user.currency,cash];
            
            UILabel*label2=self.saveAllLabel[1];
            CGFloat unreach=[user.unreachable floatValue];
            label2.text=[NSString stringWithFormat:@"%@%.2f",user.currency,unreach];
            
            UILabel*label3=self.saveAllLabel[2];
            label3.text=[NSString stringWithFormat:@"%@",user.point];
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=NO;
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.section==0) {
        NewPersonCenterSection0TableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:SECTION0];
      NSBundle *bundle=[InternationalLanguage bundle];
        
        UIImageView*imageView0=[cell viewWithTag:1];
        imageView0.image=[UIImage imageNamed:[bundle
        localizedStringForKey:@"zh_mall" value:nil table:@"Language"]];
        UIImageView*imageView1=[cell viewWithTag:2];
        imageView1.image=[UIImage imageNamed:[bundle localizedStringForKey:@"zh_department" value:nil table:@"Language"]];
        UIImageView*imageView2=[cell viewWithTag:3];
        imageView2.image=[UIImage imageNamed:[bundle localizedStringForKey:@"zh_purchase" value:nil table:@"Language"]];
        UIImageView*imageView3=[cell viewWithTag:4];
        imageView3.image=[UIImage imageNamed:[bundle localizedStringForKey:@"zh_transOrder" value:nil table:@"Language"]];
        UIImageView*imageView4=[cell viewWithTag:5];
        imageView4.image=[UIImage imageNamed:[bundle localizedStringForKey:@"zh_oneyuango" value:nil table:@"Language"]];

        
        __weak typeof (self)weakSelf =self;
        cell.imageBolck=^(NSInteger integer){
            NSLog(@"%lu",integer);
            
            if ([UserSession instance].isLogin==NO) {
                [weakSelf touchLogin];
                return ;
            }else{
            
            switch (integer) {
                case 1:{
                    //商城订单
                    ShoppingCentreOrderViewController*vc=[[ShoppingCentreOrderViewController alloc]init];
                  
                    [self.navigationController pushViewController:vc animated:YES];

                    
                }
                    break;
                case 2:{
                    //百货订单
                    NewDepartmentOrderViewController*vc=[[NewDepartmentOrderViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;

                case 3:{
                    //代购订单
                    BuyOrderViewController*vc=[[BuyOrderViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                    
                }
                    break;

                case 4:{
                    //转运订单
                    TransportOrderViewController*vc=[[TransportOrderViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;

                case 5:{
                    //一元购个人中心
                    OneYuanPurchaseViewController*vc=[[OneYuanPurchaseViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;

                    
                default:
                    break;
            }
            }
            
            
        };
        
        return cell;
    }
    
    if (indexPath.section==1) {
        
        NewPersionCenterSection1TableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:SECTION1];
        cell.selectionStyle=NO;
        //collectionView  已经给图片赋值了
        
        
        __weak typeof (self)weakSelf =self;

        cell.collectionCellBlock=^(NSInteger integer){
            if ([UserSession instance].isLogin==NO) {
                [weakSelf touchLogin];
                return ;
            }else{
            
            switch (integer) {
                case 0:{
                    //国际运单
                    InternationalOrderViewController*vc=[[InternationalOrderViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    

                }
                    break;
                    
                case 1:{
                                   //云仓库
                   NewCloudWareViewController*vc=[[NewCloudWareViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
                case 2:{
                  
                                      //                    //转运地址
                    //                    TransportAddressViewController*vc=[[TransportAddressViewController alloc]init];
                    //                    [self.navigationController pushViewController:vc animated:YES];
#warning 转运地址 先不要   打算放到转运订单里面
                    CalTransViewController*vc=[[CalTransViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
                case 3:{
                    //我的收藏
                    MyCollectionViewController*vc=[[MyCollectionViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:NO];

                }
                    break;
                case 4:{
                    //货币选择
                    ChooseCurrencyKindViewController*vc=[[ChooseCurrencyKindViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 5:{

                    //收货地址
                    TMAddressViewController*vc=[[TMAddressViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                    
                }
                    break;
                case 6:{
                    //消费记录
                    ExpenseRecordViewController*vc=[[ExpenseRecordViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
                case 7:{
                    //申请提现
                    WithdrawDespositViewController*vc=[[WithdrawDespositViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
                case 8:{
                    //账户充值
                    AccountRechargeViewController*vc=[[AccountRechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
               
                    
                default:
                    break;
            }
            
            
          }
            
        };
        
        
        return cell;
  
    
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger number=9;
    
    if (indexPath.section==0) {
        return KScreenWidth/5+10;
    }
    //通过个数来计算 cell 的高度   10个的话
    NSInteger hang =number/3;
    NSInteger lie =number%3;
    if (lie!=0) {
       hang= hang+1;
    }
    
    CGFloat height=(KScreenWidth-3)/3*106/124;
    
    return hang*height+(hang-1)*2+5;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 5;
    }else{
        return 0.001;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeHeaderView{
  
    
    
     self.navigationItem.title = [UserSession instance].user;
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setUp"] style:UIBarButtonItemStylePlain target:self action:@selector(TouchleftBarButton)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStylePlain target:self action:@selector(TouchRightBarButton)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    
    
    
    //包含的view
    UIView*contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, HeaderHeight)];
    self.headerContentView=contentView;
    contentView.backgroundColor=[UIColor blackColor];
    self.headerContentView.layer.masksToBounds=YES;
    
    //背景图
    
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:contentView.bounds];
    imageView.image=[UIImage imageNamed:@"樱花.jpg"];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFill;

    self.headerImageView=imageView;
    imageView.userInteractionEnabled=YES;
    [self.headerContentView addSubview:imageView];
//    [self.headerContentView insertSubview:imageView atIndex:1];
    
    UIVisualEffectView*visualEffectView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.userInteractionEnabled=YES;
    visualEffectView.frame=imageView.frame;
    visualEffectView.alpha=0.6;
    [imageView addSubview:visualEffectView];
    [visualEffectView bringSubviewToFront:imageView];
    _visualEffectView=visualEffectView;
//    _visualEffectView.hidden=YES;
//    self.title=@"";
    
    //headerView 的图
    CGRect bounds = CGRectMake(0, 0, KScreenWidth, HeaderHeight);
    UIView *headerView = [[UIView alloc] initWithFrame:bounds];
    [headerView addSubview:self.headerContentView];
    self.tableView.tableHeaderView=headerView;
    
   
#pragma mark  ---   所有元素
    UIImageView*headerImage=[[UIImageView alloc]initWithFrame:CGRectMake((self.headerContentView.width-90)/2, self.headerContentView.bottom-90-115, 90, 90)];
    headerImage.layer.cornerRadius=45;
    headerImage.layer.masksToBounds=YES;
    headerImage.backgroundColor=[UIColor whiteColor];
    headerImage.contentMode=UIViewContentModeScaleAspectFit;

    [self.headerContentView addSubview:headerImage];
    _headImageView=headerImage;
    headerImage.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editPortrait)];
    [headerImage addGestureRecognizer:tap];
    
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.headerContentView.width/4*1)/2, self.headerImageView.bottom-100, (KScreenWidth-KScreenWidth/4), 40)];
    titleLabel.numberOfLines=2;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.headerContentView addSubview:titleLabel];
    _titleLabel=titleLabel;
    titleLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editSignature)];
    [titleLabel addGestureRecognizer:tapp];

    
    
    //显示钱的  栏
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.headerContentView.height-50, KScreenWidth, 50)];
    bottomView.backgroundColor=[UIColor clearColor];
    [self.headerContentView addSubview:bottomView];
    _bottomMoneyView=bottomView;
    //创建3个label
    for (int i=0; i<3; i++) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(i*KScreenWidth/3, ACTUAL_HEIGHT(5),KScreenWidth/3, ACTUAL_HEIGHT(30))];
        label.tag=i;
        label.font=[UIFont systemFontOfSize:18];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        [self.saveAllLabel addObject:label];
        [_bottomMoneyView addSubview:label];
        
        
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(i*KScreenWidth/3, ACTUAL_HEIGHT(30), KScreenWidth/3, ACTUAL_HEIGHT(15))];
        nameLabel.tag=i;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.font=[UIFont systemFontOfSize:12];
        //            nameLabel.backgroundColor=[UIColor yellowColor];
        [bottomView addSubview:nameLabel];
        NSBundle*bundle=[InternationalLanguage bundle];
        
        if (nameLabel.tag==0) {
            nameLabel.text=[bundle localizedStringForKey:@"可用余额" value:nil table:@"Language"];
        }else if (nameLabel.tag==1){
            nameLabel.text=[bundle localizedStringForKey:@"冻结金额" value:nil table:@"Language"];
        }else{
            nameLabel.text=[bundle localizedStringForKey:@"积分" value:nil table:@"Language"];
        }
        
        if ([UserSession instance].isLogin) {
            if (label.tag==0) {
                float floatString = [[UserSession instance].cash floatValue];
                label.text=[NSString stringWithFormat:@"%@%0.2f",[UserSession instance].currency,floatString];
                
            }
            if (label.tag==1) {
                float floatString1 = [[UserSession instance].unreachable floatValue];
                label.text=[NSString stringWithFormat:@"%@%0.2f",[UserSession instance].currency,floatString1];
            }
            if (label.tag==2) {
                label.text=[NSString stringWithFormat:@"%@",[UserSession instance].point];
            }
        }

        }
        
      
    
    
    //未登录的  按钮
    [self.headerContentView addSubview:self.loginButton];
    self.loginButton.frame=CGRectMake((KScreenWidth-120)/2, self.headerContentView.bottom-180, 120, 44);
    
    
    
}

#pragma mark   --- 滚动视图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
//    CGFloat alpha = (offset_Y + 40)/300.0f;
//    NSLog(@"偏移：%f   ",offset_Y);
    //    self.backView.backgroundColor = [self.backColor colorWithAlphaComponent:alpha];
    
    NSLog(@"%f",offset_Y);
    if (offset_Y < 0) {
        //放大比例
        CGFloat add_topHeight = -(offset_Y);
        self.scale = (HeaderHeight+add_topHeight)/HeaderHeight;
        //改变 frame
        CGRect contentView_frame = CGRectMake(0,-add_topHeight, KScreenWidth, HeaderHeight+add_topHeight);
        NSLog(@"top  %f",contentView_frame.origin.y);
        self.headerContentView.frame = contentView_frame;
        
        CGRect imageView_frame = CGRectMake(-(KScreenWidth*self.scale-KScreenWidth)/2.0f,0,KScreenWidth*self.scale,
HeaderHeight+add_topHeight);
        self.headerImageView.frame = imageView_frame;
        self.visualEffectView.frame=imageView_frame;
        
        
        _headImageView.frame=CGRectMake((self.headerContentView.width-90)/2, self.headerContentView.height-90-115, 90, 90);
        _titleLabel.frame=CGRectMake((self.headerContentView.width/4*1)/2, self.headerImageView.bottom-100, (KScreenWidth-KScreenWidth/4), 40);
        _bottomMoneyView.frame=CGRectMake(0, self.headerContentView.height-50, KScreenWidth, 50);
        
        
        if ([UserSession instance].isLogin==NO) {
            self.loginButton.frame=CGRectMake((KScreenWidth-120)/2, self.headerContentView.height-180, 120, 44);

        }
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-tabbarDeHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=RGBCOLOR(247, 247, 247, 1);
        _tableView.showsVerticalScrollIndicator=NO;
    }
    return _tableView;
}

-(NSMutableArray *)saveAllLabel{
    if (!_saveAllLabel) {
        _saveAllLabel=[NSMutableArray array];
    }
    return _saveAllLabel;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton=[[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth-120)/2, 90, 120, 44)];
        [_loginButton setTitle:@"登录 / 注册" forState:UIControlStateNormal];
        _loginButton.backgroundColor=[UIColor clearColor];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.layer.borderColor=[UIColor whiteColor].CGColor;
        [_loginButton addTarget:self action:@selector(touchLogin) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.layer.borderWidth=1;

    }
    
    return _loginButton;
    
}

-(void)touchLogin{
    if ([UserSession instance].isLogin==NO) {
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];

    }
  }

-(void)TouchleftBarButton{
    if ([UserSession instance].isLogin==NO) {
        [self touchLogin];
    }else{
        SystemSettingViewController*vc=[[SystemSettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
  
    
}

-(void)TouchRightBarButton{
    if ([UserSession instance].isLogin==NO) {
        [self touchLogin];
    }else{
        SecretaryMessageViewController*vc=[[SecretaryMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];

    }
}



#pragma mark ----个性签名
-(void)editSignature{
    PersonalSignViewController*vc=[[PersonalSignViewController alloc]init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];

    
}

#pragma mark  ----  照相机
//开始

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", @"系统头像",nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    self.photoView.image = editedImage;
    _headImageView.image=editedImage;
//    __weak PersonCenterViewController*weakSelf=self;
    __weak typeof(self)weakSelf=self;
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        weakSelf.headImageView.image=editedImage;
        NSString *str = [ImageCache headImagePath:editedImage];
        //        weakSelf.photoView.image=[UIImage imageNamed:str];
        
        NSData *fileData = [NSData dataWithContentsOfFile:str];
        
        //        http://www.vipxox.cn/ ?m=appapi&s=membercenter&act=ceshi&uid=1
        //        http://www.vipxox.cn/? m=appapi&s=membercenter&act=ceshi&uid=1&mypic=
        //        http://www.vipxox.cn/? m=appapi&s=membercenter&act=upload_photo&uid=1
        //        http://www.vipxox.cn/? m=appapi&s=membercenter&act=ceshi&uid=1
        
        //        http://www.vx.dev/?  m=appapi&s=membercenter&act=upload_photo
        
       
        
        //        NSString*urlStr=@"http://www.vipxox.cn/module/appapi/upload_file.php";
        NSString*urlStr=[NSString stringWithFormat:@"%@/module/appapi/upload_file.php",HTTP_ADDRESS];
        
        NSDictionary*params=@{@"uid":[UserSession instance].uid};
        HttpManager *manager=[[HttpManager alloc]init];
        [manager postDataUpDataPhotoWithUrl:urlStr parameters:params photo:fileData compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                [UserSession instance].logo=data[@"imgurl"];
                //                [_photoView sd_setImageWithURL:[NSURL URLWithString:data[@"imgurl"]] placeholderImage:nil];
                
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
                
            }
        }];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }else if (buttonIndex==2){
        SystemImageViewController*vc=[[SystemImageViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//-(void)delegateForBack4:(NSString *)str4{
//    [UserSession instance].logo=str4;
//    [_photoView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:nil];
//}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];  //倍数缩放
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



@end
