//
//  MMKaomojiAllController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/16.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiAllController.h"
#import "MMTextListFlowLayout.h"

#import "MMTextTableViewCell.h"
#import "MMTextCollectionCell.h"
#import "MMTextHeaderView.h"

//#import "SCLAlertView.h"
#import "MMFavoriteManager.h"

static float kLeftTableViewWidth = 50.0f;
static float kCollectionViewMargin = 3.f;
static float kCollectionItemSpace = THE_COLLECTION_ITEM_SPACE;

@interface MMKaomojiAllController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *categates;

@property (nonatomic, strong) NSDictionary *categateIcons;

@property (nonatomic, strong) NSMutableDictionary *allList;
@property (nonatomic, strong) NSMutableArray *cellSizes ;

@property (nonatomic, strong) UILabel *remindLabel ;

//@property (nonatomic, strong) MMTextListFlowLayout *flowLayout;

@end

@implementation MMKaomojiAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = 0;
    _isScrollDown = YES;
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
     [self loadData];
     [self initTableAndCollecionView];

     [self showTips];
    
    /*
     // 截图所用代码
    [self setDefaultTitle];
    
    NSArray *array = [self.allList valueForKey:@"Cheerful"];
    for (NSString *string in array) {
        [[MMFavoriteManager shareManager] addFavoriteItem:string] ;
    }
     */
}

- (void)showTips{
    NSString *tip1 = [NSString stringWithFormat:@"1.%@", NSLocalizedString(@"Tap item to copy it",nil)];
    NSString *tip2 =[NSString stringWithFormat:@"2.%@", NSLocalizedString(@"Long press to add item to favorites",nil)];
    
    NSString *allTips = [NSString stringWithFormat:@"%@ \n%@",tip1,tip2];
    
   [self updateTitleWithText:allTips dismissAfterDelay:5.0f];

}

- (void)loadData{
        // 加载数据
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyKaomojiList" ofType:@"json"];
//  // //        NSDictionary *dictonary = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    
    NSData *jsonData = [[NSDataAsset alloc] initWithName:@"MyKaomojiList" bundle:[NSBundle mainBundle]].data;
    NSError *error = nil;
    NSDictionary *dictonary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (dictonary == nil) {
//        NSLog(@"error = %@",error);
        return;
    }
    
//    self.dataItems = [dictonary copy];
    NSArray *categates = [dictonary valueForKey:@"Categates"];
    NSDictionary *allList = [dictonary valueForKey:@"AllList"];
    
    NSDictionary *allEmojiIcons = [dictonary valueForKey:@"CategateEMojis"];
    
    [self.categates removeAllObjects];
    [self.allList removeAllObjects];
    
    [self.categates addObjectsFromArray:categates];
    [self.allList addEntriesFromDictionary:allList];
    self.categateIcons = [NSDictionary dictionaryWithDictionary:allEmojiIcons];
    
    /* 根据每一项的字符串确定每一项的size */
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:THE_COLLECTION_ITEM_FONT_SIZE]};
    
    NSMutableArray *widthsArray = [NSMutableArray array];
//    NSLog(@"begain get widthsArray");
    
    
    CGFloat collectionWidth = SCREEN_WIDTH - kLeftTableViewWidth - 2 * kCollectionViewMargin ;
    CGFloat oneSpace = (collectionWidth - 2*kCollectionItemSpace)/3.0  ;
    CGFloat twoSpace = oneSpace * 2 + kCollectionItemSpace ;
    CGFloat threeSpace = twoSpace +oneSpace + kCollectionItemSpace;
    
    for (int i = 0; i < categates.count; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        for (NSString *string in [allList valueForKey:categates[i]]) {
            CGFloat maxWidth  = SCREEN_WIDTH - kLeftTableViewWidth - 2 * kCollectionViewMargin ;
            CGSize size        = [string boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
            size.height        = 40;
            size.width         += 10;
            
            if (size.width >twoSpace) {
                size.width = threeSpace ;
            }else if (size.width > oneSpace){
                size.width = twoSpace;
            }else{
                size.width = oneSpace;
            }
            
            [sectionArray addObject:[NSValue valueWithCGSize:size]];
        }
        
        [widthsArray addObject:sectionArray];
    }
    
    self.cellSizes = widthsArray;
//    NSLog(@"end get widthsArray");
}

- (void)initTableAndCollecionView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftTableViewWidth, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 35;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor whiteColor];
        [_tableView registerClass:[MMTextTableViewCell  class] forCellReuseIdentifier:kMMTextTableViewCellIdentifier];
        [self.view addSubview:_tableView];
    }
    
    if (!_collectionView){
        MMTextListFlowLayout *flowLayout = [[MMTextListFlowLayout alloc] init];
      
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = kCollectionItemSpace - 1.0f;
        flowLayout.minimumLineSpacing =  kCollectionItemSpace - 1.0f;
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        flowLayout.sectionInset = UIEdgeInsetsMake(kCollectionItemSpace, 0, kCollectionItemSpace, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCollectionViewMargin + kLeftTableViewWidth, kCollectionViewMargin, SCREEN_WIDTH - kLeftTableViewWidth - 2 * kCollectionViewMargin, SCREEN_HEIGHT - 2 * kCollectionViewMargin) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerClass:[MMTextCollectionCell class] forCellWithReuseIdentifier:kMMTextCollectionCellIdentifier];
        //注册分区头标题
        [_collectionView registerClass:[MMTextHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
        
        
       
        UILongPressGestureRecognizer *lpgr
        = [[UILongPressGestureRecognizer alloc]
           initWithTarget:self action:@selector(handleLongPress:)];
        //        lpgr.delegate = self;
        lpgr.delaysTouchesBegan = YES;
        [_collectionView addGestureRecognizer:lpgr];
        
        
        
        [self.view addSubview:_collectionView];
    }

    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    
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
    
        [cell  performSelector:@selector(setHighlighted:) withObject:@(NO) afterDelay:0.3f];
        
        NSArray *array = [self.allList objectForKey:[self.categates objectAtIndex:indexPath.section]];
        NSString *model = [array objectAtIndex:indexPath.item];
        [self addOrRemoveFromFavirateWithText:model];
}

