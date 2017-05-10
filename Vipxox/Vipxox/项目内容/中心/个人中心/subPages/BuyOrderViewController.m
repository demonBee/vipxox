//
//  BuyOrderViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/5.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "BuyOrderViewController.h"
#import "BODInspectLogisticsViewControllerViewController.h"
#import "HttpManager.h"
#import "BuyOrderModel.h"
#import "payButton.h"
#import "AccountRechargeViewController.h"


#define TRADEORDER  @"NewSectionTableViewCell"
@interface BuyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *stripeView;

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array
@property(nonatomic,strong)NSString*currencyData;   //货币种类

@property(nonatomic,strong)UIButton*button0;
@property(nonatomic,strong)UIButton*button1;
@property(nonatomic,strong)UIButton*button2;
@property(nonatomic,strong)UIButton*button3;


@property(nonatomic,strong) NSArray*arr0;   //交易中的订单
@property(nonatomic,strong) NSArray*arr1;   //待确定
@property(nonatomic,strong) NSArray*arr2;   //补款
@property(nonatomic,strong) NSArray*arr3;   //无效

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页
@property(nonatomic,assign)int zt; //1=交易中的订单 2=待确认 3=无效 4=补款

@property(nonatomic,assign)BOOL canDelete;
@property(nonatomic,strong)payButton *payButtonn;
@property(nonatomic,strong)NSMutableArray *IDArray;

@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *cashStr;
@property(nonatomic,strong)NSString *priceStr;

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,assign)NSInteger bbb;

@end

@implementation BuyOrderViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 99, KScreenWidth, KScreenHeight-99) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;

        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"代购订单";
//    [self makeNavi];
 
    [self createView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:TRADEORDER bundle:nil] forCellReuseIdentifier:TRADEORDER];
    
    self.pages=0;
    self.pagen=5;
    self.zt=1;
   [self setupRefresh];
    _canDelete=YES;
    self.IDArray=[[NSMutableArray alloc]init];
}

//-(void)makeNavi{
//    
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(79), ACTUAL_WIDTH(19))];
//    titleLabel.text=@"代购订单";
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:titleLabel];
//    
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    
//}
//
//-(void)dismissTo{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)goBackAction{
    
    // 在这里增加返回按钮的自定义动作
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createView{
    self.stripeView=[[UIView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, 35)];
    self.stripeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.stripeView];
    
    //0
    _button0=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button0 setTitle:@"代购中订单" forState:UIControlStateNormal];
    [_button0 setTitleColor:RGBCOLOR(174, 174, 174, 1) forState:UIControlStateNormal];
    [_button0 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_button0 setImage:[UIImage imageNamed:@"bigShadow"] forState:UIControlStateHighlighted];
    _button0.selected=YES;
    _button0.titleLabel.font=[UIFont systemFontOfSize:14];
    _button0.frame=CGRectMake(ACTUAL_WIDTH(0), 10,KScreenWidth/3, 15);
    [_button0 addTarget:self action:@selector(touchButton0:) forControlEvents:UIControlEventTouchUpInside];
    _button0.tag=0;
//    [self.fourButtons addObject:button0];
    [self.stripeView addSubview:_button0];
    

    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 33,KScreenWidth/3, 2)];
    self.bottomView.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [self.stripeView addSubview:self.bottomView];
    
    
    //1
    _button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setTitle:@"历史" forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBCOLOR(174, 174, 174, 1) forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button1.titleLabel.font=[UIFont systemFontOfSize:14];
    _button1.frame=CGRectMake(KScreenWidth/3,10,KScreenWidth/3, 15);
    [_button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:_button1];
    _button1.tag=1;
//    [self.fourButtons addObject:button1];
    


    //2
    _button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setTitle:@"无效" forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBCOLOR(174, 174, 174, 1) forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button2.titleLabel.font=[UIFont systemFontOfSize:14];
    _button2.frame=CGRectMake(KScreenWidth/3*2, 10,KScreenWidth/3, 15);
    [_button2 addTarget:self action:@selector(touchButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:_button2];
    _button2.tag=2;
//    [self.fourButtons addObject:button2];

}


-(void)touchButton0:(UIButton*)sender{
    if (sender.selected==NO) {
        _button0.selected=YES;
        _button1.selected=NO;
        _button2.selected=NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(ACTUAL_WIDTH(0), 33,KScreenWidth/3, 2);
        }];
        
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.zt=1;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];
        _canDelete=YES;

    }
    
        }
    

-(void)touchButton1:(UIButton*)sender{
    if (sender.selected==NO) {
        _button0.selected=NO;
        _button1.selected=YES;
        _button2.selected=NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(KScreenWidth/3, 33,KScreenWidth/3, 2);
        }];
        
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.zt=2;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];
        _canDelete=NO;

    }
    
   }


