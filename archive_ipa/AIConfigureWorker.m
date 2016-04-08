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

- (void)configProvisioningProfile
{
    NSString* commandFromat = @"perl -p -i -e \"s/PROVISIONING_PROFILE = *.*/PROVISIONING_PROFILE = \\\"\\\";/g\" %@/project.pbxproj";
    NSString* command = [NSString stringWithFormat:commandFromat,self.configInfo.appProjectPath];
    [self.executor executeCommand:command];
}

- (void)configTranslateAppName
{
    NSDictionary* appNames = self.configInfo.appName;
    NSString* commandFromat = @"perl -p -i -e \"s/CFBundleDisplayName = *.*/CFBundleDisplayName = \\\"%@\\\";/g\" %@";
    [appNames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString* path = [NSString stringWithFormat:self.configInfo.appTranslatePath,key];
        NSString* command = [NSString stringWithFormat:commandFromat,obj,path];
        //NSLog(@"configTranslateAppName command %@",command);
        [self.executor executeCommand:command];
    }];
    
    
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
    [self.executor executeCommand:resizeCommand];
    
    NSString* resizeLoginLogoCommand = [NSString stringWithFormat:resizeCommandFormat,180.0f,180.0f,self.configInfo.appIconSrcPath,self.configInfo.appLoginLogoPath];
    [self.executor executeCommand:resizeLoginLogoCommand];
    //NSLog(@"produceAppIcon %@",resizeLoginLogoCommand);
    
    NSString* temPicture = @"temp.png";
    NSString* compositeCommandFormat = @"composite %@ %@ %@";
    NSString* compositeCommand = [NSString stringWithFormat:compositeCommandFormat,self.configInfo.appIconSrcPath,self.configInfo.compositeLogoPath,temPicture];
    [self.executor executeCommand:compositeCommand];
    //NSLog(@"produceAppIcon %@",compositeCommand);
    NSString* commandFormat = @"convert -resize %dx%d %@ %@/%dx%d.png";
    NSString* commandFormat1 = @"convert -resize %dx%d %@ %@/%dx%d-1.png";
    int iconSize[10] = {29,40,58,76,80,87,120,152,167,180};
    for ( int i = 0; i < 10; i++) {
        NSString* command = [NSString stringWithFormat:commandFormat,
                             iconSize[i],
                             iconSize[i],
                             temPicture,
                             self.configInfo.appIconDstPath,
                             iconSize[i],
                             iconSize[i]];
        NSString* command1 = [NSString stringWithFormat:commandFormat1,
                             iconSize[i],
                             iconSize[i],
                             temPicture,
                             self.configInfo.appIconDstPath,
                             iconSize[i],
                             iconSize[i]];
        if (58 == iconSize[i] ||
            80 == iconSize[i] ||
            120 == iconSize[i]) {
            //NSLog(@"produceAppIcon %@",command1);
            [self.executor executeCommand:command1];
        }
        
        //NSLog(@"produceAppIcon %@",command);
        [self.executor executeCommand:command];
    }
    [self.executor executeCommand:[NSString stringWithFormat:@"rm %@",temPicture]];
}

- (void)produceLaunchImage
{
    NSString* temPicture = @"temp.png";
    NSString* iconPicture = @"iconTemp.png";
    CGSize sizes[6] = {CGSizeMake(640, 960),CGSizeMake(640, 1136),CGSizeMake(750, 1334),CGSizeMake(1024, 768),CGSizeMake(1242, 2208),CGSizeMake(2048, 1536)};
    for(int i = 0; i < 6; i++){
        CGSize size = sizes[i];
        NSString* resizeCommandFormat = @"convert -resize %.fx%.f! %@ %@";
        NSString* resizeCommand = [NSString stringWithFormat:resizeCommandFormat,size.width,size.height,self
                                   .configInfo.compositeLogoPath,self.configInfo.compositeLogoPath];
        [self.executor executeCommand:resizeCommand];
        //NSLog(@"produceLaunchImage %@",resizeCommand);
        
        CGFloat iconWidth =  rintf(sqrt(size.width * size.width + size.height * size.height) * 0.03);
        NSString* resizeIconCommand = [NSString stringWithFormat:resizeCommandFormat,iconWidth,iconWidth,self.configInfo.appIconSrcPath,iconPicture];
        [self.executor executeCommand:resizeIconCommand];
        
        NSString* drawIconCommandFormat = @"composite -gravity south  -geometry -%.f+50 %@ %@ %@";
        //NSString* iconPath = [self.configInfo.appIconDstPath stringByAppendingPathComponent:@"29x29.png"];
        NSString* drawIconCommand = [NSString stringWithFormat:drawIconCommandFormat,iconWidth,iconPicture,self.configInfo.compositeLogoPath,temPicture];
        //NSLog(@"produceLaunchImage %@",drawIconCommand);
        [self.executor executeCommand:drawIconCommand];
        
        
        //NSLog(@"width = %f",iconWidth);
        
        NSString* drawTextCommandFormat = @"convert %@ -fill gray  -font Times-Bold -pointsize %.f -gravity south -draw \"text %.f,48 '%@'\" %@/%.fx%.f.png";
        NSString* drawTextCommand = [NSString stringWithFormat:drawTextCommandFormat,temPicture,iconWidth,iconWidth + 10,self.configInfo.version,self.configInfo.appLaunchImagePath,size.width,size.height];
        [self.executor executeCommand:drawTextCommand];
        //NSLog(@"produceLaunchImage %@",drawText);
    }
    [self.executor executeCommand:[NSString stringWithFormat:@"rm %@",temPicture]];
    [self.executor executeCommand:[NSString stringWithFormat:@"rm %@",iconPicture]];
    [self.executor executeCommand:[NSString stringWithFormat:@"convert -resize %.fx%.f! %@ %@",256.0f,256.0f,self.configInfo.compositeLogoPath,self.configInfo.compositeLogoPath]];
}

