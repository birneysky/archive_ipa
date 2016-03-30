//
//  CommandExecutor.h
//  archive_ipa
//
//  Created by zhangguang on 16/3/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandExecutor : NSObject

- (BOOL)executeCommand:(NSString*)command;

@end
