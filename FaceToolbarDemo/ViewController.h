//
//  ViewController.h
//  FaceToolbarDemo
//
//  Created by andy on 15/12/14.
//  Copyright © 2015年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *type1;
@property (weak, nonatomic) IBOutlet UIButton *type2;

- (IBAction)type1Click:(id)sender;
- (IBAction)type2Click:(id)sender;


@end

