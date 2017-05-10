//
//  ForgetPasswardViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/15.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "ForgetPasswardViewController.h"
#import "HttpManager.h"

#define ForgetPasswardCell    @"ForgetPasswardCell"
#define ForgetPasswardCell2   @"ForgetPasswardCell2"

@interface ForgetPasswardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)BOOL canSave;




@end

@implementation ForgetPasswardViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
//        _tableView.backgroundColor=[UIColor blackColor];
        
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:ForgetPasswardCell bundle:nil] forCellReuseIdentifier:ForgetPasswardCell];
    [self.tableView registerNib:[UINib nibWithNibName:ForgetPasswardCell2 bundle:nil] forCellReuseIdentifier:ForgetPasswardCell2];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [self makeNavi];
    [self addFootView];
}

-(void)addFootView{
    UILabel*footLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(94), ACTUAL_HEIGHT(242)-10, ACTUAL_WIDTH(178), ACTUAL_HEIGHT(15))];
    footLabel.text=@"客服热线：86-02158179796";
    footLabel.font=[UIFont systemFontOfSize:11];
    footLabel.textColor=RGBCOLOR(134, 134, 134, 1);
    [self.tableView addSubview:footLabel];
    
}

-(void)makeNavi{
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69), ACTUAL_WIDTH(19))];
    titleLabel.text=@"忘记密码";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton*button2=[UIButton buttonWithType:0];
    button2.frame=CGRectMake(ACTUAL_WIDTH(342), ACTUAL_HEIGHT(36), ACTUAL_WIDTH(27), ACTUAL_WIDTH(16));
    [button2 setTitle:@"完成" forState:UIControlStateNormal];
    button2.titleLabel.font=[UIFont systemFontOfSize:11];
    [button2 addTarget:self action:@selector(compelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
}
-(void)compelete{
    _canSave=NO;
    NSString *str= [self judgeCanSave];
    
    if (!_canSave) {
        [JRToast showWithText:str];
    }else{
//        
//        http://www.vipxox.cn/?   m=appapi&s=forget_pwd&act=forget&email=963523556@qq.com&pwd=123456&code=654879
        UITableViewCell* cell= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] ];
        UITextField*yanzhencode=[cell viewWithTag:1];
        
        
        UITableViewCell* cell2= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] ];
        UITextField*Code=[cell2 viewWithTag:2];

        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"appapi",@"s":@"forget_pwd",@"act":@"forget",@"email":self.getEmail,@"pwd":Code.text,@"code":yanzhencode.text};
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            NSLog(@"%@",number);
            
            if ([number isEqualToString:@"0"]) {
                  [JRToast showWithText:[data objectForKey:@"errorMessage"]];
                //正确的话 修改密码成功 （最好能显示 用户名）然后自动跳到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [JRToast showWithText:[data objectForKey:@"errorMessage"]];
            }
        
        
        
        }];
    
    
         }
}


-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString*)judgeCanSave{
    _canSave=YES;
  UITableViewCell* cell= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] ];
    UITextField*yanzhencode=[cell viewWithTag:1];
    
    
    UITableViewCell* cell2= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] ];
    UITextField*Code=[cell2 viewWithTag:2];

    UITableViewCell* cell3= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] ];
    UITextField*nextCode=[cell3 viewWithTag:2];

    NSLog(@"%@",yanzhencode.text);
    NSLog(@"%@",Code.text);
    NSLog(@"%@",nextCode.text);
    
    if (yanzhencode.text.length<6) {
        _canSave=NO;
        return @"验证码不能小于6位";
    }
    
    if (Code.text.length<6) {
        _canSave=NO;
        return @"密码不能小于6位";
    }

    
    if (![Code.text isEqualToString:nextCode.text]) {
        _canSave=NO;
        return @"两次密码输入不一致";
    }
    
    
    return @"滚犊子";
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 2;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
          }
    
    if (indexPath.section==0&&indexPath.row==0) {
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ForgetPasswardCell];
      UITextField*textField=[cell viewWithTag:1];
        textField.placeholder=@"请输入邮箱验证码";
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ForgetPasswardCell2];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel*label=[cell viewWithTag:1];
        UITextField *textField=[cell viewWithTag:2];
        
        if (indexPath.section==1&&indexPath.row==0) {
            label.text=@"新密码";
            textField.placeholder=@"字母或者数字6-12位";
        }else{
            label.text=@"重复密码";
            textField.placeholder=@"重复输入一次新密码";
        }
        
        return cell;

        
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.001;
        return ACTUAL_HEIGHT(20);
    }else if(section==1){
               return ACTUAL_HEIGHT(37);
    }
    return ACTUAL_HEIGHT(0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(44);
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

@end
