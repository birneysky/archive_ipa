//
//  AIAppConfigInfo.h
//  archive_ipa
//
//  Created by zhangguang on 16/3/29.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIAppConfigInfo : NSObject

@property (nonatomic,copy) NSString* bundleIdentifier;
@property (nonatomic,copy) NSString* productsPath;
@property (nonatomic,copy) NSString* ipaFilePath;
@property (nonatomic,copy) NSString* appIconSrcPath;
@property (nonatomic,copy) NSString* bundleDisplayName;
@property (nonatomic,copy) NSString* serverAddress;
@property (nonatomic,assign) BOOL visitorLoginEnable;
@property (nonatomic,copy) NSString* certificateName;
@property (nonatomic,copy) NSString* pushAppKey;
@property (nonatomic,copy) NSString* provisioningProfile;
@property (nonatomic,copy) NSString* appConfigureListPath;
@property (nonatomic,copy) NSString* appIconDstPath;
@property (nonatomic,copy) NSString* appLaunchImagePath;
@property (nonatomic,copy) NSString* appProjectPath;
@property (nonatomic,copy) NSString* appInfoListPath;
@property (nonatomic,copy) NSString* appPushConfigListPath;
@property (nonatomic,copy) NSString* compositeLogoPath;
@property (nonatomic,copy) NSString* appLoginLogoPath;
@property (nonatomic,copy) NSString* appTranslatePath;
@property (nonatomic,copy) NSDictionary* copyright;
@property (nonatomic,copy) NSDictionary* appName;

@end
