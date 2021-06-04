//
//  BWMonUtil.h
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BWMonUtil : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic, assign) double threshold;

+ (NSString *)dateFormatNow;
/// 保存状态
+ (void)saveANRTrackSwitch:(BOOL)on;
/// 保存信息
+ (void)saveANRInfo:(NSDictionary *)info;
/// 目录
+ (NSString *)anrDirectory;
+ (BOOL)isOn;
/// 设置卡顿阀值
+ (void)setThresholdTime:(double)time;
+ (double)thresholdTime;
@end

NS_ASSUME_NONNULL_END
