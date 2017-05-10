//
//  TransportOrderViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/5.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "TransportOrderViewController.h"
#import "BuyOrderDetailViewController.h"
#import "AddTransportOrderViewController.h"
#import "AccountRechargeViewController.h"
#import "payButton.h"
#import "TransportOrderModel.h"

#import "NewSectionTableViewCell.h"

#define TRADEORDER  @"NewSectionTableViewCell"

@interface TransportOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *stripeView;

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array
@property(nonatomic,strong)NSDictionary *addressDic;
@property(nonatomic,strong)NSString*currencyData;   //货币种类


@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*fourButtons;

@property(nonatomic,strong) NSArray*arr0;   //交易中的订单
@property(nonatomic,strong) NSArray*arr1;   //待确定
@property(nonatomic,strong) NSArray*arr2;   //补款
@property(nonatomic,strong) NSArray*arr3;   //无效

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页
@property(nonatomic,assign)int op; //1=交易中的订单 2=待确认 3=无效 4=补款
@property(nonatomic,strong)NSString *op2;//del为“转运信息”删除 return为“已到货”删除

@property(nonatomic,strong)UIView *AtBottomView;
@property(nonatomic,assign)BOOL canTake;
@property(nonatomic,assign)BOOL canDelete;

@property(nonatomic,strong)UIButton*button2;

@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,strong)NSString *yunfeiStr;//接口传来的运费
@property(nonatomic,strong)NSString *cashStr;//账户余额

@property(nonatomic,strong)NSString *orderID;

//@property(nonatomic,strong)payButton *payButton;
@property(nonatomic,assign)NSInteger bbb;   //补运费按钮  第几行

@property(nonatomic,strong)NSMutableArray *IDArray;


@end

@implementation TransportOrderViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 99, KScreenWidth, KScreenHeight-180) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    [self makeNavi];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"转运信息";
    
    self.fourButtons=[NSMutableArray array];
    [self createView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:TRADEORDER bundle:nil] forCellReuseIdentifier:TRADEORDER];
    
    self.pages=0;
    self.pagen=4;
    self.op=0;
    self.op2=@"del";
   [self setupRefresh];
    
    _canTake=YES;
    _canDelete=YES;
    [self makeBottom];
    self.IDArray=[[NSMutableArray alloc]init];
    
}

//-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, 19)];
//    titleLabel.text=@"转运订单";
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textAlignment=1;
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
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void)goBackAction{
//    
//    // 在这里增加返回按钮的自定义动作
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

-(void)createView{
    self.stripeView=[[UIView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, KScreenHeight-64)];
    self.stripeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.stripeView];
    
    //0
    UIButton*button0=[UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:@"转运信息" forState:UIControlStateNormal];
    [button0 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [button0 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    [button0 setImage:[UIImage imageNamed:@"bigShadow"] forState:UIControlStateHighlighted];
    button0.selected=YES;
    button0.titleLabel.font=[UIFont systemFontOfSize:14];
    button0.frame=CGRectMake(ACTUAL_WIDTH(0), 10,KScreenWidth/3, 15);
    [button0 addTarget:self action:@selector(touchButton0:) forControlEvents:UIControlEventTouchUpInside];
    button0.tag=0;
    [self.fourButtons addObject:button0];
    [self.stripeView addSubview:button0];
    
    
    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 33,KScreenWidth/3, 2)];
    self.bottomView.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [self.stripeView addSubview:self.bottomView];
    
    
    //1
    UIButton*button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"已到货" forState:UIControlStateNormal];
    [button1 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [button1 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    button1.titleLabel.font=[UIFont systemFontOfSize:14];
    button1.frame=CGRectMake(KScreenWidth/3, 10,KScreenWidth/3, 15);
    [button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:button1];
    button1.tag=1;
    [self.fourButtons addObject:button1];
    
    //2
    _button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setTitle:@"无效" forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    _button2.titleLabel.font=[UIFont systemFontOfSize:14];
    _button2.frame=CGRectMake(KScreenWidth/3*2, 10,KScreenWidth/3, 15);
    [_button2 addTarget:self action:@selector(touchButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:_button2];
    _button2.tag=2;
    [self.fourButtons addObject:_button2];
    
}

-(void)makeBottom{
    if (_canTake) {
        
        self.tableView.frame=CGRectMake(0, 99, KScreenWidth, KScreenHeight-180);
        
        _AtBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(580), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(580))];
        _AtBottomView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_AtBottomView];
        
        UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(50))];
        addButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
        [addButton setTitle:@"添加转运订单" forState:0];
        addButton.layer.cornerRadius=5;
        [addButton addTarget:self action:@selector(addTransportOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.AtBottomView addSubview:addButton];
    }else{
        [self.AtBottomView removeFromSuperview];
        self.tableView.frame=CGRectMake(0, 99, KScreenWidth, KScreenHeight-99);
    }
}

