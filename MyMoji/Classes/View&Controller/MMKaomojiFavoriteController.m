//
//  MMKaomojiFavoriteController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/16.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiFavoriteController.h"
#import "MMTextListFlowLayout.h"

#import "MMFavoriteManager.h"

#import "MMTextCollectionCell.h"

//#import "SCLAlertView.h"

@interface MMKaomojiFavoriteController ()<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>{
}
@property (nonatomic,strong)NSArray *dataItems;
@property (nonatomic,strong) NSMutableDictionary *itemSizes;

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MMKaomojiFavoriteController
@synthesize collectionView = _collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self updateTitleWithText:nil];
    
    [self initTableAndCollecionView];
    
    [self updateDataIfNeed];
}
- (void)initTableAndCollecionView{
    if (!_collectionView){
        MMTextListFlowLayout *flowLayout = [[MMTextListFlowLayout alloc] init];
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = THE_COLLECTION_ITEM_SPACE - 1.0f;
        flowLayout.minimumLineSpacing =  THE_COLLECTION_ITEM_SPACE - 1.0f;
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        flowLayout.sectionInset = UIEdgeInsetsMake(THE_COLLECTION_ITEM_SPACE, 0, THE_COLLECTION_ITEM_SPACE, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerClass:[MMTextCollectionCell class] forCellWithReuseIdentifier:kMMTextCollectionCellIdentifier];
    
        UILongPressGestureRecognizer *lpgr
        = [[UILongPressGestureRecognizer alloc]
           initWithTarget:self action:@selector(handleLongPress:)];
        //        lpgr.delegate = self;
        lpgr.delaysTouchesBegan = YES;
        [_collectionView addGestureRecognizer:lpgr];
        
        
        
        [self.view addSubview:_collectionView];
    }
    
    [self.collectionView reloadData];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDataIfNeed];
}
- (void)updateDataIfNeed{
    self.dataItems =  [[MMFavoriteManager shareManager].favoriteItems copy];

    CGFloat collectionWidth = SCREEN_WIDTH -  2 * THE_COLLECTION_ITEM_SPACE ;
    CGFloat oneSpace = (collectionWidth - 2*THE_COLLECTION_ITEM_SPACE)/3.0  ;
    CGFloat twoSpace = oneSpace * 2 + THE_COLLECTION_ITEM_SPACE ;
    CGFloat threeSpace = twoSpace +oneSpace + THE_COLLECTION_ITEM_SPACE;
    
    /* 根据每一项的字符串确定每一项的size */
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:THE_COLLECTION_ITEM_FONT_SIZE]};
    
    for (NSString *item in self.dataItems) {
        if ([self.itemSizes valueForKey:item] == nil) {
            CGFloat maxWidth  = SCREEN_WIDTH -   2 * THE_COLLECTION_ITEM_SPACE ;
            CGSize size        = [item boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
            size.height        = 40;
            size.width         += 10;
            
            if (size.width >twoSpace) {
                size.width = threeSpace ;
            }else if (size.width > oneSpace){
                size.width = twoSpace;
            }else{
                size.width = oneSpace;
            }
            [self.itemSizes setObject:[NSValue valueWithCGSize:size] forKey:item];
        }
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


- (NSMutableDictionary *)itemSizes{
    if (!_itemSizes) {
        _itemSizes = [NSMutableDictionary dictionary];
    }
    return _itemSizes;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath == nil) {
        return;
    }
    
    UICollectionViewCell* cell =  (UICollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    //         do stuff with the cell
    
    if (cell == nil) {
        return;
    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        [cell  setHighlighted:YES];
        return;
    }
    
    [cell  performSelector:@selector(setHighlighted:) withObject:@(NO) afterDelay:0.2];
   
    NSString *model = [self.dataItems objectAtIndex:indexPath.item];
    [self addOrRemoveFromFavirateWithText:model];
}

- (void)updateTitleWithText:(NSString *)text{
    NSString *title = text;
    if (title.length == 0) {
        title = @"My Favorite";
    }
    self.navigationItem.title = title ;
}
#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMTextCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMMTextCollectionCellIdentifier forIndexPath:indexPath];
    
    NSString *model = [self.dataItems objectAtIndex:indexPath.item];
    
    cell.textLabel.text = model ;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSValue *value = [self.itemSizes valueForKey:self.dataItems[indexPath.item]];
    return [value CGSizeValue];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *model = [self.dataItems objectAtIndex:indexPath.item];
    [self performSelector:@selector(nowDeselectItemAtIndexPath:) withObject:indexPath afterDelay:0.5f];
    
    [self copyWithText:model];
   
}

- (void)nowDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark -- action
- (void)copyWithText:(NSString *)text{
    
    //复制内容
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:text];
    
    NSString *title = [NSString stringWithFormat:@"已复制:%@",text] ;
    [self updateTitleWithText:title];
    
    [self performSelector:@selector(updateTitleWithText:) withObject:nil afterDelay:THE_REMIND_INFOR_SHOU_TIME];
}

- (void)addOrRemoveFromFavirateWithText:(NSString *)text{
    BOOL contains = [[MMFavoriteManager shareManager] containsItem:text];
    
    NSString *remove = [NSString stringWithFormat:@"移除收藏：%@",text];
    NSString *add = [NSString stringWithFormat:@"已收藏：%@",text];
    
    NSString *favoriteButtonTitle = contains ? remove:add;
    
    if (contains) {
        [[MMFavoriteManager shareManager] removeFavoriteItem:text] ;
        
        [self updateDataIfNeed];
    }else{
        [[MMFavoriteManager shareManager] addFavoriteItem:text] ;
    }
    
    [self updateTitleWithText:favoriteButtonTitle];
    
    [self performSelector:@selector(updateTitleWithText:) withObject:nil afterDelay:THE_REMIND_INFOR_SHOU_TIME];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
