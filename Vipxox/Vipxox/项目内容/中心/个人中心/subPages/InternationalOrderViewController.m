//
//  InternationalOrderViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/5.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "InternationalOrderViewController.h"
#import "InternationalOrderModel.h"
#import "payButton.h"
#import "IOInspectLogisticsViewController.h"

#define TRADEORDER  @"NewSectionTableViewCell"

@interface InternationalOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *stripeView;

@property(nonatomic,strong)NSMutableArray*allDatas;//这个是 用到的array

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页
@property(nonatomic,assign)int order_status; //1=全部记录 2=已发货 3=确认收货

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*fourButtons;
@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,strong)payButton *payButtonn;
@property(nonatomic,strong)UIButton*button1;

@property(nonatomic,strong)NSMutableArray *IDArray;
@property(nonatomic,assign)NSInteger bbb;
@property(nonatomic,strong)NSString*orderID;

@end

@implementation InternationalOrderViewController

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
//    [self makeNavi];
    self.title=@"国际订单";
    self.navigationController.navigationBarHidden=NO;
    self.fourButtons=[NSMutableArray array];
    [self createView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:TRADEORDER bundle:nil] forCellReuseIdentifier:TRADEORDER];
    self.pages=0;
    self.pagen=8;
    self.order_status=1;
    
    self.allDatas=[[NSMutableArray alloc]init];
    self.IDArray=[[NSMutableArray alloc]init];
    
    [self setupRefresh];
    
}
//-(void)makeNavi{
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"国际订单";
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


-(void)goBackAction{
    
    // 在这里增加返回按钮的自定义动作
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)createView{
    self.stripeView=[[UIView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, 35)];
    self.stripeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.stripeView];
    
    //0
    UIButton*button0=[UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:@"国际订单信息" forState:UIControlStateNormal];
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
    _button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setTitle:@"已发货" forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    _button1.titleLabel.font=[UIFont systemFontOfSize:14];
    _button1.frame=CGRectMake(KScreenWidth/3, 10,KScreenWidth/3, 15);
    [_button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:_button1];
    _button1.tag=1;
    [self.fourButtons addObject:_button1];
    
    
    
    //2
    UIButton*button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"历史" forState:UIControlStateNormal];
 [button2 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [button2 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    button2.titleLabel.font=[UIFont systemFontOfSize:14];
    button2.frame=CGRectMake(KScreenWidth/3*2,10,KScreenWidth/3, 15);
    [button2 addTarget:self action:@selector(touchButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:button2];
    button2.tag=2;
    [self.fourButtons addObject:button2];
    
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
        self.order_status=1;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];

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
                
                self.bottomView.frame=CGRectMake(KScreenWidth/3, 33,KScreenWidth/3, 2);
            }];
            
            
        }
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.order_status=2;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];

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
        self.order_status=3;
        self.pages=0;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];

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
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:TRADEORDER];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.allDatas.count==0) {
        return cell;
    }else{
    InternationalOrderModel*model=self.allDatas[indexPath.section];
    
    UILabel *label6=[cell viewWithTag:6];
    label6.hidden=YES;
    
    UILabel *label7=[cell viewWithTag:7];
    label7.hidden=YES;
    
    UILabel*label2=[cell viewWithTag:2];
    label2.text=[NSString stringWithFormat:@"订单编号:%@",model.order_id];
    
    UILabel*label4=[cell viewWithTag:4];
    label4.text=[NSString stringWithFormat:@"运送快递:%@",model.logistics_code];
        
    UILabel*label5=[cell viewWithTag:5];
        
    if ([model.status_desc isEqualToString:@"待确定收货" ]||[model.status_desc isEqualToString:@"已确认" ] ) {
        label5.hidden=NO;
        label5.font=[UIFont systemFontOfSize:13];
        label5.text=[NSString stringWithFormat:@"总重量:%@g",model.weight];
    }else{
        label5.hidden=YES;
    }
    
    
        
    UILabel*label12=[cell viewWithTag:12];
    label12.textAlignment=NSTextAlignmentCenter;
    label12.text=[NSString stringWithFormat:@"目的地:%@",model.to_country];
    
    UILabel*label11=[cell viewWithTag:11];
    label11.text=[NSString stringWithFormat:@"总价格:¥ %@",model.amount_pro];

    UILabel*label13=[cell viewWithTag:13];
    label13.text=[NSString stringWithFormat:@"订单状态:%@",model.status_desc];
    label13.textColor=RGBCOLOR(70, 73, 70, 1);

    UIButton*button=[cell viewWithTag:10];
    button.layer.cornerRadius=2;
    button.layer.borderColor=RGBCOLOR(240, 93, 99, 1).CGColor;
    button.layer.borderWidth=0.5;
    button.hidden=YES;
    
    payButton*payButtonn=[cell viewWithTag:666];
    
    if (!payButtonn) {
        payButtonn=[[payButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(270), ACTUAL_HEIGHT(150), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(30))];
        
        [payButtonn.layer setCornerRadius:5.0];
        [payButtonn.layer setBorderColor:RGBCOLOR(193, 0, 22, 1).CGColor];
        [payButtonn setTitle:@"确认收货" forState:0];
        [payButtonn.layer setBorderWidth:1.5];
        payButtonn.titleLabel.font=[UIFont systemFontOfSize:14];
        [payButtonn setTitleColor:RGBCOLOR(193, 0, 22, 1) forState:0];
        [payButtonn addTarget:self action:@selector(fillTheBackFreight:) forControlEvents:UIControlEventTouchUpInside];
        payButtonn.tag=666;
        
    }
    payButtonn.tagg=indexPath.section;
   
    if (self.button1.selected==NO) {
        [payButtonn removeFromSuperview];
    }else{
        
        if ([model.status_desc isEqualToString:@"待确定收货"]) {
            payButtonn.hidden=NO;
            [self.IDArray addObject:model.order_id];
            [cell addSubview:payButtonn];
        }else if(![model.status_desc isEqualToString:@"待确定收货"]){
            payButtonn.hidden=YES;
        }
    }
    }
    return cell;
}

