//
//  ChooseColorAndSizeViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/14.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChooseColorAndSizeViewController.h"
#import "AddNumberView.h"
#import "SAMTextView.h"

@interface ChooseColorAndSizeViewController ()<UITableViewDataSource,UITableViewDelegate,AddNumberViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)CGFloat number;
@property(nonatomic,strong)AddNumberView*addNum;

@property(nonatomic,strong)NSMutableArray *colorNameArray;
@property(nonatomic,strong)NSMutableArray *sizeNameArray;

@property(nonatomic,strong)UIButton *colorButton;
@property(nonatomic,strong)UIButton *sizeButton;

@property(nonatomic,strong)NSMutableArray*allColorButtons;
@property(nonatomic,strong)NSMutableArray*allSizeButtons;

@property(nonatomic,strong)NSString *selectColor;
@property(nonatomic,strong)NSString *selectSize;

@property(nonatomic,strong)SAMTextView *samtext;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *color;
@property(nonatomic,strong)NSString *size;
@property(nonatomic,strong)NSString *yuan;

@property(nonatomic,strong)UITableViewCell *cell;

@property(nonatomic,assign)BOOL canSave;

@property(nonatomic,strong)NSString*orderId;  //

@end

@implementation ChooseColorAndSizeViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(144), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(204)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _colorNameArray=[[NSMutableArray alloc]init];
    _sizeNameArray=[[NSMutableArray alloc]init];
    _allColorButtons=[[NSMutableArray alloc]init];
    _allSizeButtons=[[NSMutableArray alloc]init];
    _cell=[[UITableViewCell alloc]init];
    
    _canSave=YES;
    _samtext=[[SAMTextView alloc]init];
    _samtext.tag=111;
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self makeView];
    [self makeArrayData];
    [self.view addSubview:self.tableView];
    
}

