//
//  FaceToolBar.m
//  BaseProject
//
//  Created by andy on 15/12/8.
//  Copyright © 2015年 andy. All rights reserved.
//


#import "FaceToolBar.h"

@interface FaceToolBar()<UITextViewDelegate>{
    BOOL        _inited;
    BOOL        _display;
    BOOL        _displayAtBottom;
    BOOL        _needDismiss;
    BOOL        _debugEnable;
    BOOL        _calcHightLightContent;//计算高亮内容

    CGRect		_accessorFrame;
    CGRect		_frame;
    
    CGFloat     _originY;
    CGFloat     _theSuperViewY;
    CGFloat     _theSuperViewH;
    CGFloat     _autoExpandViewH;
    
    
    CGFloat     _lastContentOffsetY;
}


@property(nonatomic,assign)UIView * theSuperView;


@property(nonatomic,strong)NSDictionary * faceMap;
@property(nonatomic,strong)NSArray * faceRangeList;

@property(nonatomic,strong)AutoExpandView *autoExpandView;//表情滚动视图
@property(nonatomic,strong)FaceView *faceView;//表情滚动视图
@property(nonatomic,strong)UIButton * maskBtn;

@end

@implementation FaceToolBar
DEF_SINGLETON(FaceToolBar)

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    if ( NO == _inited )
    {
        self.backgroundColor = [UIColor clearColor];
        
        _inited = YES;
        
        [self load];
    }
}

-(void)load{
    
    [self setNoti];
    
    
    [self initData];
    
    
    [self initView];
    
}

-(void)addToParent:(id)target{
    UIView * superview = nil;
    
    if ([target isKindOfClass:[UIViewController class]]) {
        superview = [(UIViewController *)target view];
    }
    if ([target isKindOfClass:[UIView class]]) {
        superview = (UIView *)target;
    }
    
    if (_theSuperView == nil || superview != _theSuperView) {
        _theSuperView = superview;

        [_theSuperView addSubview:self.maskBtn];
        [_theSuperView addSubview:self];
        
        
        [_theSuperView bringSubviewToFront:self];
        _theSuperViewY = _theSuperView.frame.origin.y;
        _theSuperViewH = _theSuperView.frame.size.height;
    }
    
    [self resetFrame];

    [self resetConfig];
}

-(void)resetConfig{
    _needDismiss = NO;
    _display = NO;
    _shown = NO;
    _animating = NO;
    _keyboardHeight = DEFAULT_KEYBOARD_HEIGHT;
    _lastContentOffsetY = 0;
    _calcHightLightContent = NO;
    _displayAtBottom = NO;
//    _autoExpandViewH = EXPAND_VIEW_DEFAULT_HEIGHT;
    
    if (self.sendBlock != nil) {
        self.sendBlock = nil;
    }

}

-(void)resetFrame{
    CGFloat selfHeight = FACE_TOOL_BAR_BASE_HEIGHT;
    CGFloat fy = selfHeight;// 默认 //键盘

    [self.autoExpandView setKBtype:KBType_Keyboard];//设置 默认键盘
    
    if ([self isFaceType]) {//表情
        fy = selfHeight - FACE_VIEW_HEIGHT;
    }
    
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, selfHeight);
    
    self.autoExpandView.frame = CGRectMake(0, 0, ScreenWidth, EXPAND_VIEW_DEFAULT_HEIGHT);
    
    self.faceView.frame = CGRectMake(0, fy , ScreenWidth, FACE_VIEW_HEIGHT);
}

- (void)emptyTextView{
    self.textView.text = @"";
    
    
    if (_display == YES) {
        
        if (_autoExpandViewH > EXPAND_VIEW_DEFAULT_HEIGHT) {
            _autoExpandViewH = EXPAND_VIEW_DEFAULT_HEIGHT;
            [self refreshTextViewSize:self.textView];
        }
        
    }else{
        _autoExpandViewH = EXPAND_VIEW_DEFAULT_HEIGHT;
    }
    
}

-(void)maskBtnClick{
    
    _needDismiss = YES;
    
    
    BOOL reg = [self.textView isFirstResponder];
    
    if (reg == NO) {
        
        if (_displayAtBottom == YES) {
          [self showToBottom];
            
        }else{
            self.sendBlock = nil;
            
            [self dismiss];
        }
        
        
    }else{
        [self.textView resignFirstResponder];
    }

    
    
    
}

