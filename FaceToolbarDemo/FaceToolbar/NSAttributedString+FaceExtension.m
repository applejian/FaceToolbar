//
//  NSAttributedString+FaceExtension.m
//  BaseProject
//
//  Created by andy on 15/12/12.
//  Copyright © 2015年 andy. All rights reserved.
//

#import "NSAttributedString+FaceExtension.h"

@implementation NSAttributedString(FaceExtension)
- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[FaceTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((FaceTextAttachment *) value).faceTag];
                          base += ((FaceTextAttachment *) value).faceTag.length - 1;
                          
                          
                      }
                  }];
    
    return plainString;
}



@end
