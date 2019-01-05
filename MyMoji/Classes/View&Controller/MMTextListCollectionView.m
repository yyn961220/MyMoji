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

#define kMMTextCellIdentifier @"MMTextCell"

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    MMTextListFlowLayout *flow = [[MMTextListFlowLayout alloc] init];
    flow.minimumLineSpacing         = 5;
    flow.minimumInteritemSpacing    = 5;
    
    
    self = [super initWithFrame:frame collectionViewLayout:flow];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.dataItems  = [NSMutableArray arrayWithArray:items];
        
        [self registerClass:[MMTextCell class] forCellWithReuseIdentifier:kMMTextCellIdentifier];
        
    }
    
    return self;
}

#pragma mark -------------> UICollectionView协议方法
/**
 *  自定义流布局item个数 要比数据源的个数多1 需要一个作为清除历史记录的行
 *
 *  @param collectionView 当前流布局视图
 *  @param section        nil
 *
 *  @return 自定义流布局item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataItems[section] count];
}


/**
 *  第index项的item的size大小
 *
 *  @param collectionView       当前流布局视图
 *  @param collectionViewLayout nil
 *  @param indexPath            item索引
 *
 *  @return size大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.row == _dataArr.count) {
    //        return CGSizeMake(self.frame.size.width, 40);
    //    }
    
    NSString *str      = self.dataItems[indexPath.section][indexPath.row];
    /* 根据每一项的字符串确定每一项的size */
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGSize size        = [str boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    size.height        = 40;
    size.width         += 10;
    return size;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //    [collectionView.collectionViewLayout invalidateLayout];
    return self.dataItems.count;
}


/**
 *  流布局的边界距离 上下左右
 *
 *
 *
 *  @return 边界距离值
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 5, 3, 3);
}


/**
 *  第index项的item视图
 *
 *  @param collectionView 当前流布局
 *  @param indexPath      索引
 *
 *  @return               item视图
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMMTextCellIdentifier forIndexPath:indexPath];
    //    for (UIView *vie in cell.contentView.subviews) {
    //        if ([vie isKindOfClass:[UILabel class]]) {
    //            [vie removeFromSuperview];
    //        }
    //    }
    //    if (indexPath.row == _dataArr.count) {
    //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    //        /* 判断最后一个item的内容 如果没有历史记录 内容就为暂无历史记录  否则为清除历史记录 */
    //        label.text = (_dataArr.count==0?(@"暂无历史记录"):(@"清除历史记录"));
    //        label.textAlignment = NSTextAlignmentCenter;
    //        [cell.contentView addSubview:label];
    //        return cell;
    //    }
    NSString *str                       = self.dataItems[indexPath.section][indexPath.row];
//    NSDictionary *dict                  = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    CGSize size                         = [str boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
//    UILabel *label                      =cell.textLabel;
//    label.frame = cell.bounds;
//    label.text                          = str;
//    label.font                          = [UIFont systemFontOfSize:18];
//    cell.contentView.layer.cornerRadius = 5;
//    cell.contentView.clipsToBounds      = YES;
//    cell.contentView.backgroundColor    = [UIColor colorWithRed:arc4random()%250/256.0 + 0.3 green:arc4random()%255/256.0+0.2  blue:arc4random()%250/255.0 + 0.1 alpha:0.7];
//    label.layer.borderColor             = [UIColor whiteColor].CGColor;
//    [cell.contentView addSubview:label];
    //    label.center                        = cell.contentView.center;
    
    cell.textLabel.text = str ;
    return cell;
}



/**
 *  当前点击的item的响应方法
 *
 *  @param collectionView 当前流布局
 *  @param indexPath      索引
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /* 响应回调block */
//    _itemClick(indexPath.row);
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(100, 50);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    if (!view) {
//        view = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    }
//    view.backgroundColor = [UIColor greenColor];
//    if (kind == UICollectionElementKindSectionHeader) {
//        return view;
//    }
//
//    return nil;
//
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
