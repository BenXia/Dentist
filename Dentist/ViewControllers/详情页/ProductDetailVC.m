//
//  ProductDetailVC.m
//  Dentist
//
//  Created by Ben on 16/2/14.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductDetailVC.h"
#import "ProductDetailDC.h"
#import "SDCycleScrollView.h"
#import "GroupProductView.h"
#import "EditNumberView.h"
#import "ProductDescriptionVC.h"
#import "AddCartDC.h"
#import "AddFavoriteDC.h"
#import "RemoveFavoriteDC.h"
#import "ProductEvaluateTableViewCell.h"
#import "ProductEvaluateModel.h"
#import "ProductEvaluateVC.h"
#import "GuessYouLikeProductView.h"
#import "OrderVC.h"

static const CGFloat kProductDetailVCTopImageRatio = 16.f/9;
static const CGFloat kHeightOfSectionHeader = 12;
static const CGFloat kGapXOfPopScrollView = 12;//选择分类弹出视图中选项间的横向间距
static const CGFloat kGapYOfPopScrollView = 12; //选择分类弹出视图中选项间的纵向间距
static const CGFloat kFontOfPopScrollViewTitle = 14;//分类标题字体
static const CGFloat kFontOfPopScrollViewOption = 15;//分类选项字体
static const CGFloat kGapXInSpecOptionButton = 6;
static const CGFloat kGapYInSpecOptionButton = 6;

@interface ProductDetailVC () <
SDCycleScrollViewDelegate,
PPDataControllerDelegate,
GroupProductViewDelegate,
EditNumberViewDelegate,
GuessYouLikeProductViewDelegate,
ProductEvaluateTableViewCellDelegate,
UIScrollViewDelegate>

@property (nonatomic, strong) ProductDetailDC *dc;
@property (nonatomic, strong) AddCartDC* addCartDC;
@property (nonatomic, strong) AddFavoriteDC* addFavoriteDC;
@property (nonatomic, strong) RemoveFavoriteDC* removeFavoriteDC;

@property (strong,nonatomic) NSMutableDictionary* dicFromSepcTitleToButtons;
@property (strong,nonatomic) NSMutableDictionary* dicFromSepcDataToTitle;

@property (assign,nonatomic) int buyNum;                    //当前购买数
@property (assign,nonatomic) BOOL isSelectSpecCompleted;    //选择分类完成
@property (strong,nonatomic) SpecProductItem* specProduct;  //选择分类后的商品
@property (strong,nonatomic) NSString* specProductDescription;  //选择分类后的描述信息

