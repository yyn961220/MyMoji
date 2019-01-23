//
//  MMFavoriteManager.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/15.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMFavoriteManager.h"

#define kMMFavoritePlistFileName @"MMFavorite.plist"

@interface MMFavoriteManager ()
@property (nonatomic,strong) NSMutableArray *favoriteList;
@end

@implementation MMFavoriteManager

+ (instancetype)shareManager{
    static MMFavoriteManager *theManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theManager = [[MMFavoriteManager alloc] init];
    });
    return theManager ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (NSArray *)favoriteItems{
    return _favoriteList;
}

- (void)initData{
    self.favoriteList = [NSMutableArray arrayWithContentsOfFile:[self pathForFavoriteConfig]];
    if (!self.favoriteList) {
        self.favoriteList = [NSMutableArray array];
    }
}

- (void)writeToFileNow{
    [_favoriteList writeToFile:[self pathForFavoriteConfig] atomically:YES];
}

- (NSString *)pathForFavoriteConfig{
     // 获取Library的目录路径
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [libDir stringByAppendingPathComponent:kMMFavoritePlistFileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        BOOL succeed = [[NSMutableArray array] writeToFile:path atomically:YES];
        if (!succeed) {
//            NSLog(@"should create a file here");
        }
    }
    return path;
}

- (BOOL)containsItem:(NSString *)item{
    return [self.favoriteList containsObject:item];
}

- (void)addFavoriteItem:(NSString *)item{
    if ((item.length == 0) && [self containsItem:item]) {
        return;
    }
    
    [_favoriteList addObject:item];
    [self writeToFileNow];
}

- (void)removeFavoriteItem:(NSString *)item{
    if ((item.length == 0) && (![self containsItem:item])) {
        return;
    }
    
    [_favoriteList removeObject:item];
    [self writeToFileNow];
}
@end