-(void)addTransportOrder{
    AddTransportOrderViewController *vc=[[AddTransportOrderViewController alloc]init];
    vc.addressDic=self.addressDic;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)touchButton0:(UIButton*)sender{
    if (sender.selected==NO) {
        for (UIButton*button in self.fourButtons) {
            button.selected=NO;
        }
        
        if (sender.selected) {
            
            sender.selected=NO;
        }else{
            sender.selected=YES;
            [UIView animateWithDuration:0.3 animations:^{
                
                self.bottomView.frame=CGRectMake(ACTUAL_WIDTH(0), 33,KScreenWidth/3, 2);
            }];
            
            
        }
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.op=0;
        self.op2=@"del";
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];
        
        [self.AtBottomView removeFromSuperview];
        _canTake=YES;
        _canDelete=YES;
        [self makeBottom];

    }else{
        NSLog(@"11");
    }
    
   }
-(void)touchButton1:(UIButton*)sender{
    if (sender.selected==NO) {
        for (UIButton*button in self.fourButtons) {
            button.selected=NO;
        }
        
        if (sender.selected) {
            sender.selected=NO;
            
            
        }else{
            sender.selected=YES;
            [UIView animateWithDuration:0.3 animations:^{
                
                self.bottomView.frame=CGRectMake(KScreenWidth/3,33,KScreenWidth/3, 2);
            }];
            
            
        }
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.op=1;
        self.op2=@"return";
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];
        
        [self.AtBottomView removeFromSuperview];
        _canTake=NO;
        _canDelete=YES;
        [self makeBottom];

    }
    
    
}
-(void)touchButton2:(UIButton*)sender{
    if (sender.selected==NO) {
        for (UIButton*button in self.fourButtons) {
            button.selected=NO;
        }
        
        if (sender.selected) {
            sender.selected=NO;
            
        }else{
            sender.selected=YES;
            [UIView animateWithDuration:0.3 animations:^{
                
                self.bottomView.frame=CGRectMake(KScreenWidth/3*2, 33,KScreenWidth/3, 2);
            }];
        }
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.op=2;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];
        
        [self.AtBottomView removeFromSuperview];
        _canTake=NO;
        _canDelete=NO;
        [self makeBottom];

    }
    
}

#pragma mark --------- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.allDatas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewSectionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:TRADEORDER];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.allDatas.count==0) {
        return cell;
    }else{
    TransportOrderModel *model =self.allDatas[indexPath.section];

    UILabel*label2=[cell viewWithTag:2];
    label2.text=model.order_sn;
    
    UILabel*label4=[cell viewWithTag:4];
    label4.text=model.logi_num;
    
    UILabel*label6=[cell viewWithTag:6];
    label6.hidden=YES;
    
    UILabel*label12=[cell viewWithTag:12];
    label12.hidden=YES;
    
    UILabel*label7=[cell viewWithTag:7];
    label7.text=model.logi_name;

    UILabel*label5=[cell viewWithTag:5];
    label5.frame=CGRectMake(ACTUAL_WIDTH(255), ACTUAL_HEIGHT(38), ACTUAL_WIDTH(110), ACTUAL_HEIGHT(16));
    label5.font=[UIFont systemFontOfSize:16];
    id Prince=(id)model.pkgprice;
    CGFloat Value2 = [Prince floatValue];
    label5.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,Value2];
    
    UILabel*label13=[cell viewWithTag:13];
    label13.text=[NSString stringWithFormat:@"订单状态:%@",model.status];
    label13.textColor=RGBCOLOR(70, 73, 70, 1);
    
        payButton*payButtonn=[cell viewWithTag:666];
    
        if (!payButtonn) {
            payButtonn=[[payButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(270), ACTUAL_HEIGHT(150), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(30))];
            
            [payButtonn.layer setCornerRadius:5.0];
            [payButtonn.layer setBorderColor:RGBCOLOR(193, 0, 22, 1).CGColor];
            [payButtonn setTitle:@"补运费" forState:0];
            [payButtonn.layer setBorderWidth:1.5];
            payButtonn.titleLabel.font=[UIFont systemFontOfSize:14];
            [payButtonn setTitleColor:RGBCOLOR(193, 0, 22, 1) forState:0];
            [payButtonn addTarget:self action:@selector(fillTheBackFreight:) forControlEvents:UIControlEventTouchUpInside];
            payButtonn.tag=666;
            
        }
         payButtonn.tagg=indexPath.section;
        NSLog(@"%lu",payButtonn.tagg);
        if (self.button2.selected==NO) {
            [payButtonn removeFromSuperview];
        }else{
        
        if (model.accordingPayButton) {
            payButtonn.hidden=NO;
            [self.IDArray addObject:model.order_sn];
            [cell addSubview:payButtonn];
        }else if(!model.accordingPayButton){
            payButtonn.hidden=YES;
        }
        }
    }
    return cell;

}

