//
//  ThreeRegisterViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol ThreeRegisterViewControllerDelegate <NSObject>



//@end
@interface ThreeRegisterViewController : UIViewController

//@property(nonatomic,strong)NSString*aplatformName;
//@property(nonatomic,strong)NSString*ausid;

@property(nonatomic,strong)NSString*cid;   //cid得到

@property(nonatomic,strong)NSDictionary*params;    //这个需要保存到userdefault里面  用于下次自动登录
@end
