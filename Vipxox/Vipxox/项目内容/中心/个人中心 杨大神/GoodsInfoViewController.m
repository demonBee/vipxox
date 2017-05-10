//
//  GoodsInfoViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/31.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "EvaluationViewController.h"

#define BuyDetailCell   @"BuyDetailCell"

@interface GoodsInfoViewController ()<UITableViewDataSource,UITableViewDelegate,EvaluationViewControllerDelegate>

@property(nonatomic,strong)UITableView*tableview;
@property(nonatomic,strong)NSMutableArray *allDatas;

@end

@implementation GoodsInfoViewController

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(64)) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self setupRefresh];

    [self.tableview registerNib:[UINib nibWithNibName:BuyDetailCell bundle:nil] forCellReuseIdentifier:BuyDetailCell];
    [self.view addSubview:self.tableview];
}

-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(79), ACTUAL_WIDTH(19))];
    titleLabel.text=@"商品列表";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupRefresh];
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allDatas.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(100);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BuyDetailCell];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BuyDetailCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    UIImageView *imageView=[cell viewWithTag:1];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;

    [imageView sd_setImageWithURL:[NSURL URLWithString:self.allDatas[indexPath.section][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView.alpha=0.3;
            CGFloat scale = 0.3;
            imageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.alpha=1;
                CGFloat scale = 1.0;
                imageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    
    UILabel *label2=[cell viewWithTag:2];
    label2.text=self.allDatas[indexPath.section][@"title"];
    
//    UILabel *label9=[cell viewWithTag:9];
//    label9.text=@"数量：";
    
    UILabel *label99=[cell viewWithTag:99];
    label99.text=[NSString stringWithFormat:@"x%@",self.allDatas[indexPath.section][@"num"]];
//    label99.text=self.allDatas[indexPath.section][@"num"];
//    label99.backgroundColor=[UIColor redColor];
    
//    UILabel *label8=[cell viewWithTag:8];
//    
//    label8.text=@"";
    
    UILabel *label9=[cell viewWithTag:9];
    float PriceStr=[self.allDatas[indexPath.section][@"price"] floatValue];
    label9.text=[NSString stringWithFormat:@"%@ 价格：%@%.2f",self.allDatas[indexPath.section][@"attr"],[UserSession instance].currency,PriceStr];
    
    UILabel *haveEvaluationLabel=[cell viewWithTag:11];
    if (!haveEvaluationLabel) {
        haveEvaluationLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(330), ACTUAL_HEIGHT(45), ACTUAL_WIDTH(50), ACTUAL_HEIGHT(20))];
        haveEvaluationLabel.tag=11;
        haveEvaluationLabel.textColor=RGBCOLOR(193, 0, 22, 1);
        haveEvaluationLabel.text=self.allDatas[indexPath.section][@"status"];
        haveEvaluationLabel.font=[UIFont systemFontOfSize:13];
        haveEvaluationLabel.textAlignment=0;
        [cell addSubview:haveEvaluationLabel];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.allDatas[indexPath.section][@"status"] isEqualToString:@"已评价"]) {
        
    }else{
    EvaluationViewController *vc=[[EvaluationViewController alloc]init];
    vc.attrStr=self.allDatas[indexPath.section][@"attr"];
    vc.pidStr=self.allDatas[indexPath.section][@"id"];
    vc.order_idStr=self.IDStr;
    vc.idd=self.allDatas[indexPath.section][@"idd"];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)delegateForBack1:(NSString *)str1 andSection:(NSInteger)section{
    UITableViewCell*cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    UILabel *haveEvaluationLabel=[cell viewWithTag:11];
    haveEvaluationLabel.text=@"已评价";
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableview headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    
    self.allDatas=nil;
    self.allDatas=[NSMutableArray array];
    
    
    //http://www.vipxox.cn/?m=appapi&s=membercenter&act=mall_list&zt=5&order=&uid=
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"zt":@"5",@"order":self.IDStr,@"uid":[UserSession instance].uid};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            self.allDatas=data[@"data"][@"shop"];
            
        }else{
            
        }
        [self.tableview reloadData];
        
    }];
    [self.tableview headerEndRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
