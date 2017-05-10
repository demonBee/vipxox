//
//  CalTransViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/19.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "CalTransViewController.h"
#import "ActionSheetStringPicker.h"   //选择性别  工具

@interface CalTransViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,strong)UITextField*textField0;
@property(nonatomic,strong)UITextField*textFieldL;
@property(nonatomic,strong)UITextField*textFieldW;
@property(nonatomic,strong)UITextField*textFieldH;
@property(nonatomic,strong)UITextField*textField2;
@property(nonatomic,strong)UITextField*textField3;

@property(nonatomic,strong)UILabel*labelMoney;
@property(nonatomic,strong)NSString*howMoney;   //改变钱数 自动显示

@property(nonatomic,assign)BOOL canSave;

@property(nonatomic,strong)NSArray*saveTrans;     //保存物流
@property(nonatomic,strong)NSArray*saveCountury;    //保存国家
@property(nonatomic,strong)NSString*transID;
@property(nonatomic,strong)NSString*counturyID;

@end

@implementation CalTransViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    self.title=@"计算运费";
    [self.view addSubview:self.tableView];
    [self makeBottomview];
    self.tableView.tableHeaderView=_bottomView;
    [self getInfoDatas];
}

-(void)getInfoDatas{
//    http://www.vipxox.com/?  m=app&s=jiagejisuan&act=logistics
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"jiagejisuan",@"act":@"logistics"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            self.saveTrans=data[@"data"][@"wuliu"];
            self.saveCountury=data[@"data"][@"countrys"];
            
        }
        
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)makeBottomview{
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
//    _bottomView.backgroundColor=[UIColor yellowColor];
    
    // 第0条
    UIImageView*imageView0=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 15)];
    imageView0.image=[UIImage imageNamed:@"重量1"];
    [_bottomView addSubview:imageView0];
    
    UILabel*label0=[[UILabel alloc]initWithFrame:CGRectMake(imageView0.right+5, imageView0.top, KScreenWidth/2, 15)];
    label0.text=@"重量 （g）";
    label0.font=[UIFont systemFontOfSize:14];
    label0.textColor=RGBCOLOR(197, 197, 197, 1);
    [_bottomView addSubview:label0];
    
    UITextField*textField0=[[UITextField alloc]initWithFrame:CGRectMake(imageView0.left, imageView0.bottom+5, KScreenWidth-40, 38)];
    textField0.layer.cornerRadius=3;
    textField0.layer.borderColor=RGBCOLOR(197, 197, 197, 1).CGColor;
    textField0.layer.borderWidth=1;
    textField0.keyboardType=UIKeyboardTypeNumberPad;
    textField0.delegate=self;
    [_bottomView addSubview:textField0];
    self.textField0=textField0;
    
    //第1条
    UIImageView*imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(20, textField0.bottom+10,15 , 15)];
    imageView1.image=[UIImage imageNamed:@"长宽高"];
    [_bottomView addSubview:imageView1];
    
    UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(imageView1.right+5, imageView1.top, KScreenWidth/2, 15)];
    label1.text=@"长宽高 a*b*h (cm³)";
    label1.font=[UIFont systemFontOfSize:14];
    label1.textColor=RGBCOLOR(197, 197, 197, 1);
    [_bottomView addSubview:label1];

    CGFloat TFwith=(KScreenWidth-4*20)/3;
    CGFloat Jianju=20;
    CGFloat TOLeft=20;
    for (int i=0; i<3; i++) {
        UITextField*textField1=[[UITextField alloc]initWithFrame:CGRectMake(TOLeft, imageView1.bottom+5, TFwith, 38)];
        textField1.tag=i;
        textField1.layer.cornerRadius=3;
        textField1.layer.borderColor=RGBCOLOR(197, 197, 197, 1).CGColor;
        textField1.layer.borderWidth=1;
        textField1.keyboardType=UIKeyboardTypeNumberPad;
        textField1.delegate=self;
        [_bottomView addSubview:textField1];
        TOLeft=textField1.right+Jianju;

        switch (textField1.tag) {
            case 0:
                self.textFieldL=textField1;
                [self addLabelIsXing:CGRectMake(textField1.right, textField1.top, 20, textField1.height)];
                break;
            case 1:
                self.textFieldW=textField1;
                [self addLabelIsXing:CGRectMake(textField1.right, textField1.top, 20, textField1.height)];

                break;

            case 2:
                self.textFieldH=textField1;
                break;

                
            default:
                break;
        }
        
    }
    
    
    
    //目的地国家
    UIImageView*imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.textFieldW.bottom+10, 15, 15)];
    imageView2.image=[UIImage imageNamed:@"目的"];
    [_bottomView addSubview:imageView2];
    
    UILabel*label2=[[UILabel alloc]initWithFrame:CGRectMake(imageView2.right+5, imageView2.top, KScreenWidth/2, 15)];
    label2.text=@"目的地国家";
    label2.font=[UIFont systemFontOfSize:14];
    label2.textColor=RGBCOLOR(197, 197, 197, 1);
    [_bottomView addSubview:label2];
    
    UITextField*textField2=[[UITextField alloc]initWithFrame:CGRectMake(imageView2.left, imageView2.bottom+5, KScreenWidth-40, 38)];
    textField2.layer.cornerRadius=3;
    textField2.layer.borderColor=RGBCOLOR(197, 197, 197, 1).CGColor;
    textField2.layer.borderWidth=1;
    textField2.keyboardType=UIKeyboardTypeNumberPad;
    textField2.delegate=self;
