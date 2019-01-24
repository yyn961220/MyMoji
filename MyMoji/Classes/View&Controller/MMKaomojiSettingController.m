//
//  MMKaomojiSettingController.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/22.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMKaomojiSettingController.h"
//#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MMKaomojiSettingController ()<MFMailComposeViewControllerDelegate>{
    NSArray *_helpTips;
}

@end

@implementation MMKaomojiSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"Settings",nil);
    NSString *tip1 = [NSString stringWithFormat:@"1.%@", NSLocalizedString(@"Tap item to copy it",nil)];
     NSString *tip2 =[NSString stringWithFormat:@"2.%@", NSLocalizedString(@"Long press to Add item to favirates",nil)];
    NSString *tip3 = [NSString stringWithFormat:@"3.%@", NSLocalizedString(@"Long press to remove item from favirates",nil)];
    _helpTips = @[tip1,tip2,tip3];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _helpTips.count ;
    }else if (section == 1){
        return 2 ;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCellIdentifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        cell.textLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    }
    
    if(indexPath.section == 0){
        NSString *text = _helpTips[indexPath.row];
        cell.textLabel.text = text;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = NSLocalizedString(@"Feedback",nil);
            }
                break;
            case 1:{
                cell.textLabel.text = NSLocalizedString(@"Share App",nil) ;
            }
                break;
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return NSLocalizedString(@"Help",nil);
    }else if (section == 1){
        return NSLocalizedString(@"About us",nil);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        switch (indexPath.row) {
            case 0:{
                [self suggestionAction];
            }
                break;
            case 1:{
                [self shareWithFriend];
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)shareWithFriend{
    
    NSString *downLoadURL = @"https://itunes.apple.com/app/id1450275979?mt=8";
    NSString *share = [NSString stringWithFormat:NSLocalizedString(@"I have found a good Kaomoji app,try it:%@", nil),downLoadURL];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[share,[NSURL URLWithString:downLoadURL]] applicationActivities:nil];
    UIPopoverPresentationController *pop = vc.popoverPresentationController ;
    pop.sourceRect = self.view.bounds;
    pop.sourceView = self.view;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)suggestionAction{
    if (![MFMailComposeViewController canSendMail]) {
        
        return;
    }
    MFMailComposeViewController *emailPicker = [[MFMailComposeViewController alloc] init];
    emailPicker.navigationBar.tintColor = self.view.tintColor;
    emailPicker.mailComposeDelegate = self;
    [emailPicker setToRecipients:@[@"zhxf2005307@gmail.com"]];
    emailPicker.subject = @"Sugeestions";
    
    NSString __block *text = @"My Kaomoji";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"locale"] = [NSLocale currentLocale].localeIdentifier;
    dict[@"appversion"] = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    dict[@"model"] = [UIDevice currentDevice].localizedModel;
    dict[@"systemversion"] = [UIDevice currentDevice].systemVersion;
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", [key uppercaseString]] withString:value];
    }];
    
    [emailPicker setMessageBody:text isHTML:NO];
    [self presentViewController:emailPicker animated:YES completion:nil];
}

- (void) mailComposeController: (MFMailComposeViewController*) controller didFinishWithResult:(MFMailComposeResult) result error:(NSError*) error {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
