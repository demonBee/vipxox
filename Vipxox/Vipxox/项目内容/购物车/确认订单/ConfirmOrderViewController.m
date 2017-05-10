//
//  ConfirmOrderViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmFirstTableViewCell.h"
#import "ConfirmSecondTableViewCell.h"
#import "ConfirmThiredTableViewCell.h"
#import "ShoppingModel.h"
#import "TMAddressViewController.h"    //管理收获地址
#import "AccountRechargeViewController.h"   //支付界面



#define FIRSTCELL  @"ConfirmFirstTableViewCell"
#define SECONDCELL @"ConfirmSecondTableViewCell"
#define THIREDCELL @"ConfirmThiredTableViewCell"

@interface ConfirmOrderViewController ()<UITableViewDataSource,UITableViewDelegate,TMAddressViewControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray*address;

@property(nonatomic,strong) UILabel*titleLabel;    //无标题


@end

@implementation ConfirmOrderViewController



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(60)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title=@"确认订单";
    [self makeView];
    [self.tableView registerNib:[UINib nibWithNibName:FIRSTCELL bundle:nil] forCellReuseIdentifier:FIRSTCELL];
    [self.tableView registerNib:[UINib nibWithNibName:SECONDCELL bundle:nil] forCellReuseIdentifier:SECONDCELL];
    [self.tableView registerNib:[UINib nibWithNibName:THIREDCELL bundle:nil] forCellReuseIdentifier:THIREDCELL];
  

   
//    self.address=[UserSession instance].address;
    
}



-(void)makeView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenHeight)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    [view addSubview:self.tableView];
    

    
    //”确认“按钮
    UIButton *addShoppingCartButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(281),ACTUAL_HEIGHT(617), ACTUAL_WIDTH(86), ACTUAL_HEIGHT(44))];
    [addShoppingCartButton setTitle:@"确认" forState:0];
    [addShoppingCartButton setTitleColor:[UIColor whiteColor] forState:0];
    addShoppingCartButton.backgroundColor=ManColor;
    addShoppingCartButton.titleLabel.font=[UIFont systemFontOfSize:18];
    addShoppingCartButton.layer.cornerRadius=5;
    [addShoppingCartButton addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchDown];
    [view addSubview:addShoppingCartButton];
    
    //“您需要支付：”
    UILabel *needPayLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(628), ACTUAL_WIDTH(105), ACTUAL_HEIGHT(20))];
    needPayLabel.text=@"您需要支付：";
    needPayLabel.textColor=[UIColor blackColor];
    needPayLabel.font=[UIFont systemFontOfSize:16];
    [view addSubview:needPayLabel];
    
    if (IS_IPHONE_5||IS_IPHONE_4_OR_LESS) {
        needPayLabel.font=[UIFont systemFontOfSize:12];
//        needPayLabel.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    
    //价格
    UILabel *priceLabel1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(120), ACTUAL_HEIGHT(628), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];

    priceLabel1.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,self.allMoney];
//    priceLabel1.textColor=RGBCOLOR(206, 2, 27, 1);
    priceLabel1.textColor=NewRed;
    priceLabel1.font=[UIFont systemFontOfSize:18];
    [view addSubview:priceLabel1];
    
//    UILabel *priceLabel2=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(134), ACTUAL_HEIGHT(628), ACTUAL_WIDTH(120), ACTUAL_HEIGHT(20))];
//    CGFloat money=self.allMoney;
//    priceLabel2.text=[NSString stringWithFormat:@"%.2f",money];
//    priceLabel2.textColor=RGBCOLOR(206, 2, 27, 1);
//    priceLabel2.font=[UIFont systemFontOfSize:18];
//    [view addSubview:priceLabel2];
    
  }
