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

static const CGFloat kProductDetailVCTopImageRatio = 16.f/9;
static const CGFloat kHeightOfSectionHeader = 12;
static const CGFloat kGapXOfPopScrollView = 12;
static const CGFloat kGapYOfPopScrollView = 12;
static const CGFloat kFontOfPopScrollViewTitle = 12;
static const CGFloat kFontOfPopScrollViewOption = 12;
static const NSString* kYuanSymbolStr = @"￥";

@interface ProductDetailVC () <
SDCycleScrollViewDelegate,
PPDataControllerDelegate,
GroupProductViewDelegate,
EditNumberViewDelegate,
UIScrollViewDelegate>

@property (nonatomic, strong) ProductDetailDC *dc;


@property (weak, nonatomic) IBOutlet UIView *topBarBackgroundView;

@property (weak,nonatomic)  IBOutlet UIScrollView* scrollView;
@property (assign,nonatomic) CGFloat scrollContentHeight;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (assign, nonatomic) CGFloat cycleScrollViewHeight;

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

@property (strong, nonatomic) IBOutlet UIView *groupDiscountView;
@property (weak, nonatomic) IBOutlet UILabel *groupReducePriceLabel;
@property (weak, nonatomic) IBOutlet UIView *groupBuyView;
@property (weak, nonatomic) IBOutlet UIButton *groupBuyButton;
@property (weak, nonatomic) IBOutlet UILabel *groupPayPriceLabel;
@property (weak, nonatomic) IBOutlet GroupProductView *groupFirstProductView;
@property (weak, nonatomic) IBOutlet GroupProductView *groupSecondProductView;
@property (weak, nonatomic) IBOutlet GroupProductView *groupThirdProductView;
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

@property (strong,nonatomic) NSMutableDictionary* dicFromSepcTitleToButtons;
@property (strong,nonatomic) NSMutableDictionary* dicFromSepcDataToTitle;

@end

@implementation ProductDetailVC

#pragma mark - Life Circle

-(instancetype)initWithProductId:(NSString*)productId{
    self = [super init];
    if (self) {
        self.dc = [[ProductDetailDC alloc]initWithDelegate:self];
        self.dc.productId = productId;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
    
    [self.dc requestWithArgs:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UI Init

- (void)initUIReleated {
    [self.navigationController setNavigationBarHidden:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavBar];
    [self initMainScrollView];
    [self initHeaderImageView];
    [self initBaseInfoView];
    [self initGroupDiscountView];
    [self initPopupCustomiseView];
}

- (void)initNavBar{
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
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.autoScrollTimeInterval = 10;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"ic_top_blank.png"];
    _cycleScrollView.needChangeHeight = YES;
}

- (void)initMainScrollView {
    self.scrollView.backgroundColor = [UIColor bgGray002Color];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.scrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.scrollView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.scrollView.headerPullToRefreshText = @"下拉刷新";
    self.scrollView.headerReleaseToRefreshText = @"松开就可以刷新了";
    self.scrollView.headerRefreshingText = @"正在刷新";
    
    self.scrollView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.scrollView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.scrollView.footerRefreshingText = @"正在加载中";
}

-(void)initBaseInfoView{

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
    if (self.dc.productDetail.groups > 0) {
        [self refreshGroupDiscountView];
        [self addScrollSubview:self.groupDiscountView];
        self.scrollContentHeight += kHeightOfSectionHeader;
    }
    
    //赠品
    //分类
    //评价
    //上拉提示
    
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
        
    }
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.hidden=NO;
}

-(void)refreshBaseInfoView{
    ProductDetailModel* productDetail = self.dc.productDetail;
    self.baseTitleLabel.text = productDetail.title;
    self.baseSubtitleLabel.text = productDetail.title_fu;
    
    [self themePriceLabel:self.basePriceLabel withPrice:productDetail.price bigFont:18 smallFont:14];

    self.baseOldPriceLabel.text = [NSString stringWithFormat: @"%.2f",productDetail.old_price];
    
    //调整高度
    CGFloat limitWidth = kScreenWidth - 2*self.baseTitleLabelLeadingConstraint.constant;
    [self.baseTitleLabel ajustHeightWithLimitWidth:limitWidth];
    [self.baseSubtitleLabel ajustHeightWithLimitWidth:limitWidth];
    self.baseInfoView.height = self.baseTitleLabelTopConstraint.constant + self.baseTitleLabel.height + self.baseSubtitleLabelTopConstraint.constant + self.baseSubtitleLabel.height + self.basePriceViewHeightConstraint.constant + self.baseDeliverViewHeightConstraint.constant * 3 + self.baseTitleLabelTopConstraint.constant;
}

-(void)refreshGroupDiscountView{
    GroupItem* firstGroup = [self.dc.productDetail.groups firstObject];
    NSArray* groupProductViewArray = @[self.groupSecondProductView,self.groupThirdProductView];
    
    double totalPrice = self.dc.productDetail.price;
    for (NSInteger i=0; i < firstGroup.items.count; ++i) {
        GroupContentItem* item  = [firstGroup.items objectAtIndex:i];
        GroupProductView* view = [groupProductViewArray objectAtIndex:i];
        [view.imageView sd_setImageWithURL:[NSURL URLWithString:item.img]];
        view.titleLabel.text = item.title;
        view.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,item.price];
        totalPrice += item.price;
    }
    
    self.groupReducePriceLabel.text = [NSString stringWithFormat:@"%.2f",totalPrice - firstGroup.price];
    self.groupPayPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,firstGroup.price];
    
    //默认选中主商品
    self.groupFirstProductView.selected = YES;
}

