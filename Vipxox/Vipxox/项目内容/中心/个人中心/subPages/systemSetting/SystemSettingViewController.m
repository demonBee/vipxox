//
//  SystemSettingViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/15.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "AccountSafeViewController.h"
#import "ABoutWeViewController.h"
#import "GetGoodAddressViewController.h"   //临时
//#import "PersonCenterViewController.h"   //linshi
#import "TMIdeaFeedBackViewController.h"
//#import "XXTabBarController.h"
 #import "YLWTabBarController.h"

#import "InternationalLanguage.h"



@interface SystemSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;

@end

@implementation SystemSettingViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        _tableView.backgroundColor=[UIColor yellowColor];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self makeNavi];
    self.navigationController.navigationBarHidden=NO;
//    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=[[InternationalLanguage bundle]localizedStringForKey:@"系统设置" value:nil table:@"Language"];;
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    [self.view addSubview:self.tableView];
    
    UILabel*footLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(135), ACTUAL_HEIGHT(406), ACTUAL_WIDTH(110), ACTUAL_HEIGHT(12))];
    NSDictionary*infoDictionary=[[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString*version=[[InternationalLanguage bundle] localizedStringForKey:@"当前版本：" value:nil table:@"Language"];
//    footLabel.text=@"当前版本：2.35(1477)";
    footLabel.text=[NSString stringWithFormat:@"%@%@",version,app_Version];
    footLabel.font=[UIFont systemFontOfSize:9];
    footLabel.textColor=RGBCOLOR(183, 183, 183, 1);
    [self.tableView addSubview:footLabel];
//    self.navigationController.navigationBarHidden=NO;
}

//-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=[[InternationalLanguage bundle] localizedStringForKey:@"系统设置" value:nil table:@"Language"];
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.textAlignment=1;
//    [self.view addSubview:titleLabel];
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}
//
//-(void)dismissTo{
//    [self.navigationController popViewControllerAnimated:YES];}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
          cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        NSBundle*bundle=[InternationalLanguage bundle];
        
        
        if (indexPath.row==0) {
            cell.textLabel.text=[bundle localizedStringForKey:@"账号与安全" value:nil table:@"Language"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=[UIColor blackColor];
        }else if (indexPath.row==1){
            cell.textLabel.text=[bundle localizedStringForKey:@"清除缓存" value:nil table:@"Language"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=[UIColor blackColor];

//        }else if (indexPath.row==2){
//            cell.textLabel.text=@"版本介绍";
//            cell.textLabel.font=[UIFont systemFontOfSize:14];
//            cell.textLabel.textColor=RGBCOLOR(120, 120, 120, 1);

        }else if (indexPath.row==2){
            cell.textLabel.text=[bundle localizedStringForKey:@"关于我们" value:nil table:@"Language"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=[UIColor blackColor];

        }else if (indexPath.row==3){
            cell.textLabel.text=[bundle localizedStringForKey:@"意见反馈" value:nil table:@"Language"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=[UIColor blackColor];


        }else if (indexPath.row==4){
            cell.textLabel.text=[bundle localizedStringForKey:@"退出当前账号" value:nil table:@"Language"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=[UIColor blackColor];

        }else if (indexPath.row==5){
            //切换语言
            NSBundle *bundle=[InternationalLanguage bundle];
            cell.textLabel.text=[bundle localizedStringForKey:@"getLanguage" value:nil table:@"Language"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.textColor=[UIColor blackColor];

            
            
         
            

        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(44);
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        AccountSafeViewController*vc=[[AccountSafeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row==1) {
        [self removeCache];
        NSBundle*bundle=[InternationalLanguage bundle];
        [JRToast showWithText:[bundle localizedStringForKey:@"清除缓存成功！" value:nil table:@"Language"]];
    }
    
//    if (indexPath.row==2) {
//        UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:nil message:@"当前版本为Vipxox 2.3" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alter1 show];
//    }

    if (indexPath.row==2) {
        ABoutWeViewController *vc=[[ABoutWeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row==3) {
        TMIdeaFeedBackViewController*vc=[[TMIdeaFeedBackViewController alloc]init];
         [self.navigationController pushViewController:vc animated:YES];

    }
    
    if (indexPath.row==4) {
        UserSession*session=[UserSession instance];
        [session cleanUser];
        session=nil;
        NSUserDefaults*user= [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:AUTOLOGIN];
        [user removeObjectForKey:AUTOLOGINCODE];
        [user removeObjectForKey:ISTHIRDLOGIN];
        [user removeObjectForKey:ISTHIRDPARAMS];
       
        YLWTabBarController*vc=[[YLWTabBarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController=vc;
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if (indexPath.row==5){
        //重启 系统
        NSString *lan = [InternationalLanguage userLanguage];
        
        if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
            
            [InternationalLanguage setUserlanguage:@"zh-Hans"];
            
        }else{
            
            [InternationalLanguage setUserlanguage:@"en"];
        }
        
        YLWTabBarController*vc=[[YLWTabBarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController=vc;

        
        
    }

}

-(void)removeCache
{
    //===============清除缓存==============
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    //    NSLog(@"文件数 ：%d",[files count]);
    for (NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
