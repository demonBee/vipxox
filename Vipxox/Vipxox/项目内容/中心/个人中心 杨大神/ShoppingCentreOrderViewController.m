//
//  ShoppingCentreOrderViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShoppingCentreOrderViewController.h"
#import "SCODetailsViewController.h"
#import "ShoppingCentreOrderModel.h"
#import "payButton.h"
#import "GoodsInfoViewController.h"

#define TRADEORDER  @"NewSectionTableViewCell"

@interface ShoppingCentreOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *stripeView;

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array

@property(nonatomic,strong)UIButton*button0;
@property(nonatomic,strong)UIButton*button1;
@property(nonatomic,strong)UIButton*button2;

@property(nonatomic,strong) NSArray*arr0;   //交易中的订单
@property(nonatomic,strong) NSArray*arr1;   //待确定
@property(nonatomic,strong) NSArray*arr2;   //历史

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页
@property(nonatomic,assign)int zt; //1=交易中的订单 2=待确认 3=历史
@property(nonatomic,assign)BOOL canDelete;
@property(nonatomic,strong)payButton *payButtonn;
@property(nonatomic,assign)NSInteger bbb;
@property(nonatomic,strong)NSMutableArray *IDArray;
@property(nonatomic,strong)NSMutableArray *IDArray2;
@property(nonatomic,strong)NSString *orderID;

@property(nonatomic,strong)UIAlertView *alert1;
@property(nonatomic,strong)UIAlertView *alert2;

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)UIView*bottomView;


@end

@implementation ShoppingCentreOrderViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [self headerRereshing];
//}
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
    self.title=@"商城订单";
//    [self makeNavi];
    [self createView];
    self.IDArray=[NSMutableArray array];
    self.IDArray2=[NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:TRADEORDER bundle:nil] forCellReuseIdentifier:TRADEORDER];
    
    self.pages=0;
    self.pagen=6;
    self.zt=0;
    _canDelete=YES;
    [self setupRefresh];
}

//-(void)makeNavi{
//    
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(79), ACTUAL_WIDTH(19))];
//    titleLabel.text=@"商城订单";
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
//}
//
//-(void)dismissTo{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)createView{
    self.stripeView=[[UIView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, 35)];
    self.stripeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.stripeView];
    
    //0
    _button0=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button0 setTitle:@"交易中订单" forState:UIControlStateNormal];
    [_button0 setTitleColor:RGBCOLOR(174, 174, 174, 1) forState:UIControlStateNormal];
    [_button0 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_button0 setImage:[UIImage imageNamed:@"bigShadow"] forState:UIControlStateHighlighted];
    _button0.selected=YES;
    _button0.titleLabel.font=[UIFont systemFontOfSize:14];
    _button0.frame=CGRectMake(0, 10,KScreenWidth/3, 15);
    [_button0 addTarget:self action:@selector(touchButton0:) forControlEvents:UIControlEventTouchUpInside];
    _button0.tag=0;
    //    [self.fourButtons addObject:button0];
    [self.stripeView addSubview:_button0];
    
    
    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 33,KScreenWidth/3, 2)];
    self.bottomView.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [self.stripeView addSubview:self.bottomView];
    
    
    //1
    _button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setTitle:@"待确定" forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBCOLOR(174, 174, 174, 1) forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button1.titleLabel.font=[UIFont systemFontOfSize:14];
    _button1.frame=CGRectMake(KScreenWidth/3, 10,KScreenWidth/3,15);
    [_button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:_button1];
    _button1.tag=1;
    //    [self.fourButtons addObject:button1];
    
    
    
    //2
    _button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setTitle:@"历史" forState:UIControlStateNormal];
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
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        _button0.selected=YES;
        _button1.selected=NO;
        _button2.selected=NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(ACTUAL_WIDTH(0), 33,KScreenWidth/3, 2);
        }];
        
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.zt=0;
        self.pages=0;
        _canDelete=YES;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];

    }
    
    
   }


-(void)touchButton1:(UIButton*)sender{
    if (sender.selected==NO) {
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];

        _button0.selected=NO;
        _button1.selected=YES;
        _button2.selected=NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(KScreenWidth/3, 33,KScreenWidth/3, 2);
        }];
        
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.zt=1;
        self.pages=0;
        _canDelete=NO;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];

    }
   }

