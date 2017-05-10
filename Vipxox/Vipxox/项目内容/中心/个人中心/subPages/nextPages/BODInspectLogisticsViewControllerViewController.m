//
//  BODInspectLogisticsViewControllerViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/20.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "BODInspectLogisticsViewControllerViewController.h"

#define BuyDetailCell   @"BuyDetailCell"
#define BuyStatusCell   @"BuyStatusCell"
#define BuyThreeCell    @"BuyThreeCell"

@interface BODInspectLogisticsViewControllerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableview;

@property(nonatomic,strong)NSDictionary*allDatas;//这个是 用到的array
@property(nonatomic,strong)NSMutableArray*stateArray;
@property(nonatomic,strong)NSDictionary*perDatas;

@end

@implementation BODInspectLogisticsViewControllerViewController

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
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);

//    [self makeNavi];
    self.title=@"代购物流详情";
    self.allDatas=[[NSDictionary alloc]init];
    self.stateArray=[[NSMutableArray alloc]init];
    self.perDatas=[[NSDictionary alloc]init];

    // http://www.vipxox.cn/?m=appapi&s=membercenter&act=dg_detail&uid=1&dgpid=369
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"dg_detail",@"uid":[UserSession instance].uid,@"dgpid":self.str};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
       
        if ([number isEqualToString:@"0"]) {
            self.allDatas=data[@"data"][@"dg_detail"];
            [self.stateArray addObjectsFromArray:data[@"data"][@"dg_detail"][@"logs"]];

        }else{
            
        }
        [self.tableview reloadData];
        
    }];
    
    [self.tableview registerNib:[UINib nibWithNibName:BuyDetailCell bundle:nil] forCellReuseIdentifier:BuyDetailCell];
    [self.tableview registerNib:[UINib nibWithNibName:BuyStatusCell bundle:nil] forCellReuseIdentifier:BuyStatusCell];
    [self.tableview registerNib:[UINib nibWithNibName:BuyThreeCell bundle:nil] forCellReuseIdentifier:BuyThreeCell];
    
    [self.view addSubview:self.tableview];
}

//-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156-17), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69+44), ACTUAL_HEIGHT(19))];
//    titleLabel.text=@"代购物流详情";
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.stateArray.count;
    }
    
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section==0) {
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BuyDetailCell];
        
        UILabel*label4=[cell viewWithTag:2];
        label4.text=self.allDatas[@"title"];
        
        UILabel*label5=[cell viewWithTag:9];
        label5.text=self.allDatas[@"attr_desc"];
        
        UIImageView*imageView3=[cell viewWithTag:1];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:self.allDatas[@"pro_pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_70x70"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
        
        UILabel*label8=[cell viewWithTag:4];
        label8.text=@"";
        UILabel*label6=[cell viewWithTag:3];
        label6.text=@"";
        UILabel*label7=[cell viewWithTag:8];
        label7.text=@"";

        
        return cell;
    }else if(indexPath.section==1){
        for (int i=0; i<self.stateArray.count; i++) {
            if (indexPath.row==i) {
                if (i==0) {
                    self.perDatas=self.stateArray[i];
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
                    self.perDatas=self.stateArray[i];
                    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
