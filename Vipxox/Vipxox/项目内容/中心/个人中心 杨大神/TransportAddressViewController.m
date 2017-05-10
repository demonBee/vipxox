//
//  TransportAddressViewController.m
//  weimao
//
//  Created by Tian Wei You on 16/2/21.
//  Copyright © 2016年 Tian Wei You. All rights reserved.
//

#import "TransportAddressViewController.h"

@interface TransportAddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation TransportAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout=YES;
     self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    [self makeNavi];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"转运地址";
    self.navigationController.navigationBarHidden=NO;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64,KScreenWidth, KScreenHeight-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
}

//-(void)makeNavi{
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"转运地址";
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

//-(void)dismissTo{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(51);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"mycell";
    
    //初始化倒入的TableViewCell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        
        //设置cell为不可选中显示
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIFont *myFont= [ UIFont fontWithName: @"Arial" size: 16];
        cell.textLabel.font = myFont;
        
        cell.textLabel.numberOfLines=2;
        
        if (indexPath.section==0 && indexPath.row==0) {
            cell.textLabel.text=@"收货人姓名：小明";
        }else if (indexPath.section==1 && indexPath.row==0){
            cell.textLabel.text=@"所在地区：上海市嘉定区";
        }else if (indexPath.section==2 && indexPath.row==0){
            cell.textLabel.text=@"街道地址：宝安公路2999弄东方慧谷152号";
        }else if (indexPath.section==3 && indexPath.row==0){
            cell.textLabel.text=@"邮政编码：201801";
        }else if (indexPath.section==4 && indexPath.row==0){
            cell.textLabel.text=@"手机号码：131-2079-8177";
        }
    }
    return cell;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