-(void)touchButton2:(UIButton*)sender{
    if (sender.selected==NO) {
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];

        _button0.selected=NO;
        _button1.selected=NO;
        _button2.selected=YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(KScreenWidth/3*2, 33,KScreenWidth/3, 2);
        }];
        
        self.allDatas=nil;
        self.allDatas=[NSMutableArray array];
        self.zt=2;
        self.pages=0;
        _canDelete=NO;
        [self.tableView headerBeginRefreshing];
        [self.tableView reloadData];

    }
   }



#pragma mark --------- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //bug
    if (self.allDatas) {
        return self.allDatas.count;
    }else{
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:TRADEORDER];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.allDatas.count==0) {
        return cell;
    }else{
    ShoppingCentreOrderModel *model =self.allDatas[indexPath.row];
        UIImageView*imageView1=[cell viewWithTag:1];
        imageView1.image = [UIImage imageNamed:@"littletouxiang"];
    UILabel*label2=[cell viewWithTag:2];
    label2.text=model.order_id;
    
    UIImageView*imageView3=[cell viewWithTag:3];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    label4.text=[NSString stringWithFormat:@"共%@种商品",model.nums];
    label4.textAlignment=0;
    
    UILabel*label5=[cell viewWithTag:5];
//    label5.frame=CGRectMake(ACTUAL_WIDTH(230), ACTUAL_HEIGHT(38), ACTUAL_WIDTH(120), ACTUAL_HEIGHT(16));
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.mas_left).offset(ACTUAL_WIDTH(230));
        make.top.mas_equalTo(cell.mas_top).offset(ACTUAL_HEIGHT(38));
        make.size.mas_equalTo(CGSizeMake(ACTUAL_WIDTH(120), ACTUAL_HEIGHT(38)));
        
        
    }];
    label5.font=[UIFont systemFontOfSize:16];
    label5.textAlignment=NSTextAlignmentRight;
//        label5.hidden=YES;
    id Prince=(id)model.price;
    CGFloat Value2 = [Prince floatValue];
    label5.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,Value2];
    
    
    UILabel*label6=[cell viewWithTag:6];
    label6.text=@"";
    
        UILabel*priceLabel=[cell viewWithTag:234];
        if (!priceLabel) {
            priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(80)+10, ACTUAL_HEIGHT(95), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
            priceLabel.tag=234;
            priceLabel.textColor=RGBCOLOR(193, 0, 22, 1);
            priceLabel.font=[UIFont systemFontOfSize:14];
                       priceLabel.textAlignment=0;
            [cell addSubview:priceLabel];

        }
        id freight=(id)model.freight;
        CGFloat Value3 = [freight floatValue];
        priceLabel.text=[NSString stringWithFormat:@"运费：%@%.2f",[UserSession instance].currency,Value3];

    
    UILabel*label7=[cell viewWithTag:7];
    label7.textColor=RGBCOLOR(70, 73, 70, 1);
    label7.text=@"";
    
    
    UILabel*label11=[cell viewWithTag:11];
    label11.text=@"";
    
    
    UILabel*label12=[cell viewWithTag:12];
    label12.text=@"";
    
    UILabel*label13=[cell viewWithTag:13];
    label13.textColor=RGBCOLOR(70, 73, 70, 1);
    label13.font=[UIFont systemFontOfSize:12];
    label13.text=[NSString stringWithFormat:@"订单状态：%@",model.status];
        
    payButton*payButtonn=[cell viewWithTag:666];
        
    if (!payButtonn) {
        payButtonn=[[payButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(270), ACTUAL_HEIGHT(120), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(30))];
        [payButtonn.layer setCornerRadius:5.0];
        [payButtonn.layer setBorderColor:RGBCOLOR(193, 0, 22, 1).CGColor];
        [payButtonn.layer setBorderWidth:1.5];
        payButtonn.titleLabel.font=[UIFont systemFontOfSize:14];
        [payButtonn setTitleColor:RGBCOLOR(193, 0, 22, 1) forState:0];
        [payButtonn addTarget:self action:@selector(fillTheBackFreight:) forControlEvents:UIControlEventTouchUpInside];
        payButtonn.tag=666;
            
        }
        payButtonn.tagg=indexPath.row;
        
        if (self.button0.selected==YES) {
            [payButtonn removeFromSuperview];
        }else{
            if ([model.status isEqualToString:@"待收货"]) {
                payButtonn.hidden=NO;
                [payButtonn setTitle:@"确认收货" forState:0];
                [self.IDArray addObject:model.order_id];
                [cell addSubview:payButtonn];
            }else if([model.status isEqualToString:@"待评价"]){
                payButtonn.hidden=NO;
                [payButtonn setTitle:@"去评价" forState:0];
                [self.IDArray2 addObject:model.order_id];
                [cell addSubview:payButtonn];
            }else if(![model.status isEqualToString:@"待收货"]&&![model.status isEqualToString:@"待评价"]){
                payButtonn.hidden=YES;
            }
        }
    }
    return cell;
}

