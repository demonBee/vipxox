//
//  SCODetailsViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/23.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SCODetailsViewController.h"
//#import "GoodsTailsViewController.h"
#import "NewGoodDetailViewController.h"


#define BuyDetailCell   @"BuyDetailCell"
#define BuyNumberCell   @"BuyNumberCell"
#define BuyServerCell   @"BuyServerCell"
#define BuyStatusCell   @"BuyStatusCell"
#define BuyThreeCell    @"BuyThreeCell"
#define OrderStatusCell    @"OrderStatusCell"

@interface SCODetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableview;

@property(nonatomic,strong)NSMutableArray *allDatas;

@property(nonatomic,strong)NSArray*goodsInfo;
@property(nonatomic,strong)NSArray*transInfo;

@property(nonatomic,strong)NSMutableArray*goodsDatas;//这个是 用到的array
@property(nonatomic,strong)NSDictionary*pergoodsDatas;

@property(nonatomic,strong)NSMutableArray*expressDatas;
@property(nonatomic,strong)NSDictionary*perDatas;

@property(nonatomic,strong)NSDictionary*transDatas;


@end

@implementation SCODetailsViewController

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableview;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeNavi];
    self.title=@"商城订单详情";
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    self.allDatas=[[NSMutableArray alloc]init];
    self.goodsDatas=[[NSMutableArray alloc]init];
    self.expressDatas=[[NSMutableArray alloc]init];
    self.transDatas=[[NSDictionary alloc]init];
    self.pergoodsDatas=[[NSDictionary alloc]init];
    self.perDatas=[[NSDictionary alloc]init];
    
    //  http://www.vipxox.cn/?m=appapi&s=membercenter&act=mall_list&zt=1&order=SC20160321090957302&uid=1
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"zt":@"5",@"order":self.orderStr,@"uid":[UserSession instance].uid};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        if ([number isEqualToString:@"0"]) {
            self.allDatas=data[@"data"];
            self.goodsDatas=data[@"data"][@"shop"];
            self.expressDatas=data[@"data"][@"loglist"];
            self.transDatas=data[@"data"][@"address"];
        
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
//    titleLabel.text=@"商城订单详情";
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
    
    if (self.allDatas.count==0) {
        return cell;
    }else{
    
    if (indexPath.section==0) {
        for (int j=0; j<self.goodsDatas.count; j++) {
            if (indexPath.row==j) {
                self.pergoodsDatas=self.goodsDatas[j];
                UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BuyDetailCell];
                
                UILabel*label4=[cell viewWithTag:2];
                label4.text=self.pergoodsDatas[@"title"];
                UILabel*label5=[cell viewWithTag:9];
                label5.text=self.pergoodsDatas[@"attr"];
                UIImageView *imageView=[cell viewWithTag:1];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.pergoodsDatas[@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                
                
                UILabel*label99=[cell viewWithTag:99];
                label99.text=[NSString stringWithFormat:@"x%@",self.pergoodsDatas[@"num"]];
//                UILabel*label6=[cell viewWithTag:3];
//                label6.text=@"";
//                UILabel*label7=[cell viewWithTag:8];
//                label7.text=@"";
//                UILabel*label8=[cell viewWithTag:4];
//                label8.text=@"";
                return cell;
                
            }
        }
    }else if(indexPath.section==1){
        
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:OrderStatusCell];

        UILabel*label7=[cell viewWithTag:1];
        label7.text=[NSString stringWithFormat:@"地址：%@",self.transDatas[@"shipping_address"]];
        UILabel*label8=[cell viewWithTag:2];
        label8.text=[NSString stringWithFormat:@"收货人：%@  联系方式：%@",self.transDatas[@"consignee"],self.transDatas[@"shipping_mobile"]];
        
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
                    label3.text= self.perDatas[@"status"];
                    
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
    return 40;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=indexPath.row;
    NSDictionary*dict=self.self.goodsDatas[row];
//    GoodsTailsViewController*vc=[[GoodsTailsViewController alloc]init];
//    vc.thisDatas=dict;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
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
