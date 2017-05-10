//
//  EvaluationViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/31.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "EvaluationViewController.h"
#import "SAMTextView.h"

@interface EvaluationViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)SAMTextView *samtext;
@property (nonatomic ,strong) UILabel *starScoreLabel;

@property(nonatomic,strong)NSString *scoreStr;

@property(nonatomic,strong)NSString *haveEvaluation;

@property(nonatomic,strong)UIButton *starButton1;
@property(nonatomic,strong)UIButton *starButton2;
@property(nonatomic,strong)UIButton *starButton3;
@property(nonatomic,strong)UIButton *starButton4;
@property(nonatomic,strong)UIButton *starButton5;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeView];

}

-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(79), ACTUAL_WIDTH(19))];
    titleLabel.text=@"商品评价";
    titleLabel.font=[UIFont systemFontOfSize:16];
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

-(void)makeView{
    UIView *BGView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(64))];
    BGView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGView];
    
    UIButton*saveButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(450),KScreenWidth-ACTUAL_WIDTH(40), ACTUAL_HEIGHT(50))];
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
    _samtext.font=[UIFont systemFontOfSize:16];
    _samtext.placeholder=@"  请在这里输入商品评价";
    _samtext.layer.cornerRadius=5;
    _samtext.backgroundColor=RGBCOLOR(230, 232,232, 1);
    [BGView addSubview:_samtext];
    
    _starButton1=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(280), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [_starButton1 addTarget:self action:@selector(accordingStar1) forControlEvents:UIControlEventTouchUpInside];
    [_starButton1 setImage:[UIImage imageNamed:@"huiStar"] forState:UIControlStateNormal];
    [_starButton1 setImage:[UIImage imageNamed:@"huangStar"] forState:UIControlStateSelected];
    _starButton1.selected=YES;
    [BGView addSubview:_starButton1];
    
    _starButton2=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(70), ACTUAL_HEIGHT(280), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [_starButton2 addTarget:self action:@selector(accordingStar2) forControlEvents:UIControlEventTouchUpInside];
    [_starButton2 setImage:[UIImage imageNamed:@"huiStar"] forState:UIControlStateNormal];
    [_starButton2 setImage:[UIImage imageNamed:@"huangStar"] forState:UIControlStateSelected];
    _starButton2.selected=YES;
    [BGView addSubview:_starButton2];
    
    _starButton3=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(120), ACTUAL_HEIGHT(280), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [_starButton3 addTarget:self action:@selector(accordingStar3) forControlEvents:UIControlEventTouchUpInside];
    [_starButton3 setImage:[UIImage imageNamed:@"huiStar"] forState:UIControlStateNormal];
    [_starButton3 setImage:[UIImage imageNamed:@"huangStar"] forState:UIControlStateSelected];
    _starButton3.selected=YES;
    [BGView addSubview:_starButton3];
    
    _starButton4=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(170), ACTUAL_HEIGHT(280), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [_starButton4 addTarget:self action:@selector(accordingStar4) forControlEvents:UIControlEventTouchUpInside];
    [_starButton4 setImage:[UIImage imageNamed:@"huiStar"] forState:UIControlStateNormal];
    [_starButton4 setImage:[UIImage imageNamed:@"huangStar"] forState:UIControlStateSelected];
    _starButton4.selected=YES;
    [BGView addSubview:_starButton4];
    
    _starButton5=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(220), ACTUAL_HEIGHT(280), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
    [_starButton5 addTarget:self action:@selector(accordingStar5) forControlEvents:UIControlEventTouchUpInside];
    [_starButton5 setImage:[UIImage imageNamed:@"huiStar"] forState:UIControlStateNormal];
    [_starButton5 setImage:[UIImage imageNamed:@"huangStar"] forState:UIControlStateSelected];
    _starButton5.selected=YES;
    [BGView addSubview:_starButton5];
    
    UILabel *STARLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(250), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
    STARLabel.text=@"请打分：";
    STARLabel.font=[UIFont systemFontOfSize:16];
    [BGView addSubview:STARLabel];
    
}

-(void)accordingStar1{
    _starButton1.selected=YES;
    _starButton2.selected=NO;
    _starButton3.selected=NO;
    _starButton4.selected=NO;
    _starButton5.selected=NO;
    self.scoreStr=@"1";
}

-(void)accordingStar2{
    _starButton1.selected=YES;
    _starButton2.selected=YES;
    _starButton3.selected=NO;
    _starButton4.selected=NO;
    _starButton5.selected=NO;
    self.scoreStr=@"2";
}

-(void)accordingStar3{
    _starButton1.selected=YES;
    _starButton2.selected=YES;
    _starButton3.selected=YES;
    _starButton4.selected=NO;
    _starButton5.selected=NO;
    self.scoreStr=@"3";
}

-(void)accordingStar4{
    _starButton1.selected=YES;
    _starButton2.selected=YES;
    _starButton3.selected=YES;
    _starButton4.selected=YES;
    _starButton5.selected=NO;
    self.scoreStr=@"4";
}

-(void)accordingStar5{
    _starButton1.selected=YES;
    _starButton2.selected=YES;
    _starButton3.selected=YES;
    _starButton4.selected=YES;
    _starButton5.selected=YES;
    self.scoreStr=@"5";
}

-(void)gotoSave{
    _haveEvaluation=@"1";
    if (self.scoreStr==nil) {
        self.scoreStr=@"5";
    }
    if ([_samtext.text isEqualToString:@""]) {
        _samtext.text=@"(空)";
    }
   //http://www.vipxox.cn/? m=appapi&s=membercenter&act=mall_list&zt=4&uid=&pid=&order_id=&con=&attr=&score=
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"mall_list",@"zt":@"4",@"uid":[UserSession instance].uid,@"pid":self.pidStr,@"order_id":self.order_idStr,@"con":_samtext.text,@"attr":self.attrStr,@"score":self.scoreStr,@"idd":self.idd};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            [JRToast showWithText:@"评论成功！"];
            [self dismissTo];
        }else{
            [JRToast showWithText:@"发送失败！"];
        }
    }];
    if ([self.delegate respondsToSelector:@selector(delegateForBack1: andSection:)]) {
        [self.delegate delegateForBack1:@"1" andSection:self.indexTag];
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