- (void)fillTheBackFreight:(payButton*)aa {
    self.bbb=aa.tagg;
    ShoppingCentreOrderModel *model =self.allDatas[self.bbb];
    
    if ([model.status isEqualToString:@"待收货"]) {
       self.alert1 = [[UIAlertView alloc] initWithTitle:nil message:@"您是否要确认收货？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
       [_alert1 show];
    }else if([model.status isEqualToString:@"待评价"]){
        [self gotoEvaluation];
    }

}

-(void)gotoEvaluation{
    GoodsInfoViewController *vc=[[GoodsInfoViewController alloc]init];
    ShoppingCentreOrderModel *model=self.allDatas[self.bbb];
    vc.IDStr=model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.orderID=self.IDArray[self.bbb];
    
    if ([alertView isEqual:self.alert1]) {
        //判断buttonIndex的值，buttonIndex的值从上往下由0开始。
        if (buttonIndex==0) {
            //  http://www.vipxox.cn/? m=appapi&s=membercenter&act=mall_list&zt=3&order=&uid=
            
            NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"zt":@"3",@"order":self.orderID,@"uid":[UserSession instance].uid};
            
            NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
            
            HttpManager *manager=[[HttpManager alloc]init];
            [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
                
                NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
                if ([number isEqualToString:@"0"]) {
                    
                    self.alert2 = [[UIAlertView alloc] initWithTitle:nil message:@"确认成功！" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"去评价", nil];
                    [self.alert2 show];
                    [self headerRereshing];
                    
                }
            }];
        }

    }if ([alertView isEqual:self.alert2]) {
        //判断buttonIndex的值，buttonIndex的值从上往下由0开始。
        if (buttonIndex==1) {
            GoodsInfoViewController *vc=[[GoodsInfoViewController alloc]init];
            vc.IDStr=self.orderID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCentreOrderModel *model=self.allDatas[indexPath.row];
    SCODetailsViewController *vc=[[SCODetailsViewController alloc]init];
    vc.orderStr=model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(160);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_canDelete) {
        return YES;
    }else{
        return NO;
    }
}

-(nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCentreOrderModel *model=self.allDatas[indexPath.row];
        //删除
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            //http://www.vipxox.cn/? m=appapi&s=membercenter&act=mall_list&zt=6&order=&uid=
            
            NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"zt":@"6",@"order":model.order_id,@"uid":[UserSession instance].uid};
            
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
    
    //   http://www.vipxox.cn/?m=appapi&s=membercenter&act=mall_list&zt=0&uid=1&pagen=&pages=
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    self.pages=0;
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*zt=[NSString stringWithFormat:@"%d",self.zt];
    
  NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"zt":zt,@"uid":[UserSession instance].uid,@"pages":pages,@"pagen":pagen};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            self.allDatas=nil;
            self.allDatas=[NSMutableArray array];
            for (int i=0; i<[data[@"data"] count]; i++) {
                ShoppingCentreOrderModel*model=[[ShoppingCentreOrderModel alloc]initWithShopDict:data[@"data"][i]];
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
    
    //  	http://www.vipxox.cn/?m=appapi&s=membercenter&act=cloud_warehouse&uid=1&pagen=6&pages=1&zt=3
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*zt=[NSString stringWithFormat:@"%d",self.zt];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"pages":pages,@"pagen":pagen,@"uid":[UserSession instance].uid,@"zt":zt};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            for (int i=0; i<[data[@"data"] count]; i++) {
                ShoppingCentreOrderModel*model=[[ShoppingCentreOrderModel alloc]initWithShopDict:data[@"data"][i]];
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