-(void)makeView{
    //商品图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(36), ACTUAL_WIDTH(88), ACTUAL_HEIGHT(88))];
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;

    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"placeholder_88x88"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    [self.view addSubview:imageView];
    
    //商品标题
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(114), ACTUAL_HEIGHT(36), ACTUAL_WIDTH(208), ACTUAL_HEIGHT(40))];
    titleLabel.numberOfLines=2;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.text=self.titleStr;
    titleLabel.textColor=RGBCOLOR(110, 110, 110, 1);
    [self.view addSubview:titleLabel];
    
    //商品价格
    _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(114), ACTUAL_HEIGHT(75), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(35))];
    _priceLabel.textColor=NewRed;
    float floatString = [self.priceStr floatValue];
    if (floatString==0) {
        _priceLabel.text=self.priceStr;
        _priceLabel.font=[UIFont systemFontOfSize:14];
        _priceLabel.numberOfLines=2;
        _priceLabel.backgroundColor=[UIColor yellowColor];
        
    }else{
       _priceLabel.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,floatString];
       _priceLabel.font=[UIFont systemFontOfSize:16];
    }
    _priceLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_priceLabel];
    
    //提示标签
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(114), ACTUAL_HEIGHT(114), ACTUAL_WIDTH(250), ACTUAL_HEIGHT(20))];
    promptLabel.text=@"请选择：颜色、尺码分类";
    promptLabel.textAlignment=NSTextAlignmentLeft;
    promptLabel.textColor=RGBCOLOR(152, 152, 152, 1);
    [self.view addSubview:promptLabel];
    
    //返回按钮
    UIButton *backButton=[[UIButton alloc]init];
    backButton.frame=CGRectMake(ACTUAL_WIDTH(330), ACTUAL_HEIGHT(63), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(30));
    [backButton setImage:[UIImage imageNamed:@"fork1"] forState:0];
    [backButton addTarget:self action:@selector(comeBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //确认按钮
    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(100), ACTUAL_HEIGHT(615), ACTUAL_WIDTH(182), ACTUAL_HEIGHT(40))];
    sureButton.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [sureButton setTitle:@"确认" forState:0];
    [sureButton setTitleColor:[UIColor whiteColor] forState:0];
    sureButton.layer.cornerRadius=20;
    sureButton.tag=666;
    [sureButton addTarget:self action:@selector(sureToBuy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

-(void)makeArrayData{
    
    for (int i=0; i<self.valueColorArray.count; i++) {
        [_colorNameArray addObject:self.valueColorArray[i][@"name"]];
    }

    for (int j=0; j<self.valueSizeArray.count; j++) {
        [_sizeNameArray addObject:self.valueSizeArray[j][@"name"]];
    }
}

#pragma mark tableView的属性设定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return ACTUAL_HEIGHT(65)+(_sizeNameArray.count/3+1)*ACTUAL_HEIGHT(45);
    }else if (section==1){
        return ACTUAL_HEIGHT(65)+(_colorNameArray.count/3+1)*ACTUAL_HEIGHT(45);
    }else if (section==2){
        return ACTUAL_HEIGHT(74);
    }else if (section==3){
        return ACTUAL_HEIGHT(172);
    }else{
        return 666;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //设置成点击Cell后无法显示被选中
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    _cell.backgroundColor=[UIColor yellowColor];
    
    return _cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
      if(section==0){
        //尺码
        UIView *BGView01=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,ACTUAL_HEIGHT(65)+(_sizeNameArray.count/3+1)*ACTUAL_HEIGHT(45))];
        BGView01.backgroundColor=RGBCOLOR(235, 235, 235, 1);
          
        UILabel *label01=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(200),ACTUAL_HEIGHT(22))];
        label01.text=@"尺码：";
        label01.font=[UIFont systemFontOfSize:18];
        label01.textColor=RGBCOLOR(71, 71, 71, 1);
        [BGView01 addSubview:label01];
          NSString*str=_sizeNameArray[0];
          if (str.length==0) {
              
          }else{

          for (int i=0; i<_sizeNameArray.count; i++) {
             
              _sizeButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20)+ACTUAL_WIDTH(120)*(i%3), ACTUAL_HEIGHT(45)+ACTUAL_HEIGHT(50)*(i/3), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(40))];
            [_sizeButton setTitle:_sizeNameArray[i] forState:0];
             _sizeButton.layer.cornerRadius=5;
             _sizeButton.titleLabel.font=[UIFont systemFontOfSize:14];
             _sizeButton.tag=i;
             _sizeButton.backgroundColor=[UIColor whiteColor];
             [_sizeButton setTitleColor:NewRed forState:UIControlStateSelected];
             [_sizeButton setTitleColor:ManColor forState:0];
             [BGView01 addSubview:_sizeButton];
             [_sizeButton addTarget:self action:@selector(touchSizeButton:) forControlEvents:UIControlEventTouchUpInside];
             [self.allSizeButtons addObject:_sizeButton];
         }
          
    }
        return BGView01;
        
     }else if (section==1) {
         //颜色分类
         UIView *BGView00=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,ACTUAL_HEIGHT(65)+(_colorNameArray.count/3+1)*ACTUAL_HEIGHT(45))];
         BGView00.backgroundColor=RGBCOLOR(235, 235, 235, 1);
         
         UILabel *label00=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(200),ACTUAL_HEIGHT(22))];
         label00.text=@"颜色分类：";
         label00.font=[UIFont systemFontOfSize:18];
         label00.textColor=RGBCOLOR(71, 71, 71, 1);
         [BGView00 addSubview:label00];
         
         self.allColorButtons=[NSMutableArray array];
         
         NSString*str=_colorNameArray[0];
         if (str.length==0) {
             
         }else{
        
         for (int j=0; j<_colorNameArray.count; j++) {
                 _colorButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20)+ACTUAL_WIDTH(120)*(j%3), ACTUAL_HEIGHT(45)+ACTUAL_HEIGHT(50)*(j/3), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(40))];
                 [_colorButton setTitle:_colorNameArray[j] forState:0];
                 _colorButton.layer.cornerRadius=5;
                 _colorButton.titleLabel.font=[UIFont systemFontOfSize:14];
                 _colorButton.tag=j;
                 _colorButton.backgroundColor=[UIColor whiteColor];
                 [_colorButton setTitleColor:NewRed forState:UIControlStateSelected];
                 [_colorButton setTitleColor:ManColor forState:0];
                 [_colorButton addTarget:self action:@selector(touchColorButton:) forControlEvents:UIControlEventTouchUpInside];
                 [BGView00 addSubview:_colorButton];
                 [self.allColorButtons addObject:_colorButton];
             }
         }
         return BGView00;
     
     }else if (section==2) {
        UIView *BGView02=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(74))];
        BGView02.backgroundColor=RGBCOLOR(235, 235, 235, 1);
        
        UILabel *label02=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(23), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(25))];
        label02.text=@"数量：";
        label02.font=[UIFont systemFontOfSize:18];
        label02.textColor=RGBCOLOR(71, 71, 71, 1);
        [BGView02 addSubview:label02];
        
        _addNum=[[AddNumberView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(70), ACTUAL_HEIGHT(20), ACTUAL_WIDTH(180), ACTUAL_HEIGHT(50))];
        _addNum.delegate=self;
         _addNum.numberString=@"1";
        _addNum.numberLab.font=[UIFont systemFontOfSize:18];
        [BGView02 addSubview:_addNum];
        
        return BGView02;
    }else if(section==3){
        UIView *BGView03=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(172))];
        BGView03.backgroundColor=RGBCOLOR(235, 235, 235, 1);
        
        UILabel *label03=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(25))];
        label03.text=@"备注：";
        label03.font=[UIFont systemFontOfSize:18];
        label03.textColor=RGBCOLOR(71, 71, 71, 1);
        [BGView03 addSubview:label03];
        
        _samtext=[self.view viewWithTag:111];
        _samtext=[[SAMTextView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(48), ACTUAL_WIDTH(351), ACTUAL_HEIGHT(93))];
        _samtext.delegate=self;
        _samtext.layer.cornerRadius=5;
        [BGView03 addSubview:_samtext];
        
        return BGView03;
    }return nil;
}

