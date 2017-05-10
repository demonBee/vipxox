//
//  AddTransportOrderViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/24.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "AddTransportOrderViewController.h"
#import "AddNumberView.h"
#import "SAMTextView.h"
#import "TransportAddressViewController.h"
#import "TMAddressViewController.h"
#import "AboutDelegateViewController.h"
#import "ChooseCourierViewController.h"

#define ADDADD  @"AddAddressCell"

@interface AddTransportOrderViewController ()<UITableViewDataSource,UITableViewDelegate,AddNumberViewDelegate,UITextFieldDelegate,UITextViewDelegate,TMAddressViewControllerDelegate,ChooseCourierViewControllerDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)SAMTextView *samtext;

@property(nonatomic,strong)AddNumberView*addNum;
@property(nonatomic,assign)CGFloat number;

@property(nonatomic,assign)BOOL canSave;    //判断是否符合

@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *declareTextField;
@property(nonatomic,strong)UITextField *priceTextField;
@property(nonatomic,strong)UITextField *courierNumberTextField;

@property(nonatomic,strong)UILabel *chooseCourierLabel;
@property(nonatomic,strong)NSString *chooseCourierStr;

@property(nonatomic,strong)NSDictionary*firstAddressDic;

@end


@implementation AddTransportOrderViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(65), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(130)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstAddressDic=self.addressDic;
//    [self makeNavi];
    self.title=@"添加转运订单";
    [self makeView];
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    _canSave=NO;
    
    _nameTextField=[[UITextField alloc]init];
    _nameTextField.delegate=self;
    _declareTextField=[[UITextField alloc]init];
    _declareTextField.delegate=self;
    _addNum=[[AddNumberView alloc]init];
    _priceTextField=[[UITextField alloc]init];
    _priceTextField.delegate=self;
    _courierNumberTextField=[[UITextField alloc]init];
    _courierNumberTextField.delegate=self;
    _samtext=[[SAMTextView alloc]init];
    _samtext.delegate=self;
    
    [self.tableView registerNib:[UINib nibWithNibName:ADDADD bundle:nil] forCellReuseIdentifier:ADDADD];
    [self.view addSubview:self.tableView];
}

-(void)makeView{
    
    UIView *BGView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(65), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(65))];
    BGView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGView];
    
    UIButton *submitButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(550), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [submitButton setTitle:@"已同意协议并提交" forState:0];
    submitButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    submitButton.layer.cornerRadius=5;
    submitButton.tag=333;
    [submitButton addTarget:self action:@selector(AgreeAndSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:submitButton];
    
}

//-(void)makeNavi{
//        
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"添加转运订单";
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];

}

////touch began
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
//}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==7) {
        return ACTUAL_HEIGHT(160);
    }else if (section==0||section==1){
        return 0.000001;
    }
    return ACTUAL_HEIGHT(90);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1||indexPath.section==6||indexPath.section==7) {
        return ACTUAL_HEIGHT(44);
    }else if (indexPath.section==0){
        return ACTUAL_HEIGHT(120);
    }else{
        return 0.00001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ACTUAL_HEIGHT(2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle=NO;
    if (indexPath.section==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:ADDADD];
        if (self.firstAddressDic!=nil) {
            UILabel*label1=[cell viewWithTag:1];
            label1.text=[NSString stringWithFormat:@"收货人：%@",_firstAddressDic[@"name"]];
            
            UILabel*label2=[cell viewWithTag:2];
            label2.text=[NSString stringWithFormat:@"联系方式：%@",_firstAddressDic[@"mobile"]];
            UILabel*label3=[cell viewWithTag:3];
            label3.text=[NSString stringWithFormat:@"收货地址：%@/%@/%@/%@",_firstAddressDic[@"country_name"],_firstAddressDic[@"province_name"],_firstAddressDic[@"city_name"],_firstAddressDic[@"address"]];

        }else{
            UILabel*label1=[cell viewWithTag:1];
            label1.text=@"点击添加";
            
            UILabel*label2=[cell viewWithTag:2];
            label2.text=@"";
            
            UILabel*label3=[cell viewWithTag:3];
            label3.text=@"";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

            
        }
        
        
           }
    if (indexPath.section==1) {
        cell.textLabel.text=@" 查看转运地址";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textColor=RGBCOLOR(193, 0, 22, 1);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section==6) {
        cell.textLabel.text=@" 选择快递";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.textLabel.textColor=RGBCOLOR(193, 0, 22, 1);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _chooseCourierLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(140), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(24))];
