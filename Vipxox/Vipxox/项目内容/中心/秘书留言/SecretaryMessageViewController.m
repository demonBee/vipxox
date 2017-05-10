//
//  SecretaryMessageViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SecretaryMessageViewController.h"
#import "SecretaryMessageTableViewCell.h"

@interface SecretaryMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array


@property(nonatomic,strong)UIButton*button0;
@property(nonatomic,strong)UIButton*button1;
@property(nonatomic,strong)UIButton*button2;
@property(nonatomic,strong)UIButton*button3;

@property(nonatomic,strong) NSArray*arr0;   //秘书留言
@property(nonatomic,strong) NSArray*arr1;   //交易信息
@property(nonatomic,strong) NSArray*arr2;   //活动信息
@property(nonatomic,strong) NSArray*arr3;   //系统信息

//@property(nonatomic,assign)int pagen;   //每页多少条
//@property(nonatomic,assign)int pages;   //第几页

@property(nonatomic,assign)NSString *msgtype; //jiaoyi=交易信息 activity=活动信息 system=系统信息 secretary=秘书留言

@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,strong)UITableView*tableView;

@end



@implementation SecretaryMessageViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(105), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(110)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self makeNavi];
    [self createView];
//    self.pages=0;
//    self.pagen=5;
    self.msgtype=@"secretary";
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    [self.tableView registerClass:[SecretaryMessageTableViewCell class] forCellReuseIdentifier:@"666"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
       self.navigationController.navigationBarHidden=NO;
      }

-(void)makeNavi{
    
    self.title=@"留言";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(70,73,70,1)];
}

-(void)createView{
    //0
    _button0=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button0 setTitle:@"秘书留言" forState:UIControlStateNormal];
    [_button0 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [_button0 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    [_button0 setImage:[UIImage imageNamed:@"bigShadow"] forState:UIControlStateHighlighted];
//    _button0.backgroundColor=[UIColor redColor];
    _button0.selected=YES;
    _button0.titleLabel.font=[UIFont systemFontOfSize:14];
    _button0.frame=CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(70),KScreenWidth/4, ACTUAL_HEIGHT(28));
    [_button0 addTarget:self action:@selector(touchButton0:) forControlEvents:UIControlEventTouchUpInside];
    _button0.tag=0;
    [self.view addSubview:_button0];
    
    
    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(102),KScreenWidth/4, ACTUAL_HEIGHT(2))];
    self.bottomView.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [self.view addSubview:self.bottomView];
    
    
    //1
    _button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setTitle:@"交易信息" forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    _button1.titleLabel.font=[UIFont systemFontOfSize:14];
    _button1.frame=CGRectMake(KScreenWidth/4, ACTUAL_HEIGHT(70),KScreenWidth/4, ACTUAL_HEIGHT(28));
    [_button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    _button1.tag=1;
    
    
    
    //2
    _button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setTitle:@"活动信息" forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    _button2.titleLabel.font=[UIFont systemFontOfSize:14];
    _button2.frame=CGRectMake(KScreenWidth/2, ACTUAL_HEIGHT(70), KScreenWidth/4, ACTUAL_HEIGHT(28));
    [_button2 addTarget:self action:@selector(touchButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    _button2.tag=2;
    
    
    //3
    _button3=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setTitle:@"系统信息" forState:UIControlStateNormal];
    [_button3 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [_button3 setTitleColor:RGBCOLOR(70, 73, 70, 1) forState:UIControlStateSelected];
    _button3.titleLabel.font=[UIFont systemFontOfSize:14];
    _button3.frame=CGRectMake(KScreenWidth/4*3, ACTUAL_HEIGHT(70),KScreenWidth/4, ACTUAL_HEIGHT(28));
    [_button3 addTarget:self action:@selector(touchButton3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button3];
    _button3.tag=3;
    
}

#pragma mark - 设置tableView的属性

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
    return ACTUAL_HEIGHT(115);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建Cell
    SecretaryMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"666"];
    if (self.allDatas.count==0) {
        return cell;
    }else{
    
    cell.titleLabel.text=self.allDatas[indexPath.row][@"sub"];
    cell.dateLabel.text=self.allDatas[indexPath.row][@"date"];
    cell.contentLabel.text=self.allDatas[indexPath.row][@"con"];
    return cell;
    }
}

#pragma mark - 设置cell侧滑按钮
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    QHLShop *shop = self.shoppingCar[indexPath.section];
    /**
     *  BlurEffect 毛玻璃特效
     */
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
 //http://www.vipxox.cn/?  m=appapi&s=membercenter&act=msmessage&op=del&mid=2&uid=1
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"msmessage",@"op":@"del",@"mid":self.allDatas[indexPath.row][@"id"],@"uid":[UserSession instance].uid};
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
    deleteAction.backgroundColor=RGBCOLOR(239, 97, 101, 1);
    
