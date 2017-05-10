//
//  ShopCarViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/27.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarTableViewCell.h"
#import "ShoppingModel.h"
#import "AddNumberView.h"
#import "ConfirmOrderViewController.h"   //确认订单
#import "EnterAPPViewController.h"    //登录
//#import "GoodsTailsViewController.h"  //商品详情跳转
#import "NewGoodDetailViewController.h"
#import "GoodsBuyOnBehalfViewController.h"  //商品详情跳转

#import "clearButton.h"


#define shopCar   @"ShopCarTableViewCell"
#define Bottoms     @"bottomsView"

@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,AddNumberViewDelegate,ShopCarTableViewCellDelegate,EnterAPPViewControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*allDatas; //存所有的商品信息  model 形式
@property (nonatomic,strong) UIButton *selectAllBtn;//全选按钮
@property(nonatomic,strong)UIView*bottomView;  //底部的view 用来接mainView

@property (nonatomic,strong) UIButton *jieSuanBtn;//结算按钮
@property (nonatomic,strong) UILabel *totalMoneyLab;//总金额


#warning ---运费 满50加币 免      代购的如果邮寄到仓库有运费  代购订单里补价格

@property(nonatomic,assign)CGFloat howTransMoney;  //总共多少运费
@property(nonatomic,assign) CGFloat allPrice;   //总共多少钱    (这个钱必须 还要加上运费)

@property(nonatomic,assign)NSInteger howmuch;    //总共多少件商品

#pragma mark  ------这个钱是 用来传给确认订单用的
@property(nonatomic,assign)CGFloat totalgoodsMoney;     //物品的钱
@property(nonatomic,assign)CGFloat totalFrightMoney;    //总的运送费


@property(nonatomic,strong)UILabel* transMoney;  //运费label

@property(nonatomic,assign)BOOL  isEdit;  //yes 为正在编辑
@property(nonatomic,strong)UIButton*buttonDelete;  //删除按钮
@property(nonatomic,strong)UIButton*buttonShoucang;  //收藏按钮
@property(nonatomic,assign)BOOL canSelect;

@property(nonatomic,strong)UIView*cover;  //蒙板
@property(nonatomic,strong)UIView*currentView;  //萌版上的view；


@property(nonatomic,strong)UIAlertView*alert; //
@property(nonatomic,assign)int pages;  //第0页
@property(nonatomic,assign)int pagen;  //每条多少

@property(nonatomic,strong)UIButton*rightButton;


@property(nonatomic,strong)NSDictionary*address;


@end

@implementation ShopCarViewController


#pragma mark --set mothod
-(UIView *)cover{
    if (!_cover) {
        _cover=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
        _cover.backgroundColor=[UIColor blackColor];
        _cover.alpha=0.4;
        
    }
    return _cover;
}
-(UIView *)currentView{
    if (!_currentView) {
        _currentView=[[NSBundle mainBundle]loadNibNamed:@"bottomsView" owner:nil options:nil].lastObject;
        _currentView.frame=CGRectMake(0, KScreenHeight+ACTUAL_HEIGHT(350), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(350));
        
    }
    return _currentView;
}



