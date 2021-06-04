//
//  BWANRDetailViewController.m
//  BWANRManage
//
//  Created by bairdweng on 2018/6/16.
//

#import "BWANRDetailViewController.h"

const CGFloat fontSize = 8.f;

@interface BWANRDetailViewController ()

@property (nonatomic, strong) UILabel *anrTimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *anrInfo;
@property (nonatomic, strong) UIScrollView *textScrollView;

@end

@implementation BWANRDetailViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"复制" style:UIBarButtonItemStylePlain target:self action:@selector(clickOntheCopy)];

	self.view.backgroundColor = [UIColor whiteColor];
	self.anrInfo = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
	self.title = [NSString stringWithFormat:@"%@ms",_anrInfo[@"duration"]];
	self.textScrollView.frame = self.view.bounds;
	[self.view addSubview:self.textScrollView];
	// 文本内容
	NSString *contentText = _anrInfo[@"content"];
	CGFloat labelWidth = CGRectGetWidth(self.view.frame) - 40;
	CGFloat labelHeight = 0;
	CGRect rect = [contentText boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
	labelHeight = rect.size.height;
	self.contentLabel.text = contentText;
	self.contentLabel.frame = CGRectMake(20, 20, labelWidth,labelHeight);
	[self.textScrollView addSubview:self.contentLabel];
	self.textScrollView.contentSize = CGSizeMake(0, labelHeight + 40);
}

- (void)clickOntheCopy {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.contentLabel.text;
	NSString *lastTitle = self.title.copy;
	self.title = @"已复制到粘贴板";
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.title = lastTitle;
	});
}
- (UIScrollView *)textScrollView {
	if (!_textScrollView) {
		_textScrollView = [UIScrollView new];
	}
	return _textScrollView;
}

- (UILabel *)contentLabel {
	if (!_contentLabel) {
		_contentLabel = [UILabel new];
		_contentLabel.textColor = [UIColor blackColor];
		_contentLabel.font = [UIFont systemFontOfSize:fontSize];
		_contentLabel.numberOfLines = 0;
	}
	return _contentLabel;
}
@end
