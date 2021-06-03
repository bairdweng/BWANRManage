//
//  BWANRTracker.h
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

// 参考ONEANRTracker

#import <Foundation/Foundation.h>
#import "BWPingThread.h"

//ANR监控状态枚举
typedef NS_ENUM(NSUInteger, DoraemonANRTrackerStatus) {
    DoraemonANRTrackerStatusStart, //监控开启
    DoraemonANRTrackerStatusStop,  //监控停止
};

/**
 *  主线程卡顿监控类
 */
@interface BWANRTracker : NSObject

/**
 *  开始监控
 *
 *  @param threshold 卡顿阈值
 *  @param handler   监控到卡顿回调(回调时会自动暂停卡顿监控)
 */
- (void)startWithThreshold:(double)threshold
                   handler:(DoraemonANRTrackerBlock)handler;

/**
 *  停止监控
 */
- (void)stop;

/**
 *  ANR监控状态
 */
- (DoraemonANRTrackerStatus)status;

@end