-(UITableView *)tableView{
    if (!_tableView) {
        //-ACTUAL_HEIGHT(60)
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-60) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
        _rightButton.frame=CGRectMake(0, 0, 40, 18);
        _rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_rightButton addTarget:self action:@selector(touchEditButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightButton;
}



-(void)login{
   NSUserDefaults*user= [NSUserDefaults standardUserDefaults];
    NSString*str=[user objectForKey:AUTOLOGIN];
    if (![UserSession instance].isLogin) {
        //跳登录 界面
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        vc.delegate=self;
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
        //如果有值  代表已经登录了
        //接口  得到所有的数据
//        [self.tableView headerBeginRefreshing];
        
        }
    
}
//登录界面的代理
-(void)delegateForGetDatas{
//    [self.tableView headerBeginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
 
    [self rightNaviButton];
  
    if ([UserSession instance].isLogin) {
        self.isEdit=NO;
        self.rightButton.selected=NO;
        
        [self.tableView headerBeginRefreshing];

    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets=YES;
    self.title=@"购物车";
    self.allDatas=[NSMutableArray array];
    self.view.backgroundColor=[UIColor whiteColor];
    [self login];   //判断是否登录过  没登录 跳登

    
    self.pagen=5;
    self.pages=0;
    self.isEdit=NO;
 
 [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    
    [self makeBottomView];
    [self.tableView registerNib:[UINib nibWithNibName:shopCar bundle:nil] forCellReuseIdentifier:shopCar];
    [self setupRefresh];
    _canSelect=YES;
    

    
}

-(void)rightNaviButton{
    UIButton*rightButton=[UIButton buttonWithType:0];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:10];
    // 登录 或者编辑
   NSUserDefaults*user= [NSUserDefaults standardUserDefaults];
    NSString *str=[user objectForKey:AUTOLOGIN];
    if (![UserSession instance].isLogin) {
        [rightButton setTitle:@"登录" forState:UIControlStateNormal];
        rightButton.frame=CGRectMake(0, 0, 40, 18);
        rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [rightButton addTarget:self action:@selector(touchLogin:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
//        self.navigationItem.rightBarButtonItem=item;
        self.navigationItem.rightBarButtonItem=item;

        
    }else{
        UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
        self.navigationItem.rightBarButtonItem=item;


    }
    
    
   
}
//点击登录按钮
-(void)touchLogin:(UIButton*)button{
    EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
    vc.delegate=self;
    [self presentViewController:vc animated:YES completion:nil];
    
}


//点击编辑按钮
-(void)touchEditButton:(UIButton*)sender{
    if (sender.selected==YES) {
        sender.selected=NO;
        self.isEdit=NO;
        [self CalculationPrice];
        [self.tableView reloadData];
        _canSelect=YES;
    }else{
        sender.selected=YES;
        self.isEdit=YES;
        [self.tableView reloadData];
        _canSelect=NO;
    }
    
    
    
    if (self.isEdit==YES) {
        
        //bottom隐藏
        self.jieSuanBtn.hidden=YES;
        self.totalMoneyLab.hidden=YES;
        self.transMoney.hidden=YES;
        
        self.buttonDelete.hidden=NO;
        self.buttonShoucang.hidden=NO;
        
        
    }else{
        
        //bottom 隐藏
        self.jieSuanBtn.hidden=NO;
        self.totalMoneyLab.hidden=NO;
        self.transMoney.hidden=NO;
        
        self.buttonDelete.hidden=YES;
        self.buttonShoucang.hidden=YES;
        
    }

    
}

//刷新
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
   
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (![UserSession instance].isLogin) {
        [JRToast showWithText:@"请先登录"];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }else{
    self.allDatas=[NSMutableArray array];
    self.pages=0;
    [self getDatas];

         [self CalculationPrice];
    }
}

- (void)footerRereshing
{
    if (![UserSession instance].isLogin) {
        [JRToast showWithText:@"请先登录"];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }else{
    self.pages++;
    [self getDatas];
    
//         [self CalculationPrice];
    }
}



-(void)getDatas{

//  http://www.vipxox.cn/?m=appapi&s=go_shop&act=shop_cart&uid=ccefec3267d996b8646565ca988d8005&zt=0&pagen=6&pages=0
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_cart",@"uid":[UserSession instance].uid,@"zt":@"0",@"pagen":pagen,@"pages":pages};
    
    
    HttpManager *manger=[[HttpManager alloc]init];
    [manger getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        _selectAllBtn.selected=NO;
        NSLog(@"%@",data);
//        NSString*code=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
//            [self.allDatas addObjectsFromArray:data[@"data"]];
            
            self.address=data[@"address"];
            
            for (int i=0; i<[data[@"data"] count]; i++) {
                ShoppingModel*model=[[ShoppingModel alloc]initWithShopDict:data[@"data"][i]];
                     [self.allDatas addObject:model];
              
                
            }
            
            
            // 刷新表格
            [self.tableView reloadData];
            
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tableView headerEndRefreshing];
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tableView footerEndRefreshing];


            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tableView headerEndRefreshing];
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tableView footerEndRefreshing];

            
            
        }
        
        [self.tableView headerEndRefreshing];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];

    }];
    

    
}
-(void)touchAllChoose:(UIButton*)sender{
    sender.tag = !sender.tag;
    if (sender.tag)
    {
        sender.selected = YES;
    }else{
        sender.selected = NO;
        
    }
    NSLog(@"%@",self.allDatas);
    //改变单元格选中状态
    for (int i=0; i<self.allDatas.count;i++)
    {
        ShoppingModel *model = self.allDatas[i];
        model.selectState = sender.tag;
    }
    NSLog(@"%@",self.allDatas);

    
    [self CalculationPrice];   //计算价格
    
    [self.tableView reloadData];

    
    
}

