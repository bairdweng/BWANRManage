//
//  BWANRManage.m
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import "BWANRManage.h"
#import "BWMonUtil.h"
#import "BWANRTracker.h"
#import "BWANRViewController.h"
@interface BWANRManage ()

@property (nonatomic, strong) BWANRTracker *anrTracker;
@property (nonatomic, copy) BWANRManagerBlock block;

@property (nonatomic, strong) UIWindow *entryWindow;

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

- (instancetype)init {
	self = [super init];
	if (self) {
		BWANRViewController *anrVc = [BWANRViewController new];
		UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:anrVc];
		self.entryWindow.rootViewController = navi;
	}
	return self;
}

- (void)install {
	_anrTracker = [[BWANRTracker alloc] init];
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
/// 打开
- (void)show {
	self.entryWindow.hidden = NO;
	[UIView animateWithDuration:0.3 animations:^{
	         self.entryWindow.frame = UIScreen.mainScreen.bounds;
	 }];
}
/// 关闭面板
- (void)dissShow {
	CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
	CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
	[UIView animateWithDuration:0.3 animations:^{
	         self.entryWindow.frame = CGRectMake(0, height, width, height);
	 } completion:^(BOOL finished) {
	         if (finished) {
			 self.entryWindow.hidden = YES;
		 }
	 }];
}

- (void)addANRBlock:(BWANRManagerBlock)block {
	self.block = block;
}

- (void)start {
	if (!_anrTracker) {
		NSLog(@"插件未安装");
		return;
	}
	__weak typeof(self) weakSelf = self;
	[self.anrTracker startWithThresholdhandler:^(NSDictionary *info) {
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
	[self.anrTracker stop];
}

- (void)setAnrTrackOn:(BOOL)anrTrackOn {
	_anrTrackOn = anrTrackOn;
	[BWMonUtil saveANRTrackSwitch:anrTrackOn];
}

#pragma mark Getter
- (UIWindow *)entryWindow {
	if (!_entryWindow) {
		CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
		CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
		_entryWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, height, width, height)];
		// 设置为最高级别
		_entryWindow.windowLevel = UIWindowLevelStatusBar + 100.f;
		// 默认为隐藏
		_entryWindow.hidden = YES;
	}
	return _entryWindow;
}

@end
