//
//  SignUpViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/8/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "SignUpViewController.h"


@import Parse.Parse;
#import "Post.h"
@import MaterialComponents;
@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet MDCTextField *email;
@property (weak, nonatomic) IBOutlet MDCTextField *user;
@property (weak, nonatomic) IBOutlet MDCTextField *password;

@end

@implementation SignUpViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _user.placeholder = @"User";
    _password.placeholder = @"Password";
    _email.placeholder = @"Email";

    // Do any additional setup after loading the view.
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)signUp:(id)sender {
    // initialize a user object

    
    
    PFUser * newUser = [PFUser new];
    // set user properties
    newUser.username = self.user.text;
    newUser.email = self.email.text;
    newUser.password = self.password.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {

            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error creating user" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * action= [UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleCancel) handler:nil];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"User created" message:@"The user has been created" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * action= [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleCancel) handler:nil];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{
          

            }];
            NSData *imageData = UIImagePNGRepresentation([Post resizeImage:[UIImage imageNamed:@"account"] withSize:CGSizeMake(200, 200)]);
            
            newUser[@"ProfilePic"] = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
            newUser[@"followers"] = [NSArray new];
            newUser[@"following"] = [NSArray new];
            newUser[@"Post"] = [NSArray new];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                }
            }];

            // manually segue to logged in view
        }
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

@end
