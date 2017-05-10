//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
//#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
//#import "WXMediaMessage+messageConstruct.h"

@implementation WXApiRequestHandler

#pragma mark - Public Methods
//+ (BOOL)sendText:(NSString *)text
//         InScene:(enum WXScene)scene {
//    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:text
//                                                   OrMediaMessage:nil
//                                                            bText:YES
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendImageData:(NSData *)imageData
//              TagName:(NSString *)tagName
//           MessageExt:(NSString *)messageExt
//               Action:(NSString *)action
//           ThumbImage:(UIImage *)thumbImage
//              InScene:(enum WXScene)scene {
//    WXImageObject *ext = [WXImageObject object];
//    ext.imageData = imageData;
//    
//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
//                                                   Description:nil
//                                                        Object:ext
//                                                    MessageExt:messageExt
//                                                 MessageAction:action
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:tagName];
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendLinkURL:(NSString *)urlString
//            TagName:(NSString *)tagName
//              Title:(NSString *)title
//        Description:(NSString *)description
//         ThumbImage:(UIImage *)thumbImage
//            InScene:(enum WXScene)scene {
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = urlString;
//
//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
//                                                   Description:description
//                                                        Object:ext
//                                                    MessageExt:nil
//                                                 MessageAction:nil
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:tagName];
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendMusicURL:(NSString *)musicURL
//             dataURL:(NSString *)dataURL
//               Title:(NSString *)title
//         Description:(NSString *)description
//          ThumbImage:(UIImage *)thumbImage
//             InScene:(enum WXScene)scene {
//    WXMusicObject *ext = [WXMusicObject object];
//    ext.musicUrl = musicURL;
//    ext.musicDataUrl = dataURL;
//
//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
//                                                   Description:description
//                                                        Object:ext
//                                                    MessageExt:nil
//                                                 MessageAction:nil
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:nil];
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendVideoURL:(NSString *)videoURL
//               Title:(NSString *)title
//         Description:(NSString *)description
//          ThumbImage:(UIImage *)thumbImage
//             InScene:(enum WXScene)scene {
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.description = description;
//    [message setThumbImage:thumbImage];
//    
//    WXVideoObject *ext = [WXVideoObject object];
//    ext.videoUrl = videoURL;
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendEmotionData:(NSData *)emotionData
//             ThumbImage:(UIImage *)thumbImage
//                InScene:(enum WXScene)scene {
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:thumbImage];
//    
//    WXEmoticonObject *ext = [WXEmoticonObject object];
//    ext.emoticonData = emotionData;
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendFileData:(NSData *)fileData
//       fileExtension:(NSString *)extension
//               Title:(NSString *)title
//         Description:(NSString *)description
//          ThumbImage:(UIImage *)thumbImage
//             InScene:(enum WXScene)scene {
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.description = description;
//    [message setThumbImage:thumbImage];
//    
//    WXFileObject *ext = [WXFileObject object];
//    ext.fileExtension = @"pdf";
//    ext.fileData = fileData;
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//}

//+ (BOOL)sendAppContentData:(NSData *)data
//                   ExtInfo:(NSString *)info
//                    ExtURL:(NSString *)url
//                     Title:(NSString *)title
//               Description:(NSString *)description
//                MessageExt:(NSString *)messageExt
//             MessageAction:(NSString *)action
//                ThumbImage:(UIImage *)thumbImage
//                   InScene:(enum WXScene)scene {
//    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.extInfo = info;
//    ext.url = url;
//    ext.fileData = data;
//
//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
//                                                   Description:description
//                                                        Object:ext
//                                                    MessageExt:messageExt
//                                                 MessageAction:action
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:nil];
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//
//}
//
//+ (BOOL)addCardsToCardPackage:(NSArray *)cardItems {
//    AddCardToWXCardPackageReq *req = [[[AddCardToWXCardPackageReq alloc] init] autorelease];
//    req.cardAry = cardItems;
//    return [WXApi sendReq:req];
//}
//
//+ (BOOL)sendAuthRequestScope:(NSString *)scope
//                       State:(NSString *)state
//                      OpenID:(NSString *)openID
//            InViewController:(UIViewController *)viewController {
//    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
//    req.scope = scope; // @"post_timeline,sns"
//    req.state = state;
//    req.openID = openID;
//    
//    return [WXApi sendAuthReq:req
//               viewController:viewController
//                     delegate:[WXApiManager sharedManager]];
//}
//
//+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
//                      Description:(NSString *)description
//                        tousrname:(NSString *)tousrname
//                           ExtMsg:(NSString *)extMsg {
//    [WXApi registerApp:appID withDescription:description];
//    JumpToBizWebviewReq *req = [[[JumpToBizWebviewReq alloc]init]autorelease];
//    req.tousrname = tousrname;
//    req.extMsg = extMsg;
//    req.webType = WXMPWebviewType_Ad;
//    return [WXApi sendReq:req];
//}


