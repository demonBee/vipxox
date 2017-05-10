//
//  TMIdeaFeedBackViewController.m
//  weimao
//
//  Created by Brady on 16/2/26.
//  Copyright © 2016年 Brady. All rights reserved.
//

#import "TMIdeaFeedBackViewController.h"
#import "SAMTextView.h"

@interface TMIdeaFeedBackViewController ()

@property(nonatomic,strong)SAMTextView*textView;
@end

@implementation TMIdeaFeedBackViewController

- (void)viewDidLoad {
//     self.view.backgroundColor=RGBCOLOR(70,73,70,1);
    [super viewDidLoad];
    [self makeNavi];
    self.title=[[InternationalLanguage bundle] localizedStringForKey:@"意见反馈" value:nil table:@"Language"];
    self.view.backgroundColor=RGBCOLOR(225, 225, 225, 1);
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}

-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(146), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(84), ACTUAL_WIDTH(19))];
//    titleLabel.text=@"反馈问题";
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:titleLabel];
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
    
//    UIView *BackGroundView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 64, KScreenWidth, KScreenHeight-64)];
//    BackGroundView.backgroundColor=RGBCOLOR(225, 225, 225, 1);
//    [self.view addSubview:BackGroundView];
    


    
    _textView=[[SAMTextView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 64, KScreenWidth,180)];
    _textView.backgroundColor=[UIColor whiteColor];
    _textView.font=[UIFont systemFontOfSize:14];
    _textView.placeholder=@"请输入反馈意见，我们会以消息形式回复您的建议或意见，改进产品体验，谢谢！";
    [self.view addSubview:_textView];
    
    
    
    UIButton*but1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ACTUAL_WIDTH(60), ACTUAL_HEIGHT(20))];
    [but1 setTitle:@"提交" forState:0];
    but1.titleLabel.font=[UIFont systemFontOfSize:14];
    [but1 setTitleColor:[UIColor whiteColor] forState:0];
//    but1.backgroundColor=[UIColor blackColor];
    [but1 addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but1];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:but1];
    
}

-(void)feedBack{
    //http://www.vipxox.cn/?  m=appapi&s=system_setup&act=user_feedback&feedback=很好&uid=1
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"system_setup",@"act":@"user_feedback",@"feedback":_textView.text,@"uid":[UserSession instance].uid};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"操作成功！" message:@"感谢您的建议和意见！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
//            NSLog(@"%@",data[@"errorMessage"]);
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
