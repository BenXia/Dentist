//
//  PPDataCache.h
//  Dentist
//
//  Created by Ben on 1/10/16.
//  Copyright (c) 2016 Dentist. All rights reserved.

#import <Foundation/Foundation.h>

@interface PPDataCache : NSObject

@property (nonatomic, strong) NSFileManager *fileManager;

+ (PPDataCache *)sharedPPDataCache;

- (NSString *)cacheForKey:(NSString *)key;
- (void)setCache:(NSString *)cache forKey:(NSString *)key;
- (void)removeCacheForKey:(NSString *)key;
- (void)removeAllCaches;

@end
