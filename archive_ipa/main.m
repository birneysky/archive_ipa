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


void printErrorInfo()
{
    NSLog(@"\narchive_ipa options:\n  -ipa bundleName  produce ipa file\n  -config BundleName configure .xcodeproj file,produce app icon, set bundle ID by app_config.plist");
    exit(0);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* option = nil;
        NSString* arguments = nil;
        if (3 == argc ) {
            option = [[NSString alloc] initWithUTF8String:argv[1]];
            arguments = [[NSString alloc] initWithUTF8String:argv[2]];
            if (!([option isEqualToString:@"-ipa"] || [option isEqualToString:@"-config"])) {
                printErrorInfo();
            }
        }
        else if(1 != argc){
            printErrorInfo();
        }
        
        NSDictionary* config =  [NSDictionary dictionaryWithContentsOfFile:@"app_config.plist"];
        NSArray* appConfigs = [config objectForKey:@"AppConfig"];
        NSArray* bundleIDs = [config objectForKey:@"BundleIDS"];
        NSArray* certificates = [config objectForKey:@"Certificates"];
        NSDictionary* pathes = [config objectForKey:@"Paths"];
        for (NSInteger i = 0; i < appConfigs.count; i++) {
            NSDictionary* appItem = appConfigs[i];
            NSUInteger bundleIDIndex = [[appItem objectForKey:@"BundleIdentifier"] unsignedIntegerValue];
            NSDictionary* bundleIDItem = bundleIDs[bundleIDIndex];
            NSUInteger certificateIndex = [[bundleIDItem objectForKey:@"Certificate"] unsignedIntegerValue];
            NSString* bundleID =  [bundleIDItem objectForKey:@"BundleID"];
            AIAppConfigInfo* configInfo = [[AIAppConfigInfo alloc] init];
            configInfo.bundleIdentifier = bundleID;
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
            configInfo.appPushConfigListPath = [pathes objectForKey:@"AppPushConfigListPath"];
            configInfo.appConfigureListPath = [pathes objectForKey:@"AppConfigureListPath"];
            configInfo.appLaunchImagePath = [pathes objectForKey:@"AppLaunchImagePath"];
            configInfo.appInfoListPath = [pathes objectForKey:@"AppInfoListPath"];
            configInfo.compositeLogoPath = [pathes objectForKey:@"CompositeLogoPath"];
            configInfo.productsPath = [pathes objectForKey:@"ProductsPath"];
            
            if ([option isEqualToString:@"-config"] && [bundleID isEqualToString:arguments]) {
                AIConfigureWorker* configWorker = [[AIConfigureWorker alloc] initWithAppConfigInfo:configInfo];
                [configWorker configure];
                break;
            }
            else if (([option isEqualToString:@"-ipa"] && [bundleID isEqualToString:arguments])|| 1 == argc)
            {
                AIConfigureWorker* configWorker = [[AIConfigureWorker alloc] initWithAppConfigInfo:configInfo];
                [configWorker configure];
                
                AIArchiveWorker* archiveWorker = [[AIArchiveWorker alloc] initWithAppConfigInfo:configInfo];
                [archiveWorker archive];
            }
        }

    }
    return 0;
}
