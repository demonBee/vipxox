//
//  AboutDelegateViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/24.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "AboutDelegateViewController.h"

@interface AboutDelegateViewController ()<UITextViewDelegate>

@end

@implementation AboutDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [self makeNavi];
    [self makeView];
}

-(void)makeNavi{
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
    titleLabel.text=@"包裹转运验货规则和服务协议";
    titleLabel.textAlignment=1;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)makeView{
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(64))];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    textView.scrollEnabled =YES;
    textView.editable = NO;
    textView.text=@"包裹转运验货规则:\n如果您的包裹符合签收要求,仓库在收货后会根据包裹重量,称重入库.\n\n请注意:\n1-选择开箱验货服务后,原则上会对商品的数量,颜色,尺码等信息进行核对.\n2-电器,数码产品,周边产品等专业性强的商品,其质量,型号,零配件等不在验货范围内.\n3-如果仓库在收货后发现您的货物不符合运输和航空运输的要求,我们会在相关订单上面做特别标识提醒您协商退货事宜.\n4-如果您在合理的国内运输时间后(我们的仓库地址在深圳,一般国内寄送的周期为3-5天)还没有看到仓库的收货信息,请联系您的国内物流公司或网站客服人员确认货物的状态.\n\n包裹转运赔偿标准:\n邮件在寄递过程中因非我司原因而发生丢失,短少,损毁和延误,我司不予以赔偿.对间接损失和未实现的利益不承担赔偿责任.具体请参看包裹赔偿标准\n\n以下情况不承担赔偿责任\n1-由于不可抗力造成的(保价邮件除外).\n2-寄递的物品违反禁寄或限寄规定的,经主管机关没收或依照有关法规处理的.\n3-投交时邮件封装完好无拆动痕迹,且重量无减少而内件短少或损坏的.\n4-收件人已按规定手续签收的.\n5-由于客户的责任或所寄物品本身的原因造成邮件损失或延误的.\n6-客户自交寄邮件之日起至查询期满未查询又未提出赔偿要求的.\n7-国际邮件被寄达国按其国内法令扣留,没收或销毁的.\n\n禁寄物品\n邮件禁止寄递的物品\n1-国家法律法规禁止流通或者寄递的物品;\n2-爆炸性,易燃性,腐蚀性,放射性和毒性等危险物品;\n3-反动报刊,书籍,窗口或者淫秽物品;\n4-各种货币;\n5-妨害公共卫生的物品;\n6-容易腐烂的物品;\n7-活的动物(包装能确保寄递和工作人员安全的蜜蜂,蚕,水蛭除外);\n8-包装不妥,可能危害人身安全,污染或损毁其它邮件设备的物品;\n9-其它不适合邮递条件的物品.\n邮政惯例禁止交寄\n1-物品的性质或其封装有伤害邮政服务人员或污损邮件或邮政设备嫌疑的.\n2-封口用金属扣钮等有锋利边缘,可能妨害邮件处理的物品.\n3-各类枪械,弹药,易爆炸性物品,易燃烧性物品,易腐蚀性物品,放射性元素及容器,烈性毒药,麻醉药物,生化制品和传染性物品.\n4-各种危害社会安全和稳定的以及淫秽的出版物,宣传品,印刷品等.\n5-各种妨害公共卫生的物品.\n6-对方禁止进入或流通的文件或物品.\n7-除上述的一般规定外,还应遵从海关部门的有关规定.\n\n台湾地区邮政规定禁止交寄\n1-物品的性质或其封装有伤害邮政服务人员或污损邮件或邮政设备嫌疑的.\n2-封口用金属扣钮等有锋利边缘,可能妨害邮件处理的物品.\n3-易燃,易爆裂或其它危险物品.但备案机构以特殊方法封装互寄的易坏生物学物料,经相关主管部门核发运输凭证的,不受此限制.\n4-活生动物.但蜜蜂,蚕,水蛭,由备案机构互寄的寄生虫或为消除害虫的虫类不受此限制.\n5-放射性物品.\n6-鸦片,吗啡及其它麻醉物品.但经相关主管部门核发运输凭证或司法机关,司法警察机构备文证明,供诉讼证据用途的,并作保价或申报价值包裹互寄,或作保价包裹用于医药或科学研究,经寄达局准许的物品,不受此限制.\n7-猥亵妨害风化的文件或物品.但由司法机关或司法警察机关书面证明为诉讼证据用途的,做挂号信函或包裹互寄,不受此限制.\n8-寄达地禁止进入的文件或物品.\n9-台湾地区有关主管部门禁止发售及制造的文件或物品.但由司法机关或司法警察机关书面证明为诉讼证据用途的,做挂号信函或包裹互寄,不受此限制.\n10-彩票及与彩票有关的广告传单.但由司法机关或司法警察机关书面证明为诉讼证据用途的,做挂号信函或包裹互寄,不受此限制.\n11-其它法令规定的违禁品.";
    [self.view addSubview:textView];
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose/Users/tianweiyou/Desktop/yangxin/Vipxox Final 6.0/Vipxox/项目内容/中心/个人中心/subPages/AddAddressCell.xib of any resources that can be recreated.
}


@end
