//
//  NewChooseView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewChooseView.h"
#import "NewChooseTableViewCell.h"
#import "ChooseFooterView.h"
#import "UIImage+imageColor.h"
#import "UITableView+FDTemplateLayoutCell.h"


static  NSString* const header=@"ChooseHeaderView";    //header
static  NSString* const chooseCell  =@"NewChooseTableViewCell";
static  NSString* const footer =@"ChooseFooterView";

@interface NewChooseView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;




@property(nonatomic,strong)NSMutableArray*allOptions;    //所有的数据





@property(nonatomic,strong)UIView*photoAndMoneyView;   //图片和价格图 视图



#pragma mark  ---- 组织好的所有数据
@property(nonatomic,strong)NSMutableArray*orignDatas;  //组织好了的 所有数据
@property(nonatomic,strong)NSMutableDictionary*saveAllChooseString;   //保存所有选中的str
@property(nonatomic,strong)NSArray*originalDicts;   //得到原始的字典多个
@property(nonatomic,strong)NSMutableArray*allChooseDatas;  //所有保存的数据
@property(nonatomic,strong)NSDictionary*selectedGoods;  //选中的哪一件商品

@end

@implementation NewChooseView



-(NSMutableDictionary *)saveAllChooseString{
    if (!_saveAllChooseString) {
        _saveAllChooseString=[NSMutableDictionary dictionary];
    }
    return _saveAllChooseString;
}


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
        
        [self.tableView registerNib:[UINib nibWithNibName:header bundle:nil] forHeaderFooterViewReuseIdentifier:header];
        [self.tableView registerClass:[NewChooseTableViewCell class] forCellReuseIdentifier:chooseCell];
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

-(void)layoutSubviews{
    self.tableView.frame=CGRectMake(0, 80, self.width, self.height-80);
    self.photoAndMoneyView.frame=CGRectMake(0, 0, KScreenWidth, 80);
    
}


#pragma mark  --data
//有数据之后
-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
     _allOptions=[NSMutableArray array];
    
    if ([_allDatas isKindOfClass:[NSNull class]]) {
        return;
    }
    
    _allDatas=allDatas;
    for (int i=0; i<_allDatas.count; i++) {
        //4个数组  关于颜色的
        [self.allOptions addObject:_allDatas[i][@"attr_options"]];
        
        
        
    }
    
    NSLog(@"%@",self.allOptions);
    self.originalDicts=[self.allOptions copy];
    
    
    NSMutableDictionary*mtDict=[NSMutableDictionary dictionary];

    [self.allOptions enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (!mtDict[key]) {
                mtDict [key]=[NSMutableArray array];
                [mtDict[key] addObject:obj];
            }else{
                NSMutableArray*tempArray=[mtDict[key] mutableCopy];
                if (![tempArray containsObject:obj]) {
                    [tempArray addObject:obj];
                    mtDict[key]=tempArray;

                }
                
                
                
                
                
                
            }
            
            
        }];
    }];
    
    NSLog(@"%@",mtDict);
//    self.saveAllDict=[mtDict mutableCopy];
    
//    self.orignDatas=[mtDict mutableCopy];
//    [self.tableView reloadData];
    
    NSMutableArray*mtArray=[NSMutableArray array];
    [mtDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary*dict=[NSMutableDictionary dictionary];
        dict[key]=obj;
        [mtArray addObject:dict];
        
    }];
 
    self.orignDatas=[mtArray mutableCopy];
    [self.tableView reloadData];
    
    
    
    

    
  
}