-(void)setMaskBtn{
    self.maskBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
}

//显示输入法键盘
-(void)showKeyBoard{

    [self setMaskBtn];

    [self.autoExpandView setKBtype:KBType_Keyboard];
    [self animation:_keyboardHeight];
}

//显示表情键盘
-(void)toggleToFaceBoard{
    if (_display == YES) {//显示
        [self setMaskBtn];

        [self animation:FACE_VIEW_HEIGHT];
    }else{//隐藏键盘
        if (_displayAtBottom == YES ) {
            [self showToBottom];
        }else{
            [self hideAll];
        }
    }
}

-(void)showToBottom{
    [self.autoExpandView setKBtype:KBType_Keyboard];
    [self animation:0];
}

-(void)hideAll{
    [self animation:-EXPAND_VIEW_DEFAULT_HEIGHT];
}


-(void)changeExpandViewHeight{
    if ([self isFaceType]) {//表情
        [self toggleToFaceBoard];
    }else{//键盘
        [self showKeyBoard];
    }
    
}

-(void)animation:(CGFloat)toHeight{
    CGFloat duration = 0.3;

    if (_display == NO || toHeight <= 0) {
        self.maskBtn.frame = CGRectZero;
        duration = 0.4;
    }else{

    }
    
    CGFloat faceHeight = FACE_VIEW_HEIGHT;
    CGFloat barHeight = FACE_TOOL_BAR_BASE_HEIGHT;
    CGFloat expendViewHeight = EXPAND_VIEW_DEFAULT_HEIGHT;
    CGFloat barStartY = INPUT_TEXT_START_Y  ;
    
    if (_autoExpandViewH > expendViewHeight ) {
        barStartY += expendViewHeight;
        expendViewHeight = _autoExpandViewH;
        barStartY -= expendViewHeight;
    }
    
    if ([self isFaceType]) {
        barHeight = expendViewHeight + faceHeight ;
    }else{
        barHeight = expendViewHeight + toHeight ;
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat offsetY = 0;

        //背景 滚动
        if (_accessor != nil) {
            if (_display == NO) {
                [self resetParentView:0 offsetH:0];
            }else{
                offsetY = ScreenHeight - (_accessorFrame.origin.y + _accessorFrame.size.height + barHeight ) ;
                if (offsetY > 0) {
                    offsetY = 0;
                }
                [self resetParentView:offsetY offsetH:ScreenHeight];//设为最大高度 避免 view高度不够导致 超出的视图点击事件失效
            }
        }
        
        CGFloat selfStartY = barStartY - toHeight - _theSuperViewY - offsetY ;
        
        if (_display == NO) {
            selfStartY = ScreenHeight;
        }
        NSLog(@"selfStartY:%f",selfStartY);
        
        self.frame = CGRectMake(0 , selfStartY , ScreenWidth, barHeight);
        self.autoExpandView.frame = CGRectMake(0, 0, ScreenWidth, expendViewHeight);

        if ([self isFaceType]) {//表情
            self.faceView.frame = CGRectMake(0, expendViewHeight , ScreenWidth, FACE_VIEW_HEIGHT);
        }else{
            self.faceView.frame = CGRectMake(0, barHeight , ScreenWidth, FACE_VIEW_HEIGHT);
        }
        
        
    } completion:^(BOOL finished) {
        [self clean];

    }];
    
}

-(void)clean{
    if (_display == NO) {
        
        [self.autoExpandView setKBtype:KBType_Keyboard];
        self.textView.placeholder = @"";
        
        if (_displayAtBottom == YES) {
            return ;
        }
        
        
        [self.maskBtn removeFromSuperview];
        
        [self removeFromSuperview];
        
        if (_theSuperView != nil) {
            _theSuperView = nil;
        }
        
        
        if (_accessor != nil) {
            _accessor = nil;
        }
        
    }
}

-(void)resetParentView:(CGFloat)offsetY offsetH:(CGFloat)offsetH{
    _theSuperView.frame = CGRectMake(_theSuperView.frame.origin.x,_theSuperViewY + offsetY , _theSuperView.frame.size.width,_theSuperViewH + offsetH);
}

