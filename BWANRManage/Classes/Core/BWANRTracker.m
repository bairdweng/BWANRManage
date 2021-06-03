//
//  BWANRTracker.m
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import "BWANRTracker.h"
#import "sys/utsname.h"

/**
 *  主线程卡顿监控看门狗类
 */
@interface BWANRTracker ()

/**
 *  用于Ping主线程的线程实例
 */
@property (nonatomic, strong) BWPingThread *pingThread;

@end

@implementation BWANRTracker

- (instancetype)init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (void)startWithThreshold:(double)threshold
        handler:(DoraemonANRTrackerBlock)handler {

	self.pingThread = [[BWPingThread alloc] initWithThreshold:threshold
	                   handler:^(NSDictionary *info) {
	                           handler(info);
			   }];

	[self.pingThread start];
}

- (void)stop {
	if (self.pingThread != nil) {
		[self.pingThread cancel];
		self.pingThread = nil;
	}
}

- (DoraemonANRTrackerStatus)status {
	if (self.pingThread != nil && self.pingThread.isCancelled != YES) {
		return DoraemonANRTrackerStatusStart;
	}else {
		return DoraemonANRTrackerStatusStop;
	}
}

- (void)dealloc {
	[self.pingThread cancel];
}

@end