//        _chooseCourierLabel.backgroundColor=[UIColor redColor];
        _chooseCourierLabel.font=[UIFont systemFontOfSize:14];
        _chooseCourierLabel.textColor=RGBCOLOR(70, 73, 70, 1);
        _chooseCourierLabel.textAlignment=2;
        _chooseCourierLabel.text=_chooseCourierStr;
        [cell addSubview:_chooseCourierLabel];
        
    }else if (indexPath.section==7) {
        cell.textLabel.text=@" 客户须知：包裹转运验货规则和服务协议";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textColor=RGBCOLOR(193, 0, 22, 1);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.textLabel.text=@"";
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)delegateForBack0:(NSString *)str0{
    _chooseCourierStr=str0;
    _chooseCourierLabel.text=str0;
}

-(void)DelegateForSendValueToAddress:(NSDictionary *)dict{
    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UILabel*label1=[cell viewWithTag:1];
    label1.text=[NSString stringWithFormat:@"收货人：%@",dict[@"name"]];
    
    UILabel*label2=[cell viewWithTag:2];
    label2.text=[NSString stringWithFormat:@"联系方式：%@",dict[@"mobile"]];
    UILabel*label3=[cell viewWithTag:3];
    label3.text=[NSString stringWithFormat:@"收货地址：%@/%@/%@/%@",dict[@"country_name"],dict[@"province_name"],dict[@"city_name"],dict[@"address"]];

    _firstAddressDic=dict;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        TMAddressViewController *vc=[[TMAddressViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1) {
        TransportAddressViewController *vc=[[TransportAddressViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==6) {
        ChooseCourierViewController *vc=[[ChooseCourierViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==7){
        AboutDelegateViewController *vc=[[AboutDelegateViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView *BGView0=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), KScreenWidth, ACTUAL_HEIGHT(70))];
//        BGView0.backgroundColor=[UIColor redColor];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        nameLabel.text=@"商品名称:";
        [BGView0 addSubview:nameLabel];
        
        _nameTextField.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(40), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
        _nameTextField.layer.cornerRadius=5;
        _nameTextField.backgroundColor=RGBCOLOR(222, 222, 222, 0.5);
        _nameTextField.placeholder=@"  请在这里输入";
        [BGView0 addSubview:_nameTextField];
        
        return BGView0;
    }else if (section==3){
        UIView *BGView1=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), KScreenWidth, ACTUAL_HEIGHT(70))];
//        BGView1.backgroundColor=[UIColor greenColor];
        
        UILabel *declareLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        declareLabel.text=@"申报类别:";
        [BGView1 addSubview:declareLabel];
        
        _declareTextField.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(40), KScreenWidth-ACTUAL_WIDTH(150), ACTUAL_HEIGHT(40));
        _declareTextField.layer.cornerRadius=5;
        _declareTextField.backgroundColor=RGBCOLOR(222, 222, 222, 0.5);
        _declareTextField.placeholder=@"  请在这里输入";
        [BGView1 addSubview:_declareTextField];
        
        UILabel *EGLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-ACTUAL_WIDTH(120), ACTUAL_HEIGHT(60), ACTUAL_WIDTH(120), ACTUAL_HEIGHT(20))];
        EGLabel.text=@"例如：衣服、书籍等";
        EGLabel.textColor=RGBCOLOR(193, 0, 22, 1);
//        EGLabel.backgroundColor=[UIColor yellowColor];
        EGLabel.font=[UIFont systemFontOfSize:12];
        [BGView1 addSubview:EGLabel];
        
        return BGView1;
    }else if (section==4){
        UIView *BGView2=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), KScreenWidth, ACTUAL_HEIGHT(70))];
//        BGView2.backgroundColor=[UIColor blueColor];
        
        UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        countLabel.text=@"数量:";
        [BGView2 addSubview:countLabel];
        
        _addNum.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(45), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(60));
        _addNum.delegate=self;
        _addNum.numberLab.font=[UIFont systemFontOfSize:18];
        [BGView2 addSubview:_addNum];

        return BGView2;
    }else if (section==5){
        UIView *BGView3=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), KScreenWidth, ACTUAL_HEIGHT(70))];