@property (assign,nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden; // 需要控制状态栏隐藏和显示，在PhotosBrowserVC里面难以实现

@property (weak, nonatomic) IBOutlet UIView *topBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *topBarBackButton;

@property (weak,nonatomic)  IBOutlet UIScrollView* scrollView;
@property (assign,nonatomic) CGFloat scrollContentHeight;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (assign, nonatomic) CGFloat cycleScrollViewHeight;


@property (weak, nonatomic) IBOutlet UIView *bottomButtonView;
@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;

@property (strong, nonatomic) IBOutlet UIView *baseInfoView;
@property (weak, nonatomic) IBOutlet UILabel *baseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *basePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseOldPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseTitleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseTitleLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseSubtitleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *basePriceViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *basePriceViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseDeliverViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseDeliverExpressButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseDeliverPickupButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *basePriceFreeShippingImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *basePricePresentImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *basePriceFreeShippingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *basePricePresentImageView;
@property (weak, nonatomic) IBOutlet UIButton *baseDeliverExpressButton;
@property (weak, nonatomic) IBOutlet UIButton *baseDeliverPickupButton;

@property (strong, nonatomic) IBOutlet UIView *groupDiscountView;
@property (weak, nonatomic) IBOutlet UILabel *groupReducePriceLabel;
@property (weak, nonatomic) IBOutlet UIView *groupBuyView;
@property (weak, nonatomic) IBOutlet UIButton *groupBuyButton;
@property (weak, nonatomic) IBOutlet UILabel *groupPayPriceLabel;
@property (weak, nonatomic) IBOutlet GroupProductView *groupFirstProductView;
@property (weak, nonatomic) IBOutlet GroupProductView *groupSecondProductView;
@property (weak, nonatomic) IBOutlet GroupProductView *groupThirdProductView;
@property (weak, nonatomic) IBOutlet UILabel *groupSecondAddSymbol;
@property (weak, nonatomic) IBOutlet UILabel *groupThirdAddSymbol;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupAddSymbolLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupProductViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIControl *popupCustomiseViewBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *popupCustomiseView;
@property (weak,nonatomic)  IBOutlet UIScrollView* popScrollView;
@property (assign,nonatomic) CGFloat popScrollContentHeight;
@property (weak, nonatomic) IBOutlet UIView *popInfoView;
@property (weak, nonatomic) IBOutlet UIView *popButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *popInfoImageView;
@property (weak, nonatomic) IBOutlet UILabel *popInfoPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *popInfoRemainNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *popInfoSelectTipLabel;
@property (weak, nonatomic) EditNumberView* editNumerView;

//赠品
@property (strong, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UILabel *giftContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftContentLabelTrailingConstraint;

//选择分类提示视图
@property (strong, nonatomic) IBOutlet UIView *selectTipView;
@property (weak, nonatomic) IBOutlet UILabel *selectTipLabel;

//评价
@property (strong, nonatomic) IBOutlet UIView *appraiseView;
@property (weak, nonatomic) IBOutlet UIView *appraiseContentView;
@property (weak, nonatomic) IBOutlet UILabel *appraiseTotalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appraiseHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *appraiseHeaderView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appraiseContentViewHeightConstraint;
//猜你喜欢
@property (strong, nonatomic) IBOutlet UIView *guessYouLikeView;
@property (weak, nonatomic) IBOutlet UILabel *guessYouLikeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guessYouLikeHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guessYouLikeContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *guessYouLikeContentView;

//拖拽进入图文详情提示
@property (strong, nonatomic) IBOutlet UIView *dragTipView;


@end

@implementation ProductDetailVC

#pragma mark - Life Circle

-(instancetype)initWithProductId:(NSString*)productId{
    self = [super init];
    if (self) {
        self.dc = [[ProductDetailDC alloc]initWithDelegate:self];
        self.addCartDC = [[AddCartDC alloc] initWithDelegate:self];
        self.addFavoriteDC = [[AddFavoriteDC alloc] initWithDelegate:self];
        self.removeFavoriteDC = [[RemoveFavoriteDC alloc] initWithDelegate:self];
        self.dc.productId = productId;
        self.buyNum = 1;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.title = @"商品详情";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
    
    [self.dc requestWithArgs:nil];
    [self showLoadingView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.statusBarHidden;
}

#pragma mark - UI Init

- (void)initUIReleated {
    [self.navigationController setNavigationBarHidden:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.baseTitleLabel.numberOfLines = 0;
    self.baseSubtitleLabel.numberOfLines = 0;
    self.giftContentLabel.numberOfLines = 0;
    [self initNavBar];
    [self initBottomButtonView];
    [self initMainScrollView];
    [self initHeaderImageView];
    [self initGroupDiscountView];
    [self initPopupCustomiseView];
}

- (void)initNavBar{
    self.topBarBackgroundView.backgroundColor = [UIColor themeBlueColor];
    self.topBarBackgroundView.layer.shadowOffset = CGSizeMake(2, 2);
    self.topBarBackgroundView.layer.shadowOpacity = 0.2;
    self.topBarBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)initHeaderImageView {
    self.cycleScrollViewHeight = kScreenWidth / kProductDetailVCTopImageRatio;
    _cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.cycleScrollViewHeight)];
    // 保证幻灯的宽高比
    _cycleScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    _cycleScrollView.infiniteLoop = YES;
    _cycleScrollView.imageURLStringsGroup = nil;
    _cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.showPageControl = YES;
    _cycleScrollView.dotColor = [UIColor themeBlueColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.notSelectDotColor = [UIColor gray003Color];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.autoScrollTimeInterval = 10;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"网络不给力-03"];
    _cycleScrollView.needChangeHeight = YES;
}

- (void)initMainScrollView {
    self.scrollView.backgroundColor = [UIColor themeBackGrayColor];
    
}

- (void)initBottomButtonView{
    //加阴影
    self.bottomButtonView.layer.shadowOffset = CGSizeMake(2, -2);
    self.bottomButtonView.layer.shadowOpacity = 0.2;
    self.bottomButtonView.layer.shadowRadius = 1;
    self.bottomButtonView.layer.shadowColor = [UIColor grayColor].CGColor;
    [self.bottomButtonView.layer setShadowPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, self.bottomButtonView.height)].CGPath];
}

-(void)initGroupDiscountView{
    self.groupFirstProductView.selected = YES;
    self.groupSecondProductView.delegate = self;
    self.groupThirdProductView.delegate = self;
    
    [self.groupBuyButton setBackgroundColor:[UIColor themeCyanColor]];
    [self.groupBuyButton setTitleColor:[UIColor whiteColor]];
    [self.groupBuyButton circular:self.groupBuyButton.height/2];
    
    CGFloat gapX = self.groupFirstProductView.x;
    CGFloat remainWidth = kScreenWidth - 2*gapX - self.groupBuyView.width;
    if (self.groupProductViewWidthConstraint.constant * 3 + self.groupAddSymbolLabelWidthConstraint.constant * 3 > remainWidth) {
        self.groupProductViewWidthConstraint.constant = (remainWidth - 3*self.groupAddSymbolLabelWidthConstraint.constant)/3;
    }else{
        self.groupAddSymbolLabelWidthConstraint.constant = (remainWidth - 3*self.groupProductViewWidthConstraint.constant)/3;
    }
}

- (void)initPopupCustomiseView {
    self.popupCustomiseView.layer.shadowOffset = CGSizeMake(2, -2);
    self.popupCustomiseView.layer.shadowOpacity = 0.1;
    self.popupCustomiseView.layer.shadowRadius = 1;
    self.popupCustomiseView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.popInfoImageView setBorderColor:[UIColor lineGray001Color]];
    [self.popInfoImageView setBorderWidth:1];
    
    [self.popupCustomiseViewBackgroundView addSubview:self.popupCustomiseView];
}

#pragma mark - UI Refresh

