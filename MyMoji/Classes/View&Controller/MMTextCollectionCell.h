//
//  MMTextCollectionCell.h
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMMTextCollectionCellIdentifier  @"kMMTextCollectionCell"

@interface MMTextCollectionCell : UICollectionViewCell
@property (readonly, nonatomic) UILabel * textLabel;  //cell中的文
@end

NS_ASSUME_NONNULL_END
