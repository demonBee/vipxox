//
//  SurePayVIew.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/12.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SurePayVIew.h"
#import "SurePayBottomTableViewCell.h"



#define PayCell    @"SurePayBottomTableViewCell"

@interface SurePayVIew()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@end

@implementation SurePayVIew


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //head
        UILabel*headLeft=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, kScreen_Width/2, 20)];
        headLeft.text=@"结算";
        [self addSubview:headLeft];
        
        UIButton*cancel=[[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-32, 0, 15, 15)];
        cancel.centerY=headLeft.centerY;
        [cancel setBackgroundImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 45, kScreen_Width, 1)];
        lineView.backgroundColor=RGBCOLOR(245, 245, 245, 1);
        [self addSubview:lineView];
        
        //bottom
        UIButton*sureButton=[[UIButton alloc]initWithFrame:CGRectMake(15, self.height-57, KScreenWidth-30, 44)];
        [sureButton setBackgroundColor:RGBCOLOR(252, 76, 30, 1)];
        [sureButton setTitle:@"确定支付" forState:UIControlStateNormal];
        sureButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        sureButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [sureButton addTarget:self action:@selector(surePay) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureButton];
        
        
        //tableView
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:PayCell bundle:nil] forCellReuseIdentifier:PayCell];
        
        
    }
    
    
    return self;
    
}


#pragma mark  --UI
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:PayCell];
    cell.selectionStyle=NO;
    UILabel*leftLabel=[cell viewWithTag:1];
    UILabel*rightLabel=[cell viewWithTag:2];
    UILabel*nextLabel=[cell viewWithTag:99];
    if (!nextLabel) {
        nextLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftLabel.left, leftLabel.bottom+5, KScreenWidth-60, 20)];
        nextLabel.tag=99;
        nextLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:nextLabel];
        
    }

    if (indexPath.row==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        if (![_allDatas[@"address"] isKindOfClass:[NSNull class]]) {
            //如果 有值
            leftLabel.text=[NSString stringWithFormat:@"%@ %@",_allDatas[@"address"][@"name"],_allDatas[@"address"][@"mobile"]];
                     nextLabel.text=[NSString stringWithFormat:@"%@",_allDatas[@"address"][@"address"]];
            
            rightLabel.text=@"";

            
        }else{
            //没值
            leftLabel.text=@"点击添加地址";
            rightLabel.text=@"";
            nextLabel.text=@"";

            
        }
        
    }else{
        leftLabel.text=@"应付总额";
        rightLabel.text=[NSString stringWithFormat:@"%@%@",[UserSession instance].currency,_allDatas[@"price"]];

        
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
        if (self.changeAddressBlock) {
            self.changeAddressBlock();
        }
        
        
        
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
    
        if (![_allDatas[@"address"] isKindOfClass:[NSNull class]]) {
                 
                   return 47+25;
        }
        
        
        
        
    }
    
    return 47;
}




#pragma mark  --touch
-(void)touchCancel{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}


-(void)surePay{
    if ([_allDatas[@"address"] isKindOfClass:[NSNull class]]) {
        [JRToast showWithText:@"请填写地址"];
        return;
        
    }
    
    
    if (self.sureBlock) {
        self.sureBlock(_allDatas[@"price"],_allDatas[@"id"]);
    }
    
    
}


#pragma mark --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.x, 46, self.width, self.height-46-57) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
    
}


-(void)setAllDatas:(NSDictionary *)allDatas{
    _allDatas=allDatas;
    //address    id   price
    [self.tableView reloadData];
    
    
    
}

@end