- (void)refreshUI{
    [self.scrollView removeAllSubviews];
    self.scrollContentHeight = 0;
    //图片
    [self refreshHeaderImageView];
    [self addScrollSubview:self.cycleScrollView];
    //基本信息
    [self refreshBaseInfoView];
    [self addScrollSubview:self.baseInfoView];
    self.scrollContentHeight += kHeightOfSectionHeader;
    
    //套餐优惠
    if (self.dc.productDetail.groups.count > 0) {
        [self refreshGroupDiscountView];
        [self addScrollSubview:self.groupDiscountView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    
    //赠品
    if (self.dc.productDetail.gifts.count > 0) {
        [self refreshGiftView];
        [self addScrollSubview:self.giftView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    //分类
    if (self.dc.productDetail.p_sids.count > 0) {
        [self refreshSelectTipView];
        [self addScrollSubview:self.selectTipView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    //评价
    if (self.dc.productDetail.scores.count > 0) {
        [self refreshAppraiseView];
        [self addScrollSubview:self.appraiseView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    
    //猜你喜欢
    if (self.dc.productDetail.likes.count > 0) {
        [self refreshGuessYouLikeView];
        [self addScrollSubview:self.guessYouLikeView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    
    //上拉提示
    if (self.dc.productDetail.description_p.length > 0) {
        [self addScrollSubview:self.dragTipView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.scrollContentHeight);
    
    //选择分类弹出视图
    [self refreshPopupCustomiseView];
}

- (void)refreshHeaderImageView {
    NSMutableArray *imagesURLStrings = [NSMutableArray arrayWithArray:self.dc.productDetail.img_url];
    
    if (imagesURLStrings.count > 1) {
        _cycleScrollView.autoScroll=YES;
    } else {
        _cycleScrollView.autoScroll=NO;
        _cycleScrollView.showPageControl = NO;
    }
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.hidden=NO;
}

-(void)refreshBaseInfoView{
    ProductDetailModel* productDetail = self.dc.productDetail;
    self.baseTitleLabel.text = productDetail.title;
    self.baseSubtitleLabel.text = productDetail.title_fu;
    
    [self.basePriceLabel themeWithPrice:productDetail.price bigFont:18 smallFont:14];
    
    self.baseOldPriceLabel.text = [NSString stringWithFormat: @"%.2f",productDetail.old_price];
    
    //赠品和包邮
    BOOL hasGift = self.dc.productDetail.gifts.count > 0;
    BOOL freeShipping = self.dc.productDetail.is_baoyou;
    if (hasGift && !freeShipping) {
        self.basePriceFreeShippingImageView.hidden = YES;
    }else if(!hasGift && !freeShipping){
        self.basePricePresentImageView.hidden = YES;
        self.basePriceFreeShippingImageView.hidden = YES;
    }else if(!hasGift && freeShipping){
        self.basePricePresentImageView.hidden = YES;
        self.basePriceFreeShippingImageViewLeadingConstraint.constant = self.basePricePresentImageViewLeadingConstraint.constant;
    }
    
    //快递和自取
    BOOL canExpress = self.dc.productDetail.express;
    BOOL canPickup = self.dc.productDetail.pick_up;
    if (canExpress && !canPickup) {
        self.baseDeliverPickupButton.hidden = YES;
    }else if(!canExpress && !canPickup){
        self.baseDeliverExpressButton.hidden = YES;
        self.baseDeliverPickupButton.hidden = YES;
    }else if(!canExpress && canPickup){
        self.baseDeliverExpressButton.hidden = YES;
        self.baseDeliverPickupButtonLeadingConstraint.constant = self.baseDeliverExpressButtonLeadingConstraint.constant;
    }
    
    //调整高度
    CGFloat limitWidth = kScreenWidth - 2*self.baseTitleLabelLeadingConstraint.constant;
    [self.baseTitleLabel ajustHeightWithLimitWidth:limitWidth];
    if (productDetail.title_fu.length == 0) {
        self.baseSubtitleLabel.height = 0;
        self.basePriceViewTopConstraint.constant = 0;
    }else{
        [self.baseSubtitleLabel ajustHeightWithLimitWidth:limitWidth];
    }
    self.baseInfoView.height = self.baseTitleLabelTopConstraint.constant + self.baseTitleLabel.height + self.baseSubtitleLabelTopConstraint.constant + self.baseSubtitleLabel.height + self.basePriceViewTopConstraint.constant + self.basePriceViewHeightConstraint.constant + self.baseDeliverViewHeightConstraint.constant * 3 + PIXEL_8;
}

-(void)refreshGroupDiscountView{
    GroupItem* firstGroup = [self.dc.productDetail.groups firstObject];
    NSArray* groupProductViewArray = @[self.groupSecondProductView,self.groupThirdProductView];
    NSArray* groupAddSymbolArray = @[self.groupSecondAddSymbol,self.groupThirdAddSymbol];
    for (UIView* view in groupProductViewArray) {
        view.tag = -1;
        view.hidden = YES;
    }
    for (UIView* view in groupAddSymbolArray) {
        view.hidden = YES;
    }
    double totalPrice = self.dc.productDetail.price;
    for (NSInteger i=0; i < firstGroup.items.count && i < groupProductViewArray.count; ++i) {
        GroupContentItem* item  = [firstGroup.items objectAtIndex:i];
        GroupProductView* view = [groupProductViewArray objectAtIndex:i];
        UIView* addSymbol = [groupAddSymbolArray objectAtIndex:i];
        view.tag = i;
        view.hidden = NO;
        addSymbol.hidden = NO;
        [view.imageView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];
        view.titleLabel.text = item.title;
        view.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,item.price];
        totalPrice += item.price;
    }
    
    self.groupReducePriceLabel.text = [NSString stringWithFormat:@"%.2f元",totalPrice - firstGroup.price];
    self.groupPayPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,firstGroup.price];
    
    //默认选中主商品
    self.groupFirstProductView.selected = YES;
    [self.groupFirstProductView.imageView sd_setImageWithURL:[NSURL URLWithString:[self.dc.productDetail.img_url firstObject]] placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];
    self.groupFirstProductView.titleLabel.text = self.dc.productDetail.title;
    self.groupFirstProductView.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,self.dc.productDetail.price];
    
}

- (void)refreshGiftView{
    NSArray* giftItemArray = self.dc.productDetail.gifts;
    NSMutableString* giftStr = [NSMutableString new];
    for (GiftItem* item in giftItemArray) {
        NSString* linkSymbol = giftStr.length == 0 ? @"" : @";";
        [giftStr appendFormat:@"%@%@",linkSymbol,item.title];
    }
    self.giftContentLabel.text = giftStr;
    CGFloat limitWidth = kScreenWidth - self.giftContentLabel.x - self.giftContentLabelTrailingConstraint.constant;
    [self.giftContentLabel ajustHeightWithLimitWidth:limitWidth];
    self.giftView.height = 2*self.giftContentLabel.y + self.giftContentLabel.height;
}

- (void)refreshSelectTipView{
    [self.selectTipLabel ajustHeightWithLimitWidth:kScreenWidth];
    self.selectTipView.height = 2*self.selectTipLabel.y + self.selectTipLabel.height;
    
    self.selectTipView.gestureRecognizers = nil;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSelectTipView)];
    [self.selectTipView addGestureRecognizer:tap];
}

- (void)refreshAppraiseView{
    //点击跳转评价列表w
    self.appraiseHeaderView.gestureRecognizers = nil;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAppraiseHeaderVie)];
    [self.appraiseHeaderView addGestureRecognizer:tap];
    self.appraiseHeaderViewHeightConstraint.constant = 2*self.appraiseTotalLabel.y + self.appraiseTotalLabel.height;
    
    //好评率
    NSString* goodPercentStr = [NSString stringWithFormat:@"%.0f%%",self.dc.productDetail.product_score_good];
    NSString* totalNumStr = [NSString stringWithFormat:@"%d人",self.dc.productDetail.product_score];
    NSString* appraiseTotalStr = [NSString stringWithFormat:@"好评率%@ %@评价",goodPercentStr,totalNumStr];
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:appraiseTotalStr];
    NSRange goodRange = [appraiseTotalStr rangeOfString:goodPercentStr];
    NSRange numRange = [appraiseTotalStr rangeOfString:totalNumStr];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:goodRange];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor gray006Color]} range:numRange];
    self.appraiseTotalLabel.attributedText = attStr;
    
    //添加Cell
    NSArray* scoreArray = self.dc.productDetail.scores;
    CGFloat currentY = 0;
    UINib* cellNib = [UINib nibWithNibName:@"ProductEvaluateTableViewCell" bundle:nil];
    for (ScoreItem* item in scoreArray) {
        ProductEvaluateModel* model = [ProductEvaluateModel new];
        model.evaluateContent = item.content;
        model.evaluateImageArray = item.imgs;
        model.evaluateScore = [NSString stringWithFormat:@"%d",item.score];
        NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:item.addtime];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        model.evaluateTime = [dateFormatter stringFromDate:createDate];
        model.evaluateUserName = item.nickname;
        
        CGFloat cellHeight = [ProductEvaluateTableViewCell getCellHeightWithContent:model];
        ProductEvaluateTableViewCell* cell = [[cellNib instantiateWithOwner:nil options:nil]firstObject];
        cell.delegate = self;
        cell.frame = CGRectMake(0, currentY, kScreenWidth, cellHeight);
        [cell setCellWithProductEvaluateModel:model];
        [cell setTopLineViewHidden:NO];
        [self.appraiseContentView addSubview:cell];
        currentY += cellHeight;
    }
    self.appraiseContentViewHeightConstraint.constant = currentY;
    
    self.appraiseView.height = self.appraiseHeaderViewHeightConstraint.constant + self.appraiseContentViewHeightConstraint.constant;
}

