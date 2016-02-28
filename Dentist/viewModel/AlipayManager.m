//
//  AlipayManager.m
//  Dentist
//
//  Created by 王涛 on 16/2/27.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AlipayManager.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

#define kPrivateKeyString @"MIICWwIBAAKBgQDCxRJWs+FECo2zLDY8ZgsXnQbUNqZBtEo6g4ihqcypCRsmGyWZWEdO8FV+tBn3UdWFRb/TYfO6adFbQYLIsav2Fs8BxFEKk1ovDU++4jxXlH6GEMiuCyux5pqgR3OwaYTUx/pL34p+6277/QpRqx3I5QBCmGiVO3C9YKWASkRCHwIDAQABAoGAaKfaPcp0Pcpp75/PGM9AIJUYyUkANwf4Zs6sySljNmUVOHmXz3kW//y2A9okpbdMQ0uCUsQsYbtgameeLdcCbc3k0qkb0h+kofBA41h1W9OOV73FTwpxNZO3JMgr9c4n19j2561i4vuPHK6UlvW71PHfQUiU+j4KYgGK9i1SgaECQQDsKC1a8tR5VBuTQJIiDsnewSX+0df3IiiZWRNpie/plz0PlT3Sp3O5hbZwwkoRn/iYgFClJ3jOhy6Uoohplo5vAkEA0yKkXB6HFtdmnPRrED2S4RZaducTuf5p5cSEK4pCHcpoWlAg019spfwVbrp0/ZiEcUDqkp4Ep1OXn2847JpfUQJAVEqC5dOGw0eiEA0cG8vrgfau+SUtUKiAlTuWEjWJzHaO9ODwECB0zeNMGzM9/Mx8jvI91rUgCZd2qNbamdWDQQJAZmBr1gcvddHofb6+k1dn+yC9qN4PYKaObs1FUV9vA8b7pp8n65ZftnRvaAudYsIrpkbV91YL557O7I4fygpooQJAa5lkdGJwy2z6LGfYYYq0860oSuJy5AfLzp9uWwSdlF8Hd393duR4XMJVTycOCpr+eGx4rSvrfpX7YKleBT6ONA=="

@implementation AlipayManager

SINGLETON_GCD(AlipayManager);

- (void)payWithAlipay:(ComponentAlipay_Order *)alipay_Order completeBlock:(DictionaryBlock) completeBlock{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121334701862";
    NSString *seller = @"2088121334701862";//2780887436@qq.com
    NSString *privateKey = kPrivateKeyString;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = alipay_Order.ID; //订单ID（由商家自行制定）
    order.productName = alipay_Order.name; //商品标题
    order.productDescription = alipay_Order.desc; //商品描述
    order.amount = alipay_Order.price; //商品价格
    order.notifyURL =  @"http://api.x.jiefangqian.com/pay/alipay_notify.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.toboom.yayiabc";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:completeBlock];
    }
}
@end
