//
//  DoraemonPingThread.h
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

// 参考ONEANRTracker

#import <Foundation/Foundation.h>

typedef void (^DoraemonANRTrackerBlock)(NSDictionary *info);

/**
 *  用于Ping主线程的线程类
 *  通过信号量控制来Ping主线程，判断主线程是否卡顿
 */
@interface BWPingThread : NSThread

/**
 *  初始化Ping主线程的线程类
 *  @param handler   监控到卡顿回调
 */
- (instancetype)initWithThresholdHandler:(DoraemonANRTrackerBlock)handler;

@end