- (void)refreshGuessYouLikeView{
    [self.guessYouLikeLabel ajustHeightWithLimitWidth:kScreenWidth];
    self.guessYouLikeHeaderViewHeightConstraint.constant = 2*self.guessYouLikeLabel.y + self.guessYouLikeLabel.height;
    
    NSInteger kMaxNumOfGuessYouLike = 4;
    CGFloat itemWidth = (kScreenWidth -(kMaxNumOfGuessYouLike+1)*PIXEL_12) / kMaxNumOfGuessYouLike;
    CGFloat itemHeight = itemWidth + 45;
    for(int i = 0 ; i < self.dc.productDetail.likes.count && i < kMaxNumOfGuessYouLike; ++ i){
        LikeProductItem* item = [self.dc.productDetail.likes objectAtIndex:i];
        GuessYouLikeProductView* itemView = [[GuessYouLikeProductView alloc] initWithFrame:CGRectMake(PIXEL_12*(i+1)+itemWidth*i, PIXEL_12, itemWidth, itemHeight)];
        itemView.titleLabel.text = item.title;
        [itemView.imageView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];
        itemView.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,item.price];
        itemView.delegate = self;
        itemView.tag = i;
        [self.guessYouLikeContentView addSubview:itemView];
    }
    
    self.guessYouLikeContentViewHeightConstraint.constant = itemHeight + 2*PIXEL_12;
    self.guessYouLikeView.height = self.guessYouLikeHeaderViewHeightConstraint.constant + self.guessYouLikeContentViewHeightConstraint.constant;
}