-(void)CalculationPrice{
    //得到所有被选中项的id
    NSMutableArray*allID=[NSMutableArray array];
    
    
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格(单价 * 商品数量)
    for ( int i =0; i<self.allDatas.count;i++)
    {
        ShoppingModel *model = self.allDatas[i];
        
        if (model.selectState)
        {
            CGFloat number=[model.num floatValue];
            CGFloat money=[model.price floatValue];

            self.allPrice = self.allPrice+number*money;
            self.howmuch=self.howmuch+number;
            
            [allID addObject:model.idd];

        }
}
    
// 代购无运费   商城的东西  通过后台得到运费
//    http://www.vipxox.cn/  ?m=appapi&s=go_shop&act=shop_cart&uid=1&zt=7&id= 
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*allIDD=[allID componentsJoinedByString:@","];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_cart",@"uid":[UserSession instance].uid,@"zt":@"7",@"id":allIDD};
   HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
//        NSLog(@"%@",data);
//        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            self.howTransMoney=[data[@"data"] floatValue];
            
            //给总价赋值
            
            self.allPrice=self.allPrice+self.howTransMoney;
            
            self.totalgoodsMoney=self.allPrice;
            self.totalFrightMoney=self.howTransMoney;
            
            
            
        
            self.totalMoneyLab.text=[NSString stringWithFormat:@"总共：%@%.2f(共:%ld件)",[UserSession instance].currency,self.allPrice,(long)self.howmuch];
        self.totalMoneyLab.textColor=NewRed;
            //       self.transMoney.text=@"不含运费";
            self.transMoney.text=[NSString stringWithFormat:@"含运费：%@%.2f",[UserSession instance].currency,self.howTransMoney];
            NSLog(@"%f",self.allPrice);
            
            self.allPrice = 0.0;
            self.howmuch=0.0;
            self.howTransMoney=0.0;
        
//        }else{
////            [JRToast showWithText:data[@"errorMessage"]];
//        }
        
        
        
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    self.bottomView.frame=CGRectMake(0,self.tableView.bottom, KScreenWidth, 60);
//    self.bottomView.frame=CGRectMake(0,self.tableView.bottom-60, KScreenWidth, 60);
    NSLog(@"%f",self.tableView.bottom);
    
}

-(void)makeBottomView{
    UIView*mainView=[[UIView alloc]init];
//    if (self.isPush) {
//        mainView.frame=CGRectMake(0, self.tableView.bottom, KScreenWidth, ACTUAL_HEIGHT(60));
//
//    }else{
//        mainView.frame=CGRectMake(0, self.tableView.bottom-49, KScreenWidth, ACTUAL_HEIGHT(60));
//
//
    
    mainView.frame=CGRectMake(0,self.navigationController.tabBarController.tabBar.hidden? self.tableView.bottom:self.tableView.bottom-49.f, KScreenWidth, 60);
     mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    self.bottomView=mainView;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.left);
        make.right.mas_equalTo(self.view.right);
        NSLog(@"%f",self.view.bottom);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
    }];
    
    
    
    
    
    self.selectAllBtn=[UIButton buttonWithType:0];
