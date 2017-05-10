//
//  IOInspectLogisticsViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "IOInspectLogisticsViewController.h"
#import "IOInspectLogisticsTableViewCell.h"
#import "IOInspectLogisticsSecondTableViewCell.h"

#define BuyDetailCell   @"BuyDetailCell"

@interface IOInspectLogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*tableview;

@property(nonatomic,strong)NSString *statusStr;
@property(nonatomic,strong)NSDictionary *addressDic;
@property(nonatomic,strong)NSDictionary *InfoDic;
@property(nonatomic,strong)NSMutableArray *dateArray;

@end

@implementation IOInspectLogisticsViewController

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressDic=[[NSDictionary alloc]init];
    self.InfoDic=[[NSDictionary alloc]init];
    self.dateArray=[[NSMutableArray alloc]init];
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    //http://www.vipxox.cn/?m=appapi&s=membercenter&act=gjdd_list&op=details&uid=1&id=
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"gjdd_list",@"op":@"details",@"uid":[UserSession instance].uid,@"id":self.IDStr};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            self.statusStr=data[@"data"][@"status"];
            self.addressDic=data[@"data"][@"address"];
            self.InfoDic=data[@"data"][@"info"];
            self.dateArray=data[@"data"][@"date"];
        }else{
            
        }
        [self.tableview reloadData];
        
    }];

    
//    [self makeNavi];
    self.title=@"国际订单详情";
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[IOInspectLogisticsTableViewCell class] forCellReuseIdentifier:@"666"];
    [self.tableview registerClass:[IOInspectLogisticsSecondTableViewCell class] forCellReuseIdentifier:@"777"];
    [self.tableview registerNib:[UINib nibWithNibName:BuyDetailCell bundle:nil] forCellReuseIdentifier:BuyDetailCell];
}

//-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156-17), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69+44), ACTUAL_HEIGHT(19))];
//    titleLabel.text=@"国际订单详情";
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
    return 5;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else if(section==1){
        return 4;
    }else if(section==2||section==3){
        return 1;
    }else if (section==4){
        return self.dateArray.count;
    }else{
        return 666;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4) {
        return ACTUAL_HEIGHT(100);
    }else{
        return ACTUAL_HEIGHT(30);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==4) {
        return 0.0000001;
    }else{
        return ACTUAL_HEIGHT(2);
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IOInspectLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"666"];
    if (!cell) {
        cell=[[IOInspectLogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.leftLabel.text=@"收件人信息：";
        }else if (indexPath.row==1){
            cell.leftLabel.text=[NSString stringWithFormat:@"姓名：%@",self.addressDic[@"consignee"]];
            cell.rightLabel.text=[NSString stringWithFormat:@"电话：%@",self.addressDic[@"consignee_mobile"]];
        }else if (indexPath.row==2){
            cell.leftLabel.text=[NSString stringWithFormat:@"国家：%@",self.addressDic[@"to_country"]];
            cell.rightLabel.text=[NSString stringWithFormat:@"城市：%@",self.addressDic[@"to_city"]];
        }else if (indexPath.row==3){
            cell.leftLabel.text=[NSString stringWithFormat:@"邮编：%@",self.addressDic[@"zip"]];
            cell.rightLabel.text=[NSString stringWithFormat:@"州/省/区域：%@",self.addressDic[@"to_province"]];
        }else if (indexPath.row==4){
           IOInspectLogisticsSecondTableViewCell*cell2 = [tableView dequeueReusableCellWithIdentifier:@"777"];
            if (!cell2) {
                cell2=[[IOInspectLogisticsSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"777"];
            }
            cell2.firstLabel.text=[NSString stringWithFormat:@"地址：%@",self.addressDic[@"consignee_add"]];
            return cell2;
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.leftLabel.text=@"运单信息:";
            cell.rightLabel.text=@"";
        }else if (indexPath.row==1){
            cell.leftLabel.text=[NSString stringWithFormat:@"重量：%@(g)",self.InfoDic[@"weight"]];
            cell.rightLabel.text=[NSString stringWithFormat:@"体积：%@(L)",self.InfoDic[@"volume"]];
            return cell;
        }else if (indexPath.row==2){
            cell.leftLabel.text=[NSString stringWithFormat:@"实付款：%@%@",[UserSession instance].currency,self.InfoDic[@"final_cost"]];
        }else if (indexPath.row==3){
            IOInspectLogisticsSecondTableViewCell*cell2 = [tableView dequeueReusableCellWithIdentifier:@"777"];
            if (!cell2) {
                cell2=[[IOInspectLogisticsSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"777"];
            }
            cell2.firstLabel.text=[NSString stringWithFormat:@"提交时间：%@",self.InfoDic[@"create_time"]];
            return cell2;
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            cell.leftLabel.text=[NSString stringWithFormat:@"订单状态：%@",self.statusStr];
        }
    }else if (indexPath.section==3){
            cell.leftLabel.text=@"商品信息:";
    }else if (indexPath.section==4){
            for (int i=0; i<self.dateArray.count; i++) {
                if (indexPath.row==i) {
                    UITableViewCell*cell3=[tableView dequeueReusableCellWithIdentifier:BuyDetailCell];
                    UIImageView*imageView1=[cell3 viewWithTag:1];
                    imageView1.backgroundColor=[UIColor whiteColor];
                    imageView1.contentMode=UIViewContentModeScaleAspectFit;

                    [imageView1 sd_setImageWithURL:[NSURL URLWithString:self.dateArray[i][@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_70x70"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (cacheType!=2) {
                            imageView1.alpha=0.3;
                            CGFloat scale = 0.3;
                            imageView1.transform = CGAffineTransformMakeScale(scale, scale);
                            
                            
                            [UIView animateWithDuration:0.3 animations:^{
                                imageView1.alpha=1;
                                CGFloat scale = 1.0;
                                imageView1.transform = CGAffineTransformMakeScale(scale, scale);
                            }];
                        }
                    }];
                    
                    UILabel*label2=[cell3 viewWithTag:2];
                    label2.text=self.dateArray[i][@"title"];
                    
                    UILabel *label9=[cell3 viewWithTag:9];
                    label9.text=@"数量:";
                    
                    UILabel *label3=[cell3 viewWithTag:3];
                    label3.text=self.dateArray[i][@"num"];
                    
                    UILabel *label8=[cell3 viewWithTag:8];
                    label8.text=@"价格:";
                    
                    UILabel *label4=[cell3 viewWithTag:4];
                     float priceStr = [self.dateArray[i][@"price"] floatValue];
                    label4.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,priceStr];
                    
                    return cell3;
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