- (void)setBundleDisplayName
{
    [self setPlistFileValue:self.configInfo.bundleDisplayName fromKey:@"CFBundleDisplayName" filePath:self.configInfo.appInfoListPath];
    [self setPlistFileValue:self.configInfo.version fromKey:@"CFBundleVersion" filePath:self.configInfo.appInfoListPath];
    [self setPlistFileValue:self.configInfo.version fromKey:@"CFBundleShortVersionString" filePath:self.configInfo.appInfoListPath];

}

- (void)configServerAddress
{
    [self setPlistFileValue:self.configInfo.serverAddress fromKey:@"Server address" filePath:self.configInfo.appConfigureListPath];
}


- (void)configCopyRightText
{
    [self setPlistFileValue:self.configInfo.copyright fromKey:@"Copyright" filePath:self.configInfo.appConfigureListPath];
    [self setPlistFileValue:self.configInfo.appName fromKey:@"AppName" filePath:self.configInfo.appConfigureListPath];
    [self setPlistFileValue:@(self.configInfo.visitorLoginEnable) fromKey:@"VisitorLoginEnable" filePath:self.configInfo.appConfigureListPath];
    [self setPlistFileValue:@(self.configInfo.guidePageEnable) fromKey:@"GuidePageEnable" filePath:self.configInfo.appConfigureListPath];
    if (self.configInfo.updateURL.length > 0) {
        [self setPlistFileValue:self.configInfo.updateURL fromKey:@"UpdateURL" filePath:self.configInfo.appConfigureListPath];
    }
}

- (void)configPushkey
{
    [self setPlistFileValue:self.configInfo.pushAppKey fromKey:@"APP_KEY" filePath:self.configInfo.appPushConfigListPath];
}

- (void)copyGuidePage
{
    if (!self.configInfo.guidePageEnable) {
        return;
    }
    for (int i = 0; i < 4; i++) {
        NSString* srcIphoneFileName = [NSString stringWithFormat:@"iPhone_Page%d.png",i+1];
        NSString* srcIphonePath = [self.configInfo.appGuidePageSrcPath stringByAppendingPathComponent:srcIphoneFileName];
        NSString* dstIphoneDictoryName = [NSString stringWithFormat:@"iPhone_Page%d.imageset",i+1];
        NSString* dstIphonePath = [self.configInfo.appGuidePageDstPath stringByAppendingPathComponent:dstIphoneDictoryName];
        
        NSString* copyCommandForIPhone = [NSString stringWithFormat:@"cp %@ %@",srcIphonePath,dstIphonePath];
        //NSLog(@"copyGuidePage %@",copyCommandForIPhone);
        [self.executor executeCommand:copyCommandForIPhone];
        
        NSString* srcIpadFileName = [NSString stringWithFormat:@"iPad_Page%d.png",i+1];
        NSString* srcIpadPath = [self.configInfo.appGuidePageSrcPath stringByAppendingPathComponent:srcIpadFileName];
        NSString* dstIpadDictoryName = [NSString stringWithFormat:@"iPad_Page%d.imageset",i+1];
        NSString* dstIpadPath = [self.configInfo.appGuidePageDstPath stringByAppendingPathComponent:dstIpadDictoryName];
        NSString* copyCommandForIPad = [NSString stringWithFormat:@"cp %@ %@",srcIpadPath,dstIpadPath];
        //NSLog(@"copyGuidePage %@",copyCommandForIPad);
        [self.executor executeCommand:copyCommandForIPad];
    }
}

- (BOOL)configure
{
    [self configBundleID];
    [self configProvisioningProfile];
    [self setBundleDisplayName];
    [self configServerAddress];
    [self configCopyRightText];
    [self configPushkey];
    [self configTranslateAppName];
    [self produceAppIcon];
    [self produceLaunchImage];
    [self copyGuidePage];
    return YES;
}

@end
