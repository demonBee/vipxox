//
//  GetGoodAddressViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/16.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "GetGoodAddressViewController.h"
#import "CountryViewController.h"
#import "StateViewController.h"
#import "CityViewController.h"
#import "PostalCodeViewController.h"
#import "AddressViewController.h"
#import "NameViewController.h"
#import "PhoneViewController.h"

@interface GetGoodAddressViewController ()<UITableViewDataSource,UITableViewDelegate,CountryViewControllerDelegate,StateViewControllerDelegate,CityViewControllerDelegate,PostalCodeViewControllerDelegate,AddressViewControllerDelegate,NameViewControllerDelegate,PhoneViewControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)UILabel*label0;
@property(nonatomic,strong)UILabel*label1;
@property(nonatomic,strong)UILabel*label2;
@property(nonatomic,strong)UILabel*label3;
@property(nonatomic,strong)UILabel*label4;
@property(nonatomic,strong)UILabel*label5;
@property(nonatomic,strong)UILabel*label6;
@property(nonatomic,strong)UILabel*label7;

@property(nonatomic,assign)BOOL canSave;    //判断是否符合

@end

@implementation GetGoodAddressViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(64)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self.view addSubview:self.tableView];
    
    UIView*whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(407), KScreenWidth, ACTUAL_HEIGHT(203))];
    whiteView.backgroundColor=[UIColor whiteColor];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(149), KScreenWidth, 2)];
    lineview.backgroundColor=RGBCOLOR(246, 246, 2246, 1);
    [whiteView addSubview:lineview];
    
    
    UIButton*buttonSave=[UIButton buttonWithType:0];
    buttonSave.frame=CGRectMake(ACTUAL_WIDTH(270), ACTUAL_HEIGHT(155), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(35));
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    buttonSave.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    buttonSave.layer.cornerRadius=3;
    [buttonSave addTarget:self action:@selector(saveAddressCode:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:buttonSave];
    
    [self.tableView addSubview:whiteView];
}


-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
    titleLabel.text=@"收货地址";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textAlignment=1;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=@"1111";
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"国家／区域";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label0=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _label0.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label0];
    
    }else if (indexPath.row==1){
        cell.textLabel.text=@"州／省／区域";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _label1.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label1];
    }else if (indexPath.row==2){
        cell.textLabel.text=@"城市";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label2=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _label2.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label2];
    }else if (indexPath.row==3){
        cell.textLabel.text=@"邮政编码";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label3=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _label3.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label3];
    }else if (indexPath.row==4){
        cell.textLabel.text=@"详细地址";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label4=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(100), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(230), ACTUAL_HEIGHT(20))];
        _label4.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label4];
    }else if (indexPath.row==5){
        cell.textLabel.text=@"收货人姓名";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label5=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _label5.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label5];
    }else if (indexPath.row==6){
        cell.textLabel.text=@"电话号码";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        _label6=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _label6.textAlignment=NSTextAlignmentRight;
        [cell addSubview:_label6];
    }else if (indexPath.row==7){
        cell.textLabel.text=@"";
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CountryViewController*vc=[[CountryViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1){
        StateViewController*vc=[[StateViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==2){
        CityViewController*vc=[[CityViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.delegate=self;
    }else if (indexPath.row==3){
        PostalCodeViewController*vc=[[PostalCodeViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==4){
        AddressViewController*vc=[[AddressViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==5){
        NameViewController*vc=[[NameViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==6){
        PhoneViewController*vc=[[PhoneViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(51);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)delegateForBack0:(NSString *)str0{
    _label0.text=str0;
}
-(void)delegateForBack1:(NSString *)str1{
    _label1.text=str1;
}
-(void)delegateForBack2:(NSString *)str2{
    _label2.text=str2;
}
-(void)delegateForBack3:(NSString *)str3{
    _label3.text=str3;
}
-(void)delegateForBack4:(NSString *)str4{
    _label4.text=str4;
}
-(void)delegateForBack5:(NSString *)str5{
    _label5.text=str5;
}

-(void)delegateForBack6:(NSString *)str6{
    _label6.text=str6;
}
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)saveAddressCode:(UIButton*)aa{
    NSString*str=[self judgeCansave];

     if (_canSave) {
    
    //http://www.vipxox.cn/?m=appapi&s=membercenter&act=receipt_address&uid=1&country=’中国’& country_id=4231&province=’江西省’ &city=’南昌市’&mobile=18870838741&zip=1008611&name=’小明’&address=’人民广场西楼’
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"receipt_address",@"uid":[UserSession instance].uid,@"country":_label0.text,@"province":_label1.text,@"city":_label2.text,@"zip":_label3.text,@"address":_label4.text,@"name":_label5.text,@"mobile":_label6.text};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"保存成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(NSString*)judgeCansave{
    _canSave=NO;
    
    if (!_label0.text) {
         _canSave=NO;
        return @"国家／区域不能为空！";
    }else{
        _canSave=YES;
    }
    if (!_label1.text) {
         _canSave=NO;
        return @"州／省／区域不能为空！";
    }else{
        _canSave=YES;
    }
    if (!_label2.text) {
         _canSave=NO;
        return @"城市不能为空！";
    }else{
        _canSave=YES;
    }
    if (!_label3.text) {
         _canSave=NO;
        return @"邮政编码不能为空！";
    }else{
        _canSave=YES;
    }
    if (!_label4.text) {
         _canSave=NO;
        return @"详细地址不能为空！";
    }else{
        _canSave=YES;
    }
    if (!_label5.text) {
         _canSave=NO;
        return @"收货人姓名不能为空！";
    }else{
        _canSave=YES;
    }
    if (_label6.text.length<8) {
         _canSave=NO;
        return @"电话号码输入错误";
    }else{
        _canSave=YES;
    }
    return @"...";

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