////最新的匹配
//-(void)match{
//    //比对结果
//    self.biduiJIeguo=[NSMutableArray array];
//    
//    //选择好之后 组织好的数据
//    self.chooseorignDatas=[NSMutableArray array];
//    
//    
//    
//    //    NSMutableArray * aaaaa = [NSMutableArray array];
//    
//    [self.saveAllChooseString enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull keyq, id  _Nonnull objq, BOOL * _Nonnull stop) {
//        NSDictionary*dict=[[NSDictionary alloc]initWithObjectsAndKeys:objq,keyq, nil];
//        //      {
//        //          "\U7c7b\U578b" = "\U679c\U6c41\U7cd6";
//        //      }
//        
//        //每次只会 得到一个选中的字典
//        NSLog(@"%@",dict);
//        //这个cellAllDatas 是选中那一行的 所有数据
//        NSMutableArray*cellAlldatas=[self.saveAllDict[keyq] mutableCopy];
//        
//        
//        
//        //      NSMutableArray*array=[NSMutableArray array];  //数组里是所有的
//        NSMutableDictionary*dictt=[NSMutableDictionary dictionary];  //存字典
//        
//        [self.allOptions enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull bigDict, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            
//            
//            [bigDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull keyy, id  _Nonnull objj, BOOL * _Nonnull stop) {
//                NSDictionary*newDict=[[NSDictionary alloc]initWithObjectsAndKeys:objj,keyy, nil];  //4块中一条
//                
//                if ([dict isEqual:newDict]) {
//                    NSMutableDictionary*mtDict=[bigDict mutableCopy];
//                    [mtDict removeObjectForKey:keyq];
//                    
//                    NSLog(@"%@",mtDict);
//                    
//                    
//                    NSString*str=mtDict.allKeys[0];
//                    if (!dictt[str]) {
//                        dictt[str]=[NSMutableArray array];
//                        [dictt[str] addObject:mtDict[str]];
//                        
//                    }else{
//                        NSMutableArray*arrarr=[dictt[str] mutableCopy];
//                        if (![arrarr containsObject:mtDict[str]]) {
//                            [arrarr addObject:mtDict[str]];
//                            dictt[str]=arrarr;
//                            
//                        }
//                        
//                        
//                    }
//                    
//                    
//                    
//                    //匹配newDict
//                }
//                
//                
//            }];
//            
//            
//            
//        }];
//        
//        //      NSLog(@"%@",dictt);
//        [dictt setObject:cellAlldatas forKey:keyq];
//        [self.chooseorignDatas addObject:dictt];
//        
//        
//        
//        
//    }];
//    
//    
//    NSLog(@"%@",self.chooseorignDatas);
//    //    self.biduiJIeguo;
//#pragma mark  ---   这个值 需要比对 取都有的值
//    if (self.chooseorignDatas.count>0) {
//        NSMutableDictionary*mtDict=[[NSMutableDictionary alloc]initWithDictionary:self.chooseorignDatas[0]];
//        for (int i=0; i<self.chooseorignDatas.count; i++) {
//            //        NSMutableDictionary*xxDict=[NSMutableDictionary dictionary];
//            NSArray*allKeys=[mtDict allKeys];
//            NSDictionary*dict=self.chooseorignDatas[i];
//            
//            [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull keys, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                NSMutableArray*array=[NSMutableArray array];
//                [mtDict[keys] enumerateObjectsUsingBlock:^(id  _Nonnull objO, NSUInteger idx, BOOL * _Nonnull stop) {
//                    
//                    [dict[keys] enumerateObjectsUsingBlock:^(id  _Nonnull objN, NSUInteger idx, BOOL * _Nonnull stop) {
//                        if ([objO isEqualToString:objN]) {
//                            [array addObject:objO];
//                        }
//                        
//                    }];
//                    
//                }];
//                
//                [mtDict setObject:array forKey:keys];
//                
//                
//                
//            }];
//            
//            [self.biduiJIeguo addObject:mtDict];
//        }
//        
//        NSLog(@"%@",self.biduiJIeguo);
//        
//    }else{
//        self.biduiJIeguo =[self.orignDatas mutableCopy];
//        
//    }
//    
//    
//    
//    
//    
//}
//



-(CGFloat)calculatarHeight{
    CGFloat aa=80+110;
    
    
    for (int i=0; i<self.orignDatas.count; i++) {
//        UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        CGFloat cellHeight=cell.height;
//        aa=aa+cellHeight;
        
        
        
        NSInteger cellHeight=[self.tableView fd_heightForCellWithIdentifier:chooseCell configuration:^(id cell) {
            NewChooseTableViewCell*bbb=   (NewChooseTableViewCell*) cell;
            bbb.dict=self.orignDatas[i];
        }];

         aa=aa+cellHeight;
        
    }
    
    return aa;
}