- (void)fillTheBackFreight:(payButton*)aa {
  
    self.bbb=aa.tagg;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您是否需要确认收货？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        InternationalOrderModel *model=self.allDatas[self.bbb];
        self.orderID=model.idd;
        //  http://www.vipxox.cn/? m=appapi&s=membercenter&act=gjdd_list&uid=&op=confirm&id=
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"gjdd_list",@"uid":[UserSession instance].uid,@"op":@"confirm",@"id":self.orderID};
        
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            if ([number isEqualToString:@"0"]) {
                
                [JRToast showWithText:@"确认订单成功！"];
                
            }else{
                
                [JRToast showWithText:@"确认订单失败，请您稍后再试！"];
 
            }
        }];
        [self setupRefresh];
        
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(187);

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InternationalOrderModel*model=self.allDatas[indexPath.section];
    IOInspectLogisticsViewController*vc=[[IOInspectLogisticsViewController alloc]init];
    vc.IDStr=model.idd;
    [self.navigationController pushViewController:vc animated:YES];
}

-(nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    InternationalOrderModel*model=self.allDatas[indexPath.section];
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"退货" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
      //  http://www.vipxox.cn/? m=appapi&s=membercenter&act=gjdd_list&op=del&uid=1301eb18ce63f39a65b08c620147409c&id=135
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"gjdd_list",@"op":@"del",@"uid":[UserSession instance].uid,@"id":model.idd};
        
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            
            if ([number isEqualToString:@"0"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"退货成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.order_status==1) {
        return YES;
    }else{
        return NO;
    }
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
    
    //  http://www.vipxox.cn/?m=appapi&s=membercenter&act=gjdd_list&order_status=2&pages=1&pagen=2&uid=1
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    self.pages=0;
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*order_status=[NSString stringWithFormat:@"%d",self.order_status];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"gjdd_list",@"order_status":order_status,@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            self.allDatas=nil;
            self.allDatas=[NSMutableArray array];
            
            for (int i=0; i<[data[@"data"] count]; i++) {
                InternationalOrderModel*model=[[InternationalOrderModel alloc]initWithShopDict:data[@"data"][i]];
                [self.allDatas addObject:model];
            }

            NSLog(@"%@",self.allDatas);
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
    
    //  	http://www.vipxox.cn/?m=appapi&s=membercenter&act=cloud_warehouse&uid=1&pagen=6&pages=1&zt=3
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*order_status=[NSString stringWithFormat:@"%d",self.order_status];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"gjdd_list",@"order_status":order_status,@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid};

    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            for (int i=0; i<[data[@"data"] count]; i++) {
                InternationalOrderModel*model=[[InternationalOrderModel alloc]initWithShopDict:data[@"data"][i]];
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
