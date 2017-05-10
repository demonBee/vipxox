//
//  ChooseColorAndSizeViewController.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/14.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseColorAndSizeViewController : UIViewController

@property(nonatomic,strong)NSString *typeStr;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *imageStr;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *priceStr;
@property(nonatomic,strong)NSString *yuanStr;

@property(nonatomic,strong)NSMutableArray *valueColorArray;
@property(nonatomic,strong)NSMutableArray *valueSizeArray;

@property(nonatomic,strong)NSString *colorStr;
@property(nonatomic,strong)NSString *sizeStr;

@property(nonatomic,strong)NSDictionary *idDic;
@property(nonatomic,strong)NSDictionary *priceDic;
@property(nonatomic,strong)NSDictionary *yuanDic;

@property(nonatomic,strong)NSString *sidStr;

@property(nonatomic,strong)NSString*sku_id;

@end