#pragma mark - methods
-(void)showIn:(id)target :(FaceToolSendBlock)sendBlock{
    
    [self addToParent:target];
    self.sendBlock = sendBlock;
    
    
    _display = YES;
    
    
    [self.textView becomeFirstResponder];
    
//    NSString * content = self.textView.text;


}

-(void)show{
    [self.textView becomeFirstResponder];
}


-(void)showAtBottom:(id)target :(FaceToolSendBlock)sendBlock{
    
    [self addToParent:target];
    
    self.sendBlock = sendBlock;
    
    _display = YES;
    
    _displayAtBottom = YES;
    
    [self showToBottom];
}

-(void)dismiss{
    
    
    _display = NO;
    
    _displayAtBottom = NO;
    
    
    if (self.autoExpandView.ktype == KBType_Keyboard && _shown == YES) {
        [self.textView resignFirstResponder];
    }else{
        [self hideAll];
    }
    
}

-(void)setPlaceholder:(NSString *)placeholder{
    self.textView.placeholder = placeholder;
}


#pragma mark - keyboard NSNotifications
- (void)keyboardWillShow:(NSNotification *)notification{
    
    
    
}

- (void)keyboardDidShow:(NSNotification *)notification{
    _animating = YES;
    
    NSDictionary * userInfo = (NSDictionary *)[notification userInfo];
    if ( userInfo )
    {
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    }
    
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ( value )
    {
        CGRect	keyboardEndFrame = [value CGRectValue];
        //			CGFloat	keyboardHeight = ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
        CGFloat	keyboardHeight = keyboardEndFrame.size.height;
        
        if ( keyboardHeight != _keyboardHeight )
        {
            _keyboardHeight = keyboardHeight;
            
            // HEIGHT_CHANGED
            _animating = NO;
            
            [self showKeyBoard];
        }
    }
    if (_display == YES) {
        _animating = NO;
    }
    
    [self updateAccessorAnimated:_animating];

}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    
}

- (void)keyboardDidHide:(NSNotification *)notification{
    _animating = YES;
    
    NSDictionary * userInfo = (NSDictionary *)[notification userInfo];
    if ( userInfo )
    {
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    }
    
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ( value )
    {
        CGRect	keyboardEndFrame = [value CGRectValue];
        //			CGFloat	keyboardHeight = ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
        CGFloat	keyboardHeight = keyboardEndFrame.size.height;
        
        if ( keyboardHeight != _keyboardHeight )
        {
            _keyboardHeight = keyboardHeight;
            
            //	[self postNotification:self.HEIGHT_CHANGED];
            _animating = NO;
            
            [self showKeyBoard];
        }
    }
    
    if ( _shown == YES )
    {
        _shown = NO;
        
        //HIDDEN
        
        [self toggleToFaceBoard];
    }
    [self updateAccessorAnimated:_animating];

}


- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    _animating = YES;
    
    NSDictionary * userInfo = (NSDictionary *)[notification userInfo];
    if ( userInfo )
    {
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
    }
    NSValue * value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue * value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ( value1 && value2 )
    {
        CGRect rect1 = [value1 CGRectValue];
        CGRect rect2 = [value2 CGRectValue];
        
        if ( rect1.origin.y >= [UIScreen mainScreen].bounds.size.height )
        {
            if ( NO == _shown )
            {
                _shown = YES;
//                [self postNotification:self.SHOWN];
                
                //SHOWN
                
                _keyboardHeight = rect1.size.height;
                [self showKeyBoard];
            }
            
            if ( rect2.size.height != _keyboardHeight )
            {
                _keyboardHeight = rect2.size.height;
//                [self postNotification:self.HEIGHT_CHANGED];
                
                //HEIGHT_CHANGED
                if ([self isFaceType]) {
                    [self toggleToFaceBoard];
                }else{
                    [self showKeyBoard];
                }
                
            }
        }
        else if ( rect2.origin.y >= [UIScreen mainScreen].bounds.size.height )
        {
            if ( rect2.size.height != _keyboardHeight )
            {
                _keyboardHeight = rect2.size.height;
//                [self postNotification:self.HEIGHT_CHANGED];
                
                if ([self isFaceType]) {
                    [self toggleToFaceBoard];
                }else{
                    [self showKeyBoard];
                }
                
                
                //HEIGHT_CHANGED
                
            }
            
            if ( _shown == YES )
            {
                _shown = NO;
                
//                [self postNotification:self.HIDDEN];
                
//                HIDDEN
                
                if (_needDismiss) {
                    if (_displayAtBottom == YES) {
                        [self showToBottom];
                    }else{
                        [self hideAll];
                    }
                    _needDismiss = NO;
                }else{
                    [self toggleToFaceBoard];
                }
            }
        }
    }
    [self updateAccessorAnimated:_animating];

}





