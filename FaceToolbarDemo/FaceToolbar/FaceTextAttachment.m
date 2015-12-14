//
//  FaceTextAttachment.m
//  BaseProject
//
//  Created by andy on 15/12/12.
//  Copyright © 2015年 andy. All rights reserved.
//

#import "FaceTextAttachment.h"

@implementation FaceTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, -5 , _faceSize.width, _faceSize.height);
}

//- (nullable UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(nullable NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex{
//    
//    
//}

@end
