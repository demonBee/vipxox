//
//  AffirmOrderViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/25.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "AffirmOrderViewController.h"
#import "AffirmOrderTableViewCell.h"
#import "AffirmOrder.h"
#import "TMAddressViewController.h"

@interface AffirmOrderViewController ()<UITableViewDataSource,UITableViewDelegate,TMAddressViewControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView *BGView;

@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *priceArray;
@property(nonatomic,strong)NSMutableArray *introduceArray;
@property(nonatomic,strong)NSMutableArray *limitedArray;
@property(nonatomic,strong)NSMutableArray *leastArray;
@property(nonatomic,strong)NSMutableArray *mostArray;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *addressLabel;

@property(nonatomic,strong)NSString *codeStr;

@property(nonatomic,assign)BOOL canSave;    //判断是否符合

@property(nonatomic,strong)UILabel*totailLabel;   //运费的总价
@end

@implementation AffirmOrderViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(180), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(240)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择快递";
    
//    [self makeNavi];
    [self makeView];

    NSMutableArray*array=[self.allDatas mutableCopy];
  
    self.allDatas=[NSMutableArray array];
     for (int i=0; i<array.count; i++) {
        AffirmOrder *order=[[AffirmOrder alloc]initWithShopDict:array[i]];
         [self.allDatas addObject:order];
    
    }
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[AffirmOrderTableViewCell class] forCellReuseIdentifier:@"666"];

}

-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);

    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69), ACTUAL_WIDTH(19))];
    titleLabel.text=@"选择快递";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

#pragma mark--tableView属性设置

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ACTUAL_HEIGHT(2);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(130);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    //创建Cell
    AffirmOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"666"];
    
    //设置成点击Cell后无法显示被选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AffirmOrder*order=self.allDatas[indexPath.section];
    cell.imageHook.userInteractionEnabled=NO;
    if (order.selected==YES) {
        cell.imageHook.selected=YES;

    }else{
        cell.imageHook.selected=NO;
    }
    
    cell.titleLabel.text=order.name;
    cell.introduceLabel.text=order.line_t;
    
    CGFloat priceFloat=[order.shprice floatValue];
    cell.priceLabel.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,priceFloat];
    cell.courierLimitedLabel.text=order.mail_x;
    cell.dayLabel.text=[NSString stringWithFormat:@"%@到%@个工作日",order.timeliness_least,order.timeliness_most];
    [cell.courierImageView sd_setImageWithURL:[NSURL URLWithString:order.logo] placeholderImage:[UIImage imageNamed:@"placeholder_40x40"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            cell.courierImageView.alpha=0.3;
            CGFloat scale = 0.3;
            cell.courierImageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.courierImageView.alpha=1;
                CGFloat scale = 1.0;
                cell.courierImageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<self.allDatas.count; i++) {
        AffirmOrder*order=self.allDatas[i];
        order.selected=NO;
    }
    
    AffirmOrder*model=self.allDatas[indexPath.section];
    model.selected=YES;
    self.codeStr=model.code;
    
    //计算总价
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"count_cloud",@"uid":[UserSession instance].uid,@"pids":self.pidStr,@"logisticscode":self.codeStr,@"zts":@"1"};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            
            CGFloat MoneyFloat=[data[@"money"] floatValue];
            _totailLabel.text=[NSString stringWithFormat:@"总价：%@%.2f(含有燃油附加费等费用)",[UserSession instance].currency,MoneyFloat];
            [self.tableView reloadData];

        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
    }];

    
    [self.tableView reloadData];
    
}

-(void)makeView{
    _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    _BGView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_BGView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(80), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(20))];
//    _nameLabel.backgroundColor=[UIColor redColor];
    _nameLabel.text=[NSString stringWithFormat:@"收货人：%@",self.addressDic[@"name"]];
    [self.view addSubview:_nameLabel];
    
    _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(110), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(20))];
//    _phoneLabel.backgroundColor=[UIColor greenColor];
    _phoneLabel.text=[NSString stringWithFormat:@"联系方式：%@",self.addressDic[@"mobile"]];
    [self.view addSubview:_phoneLabel];
    
    _addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(140), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(20))];
//    _addressLabel.backgroundColor=[UIColor purpleColor];
    _addressLabel.text=[NSString stringWithFormat:@"收货地址：%@/%@/%@/%@",self.addressDic[@"country_name"],self.addressDic[@"province_name"],self.addressDic[@"city_name"],self.addressDic[@"address"]];
    [self.view addSubview:_addressLabel];
    
    UIButton *BGButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(64), KScreenWidth,ACTUAL_HEIGHT(160))];
    [BGButton addTarget:self action:@selector(gotoGetGoodAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BGButton];
    
    //确定按钮
    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(280),KScreenHeight-ACTUAL_HEIGHT(50), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(40))];
    sureButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [sureButton setTitle:@"确定" forState:0];
    [sureButton.layer setCornerRadius:5.0];
    [sureButton addTarget:self  action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    
    //label 显示总运费
    _totailLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20),KScreenHeight-ACTUAL_HEIGHT(50), ACTUAL_WIDTH(250), ACTUAL_HEIGHT(20))];
    _totailLabel.centerY=sureButton.centerY;
    _totailLabel.font=[UIFont systemFontOfSize:12];
//    _totailLabel.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:_totailLabel];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(345), ACTUAL_HEIGHT(110), ACTUAL_WIDTH(15), ACTUAL_HEIGHT(30))];
    
    imageView.image=[UIImage imageNamed:@"youhui"];
    [self.view addSubview:imageView];
    
}

-(void)sendMessage{
    
    NSString*str=[self judgeCansave];
    
    if (_canSave) {
        
        //http://www.vipxox.cn/? m=appapi&s=membercenter&act=count_cloud&uid=1&pids=1&logisticscode=
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"count_cloud",@"uid":[UserSession instance].uid,@"pids":self.pidStr,@"logisticscode":self.codeStr};
        
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            NSLog(@"%@",number);
            
            if ([number isEqualToString:@"0"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提交成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"%@",data[@"errorMessage"]);
                UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:data[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter1 show];
            }
            
        }];
        
    }else{
        [JRToast showWithText:str duration:2.0];
    }
}

-(NSString*)judgeCansave{
    _canSave=NO;
    
    if (self.codeStr.length==0) {
        _canSave=NO;
        return @"请选择快递！";
    }else{
        _canSave=YES;
    }
   return @"1111";
}

-(void)gotoGetGoodAddress{
    TMAddressViewController *vc=[[TMAddressViewController alloc]init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)DelegateForSendValueToAddress:(NSDictionary *)dict{
    _nameLabel.text=[NSString stringWithFormat:@"收货人：%@",dict[@"name"]];
    _phoneLabel.text=[NSString stringWithFormat:@"联系方式：%@",dict[@"mobile"]];
    _addressLabel.text=[NSString stringWithFormat:@"收货地址：%@/%@/%@/%@",dict[@"country_name"],dict[@"province_name"],dict[@"city_name"],dict[@"address"]];
}
-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
