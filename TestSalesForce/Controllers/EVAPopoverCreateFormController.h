//
//  EVAPopoverCreateFormController.h
//  TestSalesForce
//
//  Created by ctuser on 12/4/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVAPopoverCreateFormController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ibCreateButton;

@property (weak, nonatomic) IBOutlet UITextField *ibNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ibPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *ibWebsiteTextField;

@property (strong, nonatomic) NSArray *arrayOfTF;

@end
