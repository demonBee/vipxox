//
//  PersonalSignViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/4/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "PersonalSignViewController.h"
#import "SAMTextView.h"

@interface PersonalSignViewController ()<UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate>

@property(nonatomic,strong)SAMTextView *samtext;

@end

@implementation PersonalSignViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeNavi];
    [self makeView];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"修改个性签名";
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return true;
//}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    [textView resignFirstResponder];
//    return true;
//
//}

//-(void)makeNavi{
//    
//    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
//    
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34), KScreenWidth, ACTUAL_WIDTH(20))];
//    titleLabel.text=@"修改个性签名";
//    titleLabel.textAlignment=1;
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

-(void)makeView{
    UIView *BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    BGView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGView];
    
    UIButton*saveButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(350),KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(50))];
    saveButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [saveButton setTitle:@"保存" forState:0];
    saveButton.layer.cornerRadius=2;
    [saveButton setTitleColor:[UIColor whiteColor] forState:0];
    saveButton.layer.cornerRadius=5;
    [saveButton addTarget:self action:@selector(gotoSave) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:saveButton];
    
    _samtext=[[SAMTextView alloc]init];
    _samtext.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(200));
    _samtext.delegate=self;
//    _samtext.keyboardType=
    _samtext.font=[UIFont systemFontOfSize:16];
    _samtext.placeholder=@"  请在这里输入个性签名";
    _samtext.layer.cornerRadius=5;
    _samtext.backgroundColor=RGBCOLOR(230, 232,232, 1);
    [BGView addSubview:_samtext];

}

-(void)gotoSave{
 
    if ([_samtext.text isEqualToString:@""]) {
        _samtext.text=@"(空)";
    }
    //http://www.vipxox.cn/? m=appapi&s=membercenter&act=Personal_Center&uid=&zt=up_info&personality=
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"Personal_Center",@"uid":[UserSession instance].uid,@"zt":@"up_info",@"personality":_samtext.text};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            [JRToast showWithText:@"修改成功！"];
            [UserSession instance].personality=_samtext.text;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];

//    if ([self.delegate respondsToSelector:@selector(delegateForBack1:)]) {
//        [self.delegate delegateForBack1:_samtext.text];
//    }
////    [self dismissTo];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