//    return @[deleteAction, readedAction];
    
     return @[deleteAction];
}




-(void)touchButton0:(UIButton*)sender{
    _button0.selected=YES;
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.frame=CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(102),KScreenWidth/4, ACTUAL_HEIGHT(2));
    }];
    
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];
    self.msgtype=@"secretary";
    [self.tableView headerBeginRefreshing];
    [self.tableView reloadData];

    
}
-(void)touchButton1:(UIButton*)sender{
    _button0.selected=NO;
    _button1.selected=YES;
    _button2.selected=NO;
    _button3.selected=NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.frame=CGRectMake(KScreenWidth/4, ACTUAL_HEIGHT(102), KScreenWidth/4, ACTUAL_HEIGHT(2));
    }];
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];
    self.msgtype=@"jiaoyi";
    [self.tableView headerBeginRefreshing];
    [self.tableView reloadData];
}
-(void)touchButton2:(UIButton*)sender{
    _button0.selected=NO;
    _button1.selected=NO;
    _button2.selected=YES;
    _button3.selected=NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.frame=CGRectMake(KScreenWidth/2, ACTUAL_HEIGHT(102),KScreenWidth/4, ACTUAL_HEIGHT(2));
    }];
    
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];
    self.msgtype=@"activity";
    [self.tableView headerBeginRefreshing];
    [self.tableView reloadData];

    
}

-(void)touchButton3:(UIButton*)sender{
    _button0.selected=NO;
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.frame=CGRectMake(KScreenWidth/4*3, ACTUAL_HEIGHT(102), KScreenWidth/4, ACTUAL_HEIGHT(2));
    }];
    
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];
    self.msgtype=@"system";
    [self.tableView headerBeginRefreshing];
    [self.tableView reloadData];

    
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
    
    // http://www.vipxox.cn/?m=appapi&s=membercenter&act=msmessage&msgtype=system&uid=e9c7fcd5dc8458063c49375d6089d4c5
    
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
//    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
//    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"msmessage",@"msgtype":_msgtype,@"uid":[UserSession instance].uid};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            self.allDatas=nil;
            self.allDatas=[NSMutableArray array];
            
         [self.allDatas addObjectsFromArray:data[@"data"][@"msmlist"]];
    
            // 刷新表格
            [self.tableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
            
        }else{
            UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:nil message:@"暂无信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter1 show];
        }
        
    }];
    
}

//- (void)footerRereshing
//{
//    self.pages++;
//    
//    //  	http://www.vipxox.cn/?  m=appapi&s=membercenter&act=cloud_warehouse&uid=1&pagen=6&pages=1&zt=3
//    
//    
//    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
//    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
//    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
//    //    NSString*statu=[NSString stringWithFormat:@"%d",self.statu];
//    
//    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"consumption_record",@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages};
//    HttpManager *manager=[[HttpManager alloc]init];
//    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
//        NSLog(@"%@",data);
//        
//        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
//        NSLog(@"%@",number);
//        
//        if ([number isEqualToString:@"0"]) {
//            
//            
//            [self.allDatas addObjectsFromArray:data[@"data"]];
//            // 刷新表格
//            [self.tableView reloadData];
//            
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self.tableView footerEndRefreshing];
//            
//        }else{
//        }
//    }];
//}

@end