//    [textField2 addTarget:self action:@selector(editbegain:) forControlEvents:UIControlEventEditingDidBegin];
    [_bottomView addSubview:textField2];
    self.textField2=textField2;

    UIImageView*xiala1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30/2, 18/2)];
    xiala1.contentMode=UIViewContentModeScaleAspectFit;
    xiala1.image=[UIImage imageNamed:@"下拉1"];
    xiala1.x=textField2.right-8-30/2;
    xiala1.centerY=textField2.centerY;
    [_bottomView addSubview:xiala1];
    
    
    //国际物流名称
    
    UIImageView*imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.textField2.bottom+10, 15, 15)];
    imageView3.image=[UIImage imageNamed:@"物流"];
    [_bottomView addSubview:imageView3];
    
    UILabel*label3=[[UILabel alloc]initWithFrame:CGRectMake(imageView3.right+5, imageView3.top, KScreenWidth/2, 15)];
    label3.text=@"国际物流名称";
    label3.font=[UIFont systemFontOfSize:14];
    label3.textColor=RGBCOLOR(197, 197, 197, 1);
    [_bottomView addSubview:label3];
    
    UITextField*textField3=[[UITextField alloc]initWithFrame:CGRectMake(imageView3.left, imageView3.bottom+5, KScreenWidth-40, 38)];
    textField3.layer.cornerRadius=3;
    textField3.layer.borderColor=RGBCOLOR(197, 197, 197, 1).CGColor;
    textField3.layer.borderWidth=1;
    textField3.keyboardType=UIKeyboardTypeNumberPad;
    textField3.delegate=self;
    [_bottomView addSubview:textField3];
    self.textField3=textField3;
    
    UIImageView*xiala2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30/2, 18/2)];
    xiala2.contentMode=UIViewContentModeScaleAspectFit;
    xiala2.image=[UIImage imageNamed:@"下拉1"];
    xiala2.x=textField3.right-8-30/2;
    xiala2.centerY=textField3.centerY;
    [_bottomView addSubview:xiala2];
    
    
    
    //多少钱
    UILabel*labelMoney=[[UILabel alloc]initWithFrame:CGRectMake(20, textField3.bottom+40, KScreenWidth-40, 18)];
    labelMoney.textColor=RGBCOLOR(204, 51, 69, 1);
    labelMoney.textAlignment=NSTextAlignmentRight;
    self.labelMoney=labelMoney;
    [self.bottomView addSubview:self.labelMoney];
    
    //赋值
#warning 赋值

    
    
    //确认按钮
    UIButton*okButton=[[UIButton alloc]initWithFrame:CGRectMake(20, self.labelMoney.bottom+15, KScreenWidth-40, 50)];
    [okButton setTitle:@"一键计算" forState:UIControlStateNormal];
    okButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    okButton.backgroundColor=ManColor;
    okButton.layer.cornerRadius=12;
    [okButton addTarget:self action:@selector(touButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:okButton];
    

}