-(void)refreshPopupCustomiseView{
    ProductDetailModel* productDetail = self.dc.productDetail;
    NSArray* specArray = productDetail.p_sids;
    
    //商品信息
    [self.popInfoImageView sd_setImageWithURL:[NSURL URLWithString:[productDetail.img_url firstObject]] placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];
    [self.popInfoPriceLabel themeWithPrice:productDetail.price bigFont:18 smallFont:14];
    
    //默认选中分类的索引
    NSString* curSpecStr = self.dc.productDetail.sids;
    NSMutableDictionary* curSpecDic = nil;
    if (curSpecStr.length > 0) {
        curSpecDic = [NSMutableDictionary new];
        NSArray* keyValueArray = [curSpecStr componentsSeparatedByString:@","];
        for (NSString* keyValue in keyValueArray) {
            NSArray* tmpArray = [keyValue componentsSeparatedByString:@":"];
            NSString* key = [tmpArray objectAtIndexIfIndexInBounds:0];
            NSString* value = [tmpArray objectAtIndexIfIndexInBounds:1];
            if (key && value) {
                [curSpecDic setValue:value forKey:key];
            }
        }
    }
    
    //创建分类视图
    self.popScrollContentHeight = 0;
    
    self.dicFromSepcDataToTitle = [NSMutableDictionary new];
    self.dicFromSepcTitleToButtons = [NSMutableDictionary new];
    
    for (SpecItem* specItem in specArray) {
        //标题
        self.popScrollContentHeight += PIXEL_8;
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGapXOfPopScrollView, self.popScrollContentHeight, kScreenWidth - 2*kGapXOfPopScrollView, 30)];
        titleLabel.text = specItem.name;
        titleLabel.textColor = [UIColor gray005Color];
        titleLabel.font = [UIFont systemFontOfSize:kFontOfPopScrollViewTitle];
        [titleLabel ajustHeightWithLimitWidth:kScreenWidth - 2*kGapXOfPopScrollView];
        [self.popScrollView addSubview:titleLabel];
        self.popScrollContentHeight += titleLabel.height;
        
        //选项
        NSString* curSpecValue = [curSpecDic objectForKey:specItem.name];
        CGFloat currentX = kGapXOfPopScrollView;
        CGFloat currentY = self.popScrollContentHeight + kGapXOfPopScrollView;
        NSMutableArray* optionButtonArray = [NSMutableArray new];
        for (NSString* str in specItem.data) {
            CGSize strSize = [str textSizeForOneLineWithFont:[UIFont systemFontOfSize:kFontOfPopScrollViewOption]];
            CGFloat buttonWidth = strSize.width + 2*kGapXInSpecOptionButton;
            CGFloat buttonHeight = strSize.height + 2*kGapYInSpecOptionButton;
            if (currentX + buttonWidth + kGapXOfPopScrollView > kScreenWidth) {
                currentX = kGapXOfPopScrollView;
                currentY += (buttonHeight + kGapYOfPopScrollView);
            }
            
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(currentX, currentY, buttonWidth, buttonHeight)];
            [button addTarget:self action:@selector(didSelectOptionInPopupCustomiseView:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:str forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:kFontOfPopScrollViewOption];
            [button setTitleColor:[UIColor fontGray006Color]];
            [button.layer setCornerRadius:3];
            [button setBorderWidth:1];
            [RACObserve(button, selected) subscribeNext:^(NSNumber* x) {
                if (x.boolValue) {
                    [button setTitleColor:[UIColor whiteColor]];
                    [button setBackgroundColor:[UIColor themeCyanColor]];
                    [button setBorderColor:[UIColor themeCyanColor]];
                }else{
                    [button setTitleColor:[UIColor gray006Color]];
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button setBorderColor:[UIColor lightGrayColor]];
                }
            }];
            
            //默认选中
            if (curSpecDic && [str isEqualToString:curSpecValue]) {
                button.selected = YES;
                curSpecValue = nil;
            }
            
            [self.popScrollView addSubview:button];
            [optionButtonArray addObject:button];
            
            currentX += (button.width + kGapXOfPopScrollView);
            self.popScrollContentHeight = currentY + buttonHeight;
        }
        
        //分割线
        self.popScrollContentHeight += kGapYOfPopScrollView;
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(kGapXOfPopScrollView, self.popScrollContentHeight, kScreenWidth - 2*kGapXOfPopScrollView, 1)];
        lineView.backgroundColor = [UIColor lineGray000Color];
        [self.popScrollView addSubview:lineView];
        self.popScrollContentHeight += lineView.height;
        
        //建立索引
        [self.dicFromSepcTitleToButtons setValue:optionButtonArray forKey:specItem.name];
        for (NSString* str in specItem.data) {
            [self.dicFromSepcDataToTitle setValue:specItem.name forKey:str];
        }
    }
    
    //数量
    self.popScrollContentHeight += kGapYOfPopScrollView;
    CGFloat kWidthOfEditNumberView = 150;
    EditNumberView* editNumerView = [[EditNumberView alloc] initWithFrame:CGRectMake(kScreenWidth - kGapXOfPopScrollView - kWidthOfEditNumberView, self.popScrollContentHeight, kWidthOfEditNumberView, 35)];
    editNumerView.min = @(0);
    editNumerView.num = self.buyNum;
    editNumerView.delegate = self;
    self.editNumerView = editNumerView;
    [self.popScrollView addSubview:editNumerView];
    UILabel* numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGapXOfPopScrollView, self.popScrollContentHeight, 100, 30)];
    numLabel.text = @"购买数量";
    numLabel.font = [UIFont systemFontOfSize:kFontOfPopScrollViewOption];
    numLabel.textColor = [UIColor gray005Color];
    numLabel.centerY = editNumerView.centerY;
    [self.popScrollView addSubview:numLabel];
    self.popScrollContentHeight += editNumerView.height;
    
    //分割线
    self.popScrollContentHeight += kGapYOfPopScrollView;
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(kGapXOfPopScrollView, self.popScrollContentHeight, kScreenWidth - 2*kGapXOfPopScrollView, 1)];
    lineView.backgroundColor = [UIColor lineGray000Color];
    [self.popScrollView addSubview:lineView];
    self.popScrollContentHeight += lineView.height;
    
    self.popScrollContentHeight += kGapYOfPopScrollView;
    self.popScrollView.contentSize = CGSizeMake(kScreenWidth, self.popScrollContentHeight);
    
    //根据内容高度，决定弹出视图高度
    CGFloat maxHeight = kScreenHeight - 20 - self.cycleScrollViewHeight;
    CGFloat preferHeight = self.popScrollContentHeight + self.popInfoView.height + self.popButtonView.height;
    if (preferHeight < maxHeight) {
        self.popupCustomiseView.height = preferHeight;
    }else{
        self.popupCustomiseView.height = maxHeight;
    }
    
    self.popupCustomiseView.width = kScreenWidth;
    
    //刷新选择提示
    [self refreshPopSelectTipView];
}

