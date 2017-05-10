//
//  ZhekouViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ZhekouViewController.h"

#import "ChooseViewController.h"
#import "RealChooseViewController.h"


@interface ZhekouViewController ()<UIScrollViewDelegate,ChooseViewControllerDelegate,DiscountViewControllerDelegate>

@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)ChooseViewController*chooseView;

@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong) UIView *naviBar;  //naviBar 颜色
@property(nonatomic,strong)UIView *OthernaviBar;  //另一个bar 颜色

@property(nonatomic,strong) NSMutableArray*allName;  //选择品牌所有的品牌名字
@property(nonatomic,strong)NSMutableArray*allID;   //选择品牌所有的品牌id
@end

@implementation ZhekouViewController

-(instancetype)init{
    self=[super init];
    if (self) {
        //创建discount
        self.disCount=[[DiscountViewController alloc]init];
        self.disCount.delegate=self;
    }
    
    return self;
}

-(ChooseViewController *)chooseView{
    if (!_chooseView) {
        _chooseView=[[ChooseViewController alloc]init];
        _chooseView.view.frame=CGRectMake(KScreenWidth, -20, KScreenWidth-ACTUAL_WIDTH(50), KScreenHeight);
        _chooseView.delegate=self;
//        _chooseView.delegate=_disCount;
        self.delegate=_chooseView;
    }
    return _chooseView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _scrollView.delegate=self;
        _scrollView.contentSize=CGSizeMake(KScreenWidth*2-ACTUAL_WIDTH(50), 0);
//        _scrollView.alwaysBounceVertical=NO;
//        _scrollView.backgroundColor=[UIColor greenColor];
        _scrollView.bounces=NO;
        _scrollView.pagingEnabled=YES;
        
//        _scrollView.scrollEnabled=NO;
    }
    return _scrollView;
}

//-(DiscountViewController *)disCount{
//    if (!_disCount) {
//        _disCount=[[DiscountViewController alloc]init];
//        _disCount.view.frame=CGRectMake(0, -20, KScreenWidth, KScreenHeight);
//        
////        _chooseView.delegate=_disCount;
//    }
//    return _disCount;
//}
#pragma mark ---discount 的代理
-(void)DelegateForTitle:(NSString *)title{
    self.titleLabel.text=title;
}
-(void)DelegateMainControllerPush:(NSDictionary *)dict{
    NSLog(@"%@",dict);
//    GoodsTailsViewController *vc=[[GoodsTailsViewController alloc]init];
//    vc.thisDatas=dict;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
//    self.view.backgroundColor=[UIColor yellowColor];
    
    self.disCount.view.frame=CGRectMake(0, -20, KScreenWidth, KScreenHeight);
      [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.disCount.view];
    [self.scrollView addSubview:self.chooseView.view];
//       self.chooseView.delegate=self.disCount;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pianyi:) name:@"tongzhipianyiheshuaxin" object:nil];


    [self addNaviBar];
    [self addOtherNaviBar];
    

}

-(void)pianyi:(NSNotification*)nsnotification{
    [UIView animateWithDuration:0.3 animations:^{
        
                self.scrollView.contentOffset=CGPointMake(0, -20);
            }];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    [self getColor];
    
//    _chooseView.delegate=_disCount;
//    self.delegate=_chooseView;

    
}
-(void)getColor{
    if (self.xColor==0) {
        _naviBar.backgroundColor=ManColor;
        _OthernaviBar.backgroundColor=ManColor;
    }else if (self.xColor==1){
        _naviBar.backgroundColor=YooPink;
        _OthernaviBar.backgroundColor=YooPink;

    }else if (self.xColor==2){
        _naviBar.backgroundColor=BoyColor;
        _OthernaviBar.backgroundColor=BoyColor;

    }else if (self.xColor==3){
        _naviBar.backgroundColor=NorthAmercia;
        _OthernaviBar.backgroundColor=NorthAmercia;

    }
    
    
}

