//
//  MMTextTableViewCell.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/16.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMTextTableViewCell.h"

#define defaultTableCellColor rgba(74, 178, 232, 1)

@interface MMTextTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation MMTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 60, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = rgba(130, 130, 130, 1);
        self.name.highlightedTextColor = defaultTableCellColor;
        
        self.name.contentMode = UIViewContentModeCenter;
        self.name.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.name];
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, 45)];
        self.yellowView.backgroundColor = defaultTableCellColor;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    self.name.frame = CGRectMake(5, 0, size.width - 10, size.height);
    self.yellowView.frame = CGRectMake(0, 0, 5, size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : rgba(240, 240, 240, 0.8);
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
