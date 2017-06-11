//
//  GZOrderDetailHeader.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/8.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZOrderDetailHeader.h"
#import <WebKit/WebKit.h>


@interface GZOrderDetailHeader ()<SDCycleScrollViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;


@property (nonatomic, strong) UIWebView *webView;

//此标识符表示当用户未收藏时，让collectionBtn为未选中状态，判断只走一次
@property (nonatomic) NSInteger index;

- (IBAction)collectBtn:(UIButton *)sender;

@end

@implementation GZOrderDetailHeader

+ (instancetype)createCycleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailHeaderView" owner:nil options:nil] lastObject];
}

-(BuyCountView *)buyCountView
{
    if (!_buyCountView) {
        
        _buyCountView = [[BuyCountView alloc] initWithFrame:CGRectMake(kScreenWidth - 131, 6, 124, 32)];
        
        //点击数量的block回调，如果countNum为空，说明用户没选，数量为1
        GZWeakSelf;
        _buyCountView.countChangeClickBlock = ^(NSString * countNum) {
            
            if (weakSelf.NoClassDataChangeCountNumberBlock) {
                weakSelf.NoClassDataChangeCountNumberBlock(countNum);
            }
        };
        
    }
    return _buyCountView;
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.lineLabel.bottom + 10, kScreenWidth, 200)];

        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;

        [self addSubview:_webView];
    }
    return _webView;
}

#pragma mark - 收藏点击事件 -
- (IBAction)collectBtn:(UIButton *)sender {
    
    if ([_dataModel.C_Is_shoucang isEqualToString:@"0"] && _index == 1) {
        sender.selected = YES;
        _index ++;
    }
    
    sender.selected = !sender.selected;
    
    if (_collectBtnClickBlock) {
        _collectBtnClickBlock(sender.selected,sender);
    }
}

-(void)setDataModel:(GZOrderDetailDataModel *)dataModel
{
    _dataModel = dataModel;
    
    _index = 1;
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSString *imgStr in dataModel.p_logos) {
        [dataArr addObject:[NSString stringWithFormat:@"%@%@",YUMING,imgStr]];
    }
    
    self.cycleView.imageURLStringsGroup = dataArr;
    [self setUpCycleAttribute];
  
    [self.countView addSubview:self.buyCountView];
    
    if ([dataModel.C_Is_shoucang isEqualToString:@"1"]) {
        
        [self.collectionBtn setImage:[UIImage imageNamed:@"yishoucang_"] forState:UIControlStateNormal];
    }else
    {
        [self.collectionBtn setImage:[UIImage imageNamed:@"weishoucang_"] forState:UIControlStateNormal];
    }
    
    self.titleLabel.text = dataModel.p_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",dataModel.p_price];
  //  self.taxLabel.text = [NSString stringWithFormat:@"(%@)",dataModel.is];
    
    if ([dataModel.isjifen_back isEqualToString:@"0"]) {
        self.integralLabel.hidden = YES;
    }

    NSString *webContent = [NSString stringWithFormat:@"<!doctype html><html>\n<meta charset=\"utf-8\"><style type=\"text/css\">body{ padding:0; margin:0;}\n.view_h1{ width:90%%; margin:0 auto; display:block; overflow:hidden; font-size:1.1em; color:#333; padding:0.5em 0; line-height:1.0em; }\n.con{ width:90%%; margin:0 auto; color:#fff; color:#666; padding:0.5em 0; overflow:hidden; display:block; font-size:0.92em; line-height:1.8em;}\n.con h1,h2,h3,h4,h5,h6{ font-size:1em;}\nimg{ width:auto; max-width: 100%% !important;height:auto !important;margin:0 auto;display:block;}\n*{ max-width:100%% !important;}\n</style>\n<body style=\"padding:0; margin:0; \"><div class=\"con\">%@</div></body></html>",[NSString stringWithFormat:@"%@",dataModel.p_info]];
    
    [self.webView loadHTMLString:webContent baseURL:nil];
}

- (void)setUpCycleAttribute
{
    self.cycleView.delegate = self;
    self.cycleView.currentPageDotImage = [UIImage imageWithColor:YHRGBA(130, 130, 130, 1.0) forSize:CGSizeMake(10, 2)];
    self.cycleView.pageDotImage = [UIImage imageWithColor:YHRGBA(231, 230, 230, 1.0) forSize:CGSizeMake(10, 2)];
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 获取webView的高度
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];

    CGRect newFrame = webView.frame;
    
    newFrame.size.height= webViewHeight;
    webView.frame= newFrame;
    
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    scrollView.contentSize = CGSizeMake(0, webViewHeight + self.lineLabel.y);
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSString *imgStr in self.dataModel.p_logos) {
        [dataArr addObject:[NSString stringWithFormat:@"%@%@",YUMING,imgStr]];
    }
    
    if (_addShoppSelectCycleScrollBlock) {
        _addShoppSelectCycleScrollBlock(dataArr[index]);
    }
}

@end