- (void)updateTitleWithText:(NSString *)text dismissAfterDelay:(NSTimeInterval)secend{
    NSString *title = text;
    if (title.length == 0) {
        [self setDefaultTitle];
        return;
    }
    
    self.navigationItem.titleView = self.remindLabel;
    self.remindLabel.text = title;
    
    [UIView animateWithDuration:0.1 delay:secend options:UIViewAnimationOptionCurveEaseInOut animations:^{
         self.remindLabel.alpha = 0.9;
    } completion:^(BOOL finished) {
        if (finished) {
             self.remindLabel.alpha = 1.0;
            [self setDefaultTitle];
        }
    }];
}

- (void)setDefaultTitle{
    self.navigationItem.titleView = nil;
    self.navigationItem.title = NSLocalizedString(@"Kaomoji",nil) ;
}
#pragma mark -- getters
- (NSMutableArray *)categates{
    if (!_categates)
    {
        _categates = [NSMutableArray array];
    }
    return _categates;
}

- (NSMutableDictionary *)allList{
    if (!_allList)
    {
        _allList = [NSMutableDictionary dictionary];
    }
    return _allList;
}

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 40)];
        _remindLabel.numberOfLines = 0 ;
        _remindLabel.textAlignment =NSTextAlignmentCenter ;
        _remindLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _remindLabel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMTextTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kMMTextTableViewCellIdentifier];
    if (!cell) {
        cell = [[MMTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMMTextTableViewCellIdentifier];
    }
    
    NSString *model = self.categates[indexPath.row];
    NSString *icon = [self.categateIcons valueForKey:model];
    
    cell.name.text = icon;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex = indexPath.row;
    
//     http://stackoverflow.com/questions/22100227/scroll-uicollectionview-to-section-header-view
//     解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
//    [self scrollToTopOfSection:_selectIndex animated:YES];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
       [self scrollToTopOfSection:_selectIndex animated:YES];
   
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated{
//    CGRect headerRect = [self frameForHeaderForSection:section];
//    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top - headerRect.size.height);
//    [self.collectionView setContentOffset:topOfHeader animated:animated];
    
    CGPoint point =  self.collectionView.contentOffset;
    point.y -= THE_COLLECTION_HEADER_HEIGHT + kCollectionItemSpace ;
    [self.collectionView setContentOffset:point];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.categates.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = [self.allList objectForKey:[self.categates objectAtIndex:section]];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMTextCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMMTextCollectionCellIdentifier forIndexPath:indexPath];

    NSArray *array = [self.allList objectForKey:[self.categates objectAtIndex:indexPath.section]];
    NSString *model = [array objectAtIndex:indexPath.item];
    
    cell.textLabel.text = model ;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSValue *value = [self.cellSizes[indexPath.section] objectAtIndex:indexPath.item];
    return [value CGSizeValue];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [self.allList objectForKey:[self.categates objectAtIndex:indexPath.section]];
    NSString *model = [array objectAtIndex:indexPath.item];
    
    [self performSelector:@selector(nowDeselectItemAtIndexPath:) withObject:indexPath afterDelay:0.3f];
   
    [self copyWithText:model];
}

- (void)nowDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    MMTextHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        NSString *categate =self.categates[indexPath.section];
        NSString *localizedCategate = NSLocalizedString(self.categates[indexPath.section],nil);
        NSString *icon = [self.categateIcons objectForKey:categate];
        NSString *model = [NSString stringWithFormat:@"%@- %@",icon,localizedCategate];
        view.title.text = model;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, THE_COLLECTION_HEADER_HEIGHT);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark -- action
- (void)copyWithText:(NSString *)text{
    
    //复制内容
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:text];
    
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Copied to pasteboard:%@",nil),text] ;
    
    [self updateTitleWithText:title dismissAfterDelay:THE_REMIND_INFOR_SHOW_TIME];
    
}

- (void)addOrRemoveFromFavirateWithText:(NSString *)text{
    BOOL contains = [[MMFavoriteManager shareManager] containsItem:text];

    if (!contains) {
        [[MMFavoriteManager shareManager] addFavoriteItem:text] ;
    }
    
     NSString *favoriteButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Added to favorites:%@",nil),text];
    
    [self updateTitleWithText:favoriteButtonTitle dismissAfterDelay:THE_REMIND_INFOR_SHOW_TIME];
    
}


@end
