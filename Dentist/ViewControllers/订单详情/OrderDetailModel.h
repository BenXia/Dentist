//
//  OrderDetailModel.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductListModel;
@class Address;
@interface OrderDetailModel : NSObject

@property (nonatomic, strong) NSString *orderStatus;               //订单状态
@property (nonatomic, strong) NSString *orderShowNumber;           //运单号
@property (nonatomic, strong) NSString *pickUp;                    //是否是自提  1:自提   0:快递
@property (nonatomic, strong) NSString *orderExpressCompany;       //快递公司
@property (nonatomic, strong) NSString *orderPickUpCode;           //自提码
@property (nonatomic, strong) NSString *orderExpressNumber;        //快递单号
@property (nonatomic, strong) NSString *orderReceiverName;         //收件人
@property (nonatomic, strong) NSString *orderReceiverPhone;        //收件人电话
@property (nonatomic, strong) NSString *orderReceiverAddress;      //收件人地址
@property (nonatomic, strong) NSString *orderPayTime;              //支付时间
@property (nonatomic, strong) NSString *orderProduceTime;          //下单时间
@property (nonatomic, strong) ProductListModel  *orderProductListModel;        //订单商品model

@property (nonatomic, strong) NSArray *payTypeArray;
@property (nonatomic, strong) NSString *currentPay;
@property (nonatomic, assign) int piaoType;
@property (nonatomic, strong) NSString *piaoTitle;
@property (nonatomic, strong) NSString *piaoContent;
@property (nonatomic, strong) NSString *feedbackText;

@end
