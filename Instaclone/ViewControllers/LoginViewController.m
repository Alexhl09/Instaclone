//
//  LoginViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/8/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
@import MaterialComponents;
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet MDCTextField *user;
@property (weak, nonatomic) IBOutlet MDCTextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user.placeholder = @"Username";
    _password.placeholder = @"Password";
    _loginButton.layer.cornerRadius = 10;
    _loginButton.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

/**
 this method is going to check the values inside the text fields and compare if there is a user with the 
 */
- (IBAction)logIn:(id)sender {
    
    NSString *user_s = self.user.text;
    NSString *password_s = self.password.text;
    
    [PFUser logInWithUsernameInBackground:user_s password:password_s block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Failed" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleCancel) handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"User logged in successfully" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                  [self performSegueWithIdentifier:@"loggedIn" sender:self];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
              
            }];
            // display view controller that needs to shown after successful login
        }
    }];
    
}
- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
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
