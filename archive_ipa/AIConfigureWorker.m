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
#import <AppKit/AppKit.h>

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
    NSString* commandFromat = @"perl -p -i -e \"s/PRODUCT_BUNDLE_IDENTIFIER = *.*/PRODUCT_BUNDLE_IDENTIFIER = %@;/g\" %@/project.pbxproj";
    NSString* command = [NSString stringWithFormat:commandFromat,self.configInfo.bundleIdentifier,self.configInfo.appProjectPath];
    [self.executor executeCommand:command];
    //[self setPlistFileValue:self.configInfo.bundleIdentifier fromKey:@"CFBundleIdentifier" filePath:self.configInfo.appInfoListPath];
}

- (void)produceAppIcon
{
    /*
     29,40,58,76,80,87,120,152,167,180
     
     2 个  58  80 120
     */
    NSImage* image = [[NSImage alloc] initByReferencingFile:self.configInfo.appIconSrcPath];
    //NSLog(@"produceAppIcon %p,src %@",image,self.configInfo.appIconSrcPath);
    CGFloat appIconWidth = image.size.width;
    CGFloat appIconHeight = image.size.height;
    
    NSString* resizeCommandFormat = @"convert -resize %fx%f %@ %@";
    NSString* resizeCommand = [NSString stringWithFormat:resizeCommandFormat,appIconWidth,appIconHeight,self
                               .configInfo.compositeLogoPath,self.configInfo.compositeLogoPath];
    //[self.executor executeCommand:resizeCommand];
    NSLog(@"produceAppIcon %@",resizeCommand);
    
    NSString* temPicture = @"temp.png";
    NSString* compositeCommandFormat = @"composite %@ %@ %@";
    NSString* compositeCommand = [NSString stringWithFormat:compositeCommandFormat,self.configInfo.appIconSrcPath,self.configInfo.compositeLogoPath,temPicture];
    //[self.executor executeCommand:compositeCommand];
    NSLog(@"produceAppIcon %@",compositeCommand);
//    NSString* commandFormat = @"convert -resize %dx%d %@ %@/%dx%d.png";
//    NSString* commandFormat1 = @"convert -resize %dx%d %@ %@/%dx%d-1.png";
//    int iconSize[10] = {29,40,58,76,80,87,120,152,167,180};
//    for ( int i = 0; i < 10; i++) {
//        NSString* command = [NSString stringWithFormat:commandFormat,
//                             iconSize[i],
//                             iconSize[i],
//                             temPicture,
//                             self.configInfo.appIconDstPath,
//                             iconSize[i],
//                             iconSize[i]];
//        NSString* command1 = [NSString stringWithFormat:commandFormat1,
//                             iconSize[i],
//                             iconSize[i],
//                             temPicture,
//                             self.configInfo.appIconDstPath,
//                             iconSize[i],
//                             iconSize[i]];
//        if (58 == iconSize[i] ||
//            80 == iconSize[i] ||
//            120 == iconSize[i]) {
//            NSLog(@"produceAppIcon %@",command1);
//            [self.executor executeCommand:command1];
//        }
//        
//        NSLog(@"produceAppIcon %@",command);
//        [self.executor executeCommand:command];
//    }
    //[self.executor executeCommand:[NSString stringWithFormat:@"rm %@",temPicture]];
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

- (void)configPushkey
{
    [self setPlistFileValue:self.configInfo.pushAppKey fromKey:@"APP_KEY" filePath:self.configInfo.appPushConfigListPath];
}

- (BOOL)configure
{
//    [self configBundleID];
//    [self setBundleDisplayName];
//    [self configServerAddress];
//    [self configCopyRightText];
//    [self configPushkey];
    [self produceAppIcon];
    return YES;
}

@end
