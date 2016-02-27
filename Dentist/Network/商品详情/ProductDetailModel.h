//
//  ProductDetailModel.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecItem : NSObject  //单个规格

@property (strong,nonatomic) NSString* name;    //规格名称
@property (strong,nonatomic) NSArray* data;     //NSString数组

@end


@interface GiftItem : NSObject  //单个赠品

@property (strong,nonatomic) NSString* title;   //标题
@property (strong,nonatomic) NSString* img_url;
@property (strong,nonatomic) NSString* g_code;  //内部编码
@property (assign,nonatomic) int num;           //数量

@end

@interface GroupItem : NSObject //单个组合

@property (strong,nonatomic) NSString* pgp_id;  //组合ID
@property (assign,nonatomic) double price;      //组合价格
@property (strong,nonatomic) NSString* name;    //组合名称
@property (strong,nonatomic) NSArray* items;    //组合内容,GroupContentItem数组

@end

@interface GroupContentItem : NSObject //组合里单个商品

@property (strong,nonatomic) NSString* iid;     //商品ID
@property (assign,nonatomic) double price;      //商品价格
@property (strong,nonatomic) NSString* img;
@property (strong,nonatomic) NSString* title;   //商品标题

@end

@interface SpecProductItem : NSObject   //单规格商品ID

@property (strong,nonatomic) NSString* iid;     //商品ID
@property (strong,nonatomic) NSString* sids;
@property (assign,nonatomic) int num;           //库存

@end

@interface ScoreItem : NSObject         //单条评价

@property (assign,nonatomic) int score;         //评分
@property (strong,nonatomic) NSArray* imgs;     //图片
@property (strong,nonatomic) NSString* content; //内容
@property (assign,nonatomic) int64_t addtime;   //发表时间
@property (strong,nonatomic) NSString* nickname;//发表者

@end

typedef GroupContentItem LikeProductItem;

@interface ProductDetailModel : NSObject

@property (strong,nonatomic) NSString* iid;     //商品ID
@property (strong,nonatomic) NSString* sids;    //商品属性
@property (assign,nonatomic) double old_price;  //原价
@property (assign,nonatomic) double price;      //现价
@property (assign,nonatomic) int num;           //库存
@property (strong,nonatomic) NSString* tid;     //类型ID
@property (strong,nonatomic) NSArray* p_sids;   //规格数据，SpecItem数组
@property (strong,nonatomic) NSString* cid;     //分类ID
@property (strong,nonatomic) NSString* s_cid;   //子分类ID
@property (strong,nonatomic) NSString* bid;     //品牌ID
@property (strong,nonatomic) NSString* title;   //标题
@property (strong,nonatomic) NSString* title_fu;//副标题
@property (strong,nonatomic) NSArray* img_url;  //商品图片URL，NSString数组
@property (strong,nonatomic) NSString* code;    //内部编码
@property (assign,nonatomic) int buy_cert;      //购买资质(1需要)
@property (strong,nonatomic) NSString* description_p;//商品详情
@property (strong,nonatomic) NSArray* gifts;    //赠品，GiftItem数组
@property (strong,nonatomic) NSArray* groups;   //产品组合，GroupItem数组
@property (assign,nonatomic) int64_t update_time;//更新时间
@property (strong,nonatomic) NSArray* p_iids;   //规格各参数商品ID，SpecProductItem数组
@property (strong,nonatomic) NSArray* scores;   //5条评论，ScoreItem数组

@property (assign,nonatomic) int pick_up;      //自取
@property (assign,nonatomic) int express;      //快递
@property (assign,nonatomic) int is_del;       //
@property (assign,nonatomic) int item_is_del;  //

@property (strong,nonatomic) NSArray* likes;    //猜你喜欢，LikeProductItem数组
@property (assign,nonatomic) int product_score; //评论人数
@property (assign,nonatomic) float product_score_good;//好评率

@property (assign,nonatomic) BOOL is_baoyou;

@end
