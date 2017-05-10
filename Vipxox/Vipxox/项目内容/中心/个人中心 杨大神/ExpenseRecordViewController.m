//
//  ExpenseRecordViewController.m
//  weimao
//
//  Created by Tian Wei You on 16/2/21.
//  Copyright © 2016年 Tian Wei You. All rights reserved.
//

#import "ExpenseRecordViewController.h"
#import "ExpenseRecordTableViewCell.h"

@interface ExpenseRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array
@property(nonatomic,strong)NSString*currencyData;   //货币种类

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页
//@property(nonatomic,assign)int statu; //1=未完成 2=已完成


@end

@implementation ExpenseRecordViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//     self.view.backgroundColor=RGBCOLOR(239, 97, 101, 1);
    self.automaticallyAdjustsScrollViewInsets=NO;
//    [self makeNavi];
    self.title=@"消费记录";
    self.navigationController.navigationBarHidden=NO;
    [self.view addSubview:self.tableView];
    
    self.pages=0;
    self.pagen=8;
//    self.statu=1;
    [self setupRefresh];
    [self.tableView registerClass:[ExpenseRecordTableViewCell class] forCellReuseIdentifier:@"666"];

}

//-(void)makeNavi{
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//
//    
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"消费记录";
//    titleLabel.textAlignment=1;
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:titleLabel];
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}
//
//-(void)dismissTo{
//    [self.navigationController popViewControllerAnimated:YES];
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allDatas.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(90);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  static NSString *CellID = @"mycell";
    
    //创建Cell
    ExpenseRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"666"];
    
    //设置成点击Cell后无法显示被选中
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.allDatas.count==0) {
        return cell;
    }else{
    
    cell.firstLabel1.text=self.allDatas[indexPath.row][@"day"];
    cell.firstLabel2.text=self.allDatas[indexPath.row][@"time"];
    float floatString = [self.allDatas[indexPath.row][@"price"] floatValue];
    cell.firstLabel3.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,floatString];
//        cell.firstLabel3.backgroundColor=[UIColor redColor];
    cell.firstLabel4.text=self.allDatas[indexPath.row][@"note"];
    
    if ([self.allDatas[indexPath.row][@"statu"]isEqualToString:@"1"]) {
        cell.firstLabel5.text=@"状态：未完成";
    }else if ([self.allDatas[indexPath.row][@"statu"]isEqualToString:@"2"]){
        cell.firstLabel5.text=@"状态：已完成";
    }
   
    NSLog(@"%@",self.allDatas[indexPath.row][@"mold"]);
    NSLog(@"%lu",indexPath.row);
    if ([self.allDatas[indexPath.row][@"mold"]isEqualToString:@"1"]||[self.allDatas[indexPath.row][@"mold"]isEqualToString:@"0"]) {
       cell.imageview1.image=[UIImage imageNamed:@"jia"];
    }else if([self.allDatas[indexPath.row][@"mold"]isEqualToString:@"-1"]){
      cell.imageview1.image=[UIImage imageNamed:@"jian"];
    }else{
        cell.imageview1.image=nil;
    }
    
    }
    return cell;
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
    
//   http://www.vipxox.cn/?m=appapi&s=membercenter&act=consumption_record&uid=1&pagen=5&pages=0

    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    self.pages=0;
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
//    NSString*statu=[NSString stringWithFormat:@"%d",self.statu];
    
    NSLog(@"%@",[UserSession instance].uid);
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"consumption_record",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages};
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        _currencyData=data[@"currency"];
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
            [self.tableView headerEndRefreshing];
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
//    NSString*statu=[NSString stringWithFormat:@"%d",self.statu];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"consumption_record",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages};
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
