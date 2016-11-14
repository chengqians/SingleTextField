//
//  ViewController.m
//  SingleTextField
//
//  Created by Apple on 2016/11/14.
//  Copyright © 2016年 ChengQian. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScrollViewHeight 50
#define kFont [UIFont systemFontOfSize:17]




@interface CustomScrollView : UIScrollView

@end

@implementation CustomScrollView

// 每次点击scrollView的时候都会调用该方法
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    NSLog(@"scrollRectToVisible");
    // 这个方法会让 scrollView 自动滚动到最末端。所以，重写该父类方法。
}

@end



/*----------------------------------------------------------------------------------------------------------------------*/

@interface ViewController ()
{
    CustomScrollView *_scrollView;
    UITextField *_textField;
}

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpScrollView];
    [self setUpTextField];
}

- (void)setUpScrollView {
    _scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(16, 50, (kScreenWidth - 32), kScrollViewHeight)];
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
}

- (void)setUpTextField {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 32), kScrollViewHeight)];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.placeholder = @"请在此输入内容...";
    _textField.textColor = [UIColor whiteColor];
    _textField.font = kFont;
    [_scrollView addSubview:_textField];
    
    [_textField addTarget:self action:@selector(textFieldEditingChanged)forControlEvents:UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(textFieldEditingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)textFieldEditingChanged {
    // 保持光标的位置 在最后面
    NSInteger cursorLocation = [self cursorLocation];
    CGFloat textFieldToIndexWidth = [self getTextWidthWithText:[_textField.text substringToIndex:cursorLocation]];
    if (textFieldToIndexWidth > (kScreenWidth - 32)) {
        [_scrollView setContentOffset:CGPointMake(textFieldToIndexWidth - (kScreenWidth - 32), 0) animated:YES];
    }
    
    // 随时改变textField和scrollView的宽度
    CGFloat textWidth = [self getTextWidthWithText:_textField.text];
    if (textWidth > (kScreenWidth - 32)) {
        _textField.frame = CGRectMake(0, 0, textWidth, kScrollViewHeight);
        
    } else {
        _textField.frame = CGRectMake(0, 0, (kScreenWidth - 32), kScrollViewHeight);
        
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_textField.bounds), kScrollViewHeight);
}

- (void)textFieldEditingDidBegin {
    CGFloat textFieldBeginWidth = [self getTextWidthWithText:_textField.text];
    // 如果textField的开始宽度 宽于 的初始宽度，那么将scrollView移动到最末端
    if (textFieldBeginWidth > (kScreenWidth - 32)) {
        [_scrollView setContentOffset:CGPointMake(textFieldBeginWidth - (kScreenWidth - 32), 0) animated:YES];
    }
}


// 获取文本宽度
- (CGFloat)getTextWidthWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, kScrollViewHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFont} context:nil];
    return rect.size.width;
}

// 获取光标位置
- (NSInteger)cursorLocation {
    UITextPosition *beginning = _textField.beginningOfDocument;
    UITextRange *cursorRange = _textField.selectedTextRange;
    UITextPosition *cursorStart = cursorRange.start;
    NSInteger location = [_textField offsetFromPosition:beginning toPosition:cursorStart];
    return location;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
