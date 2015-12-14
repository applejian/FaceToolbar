//
//  FaceTextAttachment.h
//  BaseProject
//
//  Created by andy on 15/12/12.
//  Copyright © 2015年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceTextAttachment : NSTextAttachment
@property(strong, nonatomic) NSString *faceTag;
@property(assign, nonatomic) CGSize faceSize;  //For emoji image size

@end
