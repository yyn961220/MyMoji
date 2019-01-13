//
//  MMKaomojiPageController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/5.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiPageController.h"
#import "MMKaomojiListController.h"

@interface MMKaomojiPageController ()
@property (nonatomic,strong) NSDictionary *dataItems;
@end

@implementation MMKaomojiPageController

- (void)viewDidLoad {
    [self loadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)loadData{
    //    // 加载数据
     NSString *path = [[NSBundle mainBundle] pathForResource:@"TestKaomejiList" ofType:@"plist"];
    NSDictionary *dictonary = [NSDictionary dictionaryWithContentsOfFile:path];
    self.dataItems = [dictonary copy];
    self.titles = [[dictonary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  -- WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return  self.titles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index > self.titles.count) {
        return nil;
    }
    
    MMKaomojiListController *vc = [[MMKaomojiListController alloc] initWithNibName:nil bundle:nil];
    vc.dataItems = [self.dataItems valueForKey:[self.titles objectAtIndex:index]];
    return vc ;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    if (index > self.titles.count) {
        return nil;
    }
    
    return [self.titles objectAtIndex:index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{

    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
  
    
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{

    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}
@end
