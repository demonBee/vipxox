//
//  YLWTabBarController.m
//  推库iOS
//
//  Created by Mac on 16/2/17.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWTabBarController.h"
#import "InternationalLanguage.h"
#import "XXNavigationController.h"

#import "YoohuoViewController.h"
//#import "NiceFoodViewController.h"        //弃用的美食界面
//#import "FindViewController.h"          //弃用的发现版块
#import "TMBuildShopStoreViewController.h"
#import "ShopCarViewController.h"


#import "GuangjieViewController.h"    //逛街
//#import "WechatViewController.h"    //聊天
//#import "DepartmentAndGOViewController.h"    //一元购  百货

#import "NewPersonCenterViewController.h"   //新的个人中心
#import "NewShoppingCarViewController.h"    //新的购物车


#import "JRSegmentViewController.h"   //tabBar index1 两项切换
#import "OnePayViewController.h"   //单个 一元购
#import "DepartmentViewController.h"    //单个 百货


#import "DepartShoppingCarViewController.h"   //百货购物车

@interface YLWTabBarController ()

@end

@implementation YLWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [UITabBar appearance].tintColor=ManColor;

    [self addChildViewControllers];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yoohooGo) name:@"YoohooGo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yoohooGohome) name:@"YoohooGohome" object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NiceFoodGo) name:@"dismissFiveButton" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NiceFoodGohome) name:@"showFiveButton" object:nil];

    
}




-(void)addChildViewControllers{
    NSBundle*bundle=[InternationalLanguage bundle];
    YoohuoViewController *homeVc = [[YoohuoViewController alloc]init];
    [self addChildViewController:homeVc WithTitle:[bundle localizedStringForKey:@"首页" value:nil table:@"Language"] image:@"tabBar_home_numal"];
    
#warning ----     百货  先不要  用   用一元购
//    DepartmentAndGOViewController *site = [[DepartmentAndGOViewController alloc]init];
//    [self addChildViewController:site WithTitle:[bundle localizedStringForKey:@"百货" value:nil table:@"Language"] image:@"tab_food"];
    
    
//    OnePayViewController *site = [[OnePayViewController alloc]init];
//    [self addChildViewController:site WithTitle:[bundle localizedStringForKey:@"一元购" value:nil table:@"Language"] image:@"tab_food"];

#warning -----    tabBar 第二项
     OnePayViewController *aaa = [[OnePayViewController alloc]init];
    DepartmentViewController*bbb=[[DepartmentViewController alloc]init];
    
    JRSegmentViewController*vc =[[JRSegmentViewController alloc]init];
    vc.viewControllers=[NSMutableArray arrayWithArray:@[bbb,aaa]];
    vc.titles=@[@"网红专区",@"一元购"];
    vc.indicatorViewColor=[UIColor clearColor];
    vc.titleColor=RGBCOLOR(158, 158, 158, 1);
//    vc.selectedColor=RGBCOLOR(252, 76, 30, 1);
    vc.selectedColor=[UIColor whiteColor];
    vc.enableScroll=YES;
    vc.itemWidth=30.0f;
    //    vc.segmentBgColor=[UIColor greenColor];
    [self addChildViewController:vc WithTitle:[bundle localizedStringForKey:@"集市" value:nil table:@"Language"] image:@"tab_food"];


    
    
#pragma mark  两种可能  en的话聊天     hans的话聊天
    
    GuangjieViewController *topic = [[GuangjieViewController alloc]init];
//    WechatViewController *wechat=[[WechatViewController alloc]init];
//    FindViewController*topic=[[FindViewController alloc]init];
   NSString*whichLanguage= [InternationalLanguage userLanguage];
    if ([whichLanguage hasPrefix:@"en"]) {
//        [self addChildViewController:wechat WithTitle:[bundle localizedStringForKey:@"聊天" value:nil table:@"Language"] image:@"tabBar_rocket"];
        [self addChildViewController:topic WithTitle:[bundle localizedStringForKey:@"逛街" value:nil table:@"Language"] image:@"tabBar_rocket"];

        
        
    }else{
          [self addChildViewController:topic WithTitle:[bundle localizedStringForKey:@"逛街" value:nil table:@"Language"] image:@"tabBar_rocket"];
    }
    
  
#pragma mark ---  3种购物车    商城 百货 代购
//    ShopCarViewController *weekly = [[ShopCarViewController alloc]init];
////    NewShoppingCarViewController*weekly=[[NewShoppingCarViewController alloc]init];
//    [self addChildViewController:weekly WithTitle:[bundle localizedStringForKey:@"购物车" value:nil table:@"Language"] image:@"tabBar_shopCar_noma"];
    
    ShopCarViewController *weekly = [[ShopCarViewController alloc]init];
    DepartShoppingCarViewController*department=[[DepartShoppingCarViewController alloc]init];
//    ShopCarViewController *daigou = [[ShopCarViewController alloc]init];
    JRSegmentViewController*shoppingCar =[[JRSegmentViewController alloc]init];
    shoppingCar.viewControllers=[NSMutableArray arrayWithArray:@[weekly,department]];
    shoppingCar.titles=@[@"商城",@"网红专区"];
    shoppingCar.indicatorViewColor=[UIColor clearColor];
    shoppingCar.enableScroll=NO;
    shoppingCar.titleColor=RGBCOLOR(158, 158, 158, 1);
//    shoppingCar.selectedColor=RGBCOLOR(252, 76, 30, 1);
    shoppingCar.selectedColor=[UIColor whiteColor];
    shoppingCar.itemWidth=30.0f;
    [self addChildViewController:shoppingCar WithTitle:[bundle localizedStringForKey:@"购物车" value:nil table:@"Language"] image:@"tabBar_shopCar_noma"];
    
    

    NewPersonCenterViewController*user=[[NewPersonCenterViewController alloc]init];
    [self addChildViewController:user WithTitle:[bundle localizedStringForKey:@"个人中心" value:nil table:@"Language"] image:@"tabBar_gerenzhongxin_nomal"];


}


-(void)addChildViewController:(UIViewController *)childController WithTitle:(NSString *)title image:(NSString *)imageName{
    
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    childController.title = title;
    
    
    XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:childController];
    
    [self addChildViewController:nav];

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


#pragma mark --- 通知的响应
-(void)NiceFoodGo{
    CGRect rect=CGRectMake(ACTUAL_WIDTH(237), 0, KScreenWidth, KScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=rect;
    }];
    
}
-(void)NiceFoodGohome{
    CGRect rect=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=rect;
    }];
    
}

-(void)yoohooGo{
    CGRect rect=CGRectMake(ACTUAL_WIDTH(250), 0, KScreenWidth, KScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=rect;
    }];
    
}

-(void)yoohooGohome{
    CGRect rect=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=rect;
    }];
    
}
@end
