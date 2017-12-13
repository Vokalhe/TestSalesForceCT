//
//  EVAAccountPropertyTableViewCell.h
//  TestSalesForce
//
//  Created by ctuser on 11/21/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVAAccountPropertyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *ibPhone;
@property (strong, nonatomic) IBOutlet UITextField *ibWebSite;
@property (weak, nonatomic) IBOutlet UILabel *ibTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@end