#pragma mark 颜色&尺码点击事件并记录点击的值

-(void)touchColorButton:(UIButton*)sender{

    
    for (int i=0; i<self.allColorButtons.count; i++) {
       UIButton*button=self.allColorButtons[i];
       button.selected=NO;
    }

    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
    _selectColor=self.valueColorArray[sender.tag][@"value_id"];
    _color=self.valueColorArray[sender.tag][@"name"];
    
    if ([_colorStr isEqualToString:@""]) {
        self.orderId=[NSString stringWithFormat:@"%@:%@",_sizeStr,_selectSize];
    }else if ([_sizeStr isEqualToString:@""]){
       self.orderId=[NSString stringWithFormat:@"%@:%@",_colorStr,_selectColor];
    }else{
       self.orderId=[NSString stringWithFormat:@"%@:%@;%@:%@",_colorStr,_selectColor,_sizeStr,_selectSize];

    }
        if ([self.colorNameArray[0] isEqual:@""]) {
        _colorButton.hidden=YES;
    }
    
    if (self.priceDic[self.idDic[self.orderId]]==nil) {
         float floatString = [self.priceStr floatValue];
        _priceLabel.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,floatString];
        _price=self.priceStr;
    }else{
        float floatString1 = [self.priceDic[self.idDic[self.orderId]] floatValue];
        _price=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,floatString1];
        _priceLabel.text=_price;
        self.yuan=self.yuanDic[self.idDic[self.orderId]];

    }
    
}

-(void)touchSizeButton:(UIButton*)sender{
    
    for (int i=0; i<self.allSizeButtons.count; i++) {
        UIButton*button=self.allSizeButtons[i];
        button.selected=NO;
    }
    
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
    _selectSize=self.valueSizeArray[sender.tag][@"value_id"];
    _size=self.valueSizeArray[sender.tag][@"name"];
    if ([_colorStr isEqualToString:@""]) {
        self.orderId=[NSString stringWithFormat:@"%@:%@",_sizeStr,_selectSize];
    }else if ([_sizeStr isEqualToString:@""]){
        self.orderId=[NSString stringWithFormat:@"%@:%@",_colorStr,_selectColor];
    }else{
        self.orderId=[NSString stringWithFormat:@"%@:%@;%@:%@",_colorStr,_selectColor,_sizeStr,_selectSize];
        
    }

    
    if (self.priceDic[self.idDic[ self.orderId]]==nil) {
        float floatString = [self.priceStr floatValue];
        _priceLabel.text=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,floatString];
        _price=self.priceStr;
    }else{
        float floatString1 = [self.priceDic[self.idDic[ self.orderId]] floatValue];
        _price=[NSString stringWithFormat:@"%@ %.2f",[UserSession instance].currency,floatString1];
        _priceLabel.text=_price;
        self.yuan=self.yuanDic[self.idDic[ self.orderId]];
    }
}

- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    if (self.number>1) {
        self.number--;
        _addNum.numberString=[NSString stringWithFormat:@"%.0f",self.number];
    }
    
    
}

- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    self.number++;
    _addNum.numberString=[NSString stringWithFormat:@"%.0f",self.number];

}


//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

#pragma mark 确定按钮点击事件

-(void)sureToBuy:(UIButton*)sender{
    
//    if (sender.selected==YES) {
//        return;
//    }else{
//        sender.selected=YES;
//        [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:2.0];
    NSString*str=[self judgeCansave];
    
    if (_canSave) {
    if (_addNum==nil) {
        _addNum=[[AddNumberView alloc]init];
        _addNum.numberString=@"1";
    }
    if (_addNum.numberString==nil) {
        _addNum.numberString=@"1";
    }
//    if (_samtext.text==nil) {
//        _samtext=[[SAMTextView alloc]init];
//        _samtext.text=@"(空)";
//    }
    if (_samtext.text.length==0||[_samtext.text isEqualToString:@""]||_samtext.text==nil) {
        _samtext.text=@"(空)";
    }
    
    if (_color==nil) {
        _color=@"(空)";
    }
    if (_size==nil) {
        _size=@"(空)";
    }
    if (self.yuan==nil) {
        self.yuan=self.yuanStr;
    }
    
        //http://www.vipxox.cn/?  m=appapi&  s=go_shop&  act=add_shop&  uid=q&  s_type=&  por_url=&  pro_pic=&  title=&  color=&  size=&  price=&  num=&  remark
        NSDictionary*params=nil;
        
        if ([self.sku_id isEqualToString:@""]) {
            
               params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"add_shop",@"uid":[UserSession instance].uid,@"s_type":self.typeStr,@"por_url":self.urlStr,@"pro_pic":self.imageStr,@"title":self.titleStr,@"color":self.color,@"size":self.size,@"price":self.yuan,@"num":_addNum.numberString,@"remark":_samtext.text,@"sid":self.sidStr,@"sku_id":self.idDic[self.orderId]};

        }else{
        params=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"add_shop",@"uid":[UserSession instance].uid,@"s_type":self.typeStr,@"por_url":self.urlStr,@"pro_pic":self.imageStr,@"title":self.titleStr,@"color":self.color,@"size":self.size,@"price":self.yuan,@"num":_addNum.numberString,@"remark":_samtext.text,@"sid":self.sidStr,@"sku_id":self.sku_id};

        }
        
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            NSLog(@"%@",number);
            
            if ([number isEqualToString:@"0"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"添加成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"%@",data[@"errorMessage"]);
                UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:data[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter1 show];
            }
             [self comeBack];
        }];
    }else{
        [JRToast showWithText:str duration:2.0];
    }
//    }
}

//-(void)timeEnough:(NSTimer*)timer{
//    UIButton *btn=(UIButton*)[self.view viewWithTag:666];
//    btn.selected=NO;
//    [timer invalidate];
//    timer=nil;
//    
//}

-(NSString*)judgeCansave{
    _canSave=YES;
    //
    if (![_colorNameArray[0] isEqual:@""]&&_color==nil) {
        _canSave=NO;
        return @"请先完善选择！";
    }else{
        _canSave=YES;
    }
    
    if (![_sizeNameArray[0] isEqual:@""]&&_size==nil) {
        _canSave=NO;
        return @"请先完善选择！";
    }else{
        _canSave=YES;
    }
    
    return @"666";
}

//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //    self.tableView.contentSize=CGSizeMake(0, ACTUAL_HEIGHT(-260));
    [self.tableView setY:self.tableView.top-203];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.tableView setY:self.tableView.top+203];
    
    return YES;
}


//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


-(void)comeBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