#pragma mark - 表情键盘 选中
-(void)appendText:(NSString *)tagString{
    UITextView * textView = self.textView;
    
    NSLog(@"tagString:%@",tagString);
    
    if (IOS7_OR_LATER) {
        [self setFace:tagString];
    }else{
        NSString * face = GET_FACE_TEXT(tagString);
        face = [self.faceMap objectForKey:face];
        NSString * content = [textView.text stringByAppendingString:face];
        textView.text = content;
    }
    
//    [self textScrollToLast];
    
    [self refreshTextViewSize:textView];
//    [self autoCheckScroll];
    [self performSelector:@selector(autoCheckScroll) withObject:nil afterDelay:0.3];
}

-(void)setFace:(NSString *)tag{
    NSString * face = GET_FACE_TEXT(tag);
    //Create emoji attachment
    FaceTextAttachment *faceTextAttachment = [FaceTextAttachment new];
    
    //Set tag and image
    faceTextAttachment.faceTag = face;
    faceTextAttachment.image = GET_FACE_IMAGE(tag);
    
    
    CGFloat fheight = floorf(self.textView.font.lineHeight);
//    fheight = FACE_SIZE;
    
    //Set emoji size
    faceTextAttachment.faceSize = CGSizeMake(fheight, fheight);

    UITextView *textView = self.textView;
    
    [textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:faceTextAttachment]
                                          atIndex:textView.selectedRange.location];
    
    //Move selection location
    textView.selectedRange = NSMakeRange(textView.selectedRange.location + 1, textView.selectedRange.length);
    
    //Reset text style
    [self resetTextStyle];
    
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, self.textView.textStorage.length);
    
    [self.textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 1;
    
    UIFont * font = [UIFont systemFontOfSize:FFONT_SIZE];
    
    [self.textView.textStorage addAttributes:@{NSFontAttributeName:font
//                                               ,NSParagraphStyleAttributeName:paraStyle
                                               } range:wholeRange];
    
    
}


#pragma mark - 表情键盘 删除
-(void)clearLastText{
    UITextView * textView = self.textView;
    
    if (IOS7_OR_LATER) {
        if (textView.textStorage.length > 0) {
            [textView.textStorage deleteCharactersInRange:NSMakeRange(textView.textStorage.length - 1, 1)];
        }
    }else{
        NSString * content = textView.text;
        if (content.length > 0) {
            self.textView.text = [content substringWithRange:NSMakeRange(0, content.length-1)];
        }
    }
    
    [self refreshTextViewSize:textView];
}


#pragma mark - 表情键盘 发送
-(BOOL)sendContent{
    NSString * content = @"";
//    if (content.length <= 0) {
//        return;
//    }
    
    
    if (IOS7_OR_LATER) {
        content = [self.textView.textStorage getPlainString];
    }else{
        content = self.textView.text;
        NSArray * fKeys = [self.faceMap allKeys];
        for (NSString * fKey in fKeys) {
            content = [content stringByReplacingOccurrencesOfString:[self.faceMap objectForKey:fKey] withString:fKey];
        }
    }
    
    
    _autoExpandViewH = EXPAND_VIEW_DEFAULT_HEIGHT;
    [self emptyTextView];
    
    
    if (self.sendBlock) {
        
        _needDismiss = self.sendBlock(content);
        
        
//        content = nil;
        
        if (_needDismiss) {// need to dismiss and release
            
            [self maskBtnClick];
            
        }else{
            
            
        }
    }
    
    
    
//    if (_autoExpandViewH > EXPAND_VIEW_DEFAULT_HEIGHT) {
//        _autoExpandViewH = EXPAND_VIEW_DEFAULT_HEIGHT;
//        [self changeExpandViewHeight];
//    }
    
    return YES;
}

