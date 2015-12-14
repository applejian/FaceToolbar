//
//  FaceView.m
//  BaseProject
//
//  Created by andy on 15/12/8.
//  Copyright © 2015年 andy. All rights reserved.
//

#import "FaceView.h"
#import <QuartzCore/QuartzCore.h>


@implementation FaceRangeData

@synthesize start;
@synthesize end;

@end


@implementation FaceView
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

    
}

-(void)fillData:(NSArray *)dataList{
    totalPage = dataList.count;
    for (NSInteger p = 0; p < totalPage; p++) {
        FaceRangeData * fd = [dataList objectAtIndex:p];
        
        CGFloat x = 0;
        CGFloat y = 0;
        
        
        CGFloat of = (ScreenWidth - 7 * FACE_BTN_KRect) / 8.0;
        
        for (NSInteger i = fd.start ,k = 0; i <= fd.end + 1; i++ , k++) {
            
            x = k % 7 * ( FACE_BTN_KRect + of ) + of + ( p * ScreenWidth );
            y = k / 7 * ( FACE_BTN_KRect + 8 * ScaleX_IP5 * 2 ) + 20 * ScaleX_IP5;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, FACE_BTN_KRect, FACE_BTN_KRect)];
            
            if (i == fd.end + 1) {
                [btn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete_pressed"] forState:UIControlStateHighlighted];
                btn.tagString = DEL_BTN_TAG_STRING;
            }else{
                NSString *tagString = [NSString stringWithFormat:@"%ld", (long)i];
                [btn setBackgroundImage:GET_FACE_IMAGE(tagString) forState:UIControlStateNormal];
                btn.tagString = [NSString stringWithFormat:@"%ld",(long)i];
            }
            [self.scrollView addSubview:btn];
            [btn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * totalPage, 180 * ScaleX_IP5);
    self.pager.numberOfPages = totalPage;
}



-(void)layoutSubviews{
    
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, 180 * ScaleX_IP5);
    

    self.topLine.frame = CGRectMake(0, 0, ScreenWidth, 0.5 * ScaleX_IP5);
    self.bottomLine.frame = CGRectMake(0, _scrollView.frame.size.height - 0.5 * ScaleX_IP5, ScreenWidth, 0.5 * ScaleX_IP5);
    
    self.pager.frame = CGRectMake(0, _scrollView.frame.size.height - (7 + 16) * ScaleX_IP5, ScreenWidth, 16 * ScaleX_IP5);

    
    self.faceSendBtn.frame = CGRectMake(ScreenWidth - 60 * ScaleX_IP5 , _scrollView.frame.size.height, 60 * ScaleX_IP5 , 35 * ScaleX_IP5);

}

-(void)sendEnableSendBtn:(BOOL)en{
    if (en) {
        self.faceSendBtn.backgroundColor = [UIColor colorWithString:@"#007AFF"];
    }
}


-(void)faceBtnClick:(UIButton *)btn {
    NSString * tagString = btn.tagString;
    
    if ( tagString  && ![tagString isEqualToString:@""] ) {
        if ( [tagString isEqualToString:DEL_BTN_TAG_STRING]) {
            if (self.faceDelBtnClickBlock != nil) {
                self.faceDelBtnClickBlock();
            }
        }else{
            if (self.faceBtnClickBlock != nil) {
                self.faceBtnClickBlock(tagString);
            }
        }
    }else{
        
        
    }


}

- (void)changePage:(id)sender {
    NSInteger page = self.pager.currentPage;
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth * page, 0)];
}

-(void)faceSendBtnClick{
    if (self.faceSendBtnClickBlock != nil) {
        self.faceSendBtnClickBlock();
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    NSInteger page = _scrollView.contentOffset.x / ScreenWidth;
    self.pager.currentPage = page;
}

#pragma mark -

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorWithString:@"#FAFAFA"];
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;

        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(UILabel *)topLine{
    if (_topLine == nil) {
        _topLine = [[UILabel alloc] init];
        _topLine.backgroundColor = [UIColor colorWithString:@"#DCDCDC"];
        
        
        [self addSubview:_topLine];
    }
    return _topLine;
}

-(UILabel *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithString:@"#BFBFBF"];
        
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

-(UIPageControl *)pager{
    if (_pager == nil) {
        _pager = [[UIPageControl alloc] init];
        _pager.pageIndicatorTintColor = [UIColor colorWithString:@"#959698" ];
        _pager.currentPageIndicatorTintColor= [UIColor colorWithString:@"#5A6572"];
        _pager.currentPage = 0;
        [_pager addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_pager];
    }
    return _pager;
}

-(UIButton *)faceSendBtn{
    if (_faceSendBtn == nil) {
        _faceSendBtn = [[UIButton alloc] init];
        [_faceSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _faceSendBtn.backgroundColor = [UIColor colorWithString:@"#007AFF"];
        _faceSendBtn.titleLabel.font = [UIFont systemFontOfSize:14 * ScaleX_IP5];
        [_faceSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_faceSendBtn addTarget:self action:@selector(faceSendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceSendBtn];
        
        _faceSendBtn.layer.shadowOffset = CGSizeMake(-4, 0);
        _faceSendBtn.layer.shadowRadius = 4.0;
        _faceSendBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _faceSendBtn.layer.shadowOpacity = 0.8f;
        
    }
    return _faceSendBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