-(void)refreshPopupCustomiseView{
    ProductDetailModel* productDetail = self.dc.productDetail;
    NSArray* specArray = productDetail.p_sids;
    
    //商品信息
    [self.popInfoImageView sd_setImageWithURL:[NSURL URLWithString:[productDetail.img_url firstObject]]];
    [self themePriceLabel:self.popInfoPriceLabel withPrice:productDetail.price bigFont:18 smallFont:14];

    //分类
    self.popScrollContentHeight = PIXEL_8;
    CGFloat kGapXInButton = 4;
    CGFloat kGapYInButton = 3;

    self.dicFromSepcDataToTitle = [NSMutableDictionary new];
    self.dicFromSepcTitleToButtons = [NSMutableDictionary new];

    for (SpecItem* specItem in specArray) {
        //标题
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kGapXOfPopScrollView, self.popScrollContentHeight, 100, 30)];
        titleLabel.text = specItem.name;
        titleLabel.textColor = [UIColor gray005Color];
        titleLabel.font = [UIFont systemFontOfSize:kFontOfPopScrollViewTitle];
        [self.popScrollView addSubview:titleLabel];
        self.popScrollContentHeight += titleLabel.height;
        
        //选项
        CGFloat currentX = kGapXOfPopScrollView;
        CGFloat currentY = self.popScrollContentHeight + kGapXOfPopScrollView;
        NSMutableArray* optionButtonArray = [NSMutableArray new];
        for (NSString* str in specItem.data) {
            CGSize strSize = [str textSizeForOneLineWithFont:[UIFont systemFontOfSize:kFontOfPopScrollViewOption]];
            CGFloat buttonWidth = strSize.width + 2*kGapXInButton;
            CGFloat buttonHeight = strSize.height + 2*kGapYInButton;
            if (currentX + buttonWidth + kGapXOfPopScrollView > kScreenWidth) {
                currentX = kGapXOfPopScrollView;
                currentY += (buttonHeight + kGapYOfPopScrollView);
            }
            
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(currentX, currentY, buttonWidth, buttonHeight)];
            [button addTarget:self action:@selector(didSelectOptionInPopupCustomiseView:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:str forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:kFontOfPopScrollViewOption];
            [button setTitleColor:[UIColor fontGray006Color]];
            [button circular:3];
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
    EditNumberView* editNumerView = [[EditNumberView alloc] initWithFrame:CGRectMake(kScreenWidth - kGapXOfPopScrollView - 100, self.popScrollContentHeight, 100, 30)];
    [editNumerView resetWithMin:@(1) max:nil default:@(1)];
    editNumerView.delegate = self;
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
    NSMutableString* noSelectedTipStr = [NSMutableString new];
    NSMutableString* selectedTipStr = [NSMutableString new];

    for (SpecItem* specItem in self.dc.productDetail.p_sids) {
        NSArray* buttons = [self.dicFromSepcTitleToButtons objectForKey:specItem.name];
        BOOL isSelected = NO;
        for (UIButton* button in buttons) {
            if (button.selected) {
                isSelected = YES;
                NSString* linkSymbol = selectedTipStr.length > 0 ? @"":@"";
                [selectedTipStr appendString:[NSString stringWithFormat:@"%@\"%@\"",linkSymbol,[button titleForState:UIControlStateNormal]]];
                break;
            }
        }
        if (!isSelected) {
            [noSelectedTipStr appendString:[NSString stringWithFormat:@" %@",specItem.name]];
        }
    }
    if (noSelectedTipStr.length > 0) {
        self.popInfoSelectTipLabel.text = [NSString stringWithFormat:@"请选择%@",noSelectedTipStr];
    }else{
        self.popInfoSelectTipLabel.text = [NSString stringWithFormat:@"已选择:%@",selectedTipStr];
        
        //TODO-GUO:刷新价格和库存
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

- (void)headerRereshing {
    
}

- (void)footerRereshing {
    
}
- (IBAction)didClickReturnButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickFavoriteButtonAction:(id)sender {
    
}

- (IBAction)didClickCartButtonAction:(id)sender {
    [self showPopupCustomiseView];
}

- (IBAction)didClickBuyNowButtonAction:(id)sender {
    [self showPopupCustomiseView];
}

- (IBAction)didClickCustomiseBackgroundViewAction:(id)sender {
    [self hidePopupCustomiseView:nil];
}

- (IBAction)didClickCustomiseCloseButtonAction:(id)sender {
    [self hidePopupCustomiseView:nil];
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
    } else {
        self.topBarBackgroundView.alpha = ((point.y > (originHeaderHeight - 60)) ? 1 : (point.y / (originHeaderHeight - 60)));
        self.topBarBackgroundView.layer.shadowOpacity = ((point.y > (originHeaderHeight - 60)) ? 0.2 : (point.y / (originHeaderHeight - 60) * 0.2));
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //TODO-GUO:点击放大
}

#pragma mark - GroupProductViewDelegate

-(void)groupProductView:(GroupProductView*)view didClickImageView:(UIImageView*)imageView{
    //点击了套餐优惠里的一项
    //    double totalPrice = self.dc.productDetail.price;
    //    NSArray* groupContentItems = (NSArray*)[self.dc.productDetail.groups firstObject];
    //    if (view == self.groupSecondProductView) {
    //        GroupContentItem* item = [groupContentItems objectAtIndexIfIndexInBounds:0];
    //        totalPrice += item.price;
    //    }else{
    //        GroupContentItem* item = [groupContentItems objectAtIndexIfIndexInBounds:1];
    //        totalPrice += item.price;
    //    }
    //    self.groupReducePriceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,totalPrice];
}

#pragma mark - EditNumberViewDelegate

-(void)editNumberView:(EditNumberView *)view didMinusNum:(int)num{
    
}

-(void)editNumberView:(EditNumberView *)view didAddNum:(int)num{
    
}

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [self refreshUI];
}
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [Utilities showToastWithText:@"获取商品详情失败"];
}

#pragma mark - Private Method

-(void)addScrollSubview:(UIView*)view{
    view.x = 0;
    view.y = self.scrollContentHeight;
    view.width = kScreenWidth;
    [self.scrollView addSubview:view];
    self.scrollContentHeight += view.height;
}

-(void)themePriceLabel:(UILabel*)label withPrice:(double)price bigFont:(CGFloat)bigFont smallFont:(CGFloat)smallFont{
    label.font = [UIFont systemFontOfSize:smallFont];
    NSString* bigStr = [NSString stringWithFormat:@"%.0f",price];
    NSString* allStr = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,price];
    NSRange bigRange = [allStr rangeOfString:bigStr];
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:bigFont]} range:bigRange];
    label.attributedText = attStr;
}

@end