#pragma mark  ----选择国家

-(void)editbegain:(UITextField*)sender{
    //选择国家
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
    __weak typeof (self)weakSelf=self;

    if (self.saveCountury.count==0) {
        return;
    }else{
      NSMutableArray*array=[NSMutableArray array];
    for (int i=0; i<self.saveCountury.count; i++) {
        
     [ array addObject:self.saveCountury[i][@"name"]];
    }
  
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择国家" rows:@[array] initialSelection:@[array[0]] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
       
        
        weakSelf.textField2.text=selectedValue[0];
        NSString* aa=selectedIndex[0];
        int bb=[aa intValue];
        weakSelf.counturyID=weakSelf.saveCountury[bb][@"id"];
        
    } cancelBlock:nil  origin:self.view];
    }
}
    


-(void)chooseTrans:(UITextField*)sender{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
       __weak typeof (self)weakSelf=self;
//选择物流
    if (self.saveTrans.count==0) {
        return;
    }else{

 
    NSMutableArray*array=[NSMutableArray array];
    for (int i=0; i<self.saveTrans.count; i++) {
        
        [ array addObject:self.saveTrans[i][@"name"]];
    }

    
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择物流" rows:@[array] initialSelection:@[array[0]] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
      
        weakSelf.textField3.text=selectedValue[0];
        NSString* aa=selectedIndex[0];
        int bb=[aa intValue];
        weakSelf.transID=weakSelf.saveTrans[bb][@"id"];

        
        
        
    } cancelBlock:nil  origin:self.view];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.textField2) {
        [self editbegain:self.textField2];
        return NO;
    }else if (textField==self.textField3){
        [self chooseTrans:self.textField3];
        return NO;
    }
    return YES;
}


#pragma mark  ----查询价格
-(void)touButton{
    NSLog(@"11");
   NSString*str= [self judgeCanSave];
    if (self.canSave==NO) {
        [JRToast showWithText:str];
        return;
    }else{
    
    
    //得到价格的接口
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"app",@"s":@"jiagejisuan",@"act":@"get_list"
                              ,@"cid":self.counturyID,@"wid":self.transID
                              ,@"long":self.textFieldL.text,@"with":self.textFieldW.text,@"hight":
                                  self.textFieldH.text,@"weight":self.textField0.text};
        
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                self.howMoney=data[@"data"];
                
            }else{
                [JRToast showWithText:data[@"errormsg"]];
            }
            
            
            
        }];
        
    
    
    }
}


-(NSString*)judgeCanSave{
    self.canSave=YES;
    if (self.textField0.text.length==0||[self.textField0.text isEqualToString:@"0"]) {
        self.canSave=NO;
        return @"请输入重量";
    }else if (self.textFieldL.text.length==0||[self.textFieldL.text isEqualToString:@"0"]){
        self.canSave=NO;
        return @"请输入正确的长度";
    }else if (self.textFieldW.text.length==0||[self.textFieldW.text isEqualToString:@"0"]){
        self.canSave=NO;
        return @"请输入正确的宽度";
    }else if (self.textFieldH.text.length==0||[self.textFieldH.text isEqualToString:@"0"]){
        self.canSave=NO;
        return @"请输入正确的高度";
    }else if (self.textField2.text.length==0){
        self.canSave=NO;
        return @"请选择国家";
    }else if (self.textField3.text.length==0){
        self.canSave=NO;
        return @"请选择国际物流";
    }

    
    

return @"哎";
    
}

-(void)addLabelIsXing:(CGRect)rect{
    UILabel*label=[[UILabel alloc]initWithFrame:rect];
    label.text=@"*";
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=RGBCOLOR(197, 197, 197, 1);
    label.textAlignment=NSTextAlignmentCenter;
    [self.bottomView addSubview:label];
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(void)setHowMoney:(NSString *)howMoney{
    _howMoney=howMoney;
    if (howMoney!=nil&&![howMoney isEqualToString:@""]) {
        self.labelMoney.text=[NSString stringWithFormat:@"金额：%@%@",[UserSession instance].currency,howMoney];
    }
    
    
}
//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

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

@end
