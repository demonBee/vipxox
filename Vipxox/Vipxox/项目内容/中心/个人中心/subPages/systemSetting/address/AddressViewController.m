//
//  AddressViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()
@property(nonatomic,strong)UITextField*textField;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeView];

}

-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(80), ACTUAL_WIDTH(19))];
    titleLabel.text=@"详细地址";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)makeView{
    UIView *BGview=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight)];
    BGview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGview];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(40), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    textField.placeholder=@"  请在这里输入.....";
    textField.layer.cornerRadius=5;
    textField.backgroundColor=RGBCOLOR(222, 222, 222, 0.5);
    self.textField=textField;
    [BGview addSubview:textField];
    
    UIButton *saveButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(150), KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [saveButton setTitle:@"保存" forState:0];
    saveButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    saveButton.layer.cornerRadius=5;
    [saveButton addTarget:self action:@selector(saveAndBack) forControlEvents:UIControlEventTouchUpInside];
    [BGview addSubview:saveButton];
}

-(void)saveAndBack{
    if ([_textField.text isEqualToString:@""]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请输入相应信息！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }else {
        if ([self.delegate respondsToSelector:@selector(delegateForBack4:)]) {
            [self.delegate delegateForBack4:self.textField.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)dismissTo{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(delegateForBack4:)]) {
        [self.delegate delegateForBack4:self.textField.text];
    }

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