//得到原始的 字典   多个字典
-(void)getOrignalDicts{
    NSMutableArray*equlOrignDatas=[self.originalDicts mutableCopy];
    
    
    [self.saveAllChooseString enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSMutableArray*temp=[NSMutableArray array];
        [equlOrignDatas enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dicts, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [dicts enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull keyy, NSString*  _Nonnull objj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:keyy]) {
                    if (![obj isEqualToString:objj]) {
                        [temp addObject:[NSString stringWithFormat:@"%zi",idx]];
                    }
                }
                
            }];
            
            
            
        }];
        //要删除的 下标存起来
        //走完之后   移除了要删掉的  在进行遍历
        
        if (temp.count>0) {
            for (int i = 0; i<temp.count; i++) {
                NSString*str=temp[temp.count-1-i];
                NSInteger tt= [str integerValue];
                [equlOrignDatas removeObjectAtIndex:tt];
                
            }
        }
        
    }];
    
    
    NSLog(@"%@",equlOrignDatas);
    
    //把多个 字典组成一个字典
    
    NSMutableDictionary*mtDict=[NSMutableDictionary dictionary];
    [equlOrignDatas enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (!mtDict[key]) {
                NSMutableArray*array=[NSMutableArray array];
                [array addObject:obj];
                [mtDict setObject:array forKey:key];
                
            }else{
                NSMutableArray*array=mtDict[key];
                if (![array containsObject:obj]) {
                    [array addObject:obj];
                    mtDict[key]=array;
                }
                
            }
            
            
            
        }];
        
        
    }];
    
    NSLog(@"%@",mtDict);
    
    
    //一个大字典   需要编程数组
    
    
    NSMutableArray*choosemtArray=[NSMutableArray array];
    [mtDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary*dict=[NSMutableDictionary dictionary];
        dict[key]=obj;
        
        [choosemtArray addObject:dict];
        
        
        
    }];
    
    
    self.allChooseDatas=choosemtArray;
    NSLog(@"%@",self.allChooseDatas);
    
    [self.tableView reloadData];
    
    
}


#pragma 加入购物车
-(void)addToShoppingCar:(NSString*)number{
    
    NSLog(@"%@",_selectedGoods);
    NSLog(@"%@",_bigMModel);

//     www.vipxox.cn/?m=app&s=baihuo&act=add_cart   &sid=3&pid=1   &num=3    uid
//sid:3(规格产品id,如果有，没有不传)
//pid:1(产品id,必须传)
    
    NSMutableDictionary*otherDict=[NSMutableDictionary dictionary];
    if (!_selectedGoods) {
        
        [otherDict setValue:_bigMModel.detailID forKey:@"pid"];
    }else{
//        "pid" = 89,
//         "id" = 385,
        
        [otherDict setValue:_selectedGoods[@"pid"] forKey:@"pid"];
        [otherDict setValue:_selectedGoods[@"id"] forKey:@"sid"];
        
    }
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*dict=@{@"m":@"app",@"s":@"baihuo",@"act":@"add_cart",@"uid":[UserSession instance].uid,@"num":number};
    
    NSMutableDictionary*params=[[NSMutableDictionary alloc]initWithDictionary:dict];
  [otherDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      [params setObject:obj forKey:key];
      
  }];
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"购物车" message:@"加入购物车成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            
            
        }else{
            
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
}


#pragma mark  --UI

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orignDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
    cell.selectionStyle=NO;
    if (self.orignDatas.count<1) {
        return cell;
    }
    
    //第一次赋值   每个cell 上都有dict
    cell.dict=self.orignDatas[indexPath.row];
    
    
    //第二次的赋值
    if (!_allChooseDatas) {
        _allChooseDatas=[self.orignDatas mutableCopy];
    }
    
    cell.canChoose=_allChooseDatas[indexPath.row];
    
    
    