-(void)touchButton2:(UIButton*)sender{
    if (sender.selected==NO) {
        _button0.selected=NO;
        _button1.selected=NO;
        _button2.selected=YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(KScreenWidth/3*2, 33,KScreenWidth/3, 2);
        }];
        
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.zt=3;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];
        _canDelete=NO;

    }
    
}

#pragma mark --------- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.allDatas.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:TRADEORDER];
    cell.selectionStyle=NO;
    
    if (self.allDatas.count==0) {
        
    }else{
    BuyOrderModel*model=self.allDatas[indexPath.row];
    
    UIImageView*imageView1=[cell viewWithTag:1];
        imageView1.backgroundColor=[UIColor whiteColor];
        imageView1.contentMode=UIViewContentModeScaleAspectFit;
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:model.mall_logo] placeholderImage:[UIImage imageNamed:@"littletouxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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

    UILabel*label2=[cell viewWithTag:2];
    label2.text=model.order_id;
    
    UIImageView*imageView3=[cell viewWithTag:3];
        imageView3.backgroundColor=[UIColor whiteColor];
        imageView3.contentMode=UIViewContentModeScaleAspectFit;
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:model.pro_pic] placeholderImage:[UIImage imageNamed:@"touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView3.alpha=0.3;
            CGFloat scale = 0.3;
            imageView3.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView3.alpha=1;
                CGFloat scale = 1.0;
                imageView3.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];


    
    UILabel*label4=[cell viewWithTag:4];
    label4.text=model.title;

    UILabel*label5=[cell viewWithTag:5];
//    label5.frame=CGRectMake(ACTUAL_WIDTH(305), ACTUAL_HEIGHT(38), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(16));
//    label5.font=[UIFont systemFontOfSize:16];
    id Prince=(id)model.price;
    CGFloat Value2 = [Prince floatValue];
    label5.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,Value2];

    UILabel*label6=[cell viewWithTag:6];
    label6.frame=CGRectMake(ACTUAL_WIDTH(328), ACTUAL_HEIGHT(60), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20));
    label6.font=[UIFont systemFontOfSize:14];
    label6.text=[NSString stringWithFormat:@"X%@",model.num];
    
    UILabel*label7=[cell viewWithTag:7];
    label7.textColor=RGBCOLOR(70, 73, 70, 1);
    label7.text=model.attr_desc;

    UILabel*label11=[cell viewWithTag:11];
    label11.text=[NSString stringWithFormat:@"共计%@件商品",model.num];
    

    UILabel*label12=[cell viewWithTag:12];
    label12.frame=CGRectMake(ACTUAL_WIDTH(206), ACTUAL_HEIGHT(110), ACTUAL_WIDTH(165), ACTUAL_HEIGHT(20));
    id allPrince=(id)model.allprice;
    CGFloat Value1 = [allPrince floatValue];
     label5.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,Value1];
    
    UILabel*label13=[cell viewWithTag:13];
    label13.textColor=RGBCOLOR(70, 73, 70, 1);
        label13.text=[NSString stringWithFormat:@"订单状态：%@",model.status];
    
    UIButton*button=[cell viewWithTag:10];
    button.hidden=YES;
        
        payButton*payButtonn=[cell viewWithTag:666];
        
        if (!payButtonn) {
            payButtonn=[[payButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(270), ACTUAL_HEIGHT(150)+5, ACTUAL_WIDTH(80), ACTUAL_HEIGHT(30))];
            
            [payButtonn.layer setCornerRadius:5.0];
            [payButtonn.layer setBorderColor:RGBCOLOR(193, 0, 22, 1).CGColor];
            [payButtonn setTitle:@"补款" forState:0];
            [payButtonn.layer setBorderWidth:1.5];
            payButtonn.titleLabel.font=[UIFont systemFontOfSize:14];
            [payButtonn setTitleColor:RGBCOLOR(193, 0, 22, 1) forState:0];
            [payButtonn addTarget:self action:@selector(fillTheBackFreight:) forControlEvents:UIControlEventTouchUpInside];
            payButtonn.tag=666;
            
        }
        payButtonn.tagg=indexPath.row;
        NSLog(@"%lu",payButtonn.tagg);
        if (self.button0.selected==NO) {
            [payButtonn removeFromSuperview];
        }else{
            
            if ([model.status isEqualToString:@"补差价"]) {
                payButtonn.hidden=NO;
                [self.IDArray addObject:model.order_id];
                [cell addSubview:payButtonn];
            }else if(![model.status isEqualToString:@"补差价"]){
                payButtonn.hidden=YES;
            }
        }

        
    }
    return cell;
}

#pragma mark 补退回运费警告框

