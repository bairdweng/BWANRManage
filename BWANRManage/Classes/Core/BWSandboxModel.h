//
//  DoraemonSandboxModel.h
//  BWANRManage
//
//  Created by yixiang on 2017/12/11.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DoraemonSandboxFileType) {
    DoraemonSandboxFileTypeDirectory = 0,//目录
    DoraemonSandboxFileTypeFile,//文件
    DoraemonSandboxFileTypeBack,//返回
    DoraemonSandboxFileTypeRoot,//根目录
};

@interface BWSandboxModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) DoraemonSandboxFileType type;

@end
