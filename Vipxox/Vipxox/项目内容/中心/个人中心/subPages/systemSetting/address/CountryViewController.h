//
//  CountryViewController.h
//  weimao
//
//  Created by 黄佳峰 on 16/2/21.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryViewControllerDelegate <NSObject>

-(void)delegateForBack0:(NSString*)str0;

@end

@interface CountryViewController : UIViewController
@property(nonatomic,assign)id<CountryViewControllerDelegate>delegate;
@end
