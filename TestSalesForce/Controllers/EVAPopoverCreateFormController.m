//
//  EVAPopoverCreateFormController.m
//  TestSalesForce
//
//  Created by ctuser on 12/4/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVAPopoverCreateFormController.h"
#import "EVADataManager.h"

@implementation EVAPopoverCreateFormController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.arrayOfTF = @[self.ibNameTextField, self.ibPhoneTextField, self.ibWebsiteTextField];
    
}

- (IBAction)actionCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)actionCreate:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (UITextField *tf in self.arrayOfTF){
        
        [dict setValue:tf.text forKey:tf.placeholder];
        
    }
    
    [[EVADataManager sharedManager] createAccountInCD:dict success:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createNewAccount" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
-(void) isEnabledButton{
    
    if (self.ibNameTextField.text.length > 0 && self.ibPhoneTextField.text.length > 0 && self.ibWebsiteTextField.text.length > 0) {
        
        self.ibCreateButton.enabled = YES;
        
    }
    
//    for (UITextField *tf in self.arrayOfTF){
//        if
//    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self isEnabledButton];

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self isEnabledButton];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
    
}

@end
