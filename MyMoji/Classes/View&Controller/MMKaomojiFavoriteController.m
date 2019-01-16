//
//  MMKaomojiFavoriteController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/16.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiFavoriteController.h"
#import "MMFavoriteManager.h"

@interface MMKaomojiFavoriteController ()

@end

@implementation MMKaomojiFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateDataIfNeed];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDataIfNeed];
}
- (void)updateDataIfNeed{
    self.dataItems = @[[MMFavoriteManager shareManager].favoriteItems];
}

- (BOOL)needRemoveItemFromList{
    return YES;
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