-(void)addOtherNaviBar{
    _OthernaviBar=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, -20, KScreenWidth, 64)];
    _OthernaviBar.backgroundColor=YooPink;
    [self.scrollView addSubview:_OthernaviBar];

    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(9),  ACTUAL_HEIGHT(32), ACTUAL_WIDTH(70), ACTUAL_HEIGHT(18))];
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.text=@"筛选商品";
    [_OthernaviBar addSubview:label];
    
    
    UIButton*chear=[UIButton buttonWithType:0];
    chear.frame=CGRectMake(ACTUAL_WIDTH(204), ACTUAL_HEIGHT(26), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(25));
    chear.backgroundColor=[UIColor whiteColor];
    chear.titleLabel.font=[UIFont systemFontOfSize:14];
    [chear setTitle:@"清空" forState:UIControlStateNormal];
    [chear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chear addTarget:self action:@selector(chearButton) forControlEvents:UIControlEventTouchUpInside];
    [_OthernaviBar addSubview:chear];
    
    
    UIButton*ok=[UIButton buttonWithType:0];
    ok.frame=CGRectMake(ACTUAL_WIDTH(265), ACTUAL_HEIGHT(26), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(25));
    ok.backgroundColor=[UIColor blackColor];
    ok.titleLabel.font=[UIFont systemFontOfSize:14];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [_OthernaviBar addSubview:ok];

    
}

-(void)chearButton{
    if ([self.delegate respondsToSelector:@selector(delegateForClear)]) {
        [self.delegate delegateForClear];
    }
}
-(void)okButton{
    if ([self.delegate respondsToSelector:@selector(delegateForSendOK)]) {
        [self.delegate delegateForSendOK];
    }
}
-(void)addNaviBar{
    _naviBar=[[UIView alloc]initWithFrame:CGRectMake(0, -20, KScreenWidth, 64)];
    _naviBar.backgroundColor=YooPink;
    [self.scrollView addSubview:_naviBar];
    
    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(22), ACTUAL_HEIGHT(28), ACTUAL_WIDTH(14), ACTUAL_HEIGHT(26));
//    button.backgroundColor=[UIColor yellowColor];
    [button setBackgroundImage:[UIImage imageNamed:@"NaviBack"] forState:UIControlStateNormal];
    button.size=button.currentBackgroundImage.size;
    button.origin=CGPointMake(16, 31);
    [button addTarget:self action:@selector(touchBackButton) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:button];
    
   _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(110), ACTUAL_HEIGHT(32), ACTUAL_WIDTH(220), ACTUAL_HEIGHT(18))];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.text=@"";
    _titleLabel.textColor=[UIColor whiteColor];
    [_naviBar addSubview:_titleLabel];
    
    
    UIButton*shaixuan=[UIButton buttonWithType:0];
    shaixuan.frame=CGRectMake(ACTUAL_WIDTH(335), ACTUAL_HEIGHT(32), ACTUAL_WIDTH(35), ACTUAL_HEIGHT(18));
    shaixuan.titleLabel.font=[UIFont systemFontOfSize:14];
    [shaixuan setTitle:@"筛选" forState:UIControlStateNormal];
    [shaixuan addTarget:self action:@selector(touchShaixuan:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:shaixuan];
    
    
    
    
}

-(void)touchBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchShaixuan:(UIButton*)sender{
    if (sender.selected==YES) {
        sender.selected=NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.scrollView.contentOffset=CGPointMake(0, -20);
        }];

        
    }else{
        sender.selected=YES;
        [UIView animateWithDuration:0.3 animations:^{
            
              self.scrollView.contentOffset=CGPointMake(KScreenWidth-ACTUAL_WIDTH(50), -20);
        }];
        
    }
  
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    CGFloat with=KScreenWidth-ACTUAL_WIDTH(50);
//    if ([scrollView isKindOfClass:[self.scrollView class]]) {
//        if (self.scrollView.contentOffset.x>=with/2) {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.scrollView.contentOffset=CGPointMake(with, -20);
//            }];
//            
//            
//        }else{
//            [UIView animateWithDuration:0.3 animations:^{
//                self.scrollView.contentOffset=CGPointMake(0, -20);
//                
//            }];
//        }
//        
//    }
//
//    
//}


#pragma mark

