//
//  AppDelegate.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/27.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "AppDelegate.h"
//#import "XXTabBarController.h"
#import "YLWTabBarController.h"
#import "WXApiManager.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialFacebookHandler.h"


#import "PayPalMobile.h"   //paypal
#import "FirstInstallViewController.h"
#import "UserSession.h"

#import "InternationalLanguage.h"

#import "UIImageView+WebCache.h"
#import "AdvertiseView.h"    //广告的视图


@interface AppDelegate ()

//@property(nonatomic,strong)UIView*adverView;   //广告图

@property (strong, nonatomic) UIImageView *splashView;  //动画效果实现
@property(nonatomic,strong)UILabel*vipxoxLabel;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    

    
    
    
    
#pragma mark  支付  分享 这块的   sdk 注册
//     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //payPal 支付
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AVv9vVmWTS5pf37TS-fGjOFQU4xRcW0Q2Mc1YFX1oOuKcVXGASBbqv6U0n-VJhST3LzEujV0GFh6K6XR",
                                                           PayPalEnvironmentSandbox : @"AbIW6w0EtS4k0zJp1fL1g7oKIGH6Gp-jUzIqJswXb9Y1I3zTBC-yCrZqwvh6kc0cBCtu5egYej8SWt_0"}];
    
    //微信支付
        [WXApi registerApp:@"wx79c6b799fa438d81" withDescription:@"demo 2.0"];
    
    
    //友盟
    [UMSocialData setAppKey:@"56f3a606e0f55ae61a002be0"];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx79c6b799fa438d81" appSecret:@"2911fb763ffa7dea4d160fb148800ee4" url:@"http://www.vipxox.com"];
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"199545722"
                                              secret:@"5bec427e8680af6f3f9e7bfdb9ceb3c4"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    
        //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105312092" appKey:@"7txdjRcPvCoeLCpg" url:@"http://www.vipxox.com"];
    //    //设置支持没有客户端情况下使用SSO授权e
    [UMSocialQQHandler setSupportWebView:YES];

    
    //设置facebook应用ID及URL
    [UMSocialFacebookHandler setFacebookAppID:@"1626870400918735" shareFacebookWithURL:@"http://www.vipxox.com"];


    
    
#pragma mark  ----国际化语言
     [InternationalLanguage initUserLanguage];//初始化应用语言
//     NSBundle *bundle = [InternationalLanguage bundle];
//  NSString *inviteMsg = [bundle localizedStringForKey:@"invite" value:nil table:@"hello"];     用法
    
    
    
    
#pragma mark  ---- 真正的登录
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
   
    

    
    //自动登录 和 引导页
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
   NSString*str= [user objectForKey:ISFIRSTINSTALL];
    if ([str isEqualToString:@"YES"]) {
        YLWTabBarController*tabBar=[[YLWTabBarController alloc]init];
        self.window.rootViewController=tabBar;
        [UITabBar appearance].tintColor=ManColor;

        
    }else{
        FirstInstallViewController*vc=[[FirstInstallViewController alloc]init];
        self.window.rootViewController=vc;

    }
    
    
    

    
     [self.window makeKeyAndVisible];

#pragma mark  启动图 动画图 广告图

//    //动画效果的实现
    _splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [_splashView setImage:[UIImage imageNamed:@"动画的背景"]];
    [self.window addSubview:_splashView];
    [self.window bringSubviewToFront:_splashView];
    [self performSelector:@selector(scale_1) withObject:nil afterDelay:0.0f];
     [self performSelector:@selector(showWord) withObject:nil afterDelay:1.5f];
//
//    
//    //广告
      [self performSelector:@selector(makeAdvert) withObject:nil afterDelay:3.0f];

    
    return YES;
}

