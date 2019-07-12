//
//  LoginViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/8/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "HomeViewController.h"
@import MaterialComponents;

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDesign];
    // Do any additional setup after loading the view.
}


///Set up the design of the button and labels
-(void) setDesign
{
    _logginButton.layer.cornerRadius = 10;
    _logginButton.clipsToBounds = YES;
    _signUpButton.layer.cornerRadius = 10;
    _signUpButton.clipsToBounds = YES;
    
}
- (IBAction)backPage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
