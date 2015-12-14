//
//  NSString+Foundation.h
//  Foundation
//
//  Created by andy on 14-3-3.
//  Copyright (c) 2014年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Foundation)

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict addingPercentEscapes:(BOOL)add;
- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSString *)trim;
- (BOOL)isEmpty;
- (BOOL)eq:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (NSString *)getterToSetter;
- (NSString *)setterToGetter;

- (NSString *)formatJSON;
+ (NSString *)GUIDString;
- (NSString *)removeHtmlTags;

- (BOOL)has4ByteChar;
- (BOOL)isAsciiString;

@end

#pragma mark -

@interface NSString (Encryption)

- (NSString *)MD5Hex;
- (NSData *)hexStringToData;    //从16进制的字符串格式转换为NSData

@end

