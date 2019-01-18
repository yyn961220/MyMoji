//
//  MMTextListFlowLayout.h
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTextListFlowLayout : UICollectionViewFlowLayout
-(instancetype)initWithArray:(NSMutableArray*)widthArray edgeInsets:(UIEdgeInsets)insets;

@property (nonatomic,strong) NSMutableArray<NSArray *> *widthArray;
@end

NS_ASSUME_NONNULL_END
