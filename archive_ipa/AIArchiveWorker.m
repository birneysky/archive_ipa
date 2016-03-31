//
//  AIArchiveWorker.m
//  archive_ipa
//
//  Created by birneysky on 16/3/28.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "AIArchiveWorker.h"
#import "CommandExecutor.h"
#import "AIAppConfigInfo.h"

@interface AIArchiveWorker ()

@property (nonatomic,strong) CommandExecutor* executor;

@property (nonatomic,strong) AIAppConfigInfo* configInfo;

@end

@implementation AIArchiveWorker


#pragma mark - *** Properties ***
- (CommandExecutor*)executor
{
    if (!_executor) {
        _executor = [[CommandExecutor alloc] init];
    }
    return _executor;
}

#pragma mark - *** ***
- (instancetype)initWithAppConfigInfo:(AIAppConfigInfo*)info
{
    if (self = [super init]) {
        _configInfo = info;
    }
    return self;
}

#pragma mark - *** Helper ***
- (void)compileProject
{
    NSString* command = [NSString stringWithFormat:@"xcodebuild -project %@ -sdk iphoneos -configuration Release  CODE_SIGN_IDENTITY=\"%@\" PROVISIONING_PROFILE=%@ clean build",self.configInfo.appProjectPath,self.configInfo.certificateName,self.configInfo.provisioningProfile];
    NSLog(@"compileProject %@",command);
    [self.executor executeCommand:command];
}

- (void)exportIpaFile
{
    NSString* commandFormat = @"xcrun -sdk iphoneos PackageApplication -v \"%@/V2_Conference.app\" -o %@";
    NSString* command = [NSString stringWithFormat:commandFormat,self.configInfo.productsPath,self.configInfo.ipaFilePath];
    NSLog(@"exportIpaFile %@",command);
    [self.executor executeCommand:command];
}

- (BOOL)archive
{
//    [self compileProject];
//    [self exportIpaFile];
    return YES;
}

@end
