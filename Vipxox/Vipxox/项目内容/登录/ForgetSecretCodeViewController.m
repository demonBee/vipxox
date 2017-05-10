//
//  ForgetSecretCodeViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/10.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ForgetSecretCodeViewController.h"
#import "STCountDownButton.h"

@interface ForgetSecretCodeViewController ()

@property(nonatomic,strong)UITextField *testCodeTextField;
@property(nonatomic,strong) STCountDownButton *obtainTextCodeButton;
@property(nonatomic,strong)UITextField *secretCodeTextField;
@property(nonatomic,strong) UITextField *mailBoxTextField;

@property(nonatomic,assign)BOOL canSave;

@end

@implementation ForgetSecretCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatView];
}

-(void)creatView{
    
    //设置背景图片
    UIImageView*mainView=[[UIImageView alloc]init];
    mainView.frame=self.view.frame;
    mainView.image=[UIImage imageNamed:@"View"];
    mainView.backgroundColor=[UIColor whiteColor];
    mainView.contentMode=UIViewContentModeScaleAspectFit;

    [self.view addSubview:mainView];
    
    //LOGO
    UIImageView *LogoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LogoTitle"]];
    LogoImageView.frame=CGRectMake(ACTUAL_WIDTH(98), ACTUAL_HEIGHT(50), ACTUAL_WIDTH(210), ACTUAL_HEIGHT(70));
//    LogoImageView.backgroundColor=[UIColor whiteColor];
//    LogoImageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.view addSubview:LogoImageView];

    //“输入邮箱”
    UIView *mailBoxView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(155), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    mailBoxView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    mailBoxView.layer.borderWidth = 2;
    mailBoxView.layer.cornerRadius=3;
    mailBoxView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:mailBoxView];
    
    _mailBoxTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(317), ACTUAL_HEIGHT(36))];
    _mailBoxTextField.backgroundColor=[UIColor clearColor];
    _mailBoxTextField.placeholder=@"输入邮箱";
    _mailBoxTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _mailBoxTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_mailBoxTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_mailBoxTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _mailBoxTextField.textColor=[UIColor whiteColor];
    [mailBoxView addSubview:_mailBoxTextField];

    
    //“输入验证码”
    UIView *testCodeView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(217), ACTUAL_WIDTH(182), ACTUAL_HEIGHT(40))];
    testCodeView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    testCodeView.layer.borderWidth = 2;
    testCodeView.layer.cornerRadius=3;
    testCodeView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:testCodeView];
    
    _testCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(163), ACTUAL_HEIGHT(36))];
    _testCodeTextField.backgroundColor=[UIColor clearColor];
    _testCodeTextField.placeholder=@"输入验证码";
    _testCodeTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _testCodeTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_testCodeTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_testCodeTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _testCodeTextField.textColor=[UIColor whiteColor];
    [testCodeView addSubview:_testCodeTextField];
    
    //“获取验证码”按钮
    _obtainTextCodeButton=[[STCountDownButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(231), ACTUAL_HEIGHT(217), ACTUAL_WIDTH(126), ACTUAL_HEIGHT(40))];
    [_obtainTextCodeButton setTitle:@"获取验证码" forState:0];
    [_obtainTextCodeButton setTitleColor:[UIColor whiteColor] forState:0];
    _obtainTextCodeButton.layer.borderWidth = 2;
    _obtainTextCodeButton.layer.cornerRadius=3;
    _obtainTextCodeButton.backgroundColor=RGBCOLOR(145, 146, 147, 0.5);
    _obtainTextCodeButton.layer.borderColor = [RGBCOLOR(155, 156, 157, 1)CGColor];
    [_obtainTextCodeButton addTarget:self action:@selector(touchObtain:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_obtainTextCodeButton];
    
    //“输入密码”
    UIView *secretCodeView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(276), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    secretCodeView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    secretCodeView.layer.borderWidth = 2;
    secretCodeView.layer.cornerRadius=3;
    secretCodeView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:secretCodeView];

        
    _secretCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(317), ACTUAL_HEIGHT(36))];
    _secretCodeTextField.backgroundColor=[UIColor clearColor];
    _secretCodeTextField.placeholder=@"输入新密码";
    _secretCodeTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _secretCodeTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_secretCodeTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_secretCodeTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _secretCodeTextField.textColor=[UIColor whiteColor];
    [secretCodeView addSubview:_secretCodeTextField];
    
    //返回按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(28), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(30))];
    //    backButton.backgroundColor=[UIColor whiteColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:0];
    [backButton addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //“确定”按钮
    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(398), ACTUAL_WIDTH(338), ACTUAL_HEIGHT(45))];
    sureButton.backgroundColor=RGBCOLOR(205, 206, 207, 1);
    [sureButton setTitle:@"确定" forState:0];
    [sureButton setTitleColor:RGBCOLOR(251, 252, 253, 1) forState:0];
    sureButton.layer.cornerRadius=3;
    [sureButton addTarget:self action:@selector(comeBackToEnterView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sureButton];

}

-(void)touchObtain:(STCountDownButton*)sender{
    if (self.mailBoxTextField.text.length<6) {
        [JRToast showWithText:@"请正确输入您的邮箱" duration:1.0];
    }else{
        
        sender.second=30;
        [sender start];
        //获取验证码
        //    	http://www.vipxox.cn/?  m=appapi&s=forget_pwd&act=get_code&email=963523556@qq.com
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*dict=@{@"m":@"appapi",@"s":@"forget_pwd",@"act":@"get_code",@"email":self.mailBoxTextField.text};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:dict compliation:^(id data, NSError *error) {
            
            NSLog(@"%@",data);
            
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                [JRToast showWithText:data[@"errorMessage"] duration:1.0];
            }else{
                [JRToast showWithText:data[@"errorMessage"] duration:1.0];
            }
        }];
    }
}

//确定
-(void)comeBackToEnterView{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    NSString*str=[self judgeCanSave];
    if (!_canSave) {
        [JRToast showWithText:str duration:1.0];
    }else{
        //注册接口
        //    http://www.vipxox.cn/?  m=appapi&s=forget_pwd&act=forget&email=963523556@qq.com&pwd=123456&code=654879&userid=1
       
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"appapi",@"s":@"forget_pwd",@"act":@"forget",@"email":self.mailBoxTextField.text,@"pwd":self.secretCodeTextField.text,@"code":self.testCodeTextField.text};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                
                [JRToast showWithText:@"修改密码成功！" duration:1];
                [self dismissViewControllerAnimated:YES completion:nil];
        
            }else{
                [JRToast showWithText:data[@"errorMessage"] duration:1];
            }
            
        }];
        
        
        
        
    }
    
}


-(NSString*)judgeCanSave{
    _canSave=YES;
    if (self.mailBoxTextField.text.length<6){
        _canSave=NO;
        return @"请正确输入邮箱";
    }else if (self.testCodeTextField.text.length<6){
        _canSave=NO;
        return @"请正确输入验证码";
    }else if (self.secretCodeTextField.text.length<6){
        _canSave=NO;
        return @"密码不能小于6位";
    }
    
    return @"";
}

-(void)dismissTo{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