#pragma mark 补退回运费警告框

- (void)fillTheBackFreight:(payButton*)aa {
//    if (aa.selected==YES) {
//        return;
//    }else{
//        aa.selected=YES;
//        [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:2.0];
    
    
     NSLog(@"%lu",aa.tagg);
    self.bbb=aa.tagg;
   //  http://www.vipxox.cn/?m=appapi&s=membercenter&act=transport&uid=1&op=
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"uid":[UserSession instance].uid,@"op":@"yunfei"};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        if ([number isEqualToString:@"0"]) {
            self.yunfeiStr=data[@"data"][@"yunfei"];
            self.cashStr=data[@"data"][@"cash"];
            
            NSString *str=[NSString stringWithFormat:@"退回运费为：%@%@",[UserSession instance].currency,self.yunfeiStr];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"支付" otherButtonTitles:@"取消", nil];
            [alert show];
            
        }
    }];

//    }
}

//-(void)timeEnough:(NSTimer*)timer{
//    UIButton *btn=(UIButton*)[self.view viewWithTag:666];
//    btn.selected=NO;
//    [timer invalidate];
//    timer=nil;
//    
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
   
    //判断buttonIndex的值，buttonIndex的值从上往下由0开始。
    
     float floatYunfei = [self.yunfeiStr floatValue];
     float floatcash = [self.cashStr floatValue];
    TransportOrderModel *model=self.allDatas[self.bbb];
    self.orderID=model.order_sn;
    if (buttonIndex==0) {
        if (floatYunfei<=floatcash) {
            //  http://www.vipxox.cn/?m=appapi&s=membercenter&act=transport&uid=1&op=
            
            NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"uid":[UserSession instance].uid,@"op":@"service_charge",@"order":self.orderID};
            
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_canDelete) {
        return YES;
    }else{
        return NO;
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        //删除
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            //http://www.vipxox.cn/? m=appapi&s=membercenter&act=transport&op=del&uid=1&order=ZY0325102159558
            
            TransportOrderModel *model =self.allDatas[indexPath.section];
            NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"op":self.op2,@"uid":[UserSession instance].uid,@"order":model.order_sn};
            
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
    
    if ([self.op2 isEqualToString:@"return"]) {
        deleteAction.title=@"退货";
    }else{
        deleteAction.title=@"删除";
        
    }

    
        return @[deleteAction];
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransportOrderModel *model =self.allDatas[indexPath.section];
    BuyOrderDetailViewController*vc=[[BuyOrderDetailViewController alloc]init];
    vc.str=model.order_sn;
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    return ACTUAL_HEIGHT(177);
    return ACTUAL_HEIGHT(193);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
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
    
    //  http://www.vipxox.cn/?m=appapi&s=membercenter&act=transport&uid=1&pagen=4&pages=2&op=0
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    self.pages=0;
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*op=[NSString stringWithFormat:@"%d",self.op];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages,@"op":op};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        self.addressDic=data[@"address"];
        if ([number isEqualToString:@"0"]) {
            self.allDatas=nil;
            self.allDatas=[NSMutableArray array];
            for (int i=0; i<[data[@"data"] count]; i++) {
            TransportOrderModel*model=[[TransportOrderModel alloc]initWithShopDict:data[@"data"][i]];
                if ([model.status isEqualToString:@"申请退货中"]) {
                    model.accordingPayButton=YES;
                }else{
                    model.accordingPayButton=NO;
                }
            [self.allDatas addObject:model];
            }
            NSLog(@"%@",self.allDatas);
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
            
        }else{
            self.allDatas=nil;
           [self.tableView headerEndRefreshing];
        }
        
    }];
}

- (void)footerRereshing
{
    self.pages++;
    
    //  	http://www.vipxox.cn/?  m=appapi&s=membercenter&act=cloud_warehouse&uid=1&pagen=6&pages=1&zt=3
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*op=[NSString stringWithFormat:@"%d",self.op];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages,@"op":op};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            
            for (int i=0; i<[data[@"data"] count]; i++) {
                TransportOrderModel*model=[[TransportOrderModel alloc]initWithShopDict:data[@"data"][i]];
                if ([model.status isEqualToString:@"申请退货中"]) {
                    model.accordingPayButton=YES;
                }else{
                    model.accordingPayButton=NO;
                }
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