#pragma mark - 表情键盘 切换事件
-(void)changeKeyboardBtnClick{
    _display = YES;

    
    if ([self isFaceType]) {// 切换到 键盘
        [self.autoExpandView setKBtype:KBType_Keyboard];
        [self.textView becomeFirstResponder];
        
        
    }else{//切换到表情输入
        [self.autoExpandView setKBtype:KBType_Face];
       
        
        BOOL reg = [self.textView resignFirstResponder];
        if (reg == NO) {//表示没有弹出键盘过
            [self toggleToFaceBoard];//手动弹出表情键盘
        }

    }
    
}


- (void)setNoti
{
    //  Registering for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
    //    //  Registering for textField notification.
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    //
    //    //  Registering for textView notification.
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
}


-(void)initData{
    _keyboardHeight = DEFAULT_KEYBOARD_HEIGHT;
    
    
    @autoreleasepool {
        
        self.faceMap = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:FACE_PLIST_NAME ofType:@"plist"]];
        
        NSInteger fcount = ceilf(self.faceMap.count / 19.0);

        NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.faceMap.count];
        NSInteger end = 0;
        for (NSInteger i = 1; i <= fcount; i++) {
            FaceRangeData * fd = [FaceRangeData new];
            fd.start = 1 + end;
            if (i == fcount) {//最后一个
                fd.end = self.faceMap.count;
            }else{
                end += 1 + 19;
                fd.end = end;
            }
            [array addObject:fd];
        }
        
        self.faceRangeList = [NSArray arrayWithArray:array];

    }
    
    
    
    
    
    
//    FaceRangeData * fd1 = [FaceRangeData new];
//    fd1.start = 1;
//    fd1.end = 20;
//    
//    FaceRangeData * fd2 = [FaceRangeData new];
//    fd2.start = 21;
//    fd2.end = 40;
//    
//    FaceRangeData * fd3 = [FaceRangeData new];
//    fd3.start = 41;
//    fd3.end = 45;//60
//    self.faceRangeList = [NSArray arrayWithObjects:fd1,fd2,fd3,nil];
//    
    

    
    _originY = ScreenHeight;
    
    
    

}

-(void)initView{
    [self resetFrame];
    [self resetConfig];
    
    
    self.autoExpandView.ktype = KBType_Keyboard;
    self.textView.delegate = self;
    [self.autoExpandView.keyBoardTypeBtn addTarget:self action:@selector(changeKeyboardBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.faceView fillData:self.faceRangeList];
    
    
    
    @weakify(self)
    
    //表情键盘 表情点击
    self.faceView.faceBtnClickBlock = ^(NSString * tagString){
        @strongify(self);
        [self appendText:tagString];
    };
    
    //表情键盘 删除
    self.faceView.faceDelBtnClickBlock = ^{
        @strongify(self);
        [self clearLastText];
    };
    
    //表情键盘 发送
    self.faceView.faceSendBtnClickBlock = ^{
        @strongify(self);
        [self sendContent];
        
    };
    
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
    if (self.sendBlock != nil) {
        self.sendBlock = nil;
    }
 
    if (self.autoExpandView != nil) {
        self.textView.delegate = nil;
        self.autoExpandView = nil;
    }
    
    if (self.faceView != nil) {
        self.faceView = nil;
    }
    
    if (_theSuperView != nil) {
        _theSuperView = nil;
    }
    
    if (_accessor != nil) {
        _accessor = nil;
    }
    
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}


#pragma mark -

-(AutoExpandView *)autoExpandView{
    if (_autoExpandView == nil) {
        _autoExpandView = [[AutoExpandView alloc] init];
        [self addSubview:_autoExpandView];
    }
    return _autoExpandView;
}

-(FaceView *)faceView{
    if (_faceView == nil) {
        _faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, FACE_TOOL_BAR_BASE_HEIGHT - FACE_VIEW_HEIGHT, ScreenWidth, FACE_VIEW_HEIGHT)];
        [self addSubview:_faceView];
    }
    return _faceView;
}

