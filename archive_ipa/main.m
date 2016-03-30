//
//  main.m
//  archive_ipa
//
//  Created by zhangguang on 16/3/28.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIAppConfigInfo.h"
#import "AIArchiveWorker.h"
#import "AIConfigureWorker.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDictionary* config =  [NSDictionary dictionaryWithContentsOfFile:@"app_config.plist"];
        NSArray* appConfigs = [config objectForKey:@"AppConfig"];
        NSArray* bundleIDs = [config objectForKey:@"BundleIDS"];
        NSArray* certificates = [config objectForKey:@"Certificates"];
        NSDictionary* pathes = [config objectForKey:@"Paths"];
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < appConfigs.count; i++) {
            NSDictionary* appItem = appConfigs[i];
            NSUInteger bundleIDIndex = [[appItem objectForKey:@"BundleIdentifier"] unsignedIntegerValue];
            NSDictionary* bundleIDItem = bundleIDs[bundleIDIndex];
            NSUInteger certificateIndex = [[bundleIDItem objectForKey:@"Certificate"] unsignedIntegerValue];
            AIAppConfigInfo* configInfo = [[AIAppConfigInfo alloc] init];
            configInfo.bundleIdentifier = [bundleIDItem objectForKey:@"BundleID"];
            configInfo.certificateName = [certificates objectAtIndex:certificateIndex];
            configInfo.pushAppKey = [bundleIDItem objectForKey:@"PushAppKey"];
            configInfo.provisioningProfile = [bundleIDItem objectForKey:@"ProvisioningProfile"];
            configInfo.ipaFilePath = [appItem objectForKey:@"IpaFilePath"];
            configInfo.appIconSrcPath = [appItem objectForKey:@"AppIconSrcPath"];
            configInfo.bundleDisplayName = [appItem objectForKey:@"BundleDisplayName"];
            configInfo.serverAddress = [appItem objectForKey:@"ServerAddress"];
            configInfo.copyright = [appItem objectForKey:@"Copyright"];
            configInfo.visitorLoginEnable = [[appItem objectForKey:@"VisitorLoginEnable"] boolValue];
            configInfo.appIconSrcPath = [appItem objectForKey:@"AppIconSrcPath"];
            configInfo.appProjectPath = [pathes objectForKey:@"AppProjectPath"];
            configInfo.appIconDstPath = [pathes objectForKey:@"AppIconDstPath"];
            configInfo.appConfigureListPath = [pathes objectForKey:@"AppConfigureListPath"];
            configInfo.appLaunchImagePath = [pathes objectForKey:@"AppLaunchImagePath"];
            configInfo.appInfoListPath = [pathes objectForKey:@"AppInfoListPath"];
            configInfo.productsPath = [pathes objectForKey:@"ProductsPath"];
            
            
            AIConfigureWorker* configWorker = [[AIConfigureWorker alloc] initWithAppConfigInfo:configInfo];
            [configWorker configure];
            
            AIArchiveWorker* archiveWorker = [[AIArchiveWorker alloc] initWithAppConfigInfo:configInfo];
            [archiveWorker archive];
            
            [array addObject:configInfo];
        }
        
        
        
       // NSLog(@"config info %@",config);
    }
    return 0;
}