-(void)refreshPopSelectTipView{
    if (self.dc.productDetail.p_sids.count == 0) {
        self.popInfoSelectTipLabel.text = @"";
        self.isSelectSpecCompleted = YES;
        
        //刷新库存
        self.popInfoRemainNumLabel.text = [NSString stringWithFormat:@"库存 %d件",self.dc.productDetail.num];
        self.editNumerView.max = @(self.dc.productDetail.num);
        self.editNumerView.min = self.dc.productDetail.num > 0 ? @(1) : @(0);
    }else{
        
        NSMutableString* noSelectedTipStr = [NSMutableString new];
        NSMutableString* selectedTipStr = [NSMutableString new];
        NSMutableString* selectedSearchStr = [NSMutableString new];
        
        for (SpecItem* specItem in self.dc.productDetail.p_sids) {
            NSArray* buttons = [self.dicFromSepcTitleToButtons objectForKey:specItem.name];
            BOOL isSelected = NO;
            for (UIButton* button in buttons) {
                if (button.selected) {
                    isSelected = YES;
                    NSString* specValue = [button titleForState:UIControlStateNormal];
                    NSString* linkSymbol = selectedTipStr.length > 0 ? @"；":@"";
                    [selectedTipStr appendString:[NSString stringWithFormat:@"%@\"%@\"",linkSymbol,specValue]];
                    
                    NSString* linkSymbolForSearch = selectedSearchStr.length > 0 ? @",":@"";
                    [selectedSearchStr appendString:[NSString stringWithFormat:@"%@%@:%@",linkSymbolForSearch,specItem.name,specValue]];
                    
                    break;
                }
            }
            if (!isSelected) {
                [noSelectedTipStr appendString:[NSString stringWithFormat:@" %@",specItem.name]];
            }
        }
        if (noSelectedTipStr.length > 0) {
            self.popInfoSelectTipLabel.text = [NSString stringWithFormat:@"请选择%@",noSelectedTipStr];
            self.popInfoSelectTipLabel.textColor = [UIColor fontGray006Color];
            self.popInfoSelectTipLabel.font = [UIFont systemFontOfSize:15];
            self.isSelectSpecCompleted = NO;
            
            self.selectTipLabel.text = [NSString stringWithFormat:@"请选择%@",noSelectedTipStr];
            
            //刷新库存
            self.popInfoRemainNumLabel.text = [NSString stringWithFormat:@"库存 %d件",self.dc.productDetail.num];
            self.editNumerView.max = @(self.dc.productDetail.num);
            self.editNumerView.min = self.dc.productDetail.num > 0 ? @(1) : @(0);
        }else{
            self.popInfoSelectTipLabel.text = selectedTipStr;
            self.popInfoSelectTipLabel.textColor = [UIColor fontGray007Color];
            self.popInfoSelectTipLabel.font = [UIFont boldSystemFontOfSize:15];
            self.isSelectSpecCompleted = YES;
            
            self.selectTipLabel.text = [NSString stringWithFormat:@"已选:%@",selectedTipStr];
            self.specProductDescription = selectedTipStr;
            
            //刷新库存
            NSArray* specProductArray = self.dc.productDetail.p_iids;
            for (SpecProductItem* specProduct in specProductArray) {
                if ([specProduct.sids isEqualToString:selectedSearchStr]) {
                    self.specProduct = specProduct;
                    self.popInfoRemainNumLabel.text = [NSString stringWithFormat:@"库存 %d件",specProduct.num];
                    self.editNumerView.max = @(specProduct.num);
                    self.editNumerView.min = specProduct.num > 0 ? @(1) : @(0);
                    break;
                }
            }
        }
    }
}