+ (NSString *)jumpToBizPay:(NSString*)aa {

//http://www.vipxox.cn/?m=appapi&s=mall&act=pay_order&money=9&operate=wechat&uid=0340628adb41b9e97d334b41a86a3338
   
//            HTTP_ADDRESS
//      NSString*str=@"http://www.vipxox.com/?m=appapi&s=mall&act=pay_order&operate=wechat";
    
    NSString*str=[NSString stringWithFormat:@"%@/?m=appapi&s=mall&act=pay_order&operate=wechat",HTTP_ADDRESS];
    NSString*addMoney=[NSString stringWithFormat:@"&money=%@",aa];
    NSString*addUid=[NSString stringWithFormat:@"&uid=%@",[UserSession instance].uid];
    NSString*urlString=[NSString stringWithFormat:@"%@%@%@",str,addMoney,addUid];
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *data = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary*dict=data[@"data"];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }

    
    


}



//+ (NSString *)jumpToBizPay:(NSString*)aa {
//    
//    //http://www.vipxox.cn/?m=appapi&s=mall&act=pay_order&money=9&operate=wechat&uid=0340628adb41b9e97d334b41a86a3338
//    
////    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
////    NSString*str=@"m=appapi&s=mall&act=pay_order&operate=wechat";
////    NSString*addMoney=[NSString stringWithFormat:@"&money=%@",aa];
////    NSString*addUid=[NSString stringWithFormat:@"&uid=%@",[UserSession instance].uid];
////    NSString*urlString=[NSString stringWithFormat:@"%@%@%@",str,addMoney,addUid];
//    
//    
//    NSString*str=@"http://www.vipxox.com/?m=appapi&s=mall&act=pay_order&operate=wechat";
//        NSString*addMoney=[NSString stringWithFormat:@"&money=%@",aa];
//        NSString*addUid=[NSString stringWithFormat:@"&uid=%@",[UserSession instance].uid];
//        NSString*urlString=[NSString stringWithFormat:@"%@%@%@",str,addMoney,addUid];
//
//   
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    // 请求的序列化
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    // 回复序列化
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    // 设置回复内容信息
//    //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    
//    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        if (responseObject!=nil) {
//            
//            NSDictionary*dict=responseObject[@"data"];
//            
//            NSLog(@"url:%@",urlString);
//            if(dict != nil){
//                NSMutableString *retcode = [dict objectForKey:@"retcode"];
//                if (retcode.intValue == 0){
//                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                    
//                    //调起微信支付
//                    PayReq* req             = [[PayReq alloc] init];
//                    req.partnerId           = [dict objectForKey:@"partnerid"];
//                    req.prepayId            = [dict objectForKey:@"prepayid"];
//                    req.nonceStr            = [dict objectForKey:@"noncestr"];
//                    req.timeStamp           = stamp.intValue;
//                    req.package             = [dict objectForKey:@"package"];
//                    req.sign                = [dict objectForKey:@"sign"];
//                    [WXApi sendReq:req];
//                    //日志输出
//                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
////                    return @"";
//                }else{
//                    NSString*strr=[dict objectForKey:@"retmsg"];
////                    return strr;
//                }
//            }else{
////                return @"服务器返回错误，未获取到json对象";
//            }
//        }else{
////            return @"服务器返回错误";
//        }
//
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        
//        
//        
//    }];
//
//    
//    
//    
//    return nil;
//    
//}

@end
