//
//  MMTextTableViewCell.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/16.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMTextTableViewCell.h"

#define defaultColor rgba(253, 212, 49, 1)

@interface MMTextTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation MMTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = rgba(130, 130, 130, 1);
        self.name.highlightedTextColor = defaultColor;
        
        self.name.contentMode = UIViewContentModeCenter;
        self.name.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:self.name];
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, 45)];
        self.yellowView.backgroundColor = defaultColor;
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
    self.name.frame = CGRectMake(10, 10, size.width - 10, size.height);
    self.yellowView.frame = CGRectMake(0, 5, 5, size.height - 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
