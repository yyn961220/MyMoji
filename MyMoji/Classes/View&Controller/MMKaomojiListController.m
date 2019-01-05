//
//  MMKaomojiListController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiListController.h"
#import "MMTextListCollectionView.h"

@interface MMKaomojiListController()


@end

@implementation MMKaomojiListController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataAndView];

}

- (void)loadDataAndView{
    // 加载数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestKaomejiList" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    //加载视图
    MMTextListCollectionView *collectionView = [[MMTextListCollectionView alloc] initWithFrame:self.view.bounds items:array];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.cellSelectHander = ^(id  _Nonnull selectItem, NSIndexPath * _Nonnull selectIndexPath) {
        NSLog(@"selectItem:%@,indexpath:%@",selectItem,selectIndexPath);
    };
    
    [self.view addSubview:collectionView];
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
