//
//  PPDataCache.m
//  Dentist
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataCache.h"
#import "NSString+Additions.h"

@interface PPDataCache ()

- (NSString *)cacheDirectoryPath;

@end

@implementation PPDataCache
@synthesize fileManager = _fileManager;

SINGLETON_GCD(PPDataCache);

- (id)init
{
    if (self = [super init]) {
        self.fileManager = [[NSFileManager alloc] init];
        
        [self removeAllCaches];
    }
    
    return self;
}

- (void)dealloc
{
    self.fileManager = nil;
}

- (NSString *)cacheDirectoryPath
{
    NSString *cacheDirectoryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DataControllerCache"];
    
    if ([self.fileManager fileExistsAtPath:cacheDirectoryPath] == NO) {
        if ([self.fileManager createDirectoryAtPath:cacheDirectoryPath
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:nil] == NO) {
            return nil;
        }
    }
    
    return cacheDirectoryPath;
}

- (NSString *)cacheForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    NSString *cachePath = [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
    
    if (cachePath == nil) {
        return nil;
    }
    
    if ([self.fileManager fileExistsAtPath:cachePath] == NO) {
        return nil;
    } else {
        return [NSString stringWithContentsOfFile:cachePath 
                                         encoding:NSUTF8StringEncoding 
                                            error:nil];
    }
}

- (void)setCache:(NSString *)cache forKey:(NSString *)key
{
    NSString *cachePath = [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
    
    if (cachePath != nil) {
        // 删除已经存在的
        if ([self.fileManager fileExistsAtPath:cachePath]) {
            [self.fileManager removeItemAtPath:cachePath 
                                         error:nil];
        }
        
        if ([self.fileManager fileExistsAtPath:cachePath] == NO 
            && cache != nil) {
            
            NSAssert([cache isKindOfClass:[NSString class]], @"必须是字符串");
            
            BOOL result = [cache writeToFile:cachePath
                                  atomically:YES
                                    encoding:NSUTF8StringEncoding
                                       error:nil];
            
            NSLog(@"write cache file result: %d", result);
        }
    }
}

- (void)removeCacheForKey:(NSString *)key
{
    NSString *cachePath = [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
    
    if (cachePath != nil 
        && [self.fileManager fileExistsAtPath:cachePath] == YES) {
        [self.fileManager removeItemAtPath:cachePath 
                                     error:nil];
    }
}

- (void)removeAllCaches
{
    [self.fileManager removeItemAtPath:[self cacheDirectoryPath]
                                 error:nil];
}

@end
