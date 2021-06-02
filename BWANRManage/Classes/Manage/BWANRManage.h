//
//  BWANRManage.h
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DoraemonANRManagerBlock)(NSDictionary *anrInfo);

@interface BWANRManage : NSObject

+ (instancetype)sharedInstance;

/// 初始化安装
/// @param timeOut 卡顿时间s
- (void)installTimeOut:(CGFloat)timeOut;
/// 打开
/// @param vc 当前控制器
- (void)opeANRVcTarget:(UIViewController *)vc;

/// 不建议直接调用
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
