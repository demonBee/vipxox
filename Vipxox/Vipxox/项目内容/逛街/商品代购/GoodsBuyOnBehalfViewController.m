//
//  GoodsBuyOnBehalfViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "GoodsBuyOnBehalfViewController.h"
#import "SDCycleScrollView.h"
#import "ChooseColorAndSizeViewController.h"
#import "EnterAPPViewController.h"


@interface GoodsBuyOnBehalfViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *BGview;
@property(nonatomic,strong)NSMutableArray*allDatas;   //这个是 用到的array

@property(nonatomic,strong)NSMutableArray*arrayImages;  //放“data”里 “pic”key的图片数组

//@property(nonatomic,strong)UIView*view;

@end

@implementation GoodsBuyOnBehalfViewController

-(UIView *)BGview{
    if (!_BGview) {
        _BGview=[[UIView alloc]initWithFrame:CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight)];
        _BGview.alpha=0.4;
        _BGview.backgroundColor=[UIColor blackColor];

    }
    return _BGview;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(58), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(124)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeNavi];
    [self makeView];
    self.allDatas=[[NSMutableArray alloc]init];
    self.arrayImages=[[NSMutableArray alloc]init];
    
    self.tableView.alwaysBounceVertical=YES;
    NSLog(@"%@",self.url);
    [self.view addSubview:self.tableView];

    
    //接口
    
//    http://www.vipxox.cn/?m=appapi&s=home_page&act=getprodata&uid=d7361d4faf46e7b5f143f77ea5cb4e6b&itemurl=http://product.m.dangdang.com/1319933344.html?sid=aad0f4d53c2da343c25ef2e41ad6bb54
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"getprodata",@"uid":[UserSession instance].uid,@"itemurl":self.url};
    
    NSLog(@"%@",self.url);
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            [self.allDatas addObject:data[@"data"][@"prodata"]];
//            NSLog(@"%@",self.allDatas);
           
//            NSLog(@"%@",data[@"data"][@"prodata"][@"pic"]);
            NSLog(@"%@",self.url);
            
            [self.arrayImages addObjectsFromArray:data[@"data"][@"prodata"][@"pic"]];
            
            
            // 刷新表格
            [self.tableView reloadData];

            
        }else{
            [JRToast showWithText:[data objectForKey:@"errorMessage"]];
        }
    }];
}

-(void)makeNavi{
    self.title=@"商品代购";
    
    
}

-(void)makeView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(60), KScreenWidth,KScreenHeight-ACTUAL_HEIGHT(60))];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    //”加入购物车“按钮
    UIButton *addShoppingCartButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(125),ACTUAL_HEIGHT(551), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(44))];
    [addShoppingCartButton setTitle:@"加入购物车" forState:0];
    [addShoppingCartButton setTitleColor:[UIColor whiteColor] forState:0];
    addShoppingCartButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    addShoppingCartButton.titleLabel.font=[UIFont systemFontOfSize:16];
    addShoppingCartButton.layer.cornerRadius=5;
    [addShoppingCartButton addTarget:self action:@selector(gotoShoppingCar) forControlEvents:UIControlEventTouchDown];
    [view addSubview:addShoppingCartButton];
    
    [view addSubview:self.tableView];
}

//tableView三问

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4+1;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayImages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==4) {
            return ACTUAL_HEIGHT(20);
        }else{
            return ACTUAL_HEIGHT(46);
        }
        
    }else{
        return ACTUAL_HEIGHT(18);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return ACTUAL_HEIGHT(369);
    }else{
        return ACTUAL_HEIGHT(208);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  static NSString *CellID = @"mycell";
    
    //创建Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
        
    }
    
    if (indexPath.section==0 && indexPath.row==0) {
        cell.textLabel.text=self.allDatas[indexPath.section][@"title"];
        cell.userInteractionEnabled = NO;
        
    }else if (indexPath.section==0 && indexPath.row==1) {
        float floatString = [self.allDatas[indexPath.section][@"price"] floatValue];
//        NSString*floatString=self.allDatas[indexPath.section][@"price"];
//        cell.textLabel.text
        NSString*str=[NSString stringWithFormat:@"价格:%@ %.2f",[UserSession instance].currency,floatString];

      
        cell.textLabel.text=str;
        cell.textLabel.textColor=NewRed;
    
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"销量:%@",self.allDatas[indexPath.section][@"sale_num"]];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.userInteractionEnabled = NO;
        
    }else if (indexPath.section==0 && indexPath.row==2) {
        cell.textLabel.text=@"选择颜色";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
    }else if (indexPath.section==0&&indexPath.row==3){
//        cell.textLabel.text=@"所有代购商品 Vipxox将收取10%的手续费 谢谢！";
        cell.textLabel.text=self.allDatas[0][@"notice"];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.selectionStyle=NO;

        
    }else if (indexPath.section==0&&indexPath.row==4){
        cell.backgroundColor=RGBCOLOR(239, 240, 241, 1);
        cell.userInteractionEnabled = NO;
    }else{
//        cell.backgroundColor=[UIColor yellowColor];
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"";
    }

    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        //整个背景View
        UIView *headLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(369))];
        headLineView.backgroundColor=[UIColor whiteColor];
        
        // 创建不带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(369)) imagesGroup:self.arrayImages andPlaceholder:@"placeholder_375x369"];
        cycleScrollView.backgroundColor=[UIColor yellowColor];
        cycleScrollView.delegate = self;
        cycleScrollView.autoScrollTimeInterval=5;
        [headLineView addSubview:cycleScrollView];
        
        return headLineView;
        
    }else if(section==1){
        UIView *BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(238))];
        BGView.backgroundColor=[UIColor whiteColor];
        
        UILabel *label01=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(13), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(18))];
        label01.text=@"商品详情";
        label01.font=[UIFont systemFontOfSize:14];
        [BGView addSubview:label01];
        
        UILabel *label02=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(73), ACTUAL_HEIGHT(17), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(12))];
        label02.text=@"PRODUCT INFO";
        label02.font=[UIFont systemFontOfSize:8];
        label02.textColor=RGBCOLOR(216, 217, 218, 1);
        [BGView addSubview:label02];
        
        UIImageView *imageView01=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(14), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(351), ACTUAL_HEIGHT(178))];
        imageView01.backgroundColor=[UIColor whiteColor];
        imageView01.contentMode=UIViewContentModeScaleAspectFit;

        [imageView01 sd_setImageWithURL:[NSURL URLWithString:self.arrayImages[0]] placeholderImage:[UIImage imageNamed:@"placeholder_351x178"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                imageView01.alpha=0.3;
                CGFloat scale = 0.3;
                imageView01.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    imageView01.alpha=1;
                    CGFloat scale = 1.0;
                    imageView01.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
        [BGView addSubview:imageView01];
        
        return BGView;
    }else if(self.arrayImages.count>1){
        for (int i=1; i<self.arrayImages.count; i++) {
            if (section==i+1) {
                UIView *BGView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(238))];
                BGView1.backgroundColor=[UIColor whiteColor];
                
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(14), ACTUAL_HEIGHT(0), ACTUAL_WIDTH(351), ACTUAL_HEIGHT(208))];
                imageView.backgroundColor=[UIColor whiteColor];
                imageView.contentMode=UIViewContentModeScaleAspectFit;

                [imageView sd_setImageWithURL:[NSURL URLWithString:self.arrayImages[i]] placeholderImage:[UIImage imageNamed:@"placeholder_351x208"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                [BGView1 addSubview:imageView];
                return BGView1;
            }
        }
    }else{
        return nil;
    }
    return nil;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==2) {
        
        
        [self gotoShoppingCar];
    }
}