-(UIButton *)maskBtn{
    if (_maskBtn == nil) {
        _maskBtn = [[UIButton alloc] init];
        [_maskBtn addTarget:self action:@selector(maskBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (_debugEnable) {
            _maskBtn.backgroundColor = [UIColor yellowColor];
            _maskBtn.alpha = 0.6;
        }
    }
    return _maskBtn;
}



-(FTTextView *)textView{
    return self.autoExpandView.textView;
}






#pragma mark - Accessor
- (void)setAccessor:(UIView *)view
{
    _accessor = view;
    _accessorFrame = view.frame;
}

-(void)clearAccessor{
    
    if (_accessor!=nil) {
        _accessor = nil;
    }
    
}


- (void)showAccessor:(UIView *)view animated:(BOOL)animated
{
    _accessor = view;
    _accessorFrame = view.frame;
    
    [self updateAccessorAnimated:animated];
}

- (void)hideAccessor:(UIView *)view animated:(BOOL)animated
{
    if ( _accessor == view )
    {
        BOOL isShown = _shown;
        
        _shown = NO;
        [self updateAccessorAnimated:animated];
        _shown = isShown;
        
        _accessor = nil;
        _accessorFrame = CGRectZero;
    }
}

- (void)updateAccessorAnimated:(BOOL)animated
{
    animated = NO;
    
    if (true) {
        return;
    }
    
    if ( nil == _accessor )
        return;
    
    if ( animated )
    {
        if ( IOS7_OR_LATER )
        {
            [UIView beginAnimations:nil context:NULL];
            
            CGFloat duration = 0.25;
            if (_display == NO) {
                duration = 0.35;
            }

            
            [UIView setAnimationDelay:duration];
            [UIView setAnimationDuration:0.23f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            //			[UIView setAnimationBeginsFromCurrentState:YES];
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            CGFloat duration = 0.25;
            if (_display == NO) {
                duration = 0.35;
            }
            
            [UIView setAnimationDuration:0.25f];
            //			[UIView setAnimationBeginsFromCurrentState:YES];
        }
    }
    
    if ( _shown == YES )
    {

        CGFloat containerHeight = _accessor.superview.bounds.size.height;
        CGRect newFrame = _accessorFrame;
        newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _keyboardHeight + EXPAND_VIEW_DEFAULT_HEIGHT);
//        _accessor.frame = newFrame;
       
        
        CGFloat y1 = _accessorFrame.origin.y;
        CGFloat y2 = newFrame.origin.y;
        CGFloat offset = y2 - y1;
        

//        _theSuperView.frame = CGRectMake(_theSuperView.origin.x,_theSuperViewY + offset  , _theSuperView.size.width, _theSuperView.size.height);
        
        _theSuperView.frame = CGRectMake(_theSuperView.frame.origin.x, - 162 , _theSuperView.frame.size.width, _theSuperView.frame.size.height);
        
        
        CGRect newFrame0 = self.frame;
        newFrame0.origin.y = newFrame0.origin.y - offset;
        self.frame = newFrame0;
        
    }
    else
    {
//        _accessor.frame = _accessorFrame;
        
//        _theSuperView.frame = CGRectMake(_theSuperView.origin.x,_theSuperViewY , _theSuperView.size.width, _theSuperView.size.height);
        
        _theSuperView.frame = CGRectMake(_theSuperView.frame.origin.x,64 , _theSuperView.frame.size.width, _theSuperView.frame.size.height);

        self.frame = _frame;

        
    }
    
    if ( animated )
    {
        [UIView commitAnimations];
    }
}



-(void)autoCheckScroll{
    
    UITextView * textView = self.textView;
    
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height -
    (textView.contentOffset.y +
     textView.bounds.size.height -
     textView.contentInset.bottom -
     textView.contentInset.top );
    if ( overflow > 0 )
    {
        // We are at the bottom of the visible text and introduced
        // a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 3; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated:
        // or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}





#pragma mark - ////////////////////////

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (text.length == 0) {//对于退格删除键开放限制
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//回车提交
        [self sendContent];
        return NO;
    }

    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];

    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < EXPAND_VIEW_MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = EXPAND_VIEW_MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        //加入动态计算高度
        CGSize size = [self getStringRectInTextView:comcatstr InTextView:textView];
        
//        CGRect frame = textView.frame;
//        frame.size.height = size.height;
//        textView.frame = frame;
        
        [self chanageTextViewSize:size];
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        
        NSRange rg = {0,MAX(len,0)};
        
        
        if (rg.length > 0)
        {
            
            NSString *s = @"";
            
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            
            if (asc) {
                
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          NSInteger steplen = substring.length;
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx = idx + steplen;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            
            //由于后面反回的是NO不触发didchange
            [self refreshTextViewSize:textView];
            //既然是超出部分截取了，哪一定是最大限制了。
            NSString * lbNums = [NSString stringWithFormat:@"%d/%ld",0,(long)EXPAND_VIEW_MAX_LIMIT_NUMS];
            NSLog(@"lbNums = %@",lbNums);
        }
        return NO;
    }
    
}




- (void)textViewDidChange:(UITextView *)textView
{
    if (_calcHightLightContent) {
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //如果在变化中是高亮部分在变，就不要计算字符了
        if (selectedRange && pos) {
            return;
        }
    }
    
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > EXPAND_VIEW_MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:EXPAND_VIEW_MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    
    //不让显示负数
    NSString * lbNums = [NSString stringWithFormat:@"%ld/%d",MAX(0,EXPAND_VIEW_MAX_LIMIT_NUMS - existTextNum),EXPAND_VIEW_MAX_LIMIT_NUMS];
    NSLog(@"lbNums = %@",lbNums);
    
    [self refreshTextViewSize:textView];

    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
//    UITextView * textView = self.textView;
//    CGFloat scrollY = textView.contentSize.height - textView.bounds.size.height;
//    
//    
//    if (_lastContentOffsetY != scrollY) {
//        _lastContentOffsetY = scrollY;
//        [UIView animateWithDuration:0.2 animations:^{
//            [self.textView setContentOffset:CGPointMake(0 ,_lastContentOffsetY)];
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//    }
    
    
}


#pragma mark -
#pragma mark -
- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
{
    //
    
    //    NSLog(@"行高  ＝ %f container = %@,xxx = %f",self.textview.font.lineHeight,self.textview.textContainer,self.textview.textContainer.lineFragmentPadding);
    
    //
    
    //实际textView显示时我们设定的宽
    
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    
    //但事实上内容需要除去显示的边框值
    
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            
                            + textView.textContainerInset.left
                            
                            + textView.textContainerInset.right
                            
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    
    CGFloat broadHeight  = (textView.contentInset.top
                            
                            + textView.contentInset.bottom
                            
                            + textView.textContainerInset.top
                            
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    
    contentWidth -= broadWith;
    
    
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    
    return adjustedSize;
    
}



- (void)refreshTextViewSize:(UITextView *)textView
{
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    
    //    CGRect frame = textView.frame;
    //    frame.size.height = size.height;
    //    textView.frame = frame;
    
    
    
    [self chanageTextViewSize:size];
    
}

-(void)chanageTextViewSize:(CGSize)size{//输入框所需要的高度 和宽度
    NSLog(@"need height:%f",size.height);
    
    if ( size.height >= EXPAND_VIEW_MAX_HEIGHT) {//是否超出最大值
        size.height = EXPAND_VIEW_MAX_HEIGHT;
    }
    
    
    CGFloat height = size.height +  KSP * 2;
    
    if (height < EXPAND_VIEW_DEFAULT_HEIGHT) {
        height = EXPAND_VIEW_DEFAULT_HEIGHT;
    }
    
    CGFloat expendViewHeight = self.autoExpandView.frame.size.height;
    CGFloat lineHeight = self.textView.font.lineHeight;
    
    NSLog(@"lineHeight :%f",lineHeight);
    NSLog(@"FFONT_SIZE :%f",FFONT_SIZE);

    if ( expendViewHeight != height
        //解决输入框 计算高度抖动问题
        && fabs(expendViewHeight - height) > //FFONT_SIZE
        (lineHeight / 3.0 * 2)
        ) {
        NSLog(@"need -to chage");
        
        _autoExpandViewH = height;
        
        [self changeExpandViewHeight];
        

    }else{

    
    }
    
    [self textScrollToLast];
    
    [self performSelector:@selector(autoCheckScroll) withObject:nil afterDelay:0.2];

    
}

-(BOOL)isFaceType{
    return self.autoExpandView.ktype == KBType_Face;
}


-(void)textScrollToLast{
    
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 4, 1)];
    
}



@end
