//
//  AIConfigureWorker.m
//  archive_ipa
//
//  Created by birneysky on 16/3/28.
//  Copyright © 2016年 com.github. All rights reserved.
//

#import "AIConfigureWorker.h"
#import "CommandExecutor.h"
#import "AIAppConfigInfo.h"

@interface AIConfigureWorker ()

@property (nonatomic,strong) CommandExecutor* executor;


@property (nonatomic,strong) AIAppConfigInfo* configInfo;

@end

@implementation AIConfigureWorker

#pragma mark - *** Properties ***
- (CommandExecutor*)executor
{
    if (!_executor) {
        _executor = [[CommandExecutor alloc] init];
    }
    return _executor;
}

#pragma mark - *** Init ***

- (instancetype)initWithAppConfigInfo:(AIAppConfigInfo*)info
{
    if (self = [super init]) {
        _configInfo = info;
    }
    return self;
}

#pragma mark - *** Helper ***

- (void)setPlistFileValue:(id)value fromKey:(NSString*)key filePath:(NSString*)path
{
    NSMutableDictionary* infoData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [infoData setObject:value forKey:key];
    [infoData writeToFile:path atomically:NO];
}

- (void)configBundleID
{
    [self setPlistFileValue:self.configInfo.bundleIdentifier fromKey:@"CFBundleIdentifier" filePath:self.configInfo.appInfoListPath];
}

- (void)produceAppIcon
{
    /*
     29,40,58,76,80,87,120,152,167,180
     
     2 个  58  80 120
     */
    
    NSString* commandFormat = @"convert -resize %dx%d %@ %@/%dx%d.png";
    NSString* commandFormat1 = @"convert -resize %dx%d %@ %@/%dx%d-1.png";
    int iconSize[10] = {29,40,58,76,80,87,120,152,167,180};
    for ( int i = 0; i < 10; i++) {
        NSString* command = [NSString stringWithFormat:commandFormat,
                             iconSize[i],
                             iconSize[i],
                             self.configInfo.appIconSrcPath,
                             self.configInfo.appIconDstPath,
                             iconSize[i],
                             iconSize[i]];
        NSString* command1 = [NSString stringWithFormat:commandFormat1,
                             iconSize[i],
                             iconSize[i],
                             self.configInfo.appIconSrcPath,
                             self.configInfo.appIconDstPath,
                             iconSize[i],
                             iconSize[i]];
        if (58 == iconSize[i] ||
            80 == iconSize[i] ||
            120 == iconSize[i]) {
            NSLog(@"produceAppIcon %@",command1);
            [self.executor executeCommand:command1];
        }
        
        NSLog(@"produceAppIcon %@",command);
        [self.executor executeCommand:command];
    }
}

- (void)produceLaunchImage
{
    
}

- (void)setBundleDisplayName
{
    [self setPlistFileValue:self.configInfo.bundleDisplayName fromKey:@"CFBundleDisplayName" filePath:self.configInfo.appInfoListPath];
}

- (void)configServerAddress
{
    [self setPlistFileValue:self.configInfo.serverAddress fromKey:@"Server address" filePath:self.configInfo.appConfigureListPath];
}


- (void)configCopyRightText
{
    [self setPlistFileValue:self.configInfo.copyright fromKey:@"Copyright" filePath:self.configInfo.appConfigureListPath];
}

- (BOOL)configure
{
    [self configBundleID];
    [self setBundleDisplayName];
    [self configServerAddress];
    [self configCopyRightText];
    [self produceAppIcon];
    return YES;
}

@end