#pragma mark  ----点击筛选的 row  选择分类啊  
-(void)chooseWhichRow:(NSIndexPath *)indexPath{
    NSLog(@"%lu",indexPath.row);
    RealChooseViewController*vc=[[RealChooseViewController alloc]init];
    vc.delegate=self.chooseView;
    
    NSArray*arr0=@[@"选择性别",@"全部",@"BOYS",@"GIRLS"];
    
    NSArray*arr1=@[@"选择品牌",@"所有品牌",@"AMENPAPA",@"ALLE nove",@"BLACKJACK",@"BABAMA",@"CLOTtee",@"connive",@"Dare To Dream"];
    
    NSArray*a20=@[@"全部上衣",@"棉服",@"羽绒服",@"棉衣",@"卫衣",@"衬衫",@"大衣／风衣",@"皮衣",@"防风外套",@"马甲",@"夹克",@"毛衣／针织",@"西装",@"T恤",@"POLO",@"背心"];
    NSArray*a21=@[@"全部裤装",@"休闲裤",@"牛仔裤",@"短裤"];
    NSArray*a22=@[@"全部鞋靴",@"时装鞋",@"凉鞋／凉拖",@"保养护理"];
    NSArray*a23=@[@"全部包类",@"双肩包",@"手拎包／单肩包",@"钱包／卡包／手包／钥匙包",@"腰包",@"电脑包"];
    NSArray*a24=@[@"全部服配",@"太阳镜／眼镜",@"帽子",@"首饰",@"袜子",@"配饰",@"手表"];
    NSArray*a25=@[@"全部内衣／家居服",@"内裤",@"家居服"];
    NSArray*a26=@[@"全部美妆／个护",@"个人护理"];

    NSArray*arr2=@[@"选择品类",@"所有品类",@"上衣",@"裤装",@"鞋靴",@"包类",@"服配",@"内衣／家居服",@"美装／个护"];
    NSArray*arr22=@[a20,a21,a22,a23,a24,a25,a26];
    
    NSArray*arr3=@[@"选择颜色",@"所有颜色",@"黑色",@"蓝色",@"灰色",@"白色",@"绿色",@"红色",@"棕色",@"彩色",@"黄色",@"银色",@"橙色",@"金色",@"紫色"];
      NSArray*arr4=@[@"选择价格",@"所有价格",@"¥0-189",@"¥190-289",@"¥290-539",@"¥539以上"];
//    NSArray*arr5=@[@"选择尺码",@"所有尺码",@"M",@"L",@"XL",@"S",@"XXL",@"F",@"XXXL",@"XS",@"30英寸",@"31英寸",@"29英寸",@"32英寸",@"33英寸",@"",@"34英寸",@"28英寸",@"36英寸",@"35英寸",@"37英寸",@"39码",@"37码",@"42码",@"43码",@"38码",@"41码",@"35码",@"36码",@"40码",@"44码",@"46",@"48",@"13寸pro",@"50",@"52",@"34码",@"35 1/2码"];
    NSArray*arr5=@[@"选择产地",@"全部",@"日本",@"韩国",@"中国",@"美国",@"英国",@"法国"];
  
    

    
    
//     NSArray*arr3=@[@"选择颜色",@"所有品类",@"上衣",@"裤装",@"鞋靴",@"包类",@"服配",@"内衣／家居服",@"美装／个户"];

    
    switch (indexPath.row) {
        case 0:
            //性别
            vc.allDatas=arr0;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 1:
            //品牌
            [self jiekouGetPinpai];
//            vc.allDatas=arr1;
//            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 2:
            //品类   只有这个  有子界面
            vc.allDatas=arr2;
            vc.subAllDatas=arr22;
            [self.navigationController pushViewController:vc animated:YES];
  
            
            break;
        case 3:
            //颜色
            vc.allDatas=arr3;
            [self.navigationController pushViewController:vc animated:YES];

            
            break;
        case 4:
                //价格
            vc.allDatas=arr4;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        case 5:
              //产地
            vc.allDatas=arr5;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        default:
            break;
    }
    
    
}

-(void)jiekouGetPinpai{
    _allName=[NSMutableArray array];
    _allID=[NSMutableArray array];
//    http://www.vipxox.cn/ ?m=appapi&s=mall&act=get_brands
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"mall",@"act":@"get_brands"};
   HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
              if ([data[@"errorCode"] isEqualToString:@"0"]) {
                 for (int i=0; i<[data[@"data"] count]; i++) {
                [_allName addObject:data[@"data"][i][@"name"]];
                [_allID addObject:data[@"data"][i][@"id"]];
                
            }
            
            RealChooseViewController*vc=[[RealChooseViewController alloc]init];
            vc.delegate=self.chooseView;
            vc.allDatas=_allName;
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    }];
    
    
}
//-(void)delegateForShaixuan:(NSMutableArray *)array{
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.scrollView.contentOffset=CGPointMake(0, -20);
//    }];
//    //此处有代理    委托discount 刷新界面
//    
//    
//}

-(void)delegateForBottomControllerScrollContentOff{
    [UIView animateWithDuration:0.3 animations:^{
        
                self.scrollView.contentOffset=CGPointMake(0, -20);
            }];

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

@end
