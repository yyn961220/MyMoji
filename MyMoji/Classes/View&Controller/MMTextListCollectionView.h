//
//  MMTextListCollectionView.h
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTextListCollectionView : UICollectionView
@property (nonatomic,strong) NSArray *items;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items ;
@end

NS_ASSUME_NONNULL_END
