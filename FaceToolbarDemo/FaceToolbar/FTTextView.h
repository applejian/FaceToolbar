//
//  FTTextView.h
//  BaseProject
//
//  Created by andy on 15/12/12.
//  Copyright © 2015年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTTextView : UITextView
/**
 Set textView's placeholder text. Default is nil.
 */
@property(nonatomic,copy)   NSString    *placeholder;

-(void)refreshPlaceholder;


@end