//        BGView3.backgroundColor=[UIColor orangeColor];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        priceLabel.text=[NSString stringWithFormat:@"申报价值（%@）:",[UserSession instance].currency];
        
        _priceTextField.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(40), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
        _priceTextField.layer.cornerRadius=5;
        _priceTextField.backgroundColor=RGBCOLOR(222, 222, 222, 0.5);
        _priceTextField.placeholder=@"  请在这里输入";
        [BGView3 addSubview:_priceTextField];

        [BGView3 addSubview:priceLabel];

        return BGView3;
    }else if (section==6){
        UIView *BGView5=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), KScreenWidth, ACTUAL_HEIGHT(70))];

        UILabel *courierLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        courierLabel.text=@"快递单号：";
        [BGView5 addSubview:courierLabel];
        
        _courierNumberTextField.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(40), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
        _courierNumberTextField.layer.cornerRadius=5;
        _courierNumberTextField.backgroundColor=RGBCOLOR(222, 222, 222, 0.5);
        _courierNumberTextField.placeholder=@"  请在这里输入";
        [BGView5 addSubview:_courierNumberTextField];
    
        return BGView5;
    }else if (section==7){
        UIView *BGView4=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), KScreenWidth, ACTUAL_HEIGHT(70))];
//        BGView4.backgroundColor=[UIColor purpleColor];
        
        UILabel *remarkLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        remarkLabel.text=@"商品备注:";
        [BGView4 addSubview:remarkLabel];
        
        _samtext.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(45), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(100));
        _samtext.delegate=self;
        _samtext.layer.cornerRadius=5;
//        _samtext.backgroundColor=[UIColor greenColor];
        [BGView4 addSubview:_samtext];
        
        return BGView4;
    }
    return nil;
}

- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    if (self.number>=1) {
        self.number--;
        _addNum.numberString=[NSString stringWithFormat:@"%.0f",self.number];
    }
    
    
}

- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    self.number++;
    _addNum.numberString=[NSString stringWithFormat:@"%.0f",self.number];
    
}
-(void)AgreeAndSubmit:(UIButton*)sender{
//    if (sender.selected==YES) {
//        return;
//    }else{
//        sender.selected=YES;
//        [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:2.0];
    NSString*str=[self judgeCansave];

    CGFloat allPrices=[_addNum.numberString floatValue]*[_priceTextField.text floatValue];
    NSString *allPricesStr=[NSString stringWithFormat:@"%.2f",allPrices];
    if (_addNum.numberString==nil) {
        _addNum.numberString=@"1";
    }
    if (_canSave) {
        
        //http://www.vipxox.cn/? m=appapi&  s=membercenter&  act=transport&  op=add&  uid=&  name=&  remark&  num=&  price=& price_one=& desc=&  logi_name=&  logi_num=&  thumb=&
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"op":@"add",@"uid":[UserSession instance].uid,@"name":self.nameTextField.text,@"remark":self.declareTextField.text,@"num":_addNum.numberString,@"price":allPricesStr,@"price_one":self.priceTextField.text,@"dedc":self.samtext.text,@"logi_name":self.courierNumberTextField.text,@"logi_num":self.chooseCourierStr};
        
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
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
//    }
}

//-(void)timeEnough:(NSTimer*)timer{
//    UIButton *btn=(UIButton*)[self.view viewWithTag:333];
//    btn.selected=NO;
//    [timer invalidate];
//    timer=nil;
//}

-(NSString*)judgeCansave{
    _canSave=YES;
    
    if (_nameTextField.text.length==0) {
        _canSave=NO;
        return @"商品名称不能为空！";
    }
    if (_declareTextField.text.length==0) {
        _canSave=NO;
        return @"申报类别不能为空！";
    }
    if ([_addNum.numberString isEqualToString:@"0"]) {
        _canSave=NO;
        return @"数量不能为空！";
    }
    if (_priceTextField.text.length==0) {
        _canSave=NO;
        return @"商品价值不能为空！";
    }
    if (_courierNumberTextField.text.length==0) {
        _canSave=NO;
        return @"商品运单号不能为空！";
    }
    if (_chooseCourierLabel.text.length==0) {
        _canSave=NO;
        return @"请选择快递！";
    }
    if (_samtext.text.length==0) {
        _canSave=NO;
        return @"商品备注不能为空！";
    }
    return @"666";
}
-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}


//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];

    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setY:self.tableView.y-255];
        
        
    }];
    
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setY:self.tableView.y+255];
        
        
    }];
    
    
    return YES;

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//- (UIView*)findFirstResponderBeneathView:(UIView*)view
//{
//    // Search recursively for first responder
//    for ( UIView *childView in view.subviews ) {
//        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
//            return childView;
//        UIView *result = [self findFirstResponderBeneathView:childView];
//        if ( result )
//            return result;
//    }
//    return nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