- (void)fillTheBackFreight:(payButton*)aa {
    NSLog(@"%lu",aa.tagg);
    self.bbb=aa.tagg;
    
    BuyOrderModel *model=self.allDatas[self.bbb];
    self.orderID=model.order_id;
    //  http://www.vipxox.cn/?m=appapi&s=membercenter&act=dg_list&uid=1&zt=bufei&order=DG0328065223354
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"dg_list",@"uid":[UserSession instance].uid,@"zt":@"bufei",@"order":self.orderID};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        if ([number isEqualToString:@"0"]) {
            self.priceStr=data[@"data"][@"price"];
            self.cashStr=data[@"data"][@"cash"];
            
            CGFloat aa=[self.priceStr floatValue];
            NSString *str=[NSString stringWithFormat:@"补款差价为：%@%.2f",[UserSession instance].currency,aa];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"支付" otherButtonTitles:@"取消", nil];
            [alert show];
            
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    //判断buttonIndex的值，buttonIndex的值从上往下由0开始。
    
    float floatPrice = [self.priceStr floatValue];
    float floatcash = [self.cashStr floatValue];
    BuyOrderModel *model=self.allDatas[self.bbb];
    self.orderID=model.order_id;
    if (buttonIndex==0) {
        if (floatPrice<=floatcash) {
            //  http://www.vipxox.cn/? m=appapi&s=membercenter&act=dg_list&uid=1&zt=replenishment&order=DG0328065223354
            NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"dg_list",@"uid":[UserSession instance].uid,@"zt":@"replenishment",@"order":self.orderID};
            
            NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
            
            HttpManager *manager=[[HttpManager alloc]init];
            [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
                
                NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
                if ([number isEqualToString:@"0"]) {
                    
                    [JRToast showWithText:@"支付成功！"];
                    [self.tableView headerBeginRefreshing];
                }
            }];
    
        }else{
            [JRToast showWithText:@"您的余额不足！"];
            
            AccountRechargeViewController *vc=[[AccountRechargeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BODInspectLogisticsViewControllerViewController*vc=[[BODInspectLogisticsViewControllerViewController alloc]init];
    BuyOrderModel*model=self.allDatas[indexPath.row];
    vc.str=model.idd;
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(193);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyOrderModel*model=self.allDatas[indexPath.row];
    
    if (_canDelete&&([model.status isEqualToString:@"等待客服处理"]||[model.status isEqualToString:@"补差价"])) {
        return YES;
    }else{
        return NO;
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyOrderModel*model=self.allDatas[indexPath.row];
    
        if ([model.status isEqualToString:@"等待客服处理"]||[model.status isEqualToString:@"补差价"]) {
        //删除
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            //http://www.vipxox.cn/? m=appapi&s=membercenter&act=dg_list&uid=1&zt=del&id=
            
            NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"dg_list",@"uid":[UserSession instance].uid,@"zt":@"del",@"id":model.idd};
            
            NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
            
            HttpManager *manager=[[HttpManager alloc]init];
            [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
                NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
                
                if ([number isEqualToString:@"0"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"删除成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alter show];
                    //删除数据
                    [self.tableView headerBeginRefreshing];
                    
                }else{
                    NSLog(@"%@",data[@"errorMessage"]);
                    UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:data[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alter1 show];
                }
            }];
            
            [self.tableView reloadData];
            
        }];
        deleteAction.backgroundColor=RGBCOLOR(239, 97, 101, 1);
        
        return @[deleteAction];
    }else{
        return @[];
    }
    return nil;
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];

//   http://www.vipxox.cn/?  m=appapi&s=membercenter&act=dg_list&pages=0&pagen=5&uid=8465a0ae689139c5854982c6e71e1e26&zt=1

    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    self.pages=0;
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*zt=[NSString stringWithFormat:@"%d",self.zt];

    
 NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"dg_list",@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid,@"zt":zt};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        _currencyData=data[@"currency"];
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            self.allDatas=nil;
            self.allDatas=[NSMutableArray array];
            for (int i=0; i<[data[@"data"][@"dg_list"] count]; i++) {
                BuyOrderModel*model=[[BuyOrderModel alloc]initWithShopDict:data[@"data"][@"dg_list"][i]];
                [self.allDatas addObject:model];
            }
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
            
        }else{
            self.allDatas=nil;
        }
        
    }];
    
}

- (void)footerRereshing
{
    self.pages++;
       
    //   http://www.vipxox.cn/?m=appapi&s=membercenter&act=dg_list&pages=1&pagen=10&uid=1&zt=1
    

    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*zt=[NSString stringWithFormat:@"%d",self.zt];

    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"dg_list",@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid,@"zt":zt};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            
            for (int i=0; i<[data[@"data"][@"dg_list"] count]; i++) {
                BuyOrderModel*model=[[BuyOrderModel alloc]initWithShopDict:data[@"data"][@"dg_list"][i]];
                [self.allDatas addObject:model];
            }
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView footerEndRefreshing];
            
        }else{
            self.allDatas=nil;

        }
    }];
}

@end
