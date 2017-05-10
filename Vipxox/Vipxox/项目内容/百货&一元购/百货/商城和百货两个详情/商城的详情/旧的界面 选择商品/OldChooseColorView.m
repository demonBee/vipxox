//
//  OldChooseColorView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OldChooseColorView.h"
#import "OldChooseTableViewCell.h"
#import "ChooseFooterView.h"

#define OLDCHOOSE   @"OldChooseTableViewCell"
static  NSString* const footer =@"ChooseFooterView";

@interface OldChooseColorView()<UITableViewDelegate,UITableViewDataSource>
//@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView*photoAndMoneyView;   //图片和价格图

@property(nonatomic,strong)NSMutableDictionary*mtDict;  //存储选中的东西
@end

@implementation OldChooseColorView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 80, frame.size.width, frame.size.height-80) style:UITableViewStyleGrouped];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.backgroundColor=[UIColor whiteColor];
        self.tableView.scrollEnabled=NO;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
  
        [self addSubview:self.tableView];
        
      
        [self.tableView registerClass:[OldChooseTableViewCell class] forCellReuseIdentifier:OLDCHOOSE];
        [self.tableView registerNib:[UINib nibWithNibName:footer bundle:nil] forHeaderFooterViewReuseIdentifier:footer];
        
        
        //得到view
       
        UIView*headerView=[[NSBundle mainBundle]loadNibNamed:@"ChooseHeaderView" owner:nil options:nil].firstObject ;
        headerView.frame=CGRectMake(0, 0, KScreenWidth, 80);
        [self addSubview:headerView];
        self.photoAndMoneyView=headerView;
        
        UIButton*cancel=[headerView viewWithTag:3];
        [cancel addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OldChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:OLDCHOOSE forIndexPath:indexPath];
    cell.selectionStyle=NO;
    if (self.allDatas.count<1) {
        return nil;
    }
    
//     NSArray*array=@[@"尺码,aa,bbb,dcc,sfsfs,sfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs"];
//    cell.allDatas=[array mutableCopy];
    
    cell.allDatas=[self.allDatas[indexPath.row] mutableCopy];
    
    cell.chooseBlock=^(NSString*value,NSString*key){
        NSLog(@"%@--%@",key,value);
        if ([value isEqualToString:@""]) {
            [self.mtDict removeObjectForKey:key];
        }else{
            [self.mtDict setObject:value forKey:key];

        }
        
        
    };
    
  
    
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ChooseFooterView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:footer];
    view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    __weak typeof (view)WeakView=view;
    
    if (self.buyImmedatelyOrAddToCar==immedateBuy) {
        [view.sureButton setTitle:@"确定购买" forState:UIControlStateNormal];
        view.touchSureBlock=^{
            self.buyImmedatelyOrAddToCar=immedateBuy;
//            self.mtDict;
//            NSInteger number=self.allDatas.count;
            //物品数量           view.numberStr;
            
            if ([self.delegate respondsToSelector:@selector(DelegateBuy:andChooseDict:andHowMuchChoose:andgoodsHowMuch:)]) {
                
                [self.delegate DelegateBuy:self.buyImmedatelyOrAddToCar andChooseDict:self.mtDict andHowMuchChoose:self.allDatas.count andgoodsHowMuch:WeakView.numberStr];
            };
           
            
        };
        
        
    }else{
        [view.sureButton setTitle:@"确定加入购物车" forState:UIControlStateNormal];
        view.touchSureBlock=^{
             self.buyImmedatelyOrAddToCar=addToshoppingCar;
            //            self.mtDict;
//            NSInteger number=self.allDatas.count;
            //物品数量           view.numberStr;
            
            if ([self.delegate respondsToSelector:@selector(DelegateBuy:andChooseDict:andHowMuchChoose:andgoodsHowMuch:)]) {
                
                [self.delegate DelegateBuy:self.buyImmedatelyOrAddToCar andChooseDict:self.mtDict andHowMuchChoose:self.allDatas.count andgoodsHowMuch:WeakView.numberStr];
            };

            
        };

        
    }
    
    
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger aa=[tableView fd_heightForCellWithIdentifier:OLDCHOOSE configuration:^(id cell) {
//        OldChooseTableViewCell*bbb=   (OldChooseTableViewCell*) cell;
//        NSArray*aa=@[@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",];
//       NSMutableArray* mtArray=[aa mutableCopy];
//
//         bbb.allDatas=[mtArray mutableCopy];
//    }];
//    NSLog(@"%@ ---%lu",indexPath,aa);
//    
//    return aa;
//    return [tableView fd_heightForCellWithIdentifier:OLDCHOOSE cacheByIndexPath:indexPath configuration:^(OldChooseTableViewCell *cell) {
////        [self configureCell:cell atIndexPath:indexPath];
////      cell.allDatas=[self.allDatas[indexPath.row] mutableCopy];
//         cell.fd_enforceFrameLayout = NO;
//    OldChooseTableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
//
   
//        NSArray*array=@[@"尺码,aa,bbb,dcc,sfsfs,sfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs,sfsfsf,sfsfsfs,sfsfsfsf,sfsfsfs,sfsfsdf,sfsfsf,sfsfs,sfsfsfsf,sfs,sfsf,sfsfsffssf,sfsfsfs"];
//      
//    
//    return [self calculatarHeight:[array mutableCopy]];

    return [self calculatarHeight:[self.allDatas[indexPath.row] mutableCopy]];
 
  
    
    
}





-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
     [self.tableView reloadData];
    
}

