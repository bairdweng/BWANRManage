//
//  BWANRManage.m
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import "BWANRManage.h"
#import "BWMonUtil.h"
#import "DoraemonANRTracker.h"
#import "BWANRViewController.h"
@interface BWANRManage ()

@property (nonatomic, strong) DoraemonANRTracker *doraemonANRTracker;
@property (nonatomic, copy) DoraemonANRManagerBlock block;
/// 卡顿时间
@property (nonatomic, assign) CGFloat timeOut;
@property (nonatomic, assign) BOOL anrTrackOn;

@end

@implementation BWANRManage

+ (instancetype)sharedInstance {
	static id instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

- (void)installTimeOut:(CGFloat)timeOut {
	_doraemonANRTracker = [[DoraemonANRTracker alloc] init];
	_timeOut = timeOut;
	_doraemonANRTracker = [[DoraemonANRTracker alloc] init];
	_anrTrackOn = [BWMonUtil isOn];
	if (_anrTrackOn) {
		[self start];
	}
	else {
		[self stop];
		// 如果是关闭的话，删除上一次的卡顿记录
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[BWMonUtil anrDirectory] error:nil];
	}
}
- (void)opeANRVcTarget:(UIViewController *)vc {
	BWANRViewController *anrVc = [BWANRViewController new];
	UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:anrVc];
	[vc presentViewController:navi animated:YES completion:nil];
}

- (void)addANRBlock:(DoraemonANRManagerBlock)block {
	self.block = block;
}

- (void)start {
	if (!_doraemonANRTracker) {
		NSLog(@"插件未安装");
		return;
	}
	__weak typeof(self) weakSelf = self;
	[self.doraemonANRTracker startWithThreshold:self.timeOut handler:^(NSDictionary *info) {
	         __strong typeof(weakSelf) strongSelf = weakSelf;
	         [strongSelf dumpWithInfo:info];
	 }];
}

- (void)dumpWithInfo:(NSDictionary *)info {
	if (![info isKindOfClass:[NSDictionary class]]) {
		return;
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.block) {
			self.block(info);
		}
		[BWMonUtil saveANRInfo:info];
	});
}

- (void)dealloc {
	[self stop];
}

- (void)stop {
	[self.doraemonANRTracker stop];
}

- (void)setAnrTrackOn:(BOOL)anrTrackOn {
	_anrTrackOn = anrTrackOn;
	[BWMonUtil saveANRTrackSwitch:anrTrackOn];
}

@end
