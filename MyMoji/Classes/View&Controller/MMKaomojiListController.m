//
//  MMKaomojiListController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiListController.h"
#import "MMTextListCollectionView.h"
#import "SCLAlertView.h"

#import "MMFavoriteManager.h"


@interface MMKaomojiListController()
@property (nonatomic, strong) MMTextListCollectionView *collectionView ;
@end

@implementation MMKaomojiListController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDataAndViewIfNeed{
//    // 加载数据
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestKaomejiList" ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    //加载视图
    if (self.collectionView == nil) {
        MMTextListCollectionView *collectionView = [[MMTextListCollectionView alloc] initWithFrame:self.view.bounds items:@[]];
        collectionView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        collectionView.cellSelectHander = ^(id  _Nonnull selectItem, NSIndexPath * _Nonnull selectIndexPath) {
//            NSLog(@"selectItem:%@,indexpath:%@",selectItem,selectIndexPath);
//            weakSelf
            NSString *title = selectItem ;
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert addButton:@"复制" actionBlock:^(void) {
                [weakSelf copyWithText:title];
//                [weakSelf performSelector:@selector(copyWithText:) withObject:title afterDelay:0.5];
            }];
            
            BOOL contains = [[MMFavoriteManager shareManager] containsItem:title];
            NSString *favoriteButtonTitle = contains ? @"从收藏中移除":@"收藏";
            if (contains) {
                [alert addButton:favoriteButtonTitle actionBlock:^(void) {
                    [weakSelf removeFavirateWithText:title];
                }];
            }else{
                [alert addButton:favoriteButtonTitle actionBlock:^(void) {
                    [weakSelf addToFavirateWithText:title];
                }];
            }
           
            
            alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter ;
            
            alert.shouldDismissOnTapOutside = YES;
            
            
            [alert showTitle:weakSelf.parentViewController title:title subTitle:nil style:SCLAlertViewStyleWaiting  closeButtonTitle:@"取消" duration:0.0f];

            
        };
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView ;
    }
   
    self.collectionView.dataItems = self.dataItems;
}

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

- (void)setDataItems:(NSArray *)dataItems{
    _dataItems = dataItems;
    if (dataItems.count > 0) {
        [self loadDataAndViewIfNeed];
    }
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
