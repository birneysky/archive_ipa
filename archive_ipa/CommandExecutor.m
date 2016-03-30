//
//  CommandExecutor.m
//  archive_ipa
//
//  Created by zhangguang on 16/3/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "CommandExecutor.h"

@implementation CommandExecutor

- (BOOL)executeCommand:(NSString*)command
{
    if (0 == system(command.UTF8String)) {
        return YES;
    }
    NSLog(@"%@ exit",command);
    exit(0);
    return NO;
}

@end
