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

#import "SCLAlertView.h"

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
    
    [self.collectionView reloadData];
}


- (NSMutableDictionary *)itemSizes{
    if (!_itemSizes) {
        _itemSizes = [NSMutableDictionary dictionary];
    }
    return _itemSizes;
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

    __weak typeof(self) weakSelf = self;
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert addButton:@"复制" actionBlock:^(void) {
        [weakSelf copyWithText:model];
    }];
    
    BOOL contains = [[MMFavoriteManager shareManager] containsItem:model];
    NSString *favoriteButtonTitle = contains ? @"从收藏中移除":@"收藏";
    if (contains) {
        [alert addButton:favoriteButtonTitle actionBlock:^(void) {
            [weakSelf removeFavirateWithText:model];
        }];
    }else{
        [alert addButton:favoriteButtonTitle actionBlock:^(void) {
            [weakSelf addToFavirateWithText:model];
        }];
    }
    
    
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter ;
    
    alert.shouldDismissOnTapOutside = YES;
    
    
    [alert showTitle:weakSelf.parentViewController title:model subTitle:nil style:SCLAlertViewStyleWaiting  closeButtonTitle:@"取消" duration:0.0f];
    
}

#pragma mark -- action
- (void)copyWithText:(NSString *)text{
    
    //复制内容
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:text];
    
    SCLAlertView *sucessAlert = [[SCLAlertView alloc] init];
    
    sucessAlert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
    sucessAlert.shouldDismissOnTapOutside = YES;
    [sucessAlert showInfo:self.parentViewController title: [NSString stringWithFormat:@"%@已复制到粘贴板上",text] subTitle:@"请在其他应用里粘贴" closeButtonTitle:@"Done" duration:0.0];
}

- (void)addToFavirateWithText:(NSString *)text{
    [[MMFavoriteManager shareManager] addFavoriteItem:text] ;
}

- (void)removeFavirateWithText:(NSString *)text{
    [[MMFavoriteManager shareManager] removeFavoriteItem:text] ;
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