//    self.selectAllBtn.backgroundColor=[UIColor blackColor];
    [self.selectAllBtn setBackgroundImage:[UIImage imageNamed:@"notAllSelect"] forState:UIControlStateNormal];
    [self.selectAllBtn setBackgroundImage:[UIImage imageNamed:@"allSelect"] forState:UIControlStateSelected];
    self.selectAllBtn.frame=CGRectMake(ACTUAL_WIDTH(30), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(25), ACTUAL_HEIGHT(43));
    [self.selectAllBtn addTarget:self action:@selector(touchAllChoose:) forControlEvents:UIControlEventTouchUpInside];
    self.selectAllBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [mainView addSubview:self.selectAllBtn];
    
    
    //

        self.jieSuanBtn=[UIButton buttonWithType:0];
        self.jieSuanBtn.frame=CGRectMake(ACTUAL_WIDTH(280), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(85), ACTUAL_HEIGHT(45));
        self.jieSuanBtn.backgroundColor=RGBCOLOR(70, 73, 70, 1);
        [self.jieSuanBtn setTitle:@"结算" forState:UIControlStateNormal];
        [self.jieSuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.jieSuanBtn addTarget:self action:@selector(touchJiesuan:) forControlEvents:UIControlEventTouchUpInside];
        self.jieSuanBtn.layer.cornerRadius=6;
        self.jieSuanBtn.hidden=NO;
        [mainView addSubview:self.jieSuanBtn];
        
        self.totalMoneyLab=[[UILabel alloc]init];
        self.totalMoneyLab.height=19;
    //总计:¥4938.00(2件)
        self.totalMoneyLab.text=[NSString stringWithFormat:@"%@0.00(共:0件)",[UserSession instance].currency];
        self.totalMoneyLab.textColor=NewRed;
        self.totalMoneyLab.textAlignment=NSTextAlignmentCenter;
        self.totalMoneyLab.font=[UIFont systemFontOfSize:16];
        self.totalMoneyLab.hidden=NO;
        
        [mainView addSubview:self.totalMoneyLab];
        [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.selectAllBtn.mas_top);
            make.right.mas_equalTo(self.jieSuanBtn.mas_left).offset(-10);
        }];
        
        self.transMoney=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(120), ACTUAL_HEIGHT(36), ACTUAL_WIDTH(135), ACTUAL_HEIGHT(14))];
        self.transMoney.text=@"不含运费";
        self.transMoney.textAlignment=NSTextAlignmentRight;
        self.transMoney.textColor=RGBCOLOR(160, 160, 160, 1);
        self.transMoney.font=[UIFont systemFontOfSize:12];
        self.transMoney.hidden=NO;
        
        [mainView addSubview:self.transMoney];

 
    
    //隐藏的2个按钮
    self.buttonDelete=[UIButton buttonWithType:0];
    self.buttonDelete.frame=CGRectMake(ACTUAL_WIDTH(280), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(85), ACTUAL_HEIGHT(45));
    self.buttonDelete.backgroundColor=[UIColor redColor];
    [self.buttonDelete setTitle:@"删除" forState:UIControlStateNormal];
    [self.buttonDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.buttonDelete.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.buttonDelete addTarget:self action:@selector(deleteArray:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonDelete.layer.cornerRadius=6;
    self.buttonDelete.hidden=YES;
    [mainView addSubview:self.buttonDelete];

   
    self.buttonShoucang=[UIButton buttonWithType:0];
    self.buttonShoucang.frame=CGRectMake(ACTUAL_WIDTH(185), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(85), ACTUAL_HEIGHT(45));
    self.buttonShoucang.backgroundColor=[UIColor blackColor];
    [self.buttonShoucang setTitle:@"移入收藏夹" forState:UIControlStateNormal];
    [self.buttonShoucang setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonShoucang.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.buttonShoucang addTarget:self action:@selector(inFavourite:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonShoucang.layer.cornerRadius=6;
    self.buttonShoucang.hidden=YES;
    [mainView addSubview:self.buttonShoucang];

    
}

#pragma mark   ------------   加入购物车
//加入收藏夹
-(void)inFavourite:(UIButton*)sender{
    //删除按钮
    NSMutableArray*cunAllArray=[NSMutableArray array];//保存所有要删的数据
    //存要删除的所有id
    NSMutableArray*idArray=[NSMutableArray array];   //
    
    for (int i=0; i<self.allDatas.count; i++) {
        ShoppingModel*model=[self.allDatas objectAtIndex:i];
        if (model.selectState==YES) {
            
            
            [cunAllArray addObject:model];
            [idArray addObject:model.idd];
        }
        
    }
    
    
    for (int i=0; i<cunAllArray.count; i++) {
        if ([self.allDatas containsObject:cunAllArray[i]]) {
            [self.allDatas removeObject:cunAllArray[i]];
        }
    }
    
    NSString*idd=[idArray componentsJoinedByString:@","];
  
//    http://www.vipxox.cn/? m=appapi&s=go_shop&act=shop_cart&uid=1&zt=2&id=     
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_cart",@"zt":@"6",@"uid":[UserSession instance].uid,@"id":idd};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [JRToast showWithText:@"收藏成功"];

        }else{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:data[@"errorMessage"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alter show];
        }
    
    }];
         [self.tableView reloadData];
}