-(void)scale_1
{
    UIImageView *round_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    round_1.centerX=KScreenWidth/2;
    round_1.centerY=KScreenHeight/2;
    round_1.layer.cornerRadius=45;
    round_1.layer.masksToBounds=YES;
    round_1.backgroundColor=[UIColor redColor];
    round_1.image = [UIImage imageNamed:@"logo 1024X1024"];
    [_splashView addSubview:round_1];
    
    
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-100, 30)];
    [title setY:round_1.bottom+10];
    [title setCenterX:round_1.centerX];
    title.font=[UIFont systemFontOfSize:20];
    title.text=@"Vipxox";
    title.textColor=[UIColor whiteColor];
    title.textAlignment=NSTextAlignmentCenter;
    [_splashView addSubview:title];
    _vipxoxLabel=title;
    
    
    [self setAnimation:round_1];
    [self setAnimation:title];
}


-(void)showWord{
    UILabel *word_ = [[UILabel alloc]initWithFrame:CGRectMake(0, self.vipxoxLabel.bottom+5, KScreenWidth-100, 20)];
    word_.text=@"国货优品一站购";
    word_.textColor=[UIColor whiteColor];
    word_.textAlignment=NSTextAlignmentCenter;
    word_.centerX=KScreenWidth/2;
    word_.font=[UIFont systemFontOfSize:17];
    [_splashView addSubview:word_];
    
    word_.alpha = 0.0;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         word_.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         [NSThread sleepForTimeInterval:1.0f];
         [_splashView removeFromSuperview];
     }
     ];

    
}


-(void)setAnimation:( UIView*)nowView
{
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         // 执行的动画code
         [nowView setFrame:CGRectMake(nowView.frame.origin.x, nowView.frame.origin.y-kscreenHeight*0.2, nowView.frame.size.width, nowView.frame.size.height)];
     }
                     completion:^(BOOL finished)
     {
        
     }
     ];
    
    
}


#pragma mark 使用第三方登录需要重写下面两个方法
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 登录需要编写
    [UMSocialSnsService applicationDidBecomeActive];
}





- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"result = %@",resultDic);
        }];
    }
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else{
        return YES;
        
    }
    return result;
}


//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    return result;
//}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"result = %@",resultDic);
        }];
    }
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等

        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else{
//        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
       return  result;
        
    }
    return result;

}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ---- 广告
-(void)makeAdvert{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
        
    }
    
    
#warning ---   这里  后台操作
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新  没有的话删除本地图片
    [self getAdvertisingImage];

    
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
//    www.vipxox.com  /?m=app&s=ad&act=index
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"ad",@"act":@"index"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSString*errorcode =[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        if ([errorcode isEqualToString:@"0"]) {
            if ([data[@"data"] isKindOfClass:[NSNull class]]) {
                return ;
            }
            NSDictionary*dict=data[@"data"];
            
            NSString*imageStr=dict[@"picName"];
            //用来取消图片
//            NSString*imageStr=@"";
            NSString*idd=dict[@"id"];
            if ([imageStr isEqualToString:@""]) {
                //如果是 空字符串 删除本地图片
                 [self deleteOldImage];
                
            }else{
            NSArray*array=[imageStr componentsSeparatedByString:@"/"];
            NSString*imageName=array.lastObject;
            
            NSString*path=[self getFilePathWithImageName:imageName];
             BOOL isExist = [self isFileExistWithFilePath:path];
            if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
                
                [self downloadAdImageWithUrl:imageStr imageName:imageName andshoppingID:(NSString*)idd];
                
            }
            }
            
        }else{
            //出错的话删除本地图片
              [self deleteOldImage];
        }
        
        
    }];
    
    
    
    
//    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
//    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
//    NSString *imageUrl = imageArray[arc4random() % imageArray.count];

    
//#warning   如果得到空的字符串。   删除原来保存的图片
//    
//    
//    // 获取图片名:43-130P5122Z60-50.jpg
//    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
//    NSString *imageName = stringArr.lastObject;
//    
//    // 拼接沙盒路径
//    NSString *filePath = [self getFilePathWithImageName:imageName];
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
//        
//        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
//        
//    }
    
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName andshoppingID:(NSString*)idd
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            if ([idd isEqualToString:@""]) {
                
            }else{
                [kUserDefaults setValue:idd forKey:adUrl];

            }
            
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [kUserDefaults removeObjectForKey:adUrl];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}




@end