#pragma mark “加入购物车”二级界面跳转及传值
-(void)gotoShoppingCar{
    if ([UserSession instance].isLogin==NO) {
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
    
    ChooseColorAndSizeViewController *vc=[[ChooseColorAndSizeViewController alloc]init];
    if (self.allDatas!=nil&&self.allDatas[0]!=nil) {
    vc.typeStr=self.allDatas[0][@"seller_info"][@"seller_type"];
    vc.urlStr=self.allDatas[0][@"url"];
    vc.imageStr=self.arrayImages[0];
        NSLog(@"%@",self.arrayImages[0]);
    vc.titleStr=self.allDatas[0][@"title"];
    vc.priceStr=self.allDatas[0][@"price"];
    vc.yuanStr=self.allDatas[0][@"yuan_price"];
    vc.valueColorArray=self.allDatas[0][@"sku_property"][0][@"values"][@"sku_property_value"];
    vc.valueSizeArray=self.allDatas[0][@"sku_property"][1][@"values"][@"sku_property_value"];
    vc.colorStr=self.allDatas[0][@"sku_property"][0][@"prop_id"];
    vc.sizeStr=self.allDatas[0][@"sku_property"][1][@"prop_id"];
    vc.idDic=self.allDatas[0][@"pv_map_sku"];
    vc.priceDic=self.allDatas[0][@"sku_price_item"];
    vc.yuanDic=self.allDatas[0][@"yuan_price_item"];
    vc.sidStr=self.allDatas[0][@"sid"];
    vc.sku_id=self.allDatas[0][@"sku_id"];
    [self presentViewController:vc animated:YES completion:nil];
    
      }else{
        
      }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

//-(void)viewWillAppear:(BOOL)animated{
//    // 监听键盘的即将显示事件. UIKeyboardWillShowNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    // 监听键盘即将消失的事件. UIKeyboardWillHideNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
//    
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    
//    
//}
//
//
//- (void) keyboardWillShow:(NSNotification *)notify {
//    UIView *sv=self.tableView;
//    //这里只写了关键代码，细节根据自己的情况来定，sv为弹出键盘的视图，UITextField
//    CGFloat kbHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;//获取键盘高度，在不同设备上，以及中英文下是不同的，很多网友的解决方案都把它定死了。
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGFloat screenHeight = self.view.bounds.size.height;
//    CGFloat viewBottom = sv.frame.origin.y + sv.frame.size.height;
//    if (viewBottom + kbHeight < screenHeight) return;//若键盘没有遮挡住视图则不进行整个视图上移
//    
//    // 键盘会盖住输入框, 要移动整个view了
//    CGFloat dalta = viewBottom + kbHeight - screenHeight-30;
//    
//    // masonry的地方了 mas_updateConstraints 更新superView的约束，这里利用第三方库进行了重新自动布局，如果你不是自动布局，这里换成你的视图上移动画即可
//    UIView *superView = self.tableView;
//    [superView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(-dalta);
//    }];
//    [UIView animateWithDuration:duration animations:^void(void){
//        // superView来重新布局
//        [superView layoutIfNeeded];
//    }];
//}
//
////关闭键盘
//- (void) keyboardWillHidden:(NSNotification *)notify {//键盘消失
//    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    UITableView *superView=self.tableView;
//    [superView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//    }];
//    [UIView animateWithDuration:duration animations:^{
//        [superView layoutIfNeeded];
//    }];
//    //    CGFloat delta = 0.0f;
//}

@end
