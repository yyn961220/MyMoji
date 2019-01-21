//
//  MMTextCollectionCell.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMTextCollectionCell.h"


@interface MMTextCollectionCell ()

@property (nonatomic,strong) UILabel * textLabel;  //cell中的文

@end

@implementation MMTextCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.layer.borderWidth =1;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.contentMode = UIViewContentModeCenter;
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:THE_COLLECTION_ITEM_FONT_SIZE];
        
        [self.contentView addSubview:label];
        self.textLabel = label;
        
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:label];
    self.textLabel = label;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
}
@end
