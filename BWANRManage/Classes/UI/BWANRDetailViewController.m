//
//  BWANRDetailViewController.m
//  DoraemonKit-DoraemonKit
//
//  Created by bairdweng on 2018/6/16.
//

#import "BWANRDetailViewController.h"
#import "DoraemonDefine.h"

@interface BWANRDetailViewController ()

@property (nonatomic, strong) UILabel *anrTimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *anrInfo;

@end

@implementation BWANRDetailViewController

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	_contentLabel.frame = CGRectMake(20, 50, CGRectGetWidth(self.view.bounds)  - 40, CGRectGetHeight(self.view.bounds) - 50);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.anrInfo = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
	self.title = [NSString stringWithFormat:@"anr time : %@ms",_anrInfo[@"duration"]];
	_contentLabel = [UILabel new];
	_contentLabel.textColor = [UIColor blackColor];
	_contentLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(16)];
	_contentLabel.numberOfLines = 0;
	_contentLabel.text = _anrInfo[@"content"];
	[self.view addSubview:_contentLabel];

}
@end
