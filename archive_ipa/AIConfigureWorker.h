//
//  AIConfigureWorker.h
//  archive_ipa
//
//  Created by birneysky on 16/3/28.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 1.修改Bundle id
 2.生成各种size的AppIcon
 3.生成各种size的LaunchImage
 4.修改Bundle display name
 5.修改Server Address
 6.修改CopyRight
 */

@class AIAppConfigInfo;

@interface AIConfigureWorker : NSObject

- (instancetype)initWithAppConfigInfo:(AIAppConfigInfo*)info;

- (BOOL)configure;

@end
