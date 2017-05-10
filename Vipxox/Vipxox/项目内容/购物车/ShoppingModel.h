//
//  ShoppingModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingModel : NSObject

//@property(nonatomic,strong)NSString*image;
//@property(nonatomic,strong)NSString*title;
//@property(nonatomic,strong)NSString*color;
//@property(nonatomic,strong)NSString*size;
//@property(nonatomic,strong)NSString*money;
//@property(nonatomic,strong)NSString*number;   //数量
//@property(nonatomic,assign)NSString*transMoney;  //运费
//@property(nonatomic,assign)BOOL isFavorite;    //收藏


//"num": "1",
//"title": "韩版毛呢外套女2015秋冬装新款韩范中长款加厚加棉羊毛呢子大衣潮",
//"price": 52.7868,
//"pro_pic": "http://img.alicdn.com/bao/uploaded/i1/TB1nFo6KpXXXXaQXFXXXXXXXXXX_!!0-item_pic.jpg",
//"attr_desc": "颜色分类:灰色加棉尺码:S",
//"s_type": "tmall",
//"sku_id": "3130794392512",
//"freight_price": " ",
//"kx": "0",
//"pz": " ",
//"qd": "0"
@property(nonatomic,assign)BOOL selectState;   //是否被电击

@property(nonatomic,strong)NSString*idd;     //id
@property(nonatomic,strong)NSString*num;       //数量
@property(nonatomic,strong)NSString*title;    //标题
@property(nonatomic,strong)NSString*price;    //钱
@property(nonatomic,strong)NSString*pro_pic;    //大图片
@property(nonatomic,strong)NSString*attr_desc;   //颜色分类
@property(nonatomic,strong)NSString*s_type;     //尺寸       @"vipxox"
@property(nonatomic,strong)NSString*sku_id;     //代购编号
@property(nonatomic,strong)NSString*freight_price;   //运费
@property(nonatomic,strong)NSString*kx;     //开箱
@property(nonatomic,strong)NSString*pz;     //拍照
@property(nonatomic,strong)NSString*qd;     //去皮
@property(nonatomic,strong)NSString*f_address;    //发货仓库
@property(nonatomic,strong)NSString*s_time;    //配送时效
@property(nonatomic,strong)NSString*pro_url;
@property(nonatomic,strong)NSString*pid;

@property(nonatomic,strong)NSString*url;    //抓取


//


-(instancetype)initWithShopDict:(NSDictionary*)dict;

@end
