//
//  UserDetailInfoViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "UserDetailInfoViewController.h"
#import "PhotoAlbumView.h"

@interface UserDetailInfoViewController ()

@end

@implementation UserDetailInfoViewController {
    UserInfoModel *_userInfo;
    BOOL _editMode;
    UIImagePickerController *_imagePicker;
}

@synthesize imageView, nameField, idField, homeCityField, addressField, activityView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeEditMode:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _editMode = false;
    //[activityView stopAnimating];
    
    [self loadUserDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeEditMode:(id)sender {
    if (_editMode == false) {
        _editMode = true;
        self.navigationItem.rightBarButtonItem.title = @"保存";
    } else {
        [self saveUserDetailInfo];
        _editMode = false;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

- (IBAction)logoutButtonTaped:(id)sender {
    [[UserModel sharedClient] setLoginStatus:false];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_editMode == false) {
        return NO;
    }
    if (textField == nameField) {

    } else if (textField == homeCityField) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CitySelect"];
        
        if ([controller respondsToSelector:@selector(setDelegate:)]) {
            [controller setValue:self forKey:@"delegate"];
        }
        
        if (controller != nil) {
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        return NO;
    } else if (textField == addressField) {

    }
    
    return YES;
}

- (void)citySelected:(NSString *)name {
    homeCityField.text = name;
}

- (void)loadUserDetailInfo {
    [activityView startAnimating];
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user", @"user_id":userModel.user_id};
    [RCar GET:rcar_api_user modelClass:@"UserInfoModel" config:nil params:params success:^(UserInfoModel *model) {
        [activityView stopAnimating];
        if (model.api_result == APIE_OK) {
            _userInfo = model;
            
            idField.text = userModel.user_id;
            nameField.text = model.user_name;
            homeCityField.text = model.home_city;
            addressField.text = model.home_addr;
            
            userModel.info = _userInfo; // save
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [activityView stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}

- (void)saveUserDetailInfo {
    [activityView startAnimating];
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":userModel.user_id,
                             @"user_name":nameField.text,
                             @"home_city":homeCityField.text,
                             @"home_addr":addressField.text};
    [RCar PUT:rcar_api_user modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *model) {
        [activityView stopAnimating];
        if (model.api_result == APIE_OK) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"信息提示" message:@"用户信息保存成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"登录", nil];
            //alert.alertViewStyle =
            [alert show:self];
            
            _userInfo.user_name = nameField.text;
            _userInfo.home_city = homeCityField.text;
            _userInfo.home_addr = addressField.text;
            
            userModel.info = _userInfo; // save
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [activityView stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_editMode == false) {
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //_imagePicker.allowsEditing = YES;
            //_imagePicker.allowsImageEditing=YES;
            _imagePicker.delegate = self;
            [self presentViewController:_imagePicker animated:YES completion:nil];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float maxWidth = [UIScreen mainScreen].scale*320;
    float maxHeight = maxWidth * originalImage.size.height / originalImage.size.width;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(maxWidth,maxHeight), NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, maxWidth, maxHeight)];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //[self addImageViewThumbnail:thumbnail fullImage:fullImage];
    [imageView setImage:thumbnail];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


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
