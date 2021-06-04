//
//  BWMonUtil.m
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import "BWMonUtil.h"
static NSString * const kDoraemonANRTrackKey = @"doraemon_anr_track_key";
static NSString * const BWANRTimeTrackKey = @"BWANRTimeTrackKey";

@implementation BWMonUtil

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
        _threshold = [BWMonUtil thresholdTime];
    }
    return self;
}


+ (NSString *)dateFormatNow {
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [formatter stringFromDate: date];
	return dateString;
}

+ (void)saveANRTrackSwitch:(BOOL)on {
	[[NSUserDefaults standardUserDefaults] setBool:on forKey:kDoraemonANRTrackKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

/// 设置卡顿阀值
+ (void)setThresholdTime:(double)time {
	[BWMonUtil sharedInstance].threshold = time;
	[[NSUserDefaults standardUserDefaults] setDouble:time forKey:BWANRTimeTrackKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (double)thresholdTime {
	double value =  [[[NSUserDefaults standardUserDefaults]objectForKey:BWANRTimeTrackKey]doubleValue];
	return value > 0 ? value : 0.5;
}

+ (BOOL)isOn {
	return [[[NSUserDefaults standardUserDefaults]objectForKey:kDoraemonANRTrackKey]boolValue];
}

+ (void)saveANRInfo:(NSDictionary *)info {
	if ([info isKindOfClass:[NSDictionary class]] && (info.count > 0)) {
		NSFileManager *manager = [NSFileManager defaultManager];
		NSString *anrDirectory = [self anrDirectory];
		if (anrDirectory && [manager fileExistsAtPath:anrDirectory]) {
			// 获取 ANR 保存的路径
			NSString *anrPath = [anrDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ANR %@.plist", info[@"title"]]];
			[info writeToFile:anrPath atomically:YES];
		}
	}
}

+ (NSString *)anrDirectory {
	NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
	NSString *directory = [cachePath stringByAppendingPathComponent:@"ANR"];

	NSFileManager *manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:directory]) {
		[manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
	}

	return directory;
}


@end
