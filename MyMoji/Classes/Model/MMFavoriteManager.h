//
//  MMFavoriteManager.h
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/15.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMFavoriteManager : NSObject
@property (nonatomic,readonly) NSArray *favoriteItems;
+ (instancetype)shareManager;

- (BOOL)containsItem:(NSString *)item;
- (void)addFavoriteItem:(NSString *)item;
- (void)removeFavoriteItem:(NSString *)item;
@end

NS_ASSUME_NONNULL_END
