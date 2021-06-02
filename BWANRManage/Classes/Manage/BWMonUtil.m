//
//  BWMonUtil.m
//  BWANRManage
//
//  Created by bairdweng on 2021/6/2.
//

#import "BWMonUtil.h"
static NSString * const kDoraemonANRTrackKey = @"doraemon_anr_track_key";

@implementation BWMonUtil
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
