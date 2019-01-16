//
//  MMTextTableViewCell.h
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/16.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMMTextTableViewCellIdentifier  @"kMMTextTableViewCell"

@interface MMTextTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *name;
@end

NS_ASSUME_NONNULL_END