-(void)setAllDict:(NSDictionary *)allDict{
    _allDict=allDict;
   UIImageView*imageView= [self.photoAndMoneyView viewWithTag:1];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:allDict[@"pic"][0]] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UILabel*titleLabel=[self.photoAndMoneyView viewWithTag:2];
    CGFloat jiage=[allDict[@"price"] floatValue];
    titleLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,jiage];
    
    
    [self.tableView reloadData];
}

-(void)setBuyImmedatelyOrAddToCar:(BUYORADD)buyImmedatelyOrAddToCar{
    _buyImmedatelyOrAddToCar=buyImmedatelyOrAddToCar;
//    [self.tableView reloadData];
    
}

-(NSMutableDictionary *)mtDict{
    if (!_mtDict) {
        _mtDict=[NSMutableDictionary dictionary];
    }
    return _mtDict;
}


//顶部的x 按钮
-(void)touchCancel{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}

#pragma mark ----  计算cell 的高度 传值过来
-(CGFloat)calculatarHeight:(NSMutableArray*)mttArray{
    NSMutableArray*allDatas=[NSMutableArray array];
    allDatas=[mttArray mutableCopy];
    
 
    //一个标题 另一个是元素
    NSString*longStr=allDatas[0];
    NSArray*array=[longStr componentsSeparatedByString:@","];
    NSMutableArray*mtArray=[array mutableCopy];
    NSString*title=mtArray[0];
    
    [mtArray removeObject:mtArray[0]];
    
    
    UILabel*titleLabel=[self viewWithTag:10000];
    if (!titleLabel) {
        titleLabel=[[UILabel alloc]init];
        titleLabel.tag=10000;
        titleLabel.font=[UIFont systemFontOfSize:16];
       
    }
    
    NSString*str=title;
    titleLabel.text=str;
    CGSize strSize=[str boundingRectWithSize:CGSizeMake(KScreenWidth/2, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    titleLabel.y=(44-strSize.height)/2;
    titleLabel.x=15;
    titleLabel.size=strSize;
    
    CGFloat common= titleLabel.right+10;  //默认的距离左边
    CGFloat leftPoint=titleLabel.right+10;  //左边距离
    CGFloat leaveTop=titleLabel.y-6;     //距上可加
    CGFloat leavejianju=10;    //
    CGFloat buttonAddWith =16;   //每个button string大小要加上这个
    CGFloat ButtonHeight =27;
    
   
    for (int i=0; i<mtArray.count; i++) {
        NSArray*name=mtArray;
        UIButton*button=[self viewWithTag:20000+i];
        if (!button) {
            button=[[UIButton alloc]init];
            button.tag=20000+i;
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            button.layer.borderWidth=1;
            button.layer.borderColor=RGBCOLOR(204, 204, 204, 1).CGColor;
            
            
            
            
            
            
        }
        
        [button setTitle:name[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        
        
        [button setTitle:name[i] forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(228, 228, 228, 1)] forState:UIControlStateDisabled];
        
        
        [button setTitle:name[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(252, 76, 30, 1)] forState:UIControlStateSelected];
        
        
        
        CGSize stringSize=[name[i] boundingRectWithSize:CGSizeMake(KScreenWidth/3*2, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (leftPoint+stringSize.width+buttonAddWith+leavejianju>KScreenWidth) {
            leftPoint=common;
            leaveTop=leaveTop+ButtonHeight+10;
        }
        
        button.frame=CGRectMake(leftPoint, leaveTop, stringSize.width+buttonAddWith, ButtonHeight);
        
        
        leftPoint=leftPoint+stringSize.width+buttonAddWith+leavejianju;
       
        
      
        
        
        
    }

    
    return leaveTop+ButtonHeight+10;
}




//整个
-(CGFloat)getViewHeight{
    CGFloat aa=80+110;
    
    
    for (int i=0; i<self.allDatas.count; i++) {
        UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CGFloat cellHeight=cell.height;
        aa=aa+cellHeight;
    }
  
    
  
    
    return aa;

    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame=CGRectMake(0, 80, self.size.width, self.size.height-80);
    self.photoAndMoneyView.frame=CGRectMake(0, 0, KScreenWidth, 80);
}

@end