-(void)showPopupCustomiseView{
    [self.popupCustomiseViewBackgroundView bringToFront];
    self.popupCustomiseView.x = 0;
    self.popupCustomiseView.y = self.popupCustomiseViewBackgroundView.height;
    self.popupCustomiseViewBackgroundView.hidden = NO;
    self.popupCustomiseViewBackgroundView.alpha = 0;
    [self.popupCustomiseViewBackgroundView layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.popupCustomiseView.y = self.popupCustomiseViewBackgroundView.height - self.popupCustomiseView.height;
        self.popupCustomiseViewBackgroundView.alpha = 1;
        [self.popupCustomiseViewBackgroundView layoutIfNeeded];
    }];
}

-(void)hidePopupCustomiseView:(Block)block{
    [UIView animateWithDuration:0.3 animations:^{
        self.popupCustomiseView.y = self.popupCustomiseViewBackgroundView.height;
        self.popupCustomiseViewBackgroundView.alpha = 0;
        [self.popupCustomiseViewBackgroundView layoutIfNeeded];
    }completion:^(BOOL finished) {
        if (finished) {
            self.popupCustomiseViewBackgroundView.hidden = YES;
            if(block){
                block();
            }
        }
    }];
}

#pragma mark - UI Action

- (void)didDragFromBottom {
    NSLog(@"上拉刷新");
    ProductDescriptionVC* descriptionVC = [[ProductDescriptionVC alloc] initWithHtmlString:self.dc.productDetail.description_p];
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:descriptionVC];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (IBAction)didClickReturnButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickFavoriteButtonAction:(id)sender {
    if (self.addFavoriteButton.selected == NO) {
        //收藏
        if (self.dc.productDetail.iid) {
            self.addFavoriteDC.productIds = @[self.dc.productDetail.iid];
            [self.addFavoriteDC requestWithArgs:nil];
        }else{
            [Utilities showToastWithText:@"商品不存在"];
        }
    }else{
        //取消收藏
        if (self.dc.productDetail.iid) {
            self.removeFavoriteDC.productIds = @[self.dc.productDetail.iid];
            [self.removeFavoriteDC requestWithArgs:nil];
        }else{
            [Utilities showToastWithText:@"商品不存在"];
        }
    }
}

- (IBAction)didClickCartButtonAction:(id)sender {
    [self showPopupCustomiseView];
}

- (IBAction)didClickBuyNowButtonAction:(id)sender {
    [self showPopupCustomiseView];
}

- (void)didClickSelectTipView {
    [self showPopupCustomiseView];
}

