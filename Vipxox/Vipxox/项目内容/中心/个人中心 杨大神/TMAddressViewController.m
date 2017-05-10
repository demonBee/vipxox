//
//  TMAddressViewController.m
//  weimao
//
//  Created by Brady on 16/2/26.
//  Copyright © 2016年 Brady. All rights reserved.
//

#import "TMAddressViewController.h"
#import "GetGoodAddressViewController.h"
#import "TMAddressTableViewCell.h"

@interface TMAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页


@end

@implementation TMAddressViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(76)-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.title=@"收货地址";
    self.navigationController.navigationBarHidden=NO;
//    [self makeNavi];
    [self makeBottomView];
    [self.view addSubview:self.tableView];
    
    self.pages=0;
    self.pagen=5;
    
    [self setupRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    [self setupRefresh];
}

-(void)makeNavi{
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
    titleLabel.text=@"收货地址";
    titleLabel.textAlignment=1;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
   
}

-(void)makeBottomView{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 64, KScreenWidth, KScreenHeight-64)];
    BGView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGView];
    
    UIButton*but1=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(540), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(50))];
    but1.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [but1 setTitle:@"新增收货地址" forState:0];
    but1.layer.cornerRadius=2;
    [but1 setTitleColor:[UIColor whiteColor] forState:0];
    but1.layer.cornerRadius=5;
    [but1 addTarget:self action:@selector(gotoGetGoodAddress) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:but1];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return _allDatas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  static NSString *CellID = @"mycell";
    TMAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];

    
    if (self.allDatas.count==0) {
        
    }else{
    //创建Cell
      
 
    cell = [[TMAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    cell.label1.text=self.allDatas[indexPath.row][@"province_name"];
    cell.label2.text=[NSString stringWithFormat:@"%@/%@",self.allDatas[indexPath.row][@"country_name"],self.allDatas[indexPath.row][@"city_name"]];
    cell.label3.text=self.allDatas[indexPath.row][@"address"];
    cell.label4.text=self.allDatas[indexPath.row][@"zip"];
    cell.label5.text=self.allDatas[indexPath.row][@"mobile"];
        return cell;

    }
    return cell;
   }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击了之后  代理出去把数据
    if ([self.delegate respondsToSelector:@selector(DelegateForSendValueToAddress:)]) {
//        http://www.vipxox.cn/?m =appapi&s=membercenter&act=address_default&default=1&uid=1&id=3
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"address_default",@"default":@"1",@"uid":[UserSession instance].uid,@"id":self.allDatas[indexPath.row][@"id"]};
       HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                [self.delegate DelegateForSendValueToAddress:self.allDatas[indexPath.row]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }];
        
        
        
      
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(100);
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
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableView.headerRefreshingText = @"正在帮你刷新中";
//    
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tableView.footerRefreshingText = @"正在帮你加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.pages=0;
 
    self.allDatas=[NSMutableArray array];
    
    //   http://www.vipxox.cn/?m=appapi&s=membercenter&act=address&uid=1&pages=0&pagen=3

    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
 
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"address",@"uid":[UserSession instance].uid,@"pages":pages,@"pagen":pagen};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            NSLog(@"%@",self.allDatas);
            [self.allDatas addObjectsFromArray:data[@"data"]];
            
            NSLog(@"%@",self.allDatas);
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
            
        }else{
          
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
    
     NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"address",@"uid":[UserSession instance].uid,@"pages":pages,@"pagen":pagen};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            
            
            [self.allDatas addObjectsFromArray:data[@"data"]];
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView footerEndRefreshing];
            
        }else{
            
        }
    }];
}


#pragma mark - 设置cell侧滑按钮

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    QHLShop *shop = self.shoppingCar[indexPath.section];
    /**
     *  BlurEffect 毛玻璃特效
     */
    
    
    //设为已读
    UITableViewRowAction *readedAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

//        http://www.vipxox.cn/?  m=appapi&s=membercenter&act=address_default&default=1&uid=1&id=3
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"address_default",@"default":@"1",@"uid":[UserSession instance].uid,@"id":self.allDatas[indexPath.row][@"id"]};
        NSLog(@"%@",self.allDatas[indexPath.row][@"id"]);
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            NSLog(@"%@",data[@"data"]);
            if ([number isEqualToString:@"0"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"设置成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
//                [self.allDatas removeObjectAtIndex:indexPath.row];
//                [_tableView reloadData];
//                [self.tableView reloadData];
                
            }else{
                NSLog(@"%@",data[@"errorMessage"]);
                UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:data[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter1 show];
            }
        }];

        
        //设为不可编辑
        [tableView setEditing:NO animated:YES];
    }];
    readedAction.backgroundColor = RGBCOLOR(245, 133, 136, 1);
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

//http://www.vipxox.cn/? m=appapi&s=membercenter&act=address_del&id=38&uid=1
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"address_del",@"uid":[UserSession instance].uid,@"id":self.allDatas[indexPath.row][@"id"]};
        NSLog(@"%@",self.allDatas[indexPath.row][@"id"]);
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            
            if ([number isEqualToString:@"0"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"删除成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
        
            }else{
                NSLog(@"%@",data[@"errorMessage"]);
                UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:data[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter1 show];
            }
        }];
        //删除数据
        [self.allDatas removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
            }];
    deleteAction.backgroundColor=RGBCOLOR(193, 0, 22, 1);
    
    return @[deleteAction, readedAction];
}


-(void)gotoGetGoodAddress{
    GetGoodAddressViewController*vc=[[GetGoodAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