#pragma mark   ----pay
-(void)gotoPay{
    NSString*str=[UserSession instance].cash;   //可用余额
    CGFloat money=[str floatValue];
    CGFloat needPay=self.allMoney;   //需要支付
#warning ------暂时


    if (money>needPay) {
        //接口 支付  可以完成支付
        
        [self toBuy];
        
        
    }else{
        //充值   传价格
        
        AccountRechargeViewController*vc=[[AccountRechargeViewController alloc]init];
//        vc.num=money=needPay;
        vc.num=needPay-money+1;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    
}

-(void)toBuy{
    
    if (self.immeToBuy==YES) {
        [self immeToBuyThisGoods];   //立即购买  没有id  需要传尺寸
    }else{
    //购物车  购买
    NSMutableArray*allId=[NSMutableArray array];
    for (int i=0; i<self.allDatas.count; i++) {
        ShoppingModel*model=self.allDatas[i];
        [allId addObject:model.idd];
        
    }
    
    NSString*strr=[allId componentsJoinedByString:@","];
    NSLog(@"%@",strr);
    
//    http://www.vipxox.cn/?  m=appapi&s=go_shop&act=shop_settlement&uid=1&money=11132&id=1717850259,321321,111133&seller=asdasd&amount_fre=0.00
    CGFloat allmoney=self.allMoney+self.allTrans;
    NSString*money=[NSString stringWithFormat:@"%f",allmoney];  //运费＋货费
    NSString*trans=[NSString stringWithFormat:@"%f",self.allTrans];
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];

    
    
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_settlement",@"uid":[UserSession instance].uid,@"money":money,@"id":strr,@"seller":@"",@"amount_fre":trans};
   HttpManager*manager= [[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
//        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            //成功
            [JRToast showWithText:data[@"errorMessage"]];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:data[@"errorMessage"] message:@"代购商品完成代购后，会为您存入拥吻汇云仓库中，您可以根据需求合并商品并选择国际快递发往海外" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
//            NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
//            UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:4];
//            personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%@",data[@"num"]];//显示消息条数
//
//            NSDictionary*dict=@{@"DG":data[@"DG"],@"SC":data[@"SC"]};
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"addRedBall" object:nil userInfo:dict];
            
            [self.navigationController popViewControllerAnimated:YES];
//            NSString*str=@"3";
//            self.tabBarItem.badgeValue=str;
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
            
        }
        
    }];
    
    }
}


-(void)immeToBuyThisGoods{
#pragma mark ----sb  我艹 
//    http://www.vipxox.cn/ ?m=appapi&s=go_shop&act=Immediate_settlement&zt=1&uid=1&color=红色&size=L&num=2&id=20
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
   
//    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"shop_settlement",@"uid":[UserSession instance].uid,@"money":money,@"id":strr,@"seller":@"",@"amount_fre":trans};

    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"Immediate_settlement",@"zt":@"1",@"uid":[UserSession instance].uid,@"attr":self.attr,@"num":self.num,@"id":self.idd};
   HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            //成功
            [JRToast showWithText:data[@"errorMessage"]];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:data[@"errorMessage"] message:@"代购商品完成代购后会为您存入拥吻汇云仓库中，您可以根据需求合并商品并选择国际快递发往海外" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
