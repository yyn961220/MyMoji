//
//  MMTextCollectionCell.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMTextCollectionCell.h"
#define defaultCollectionCellColor rgba(253, 210, 42, 1)

@interface MMTextCollectionCell ()

@property (nonatomic,strong) UILabel * textLabel;  //cell中的文

@end

@implementation MMTextCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        label.contentMode = UIViewContentModeCenter;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        
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
    self.textLabel.layer.cornerRadius = 3.0f;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.layer.borderColor = defaultCollectionCellColor.CGColor;
        self.layer.borderWidth = 1.0f;
        self.contentView.backgroundColor = defaultCollectionCellColor;
    }else{
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0.0f;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setHighlighted:selected];
}
@end
