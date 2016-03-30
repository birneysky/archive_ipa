//
//  AIArchiveWorker.h
//  archive_ipa
//
//  Created by birneysky on 16/3/28.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 1. 编译
 2. 导出 ipa 文件
 */

@class AIAppConfigInfo;

@interface AIArchiveWorker : NSObject

- (instancetype)initWithAppConfigInfo:(AIAppConfigInfo*)info;

- (BOOL)archive;

@end
