//
//  BWANRManage.h
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BWANRManagerBlock)(NSDictionary *anrInfo);

@interface BWANRManage : NSObject

+ (instancetype)sharedInstance;

/// 初始化安装
- (void)install;
/// 打开
- (void)show;
/// 关闭面板
- (void)dissShow;

/// 不建议直接调用
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