- (IBAction)didClickBuyGroupButtonAction:(id)sender {
    NSMutableArray* modelArray = [NSMutableArray new];
    // 主商品
    OrderItemModel *model = [[OrderItemModel alloc] init];
    model.productId = self.dc.productDetail.iid;
    model.productTitle = self.dc.productDetail.title;
    model.productImageUrl = [self.dc.productDetail.img_url firstObject];
    model.descriptionString = self.dc.productDetail.sids;
    model.productPrice = self.dc.productDetail.price;
    model.buyNum = self.buyNum;
    [modelArray addObject:model];
    
    // 套餐商品
    for (GroupContentItem* item in ((GroupItem *)[self.dc.productDetail.groups firstObject]).items) {
        OrderItemModel* submodel = [OrderItemModel new];
        submodel.productId = item.iid;
        submodel.productTitle = item.title;
        submodel.productImageUrl = item.img;
        submodel.descriptionString = @"";
        submodel.productPrice = item.price;
        submodel.buyNum = 1;
        [modelArray addObject:submodel];
    }
    
    OrderVC *vc = [[OrderVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setProductItemsArray:modelArray];
    [vc setGroupId:((GroupItem *)[self.dc.productDetail.groups firstObject]).pgp_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickAppraiseHeaderVie{
    ProductEvaluateVC *productEvaluateVC = [[ProductEvaluateVC alloc] initWithProductId:self.dc.productId];
    [self.navigationController pushViewController:productEvaluateVC animated:YES];
}

- (IBAction)didClickCustomiseBackgroundViewAction:(id)sender {
    [self hidePopupCustomiseView:nil];
}

- (IBAction)didClickCustomiseCloseButtonAction:(id)sender {
    [self hidePopupCustomiseView:nil];
}

- (IBAction)didClickAddCartButtonOnPopView:(id)sender {
    if (!self.isSelectSpecCompleted) {
        [Utilities showToastWithText:@"请选择商品种类"];
        return;
    }
    if (self.buyNum <= 0) {
        if (self.dc.productDetail.num == 0 && self.specProduct.num == 0) {
            [Utilities showToastWithText:@"库存不足"];
        }else{
            [Utilities showToastWithText:@"请选择商品数量"];
        }
        return;
    }
    NSString* productId = self.specProduct.iid ? self.specProduct.iid : self.dc.productDetail.iid;
    if (productId) {
        self.addCartDC.productIds = @[productId];
        self.addCartDC.cartNums = @[@(self.buyNum)];
        [self.addCartDC requestWithArgs:nil];
    }else{
        [Utilities showToastWithText:@"商品不存在"];
    }
}

- (IBAction)didClickBuyButtonOnPopView:(id)sender {
    if (!self.isSelectSpecCompleted) {
        [Utilities showToastWithText:@"请选择商品种类"];
        return;
    }
    if (self.buyNum <= 0) {
        if (self.dc.productDetail.num == 0 && self.specProduct.num == 0) {
            [Utilities showToastWithText:@"库存不足"];
        }else{
            [Utilities showToastWithText:@"请选择商品数量"];
        }
        return;
    }
    
    OrderItemModel *model = [[OrderItemModel alloc] init];
    if (self.specProduct) {
        model.productId = self.specProduct.iid;
        model.descriptionString = self.specProduct.sids;
    } else {
        model.productId = self.dc.productDetail.iid;
        model.descriptionString = self.dc.productDetail.sids;
    }
    
    //保证描述字段正确
    if (model.descriptionString.length == 0 && self.specProductDescription.length > 0) {
        model.descriptionString = self.specProductDescription;
    }
    
    model.productTitle = self.dc.productDetail.title;
    model.productImageUrl = [self.dc.productDetail.img_url firstObject];
    model.productPrice = self.dc.productDetail.price;
    model.buyNum = self.buyNum;
    
    OrderVC *vc = [[OrderVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setProductItemsArray:[NSMutableArray arrayWithObject:model]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectOptionInPopupCustomiseView:(UIButton*)sender{
    NSString* specData = [sender titleForState:UIControlStateNormal];
    NSString* specName = [self.dicFromSepcDataToTitle objectForKey:specData];
    NSArray* specButtons = [self.dicFromSepcTitleToButtons objectForKey:specName];
    for (UIButton* button in specButtons) {
        if (button != sender) {
            button.selected = NO;
        }else{
            button.selected = !button.selected;
        }
    }
    [self refreshPopSelectTipView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //隐藏或显示导航栏
    CGPoint point = scrollView.contentOffset;
    CGFloat originHeaderHeight = self.cycleScrollViewHeight;
    if (point.y < 0) {
        self.topBarBackgroundView.alpha = 0;
        self.topBarBackgroundView.layer.shadowOpacity = 0;
        [self.topBarBackButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    } else {
        self.topBarBackgroundView.alpha = ((point.y > originHeaderHeight) ? 1 : (point.y / originHeaderHeight ));
        self.topBarBackgroundView.layer.shadowOpacity = ((point.y > originHeaderHeight) ? 0.2 : (point.y / originHeaderHeight * 0.2));
        if (self.topBarBackgroundView.alpha < 1) {
            [self.topBarBackButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
        }else{
            [self.topBarBackButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
        }
    }
    
    //TODO-GUO:MJRefresh不好用，只能这样了
    CGFloat limit = self.scrollContentHeight > self.scrollView.height ? self.scrollContentHeight - self.scrollView.height + 80 : 80;
    if (point.y >=  limit && self.dc.productDetail.description_p.length > 0) {
        [self didDragFromBottom];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //TODO-GUO:点击放大
}

#pragma mark - GroupProductViewDelegate

-(void)groupProductView:(GroupProductView*)view didClickImageView:(UIImageView*)imageView{
    if (view != self.groupFirstProductView) {
        NSString* productId = nil;
        GroupItem* group = [self.dc.productDetail.groups firstObject];
        if(view.tag >= 0 && group.items.count > view.tag){
            GroupContentItem* item = [group.items objectAtIndex:view.tag];
            productId = item.iid;
        }
        if (productId) {
            ProductDetailVC* detailVC = [[ProductDetailVC alloc] initWithProductId:productId];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark - GuessYouLikeProductViewDelegate

-(void)guessYouLikeProductView:(GuessYouLikeProductView *)view didClickProduct:(id)model{
    LikeProductItem* item = [self.dc.productDetail.likes objectAtIndex:view.tag];
    ProductDetailVC* detailVC = [[ProductDetailVC alloc] initWithProductId:item.iid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - EditNumberViewDelegate

-(void)editNumberView:(EditNumberView *)view didChangeNum:(int)num{
    self.buyNum = num;
}

#pragma mark - ProductEvaluateTableViewCellDelegate

-(void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden = statusBarHidden;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [self hideLoadingView];
    if (controller == self.dc) {
        [self refreshUI];
    }else if(controller == self.addFavoriteDC){
        if (self.addFavoriteDC.code == 200) {
            [Utilities showToastWithText:@"添加收藏成功"];
            self.addFavoriteButton.selected = YES;
        }
    }else if(controller == self.removeFavoriteDC){
        if(self.removeFavoriteDC.code == 200){
            [Utilities showToastWithText:@"取消收藏成功"];
            self.addFavoriteButton.selected = NO;
        }
    }else if(controller == self.addCartDC){
        [self hidePopupCustomiseView:nil];
        switch (self.addCartDC.code) {
            case 200:
                [Utilities showToastWithText:@"添加购物车成功"];
                break;
            case 403:
                [Utilities showToastWithText:@"商品不存在或已下架"];
                break;
            case 101:
                [Utilities showToastWithText:@"需要登录"];
                break;
            default:
                break;
        }
    }
}
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [self hideLoadingView];
    if (controller == self.dc) {
        [Utilities showToastWithText:@"获取商品详情失败"];
    }else if(controller == self.addFavoriteDC){
        [Utilities showToastWithText:@"添加收藏失败"];
    }else if(controller == self.removeFavoriteDC){
        [Utilities showToastWithText:@"取消收藏失败"];
    }else if(controller == self.addCartDC){
        [self hidePopupCustomiseView:nil];
        [Utilities showToastWithText:@"添加购物车失败"];
    }
}

#pragma mark - Private Method

-(void)addScrollSubview:(UIView*)view{
    view.x = 0;
    view.y = self.scrollContentHeight;
    view.width = kScreenWidth;
    [self.scrollView addSubview:view];
    self.scrollContentHeight += view.height;
}

-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
