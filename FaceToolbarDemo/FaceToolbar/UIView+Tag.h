
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)


#pragma mark -

@interface UIView(Tag)

@property (nonatomic, retain) NSString *		nameSpace;
@property (nonatomic, retain) NSString *		tagString;
@property (nonatomic, retain) NSMutableArray *	tagClasses;

- (UIView *)viewWithTagString:(NSString *)value;
- (UIView *)viewWithTagPath:(NSString *)value;

- (NSArray *)viewWithTagClass:(NSString *)value;
- (NSArray *)viewWithTagClasses:(NSArray *)array;

- (NSArray *)viewWithTagMatchRegex:(NSString *)regex;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