-(void)deleteArray:(UIButton*)sender{
    //删除按钮
    NSMutableArray*cunAllArray=[NSMutableArray array];//保存所有要删的数据
    //存要删除的所有id
    NSMutableArray*idArray=[NSMutableArray array];   //
    
 for (int i=0; i<self.allDatas.count; i++) {
        ShoppingModel*model=[self.allDatas objectAtIndex:i];
        if (model.selectState==YES) {
            
            
            [cunAllArray addObject:model];
            [idArray addObject:model.idd];
            }
        
    }
    
    
    for (int i=0; i<cunAllArray.count; i++) {
        if ([self.allDatas containsObject:cunAllArray[i]]) {
            [self.allDatas removeObject:cunAllArray[i]];
        }
    }

    //接口
    //    http://www.vipxox.cn/ ?m=appapi&s=go_shop&act=shop_del&id=$uid=
    
    
    
    NSString*str=[idArray componentsJoinedByString:@","];
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_del",@"uid":[UserSession instance].uid,@"id":str};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [JRToast showWithText:@"删除成功"];
        }
        
    }];

    
    

      [self.tableView reloadData];
}

-(void)touchJiesuan:(UIButton*)sender{
    //结算按钮
    if (![UserSession instance].isLogin) {
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        NSMutableArray*shop=[NSMutableArray array];
        for (int i=0; i<self.allDatas.count; i++) {
            ShoppingModel *model=self.allDatas[i];
            if (model.selectState){
            
                [shop addObject:model];
            }
        }
        
        if (shop.count>0) {
            ConfirmOrderViewController *vc=[[ConfirmOrderViewController alloc]init];
            vc.allDatas=shop;
            vc.allMoney=self.totalgoodsMoney;
            vc.allTrans=self.totalFrightMoney;
            vc.dizhi=self.address;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            [JRToast showWithText:@"请选择商品"];
        }
       
      }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}



- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction*favourite=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移入收藏夹" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //移入收藏夹
//        [tableView setEditing:NO animated:YES];
        ShoppingModel*model=self.allDatas[indexPath.row];
        
        NSString*str=model.idd;
        
        //    http://www.vipxox.cn/? m=appapi&s=go_shop&act=shop_cart&uid=1&zt=2&id=
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_cart",@"zt":@"6",@"uid":[UserSession instance].uid,@"id":str};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                             [self.allDatas removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [self CalculationPrice];   //计算价格
                [JRToast showWithText:@"收藏成功"];


            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:data[@"errorMessage"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [alter show];
            }
            
        }];

    }];
       favourite.backgroundColor=[UIColor blackColor];
    
    
    //删除
    UITableViewRowAction*deleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
     
        
        
        //接口
        //    http://www.vipxox.cn/ ?m=appapi&s=go_shop&act=shop_del&id=$uid=
        NSLog(@"%ld",(long)indexPath.row);
   
        ShoppingModel*model=self.allDatas[indexPath.row];
        
        NSString*str=model.idd;

        
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_del",@"uid":[UserSession instance].uid,@"id":str};
        
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                //删除
                [self.allDatas removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [self CalculationPrice];   //计算价格

                [JRToast showWithText:@"删除成功"];
            }
            
            
        }];

        
        
    }];
    
    return @[deleteAction,favourite];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    ShopCarTableViewCell*cell=[self.tableView dequeueReusableCellWithIdentifier:shopCar];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.allDatas.count<=0) {
        return cell;
    }else{
   ShoppingModel*model=self.allDatas[indexPath.row];
//    cell.shuliang=[model.number integerValue];
    cell.addView.delegate=self;
    cell.delegate=self;
    cell.addView.numberLab.text=model.num;
    

        cell.selectButton.layer.cornerRadius=10;
        cell.selectButton.layer.borderColor=[UIColor blackColor].CGColor;
        //                button.layer.borderWidth=1;
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
        cell.selectButton.tag=indexPath.row;
        [cell.selectButton addTarget:self action:@selector(touchchooseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //选中范围增加
//        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:[self touchchooseButton:cell.selectButton]];
        clearButton*bigButton=[cell viewWithTag:178];
        if (!bigButton) {
            bigButton=[[clearButton alloc]initWithFrame:CGRectMake(0, 0, ACTUAL_WIDTH(50), cell.contentView.height)];
            bigButton.backgroundColor=[UIColor clearColor];
            bigButton.tag=178;
            [cell.contentView addSubview:bigButton];

        }
            bigButton.aa=indexPath.row;
        [bigButton addTarget:self action:@selector(touchBigButton:) forControlEvents:UIControlEventTouchUpInside];
        
    if (model.selectState==YES) {
        cell.selectButton.selected=YES;
    }else{
        cell.selectButton.selected=NO;
    }
 //
    UIImageView*imageView2=[cell viewWithTag:222];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:model.pro_pic] placeholderImage:[UIImage imageNamed:@"placeholder_75x100"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView2.alpha=0.3;
            CGFloat scale = 0.3;
            imageView2.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView2.alpha=1;
                CGFloat scale = 1.0;
                imageView2.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    
    UILabel*label3=[cell viewWithTag:333];
    label3.text=model.title;
    
    UILabel*label4=[cell viewWithTag:444];
    label4.text=model.attr_desc;
    
    UILabel*label5=[cell viewWithTag:555];
    label5.hidden=YES;
//    label5.text=model.size;
    
    UILabel*label6=[cell viewWithTag:666];
//    label6.textColor=[UIColor orangeColor];
        label6.textColor=ManColor;
//    label6.text=model.price;
    CGFloat price=[model.price floatValue];
    label6.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,price];
    label6.textColor=NewRed;
    
    UILabel*label7=[cell viewWithTag:777];
    label7.text=model.num;
    
    
    if (self.isEdit==YES) {
        cell.addView.hidden=NO;
        cell.addView.tag=indexPath.row;
        cell.buttonChoose.hidden=NO;
        cell.buttonChoose.tag=indexPath.row;
        UILabel*label3=[cell viewWithTag:333];
        label3.text=model.title;
        label3.hidden=YES;

        UILabel*label4=[cell viewWithTag:444];
//        label4.text=model.color;
        label4.hidden=YES;
        UILabel*label5=[cell viewWithTag:555];
//        label5.text=model.size;
        label5.hidden=YES;
        
        //bottom隐藏
        self.jieSuanBtn.hidden=YES;
        self.totalMoneyLab.hidden=YES;
        self.transMoney.hidden=YES;

        self.buttonDelete.hidden=NO;
        self.buttonShoucang.hidden=NO;
        

    }else{
        cell.addView.hidden=YES;
        cell.addView.tag=indexPath.row;
        cell.buttonChoose.hidden=YES;
        cell.addView.tag=indexPath.row;
        UILabel*label3=[cell viewWithTag:333];
        label3.text=model.title;
        label3.hidden=NO;

        UILabel*label4=[cell viewWithTag:444];
//        label4.text=model.color;
        label4.hidden=NO;
        UILabel*label5=[cell viewWithTag:555];
//        label5.text=model.size;
        label5.hidden=NO;
        
        //bottom 隐藏
        self.jieSuanBtn.hidden=NO;
        self.totalMoneyLab.hidden=NO;
        self.transMoney.hidden=NO;

        self.buttonDelete.hidden=YES;
        self.buttonShoucang.hidden=YES;

    }
    
    }
    
    
//    [self CalculationPrice];
    return cell;
}

