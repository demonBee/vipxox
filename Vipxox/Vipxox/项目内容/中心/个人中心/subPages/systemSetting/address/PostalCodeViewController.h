//
//  PostalCodeViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostalCodeViewControllerDelegate <NSObject>

-(void)delegateForBack3:(NSString*)str3;

@end
@interface PostalCodeViewController : UIViewController
@property(nonatomic,assign)id<PostalCodeViewControllerDelegate>delegate;
@end