#pragma mark -- 点击
    __weak typeof (self)weakSelf=self;

    cell.chooseBlock=^(NSString*str,NSString*key){
        NSLog(@"%@",str);
        //选中了  一个str
        //如果是@""  代表 这个key 里面的值 都可以
        //否则  就是  有这个key 的值
        if ([str isEqualToString:@""]&&weakSelf.saveAllChooseString[key]) {
            [weakSelf.saveAllChooseString removeObjectForKey:key];
              [self getOrignalDicts];
            
        }else{
              [weakSelf.saveAllChooseString setObject:str forKey:key];
            
            [self getOrignalDicts];
            
        }
        
#warning ---  所有选项都选了   匹配哪一个  然后刷新 图片和 价格
        //如果所有的选项都选了
        
        __block NSDictionary*dictt=[NSDictionary dictionary];
        
        if (self.saveAllChooseString.count==self.orignDatas.count) {
            
            
            [_allDatas enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary*attr=dict[@"attr_options"];
                
                __block NSInteger count=0;
                [attr enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull keyy, id  _Nonnull objj, BOOL * _Nonnull stop) {
                    
                    [self.saveAllChooseString enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        //3个key
                        if ([keyy isEqualToString:key]) {
                            if ([obj isEqualToString:objj]) {
                                count++;
                            }
                            
                        }
                        
                    }];
                }];
            
               
                if (count>=self.saveAllChooseString.count) {
                    
                    dictt=dict;
                }
                
                
                
                
            }];
            
            
            self.selectedGoods=dictt;
            NSLog(@"%@",dictt);
            
            
            
            
           UIImageView*imageView= [weakSelf.photoAndMoneyView viewWithTag:1];
           [imageView sd_setImageWithURL:[NSURL URLWithString:dictt[@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
               
           }];

            UILabel*moneyLabel=[weakSelf.photoAndMoneyView viewWithTag:2];
            moneyLabel.text=[NSString stringWithFormat:@"%@%@",[UserSession instance].currency,dictt[@"price"]];
            
        }else{

            

        }
        
        
        
        
        
//        //第二次覆盖
//        if (self.paixuOK==nil) {
//            self.paixuOK=[self.orignDatas mutableCopy];
//        }
//        cell.canChoose=self.paixuOK[indexPath.row];
//
//         [self match];
//        //先要排序
//        NSMutableArray*mtArray=[NSMutableArray array];  //key
//        NSMutableArray*realArray=[NSMutableArray array];  //真正的值
//        
//        for (int i=0; i<self.orignDatas.count; i++) {
//            NSDictionary*dict=self.orignDatas[i];
//           NSString*keys= [dict allKeys][0];
//            [mtArray addObject:keys];
//        }
//        
//        NSMutableArray*realArr=[NSMutableArray array];
//        for (NSString * key in mtArray) {
//            NSMutableDictionary*mtDict=[[NSMutableDictionary alloc]initWithDictionary:@{key:@[]}];
//            [realArr addObject:mtDict];
//        }
//        
//        
////        weakSelf.biduiJIeguo
//        [weakSelf.biduiJIeguo enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
//            [mtArray enumerateObjectsUsingBlock:^(NSString * keyStr, NSUInteger idxt, BOOL * _Nonnull stop) {
//                NSMutableDictionary * realDic = realArr[idxt];
//                NSMutableArray * arr = realDic[keyStr];
////                [arr addObjectsFromArray:dict[keyStr]];
//                if (dict[keyStr]) {
//                    arr=[dict[keyStr] mutableCopy];
//                    [realDic setObject:arr forKey:keyStr];
//                
//                
//                
//                }
////                [realArr replaceObjectAtIndex:idxt withObject:realDic];
//                
//            }];
//            
//            
//        }];
//        
//        NSLog(@"%@",realArr);
//        self.paixuOK=[realArr mutableCopy];
//
//      
//        [self.tableView reloadData];
//        
//        
    };
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //    return 80;
    return 0.01;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ChooseFooterView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:footer];
    view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    
    [view.sureButton setTitle:@"确定加入购物车" forState:UIControlStateNormal];
//    view.numberStr;
    
    
    
    __weak typeof (view)WeakView=view;
    view.touchSureBlock=^{
        if (self.saveAllChooseString.count==self.orignDatas.count) {
            NSLog(@"%@",WeakView.numberStr);
            NSLog(@"%@",_selectedGoods);
            NSLog(@"%@",_bigMModel);
            
            [self addToShoppingCar:WeakView.numberStr];
            
            //
            if ([self.delegate respondsToSelector:@selector(ShowViewDismiss)]) {
                [self.delegate ShowViewDismiss];
            }
            
            
            
        }else{
            [JRToast showWithText:@"请完善选项"];
            
        }
        
        
        
    };
    
    
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 44;
    NSInteger aa=[tableView fd_heightForCellWithIdentifier:chooseCell configuration:^(id cell) {
        NewChooseTableViewCell*bbb=   (NewChooseTableViewCell*) cell;
        bbb.dict=self.orignDatas[indexPath.row];
    }];
    NSLog(@"%@ ---%lu",indexPath,aa);
    
    return aa;
}











#pragma mark  --touch
-(void)touchCancel{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}


#pragma mark  --set


@end
