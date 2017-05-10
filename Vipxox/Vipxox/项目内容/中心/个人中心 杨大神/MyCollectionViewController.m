//
//  MyCollectionViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionTableViewCell.h"
//#import "GoodsTailsViewController.h"
#import "NewGoodDetailViewController.h"
#import "GoodsBuyOnBehalfViewController.h"

@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array

@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页


@property(nonatomic,strong)UIView *headLineView;

@end

@implementation MyCollectionViewController

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
    self.navigationController.navigationBarHidden=NO;
        self.title=@"我的收藏";
//    [self makeNavi];
    [self makeView];
    self.pages=0;
    self.pagen=8;
    [self setupRefresh];

    [self.tableView registerClass:[MyCollectionTableViewCell class] forCellReuseIdentifier:@"666"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;
}

//-(void)makeNavi{
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);    
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(30),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"我的收藏";
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
//    
//}

-(void)makeView{
//    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth,KScreenHeight-64)];
//    view.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:view];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.allDatas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(120);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建Cell
    MyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"666"];
    if (self.allDatas.count==0) {
        return cell;
    }else{
    
    
    
    //设置成点击Cell后无法显示被选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text=self.allDatas[indexPath.row][@"title"];
//    cell.currencyLabel.text=[NSString stringWithFormat:@"%@",[UserSession instance].currency];
    cell.moneyLabel.text=[NSString stringWithFormat:@"%@%@",[UserSession instance].currency,self.allDatas[indexPath.row][@"price"]];
    cell.goodsDetailLabel.text=self.allDatas[indexPath.row][@"attr_desc"];
    [cell.imageview1 sd_setImageWithURL:[NSURL URLWithString:self.allDatas[indexPath.row][@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_70x95"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            cell.imageview1.alpha=0.3;
            CGFloat scale = 0.3;
            cell.imageview1.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.imageview1.alpha=1;
                CGFloat scale = 1.0;
                cell.imageview1.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.allDatas[indexPath.row][@"s_type"] isEqualToString:@"dg"]) {
    NSDictionary *thisDic=@{@"id":self.allDatas[indexPath.row][@"id"]};
    GoodsBuyOnBehalfViewController *vc=[[GoodsBuyOnBehalfViewController alloc]init];
    vc.thisDatas=thisDic;
        vc.url=self.allDatas[indexPath.row][@"url"];
    [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.allDatas[indexPath.row][@"s_type"] isEqualToString:@"vipxox"]){
        NSDictionary *thisDic2=@{@"id":self.allDatas[indexPath.row][@"id"]};
//        GoodsTailsViewController *vc2=[[GoodsTailsViewController alloc]init];
//        vc2.thisDatas=thisDic2;
//        [self.navigationController pushViewController:vc2 animated:YES];
        
        NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:thisDic2];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - 设置cell侧滑按钮

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    QHLShop *shop = self.shoppingCar[indexPath.section];
    /**
     *  BlurEffect 毛玻璃特效
     */
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //http://www.vipxox.cn/? m=appapi&s=membercenter&act=collection&zt=1&uid=1&id=
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"collection",@"zt":@"1",@"uid":[UserSession instance].uid,@"id":self.allDatas[indexPath.row][@"ids"]};
        
        NSLog(@"%@",self.allDatas[indexPath.row][@"ids"]);
        
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
    deleteAction.backgroundColor=RGBCOLOR(239, 97, 101, 1);
    
    return @[deleteAction];
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
    //    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];

}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];
    
    // http://www.vipxox.cn/?m=appapi&s=membercenter&act=collection&zt=0&uid=1&pagen=6&pages=0
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    self.pages=0;
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"collection",@"zt":@"0",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            
            [self.allDatas addObjectsFromArray:data[@"data"]];
            
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
            
        }else{
            UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:nil message:@"我的收藏为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter1 show];
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

 NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"collection",@"zt":@"0",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages};

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


-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
