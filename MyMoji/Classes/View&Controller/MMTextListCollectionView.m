//
//  MMTextListCollectionView.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMTextListCollectionView.h"
#import "MMTextListFlowLayout.h"
#import "MMTextCell.h"

@interface MMTextListCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
}

@end

@implementation MMTextListCollectionView
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    MMTextListFlowLayout *flow = [[MMTextListFlowLayout alloc] init];
    flow.minimumLineSpacing         = 5;
    flow.minimumInteritemSpacing    = 5;
    
    
    self = [super initWithFrame:frame collectionViewLayout:flow];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        
        
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
