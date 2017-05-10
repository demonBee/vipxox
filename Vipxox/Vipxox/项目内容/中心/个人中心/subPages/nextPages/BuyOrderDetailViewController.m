//
//  BuyOrderDetailViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/14.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "BuyOrderDetailViewController.h"


#define BuyDetailCell   @"BuyDetailCell"
#define BuyNumberCell   @"BuyNumberCell"
#define BuyServerCell   @"BuyServerCell"
#define BuyStatusCell   @"BuyStatusCell"
#define BuyThreeCell    @"BuyThreeCell"
#define OrderStatusCell    @"OrderStatusCell"

@interface BuyOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView*tableview;

@property(nonatomic,strong)NSArray*goodsInfo;
@property(nonatomic,strong)NSArray*transInfo;

@property(nonatomic,strong)NSMutableArray*goodsDatas;//这个是 用到的array
@property(nonatomic,strong)NSDictionary*pergoodsDatas;

@property(nonatomic,strong)NSMutableArray*expressDatas;
@property(nonatomic,strong)NSDictionary*perDatas;

@property(nonatomic,strong)NSDictionary*transDatas;

@end

@implementation BuyOrderDetailViewController

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"转运订单";
    self.navigationController.navigationBarHidden=NO;
//    [self makeNavi];
  
    self.goodsDatas=[[NSMutableArray alloc]init];
    self.expressDatas=[[NSMutableArray alloc]init];
    self.transDatas=[[NSDictionary alloc]init];
    self.pergoodsDatas=[[NSDictionary alloc]init];
    self.perDatas=[[NSDictionary alloc]init];
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
//  http://www.vipxox.cn/?m=appapi&s=membercenter&act=transport&uid=1&op=4&order_sn=

    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"uid":[UserSession instance].uid,@"op":@"4",@"order_sn":self.str};
   
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];

    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {

    NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        if ([number isEqualToString:@"0"]) {
            [self.goodsDatas addObjectsFromArray:data[@"data"][@"shop"]];
            [self.expressDatas addObjectsFromArray:data[@"data"][@"log"]];
            self.transDatas=data[@"data"][@"wuliu"];
//            NSLog(@"%@",self.expressDatas);
//            NSLog(@"%lu",(unsigned long)self.expressDatas.count);
        }else{
        
        }
        [self.tableview reloadData];
        
    }];
    
    [self.tableview registerNib:[UINib nibWithNibName:BuyDetailCell bundle:nil] forCellReuseIdentifier:BuyDetailCell];
    [self.tableview registerNib:[UINib nibWithNibName:BuyNumberCell bundle:nil] forCellReuseIdentifier:BuyNumberCell];
    [self.tableview registerNib:[UINib nibWithNibName:BuyServerCell bundle:nil] forCellReuseIdentifier:BuyServerCell];
    [self.tableview registerNib:[UINib nibWithNibName:BuyStatusCell bundle:nil] forCellReuseIdentifier:BuyStatusCell];
    [self.tableview registerNib:[UINib nibWithNibName:BuyThreeCell bundle:nil] forCellReuseIdentifier:BuyThreeCell];
    [self.tableview registerNib:[UINib nibWithNibName:OrderStatusCell bundle:nil] forCellReuseIdentifier:OrderStatusCell];
    
    [self.view addSubview:self.tableview];


}

//-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156-17), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69+44), ACTUAL_HEIGHT(19))];
//    titleLabel.text=@"转运订单详情";
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
//-(void)dismissTo{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return self.goodsDatas.count;
    }else if(section==1){
        return 1;
    }else{
        return self.expressDatas.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section==0) {
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BuyDetailCell];
        
        for (int i=0; i<self.goodsDatas.count; i++) {
            if (indexPath.row==i) {
                NSLog(@"%d",i);
                self.pergoodsDatas=self.goodsDatas[i];
              
                
                UILabel*label4=[cell viewWithTag:2];
                label4.text=self.pergoodsDatas[@"name"];
                UILabel*label5=[cell viewWithTag:9];
                label5.text=[NSString stringWithFormat:@"种类:%@",self.pergoodsDatas[@"remark"]];
                
                UILabel*label8=[cell viewWithTag:4];
                label8.text=[NSString stringWithFormat:@"状态:%@",self.pergoodsDatas[@"status"]];
                UILabel*label6=[cell viewWithTag:3];
                label6.text=@"";
                UILabel*label7=[cell viewWithTag:8];
                label7.text=@"";
                
                return cell;

            }
        }
    }else if(indexPath.section==1){
      
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:OrderStatusCell];
        UILabel*label7=[cell viewWithTag:1];
        label7.text=self.transDatas[@"logi_num"];
        UILabel*label8=[cell viewWithTag:2];
        label8.text=self.transDatas[@"logi_name"];
        
        return cell;
  
    }else if (indexPath.section==2){
        for (int i=0; i<self.expressDatas.count; i++) {
            if (indexPath.row==i) {
                if (i==0) {
                    self.perDatas=self.expressDatas[i];
//                    NSLog(@"%@",self.perDatas);
                    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BuyStatusCell];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    
                    UILabel*label1=[cell viewWithTag:3];
                    label1.text=self.perDatas[@"status"];
                    UILabel*label2=[cell viewWithTag:4];
                    label2.text=self.perDatas[@"create_time"];
                    UILabel*label3=[cell viewWithTag:1];
                    label3.text=self.perDatas[@"status"];
                    
                    return cell;

                }else{
                    self.perDatas=self.expressDatas[i];
                    NSLog(@"%@",self.perDatas);
                    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BuyThreeCell];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    UILabel*label1=[cell viewWithTag:2];
                    label1.text=self.perDatas[@"status"];
                    UILabel*label2=[cell viewWithTag:3];
                    label2.text=self.perDatas[@"create_time"];
                    
                    return cell;

                }
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 107;
    }else if (indexPath.section==2&&indexPath.row==0){
        return 98;
    }else{
        return 65;
    }

    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