-(void)touchBigButton:(clearButton*)sender{
    NSLog(@"%ld",(long)sender.aa);
    NSLog(@"%lu",sender.tag);
    
    ShopCarTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.aa inSection:0]];
    cell.selectButton.tag=sender.aa;
    [cell.selectButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.canSelect) {
        
    }else{
    ShoppingModel *model=self.allDatas[indexPath.row];
    
    if ([model.s_type isEqualToString:@"vipxox"]){
        NSDictionary *thisDic2=@{@"id":model.pid};
//        GoodsTailsViewController *vc2=[[GoodsTailsViewController alloc]init];
//        vc2.thisDatas=thisDic2;
//        [self.navigationController pushViewController:vc2 animated:YES];
        NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:thisDic2];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        NSDictionary *thisDic=@{@"id":model.idd};
        GoodsBuyOnBehalfViewController *vc=[[GoodsBuyOnBehalfViewController alloc]init];
        vc.thisDatas=thisDic;
        vc.url=model.pro_url;
        [self.navigationController pushViewController:vc animated:YES];
    }
  }
}



-(void)touchchooseButton:(UIButton*)sender{
    NSLog(@"%ld",(long)sender.tag);
    ShoppingModel*model =self.allDatas[sender.tag];
    if (sender.selected) {
        sender.selected=NO;
        model.selectState=NO;
        
    }else{
        sender.selected=YES;
        model.selectState=YES;
    }
    
    [self CalculationPrice];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加  减的代理
-(void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    ShoppingModel*model=self.allDatas[view.tag];
    int i=[model.num intValue];
    if (i<=1) {
        sender.enabled=NO;
    }else{
    
    int x=i-1;
    NSString*str=[NSString stringWithFormat:@"%d",x];
    model.num=str;
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:view.tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        //接口
        //    http://www.vipxox.cn/? m=appapi&s=go_shop&act=shop_cart&uid=1&zt=1&id=1717850259&num=3(修改个数)
        
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSString*num=[NSString stringWithFormat:@"%d",x];
        ShoppingModel*aa=self.allDatas[view.tag];
        
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_cart",@"uid":[UserSession instance].uid,@"zt":@"1",@"id":aa.idd,@"num":num};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",params);
            
            
        }];
    }
}
-(void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    NSLog(@"%lu",view.tag);
    ShoppingModel*model=self.allDatas[view.tag];
    int i=[model.num intValue];
    int x=i+1;
    NSString*str=[NSString stringWithFormat:@"%d",x];
    model.num=str;
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:view.tag inSection:0];
     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

//    http://www.vipxox.cn/? m=appapi&s=go_shop&act=shop_cart&uid=1&zt=1&id=1717850259&num=3(修改个数)
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*num=[NSString stringWithFormat:@"%d",x];
    ShoppingModel*aa=self.allDatas[view.tag];
    
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_cart",@"uid":[UserSession instance].uid,@"zt":@"1",@"id":aa.idd,@"num":num};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",params);
        
        
    }];
    
}

//点击了 cell 上按钮  跳选择样式栏    那个黑色的黑块
-(void)delegateForShowChoose:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    //得到了所有数据
    ShoppingModel *model=self.allDatas[sender.tag];
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self.cover];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDismiss)];
    [self.cover addGestureRecognizer:tap];
    [window addSubview:self.currentView];
    
    [UIView animateWithDuration:0.5 animations:^{
       self.cover.frame= CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.currentView.frame=CGRectMake(0, ACTUAL_HEIGHT(350), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(350));
        
    }];
    
}

-(void)touchDismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.frame= CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);
        self.currentView.frame=CGRectMake(0, ACTUAL_HEIGHT(350)+KScreenHeight, KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(350));
        
    }];

    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(realDismiss:) userInfo:nil repeats:NO];
}

-(void)realDismiss:(NSTimer*)timer{
    [self.cover removeFromSuperview];
    [self.currentView removeFromSuperview];
    
    timer=nil;
    [timer invalidate];
}


@end
