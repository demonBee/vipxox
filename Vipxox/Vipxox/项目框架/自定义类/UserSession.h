//
//  UserSession.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/6.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject



@property(nonatomic,strong)NSString*uid;  //uid   token
@property(nonatomic,strong)NSString*ip;   //ip
@property(nonatomic,strong)NSString*unreachable;   //冻结金额
@property(nonatomic,strong)NSString*mobile_verify; //手机验证
@property(nonatomic,strong)NSString*cash;     //可用金额
@property(nonatomic,strong)NSString*mobile;   //手机号
@property(nonatomic,strong)NSString*point;    //积分
@property(nonatomic,strong)NSString*cityid;    //城市id
@property(nonatomic,strong)NSString*invite;   //邀请者
@property(nonatomic,strong)NSString*name;      //真实姓名
@property(nonatomic,strong)NSString*userid;    // 用户ID
@property(nonatomic,strong)NSString*sex;     //性别
@property(nonatomic,strong)NSString*skype;    //skype
@property(nonatomic,strong)NSString*password;   //密码
@property(nonatomic,strong)NSString*user;          //会员名 就是账号
@property(nonatomic,strong)NSString*email;    //邮箱
@property(nonatomic,strong)NSString*streetid;   //街id
@property(nonatomic,strong)NSString*lastLoginTime;  //最后登录时间
@property(nonatomic,strong)NSString*sellerpoints;  //卖家信用
@property(nonatomic,strong)NSString*area;    //省市区
@property(nonatomic,strong)NSString*msn;     //msn
@property(nonatomic,strong)NSString*regtime;    //注册时间
@property(nonatomic,strong)NSString*email_verify;  //email 验证
@property(nonatomic,strong)NSString*birthday;  //生日时间戳
@property(nonatomic,strong)NSString*logo;      //用户头像
@property(nonatomic,strong)NSString*pay_id;   //支付id
@property(nonatomic,strong)NSString*buyerpoints;//卖家信用
@property(nonatomic,strong)NSString*pid;    //父类id
@property(nonatomic,strong)NSString*provinceid;   //省id
@property(nonatomic,strong)NSString*rand;
@property(nonatomic,strong)NSString*qq;     //QQ
@property(nonatomic,strong)NSString*areaid;   //区id
@property(nonatomic,strong)NSString*statu;     //状态
@property(nonatomic,strong)NSString*currency; //货币
@property(nonatomic,strong)NSString*personality;   //个人签名

//收货地址
@property(nonatomic,strong)NSArray*address;


//已经登录
@property(nonatomic,assign)BOOL isLogin;   //是否登录



+ (UserSession *) instance;   //单例
-(void)cleanUser;     //清空

@end
