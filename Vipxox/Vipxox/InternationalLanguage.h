//
//  InternationalLanguage.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/13.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalLanguage : NSObject



+(void)initUserLanguage;//初始化语言文件      1

+(NSBundle *)bundle;//获取当前资源文件      2

+(NSString *)userLanguage;//获取应用当前语言    2

+(void)setUserlanguage:(NSString *)language;//设置当前语言   3


@end
