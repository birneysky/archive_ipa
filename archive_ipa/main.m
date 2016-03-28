//
//  main.m
//  archive_ipa
//
//  Created by zhangguang on 16/3/28.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NSLog(@"%s",argv[0]);
        NSDictionary* config =  [NSDictionary dictionaryWithContentsOfFile:@"app_config.plist"];
        NSLog(@"config info %@",config);
    }
    return 0;
}