//            NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
//            UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:4];
//            personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%@",data[@"num"]];//显示消息条数
//            
//            NSDictionary*dict=@{@"DG":data[@"DG"],@"SC":data[@"SC"]};
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"addRedBall" object:nil userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+self.allDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  static NSString *CellID = @"mycell";
    
    //创建Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
        
        
        if (indexPath.section==0) {
            cell=[tableView dequeueReusableCellWithIdentifier:FIRSTCELL];
            cell.selectionStyle=NO;
            if (self.dizhi.count==0) {
                _titleLabel=[cell viewWithTag:278];
                if (!_titleLabel) {
                    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(70), ACTUAL_HEIGHT(20), ACTUAL_WIDTH(140), ACTUAL_HEIGHT(40))];
                    _titleLabel.tag=278;
//                    titleLabel.backgroundColor=[UIColor redColor];
                    _titleLabel.textAlignment=NSTextAlignmentCenter;
                    [cell.contentView addSubview:_titleLabel];
                    
                                  }
                _titleLabel.text=@"请选择地址";

                UIImageView*imageView1=[cell viewWithTag:31];
                imageView1.image=[UIImage imageNamed:@""];
                
                UIImageView*imageView2=[cell viewWithTag:32];
                imageView2.image=[UIImage imageNamed:@""];

                UILabel*label=[cell viewWithTag:1];
                label.text=@"";
                
                UILabel*label2=[cell viewWithTag:2];
                label2.text=@"";
                
                UILabel*label3=[cell viewWithTag:3];
                label3.text=@"";
                
            }else{
                 [_titleLabel removeFromSuperview];
                UIImageView*imageView1=[cell viewWithTag:31];
                imageView1.image=[UIImage imageNamed:@"shop_man"];
                
                UIImageView*imageView2=[cell viewWithTag:32];
                imageView2.image=[UIImage imageNamed:@"shop_locate"];
                
                
                //返回的地址
                //收货人
                UILabel*name=[cell viewWithTag:1];
                name.text=[NSString stringWithFormat:@"收货人:%@",self.dizhi[@"name"]];
                
                
                //电话号码
                UILabel*phone=[cell viewWithTag:2];
                phone.text=self.dizhi[@"mobile"];
//
//                //收货地址
                UILabel*address=[cell viewWithTag:3];
                address.text=[NSString stringWithFormat:@"收货地址:%@%@%@%@",self.dizhi[@"country_name"],self.dizhi[@"province_name"],self.dizhi[@"city_name"],self.dizhi[@"address"]];

                
            }
                      return cell;
        }else if (indexPath.section>0&&indexPath.section<self.allDatas.count+1) {
            cell=[tableView dequeueReusableCellWithIdentifier:SECONDCELL];
              cell.selectionStyle=NO;
            ShoppingModel *model=self.allDatas[indexPath.section-1];
            
            UILabel*toptitle=[cell viewWithTag:1];
            NSLog(@"%@",model.s_type);
            if ([model.s_type isEqualToString:@"vipxox"]) {
                toptitle.text=@"商城订单";
            }else{
                toptitle.text=@"代购订单";
            }
            
            UIImageView*imageView=[cell viewWithTag:22];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.pro_pic] placeholderImage:[UIImage imageNamed:@"placeholder_62x65"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (cacheType!=2) {
                    imageView.alpha=0.3;
                    CGFloat scale = 0.3;
                    imageView.transform = CGAffineTransformMakeScale(scale, scale);
                    
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        imageView.alpha=1;
                        CGFloat scale = 1.0;
                        imageView.transform = CGAffineTransformMakeScale(scale, scale);
                    }];
                }
            }];
            UILabel*title=[cell viewWithTag:3];
            title.text=model.title;
            
            UILabel*money=[cell viewWithTag:4];
            NSString *str=model.price;
            CGFloat floatt=[str floatValue];
            money.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,floatt];
            money.textColor=NewRed;
            
            UILabel*color=[cell viewWithTag:5];
            color.text=model.attr_desc;
            
            UILabel*number=[cell viewWithTag:6];
            number.text=[NSString stringWithFormat:@"x%@",model.num];
            
            UILabel*label1=[cell viewWithTag:11];
            label1.text=model.f_address;
            
            UILabel*label2=[cell viewWithTag:12];
            label2.text=model.s_time;
            
            UILabel*label3=[cell viewWithTag:13];
            label3.text=[NSString stringWithFormat:@"运费:%@%@",[UserSession instance].currency,model.freight_price];
            
            
            return cell;
        }else{
             cell=[tableView dequeueReusableCellWithIdentifier:THIREDCELL];
             cell.selectionStyle=NO;
            UILabel*goodMoney=[cell viewWithTag:11];
            goodMoney.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,self.allMoney-self.allTrans];
            
            UILabel*frightMoney=[cell viewWithTag:12];
            frightMoney.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,self.allTrans];
            
#warning --- 没有运费减免     之后添加变量 
            UILabel*minusFright=[cell viewWithTag:13];
            minusFright.text=[NSString stringWithFormat:@"商城商品在商品订单，代购商品请在代购订单中查看。代购完成后（可能补差价），在云仓库中可重新分配订单，提交国际物流。"];
            minusFright.textColor=RGBCOLOR(195, 0, 22, 1);
            minusFright.font=[UIFont systemFontOfSize:12];
            
            
            return cell;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        TMAddressViewController*vc=[[TMAddressViewController alloc]init];
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section==1){
        
    
    }
    
}

-(void)DelegateForSendValueToAddress:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    [_titleLabel removeFromSuperview];
    
    ConfirmFirstTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    UIImageView*imageView1=[cell viewWithTag:31];
    imageView1.image=[UIImage imageNamed:@"shop_man"];
    
    UIImageView*imageView2=[cell viewWithTag:32];
    imageView2.image=[UIImage imageNamed:@"shop_locate"];
    
    
    //返回的地址
    //收货人
    UILabel*name=[cell viewWithTag:1];
    name.text=[NSString stringWithFormat:@"收货人:%@",dict[@"name"]];
    
    
    //电话号码
    UILabel*phone=[cell viewWithTag:2];
    phone.text=dict[@"mobile"];
    
    //收货地址
    UILabel*address=[cell viewWithTag:3];
    address.text=[NSString stringWithFormat:@"收货地址:%@%@%@%@",dict[@"country_name"],dict[@"province_name"],dict[@"city_name"],dict[@"address"]];

    
    
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 85;
    }
    else if (indexPath.section>0&&indexPath.section<self.allDatas.count+1) {
        return 140;
    }else{
        return 120;
    }



    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.allDatas.count+1) {
        return ACTUAL_HEIGHT(50);
    }

    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      return 10;
}
@end
