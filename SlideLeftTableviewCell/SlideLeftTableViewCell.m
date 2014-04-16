//
//  SlideLeftTableViewCell.m
//  SlideTableViewCell
//
//  Created by Marcio R. Arantes on 3/31/14.
//  Copyright (c) 2014 Creative Lenses. All rights reserved.
//

#import "SlideLeftTableViewCell.h"

@interface SlideLeftTableViewCell()

FOUNDATION_EXPORT const int kScrollViewTag;
FOUNDATION_EXPORT const int kButtonTag;
FOUNDATION_EXPORT const CGFloat kDefaultSlideWidth;
FOUNDATION_EXPORT const CGFloat kDefaultButtonSize;

@property (nonatomic, getter = isCellOpen) BOOL cellOpen;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat cellSlideWidth;
@property (nonatomic, copy) NSArray *leftSlideButtons;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *buttonsView;

@end

@implementation SlideLeftTableViewCell

static NSString *kCellOpenNotification = @"CellOpenNotification";
const int kScrollViewTag = 990011;
const int kButtonTag = 990012;
const CGFloat kDefaultSlideWidth = 160.0;
const CGFloat kDefaultButtonSize = 80.0;


+ (id)initWithReuseIdentifier:(NSString *)reuseIdentifier tableView: (UITableView *) tableView rowHeight: (CGFloat) rowHeight withLeftSlideButtons: (NSArray *) buttons{
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier tableView:tableView rowHeight:rowHeight withLeftSlideButtons:buttons];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView: (UITableView *) tableView rowHeight: (CGFloat) rowHeight withLeftSlideButtons: (NSArray *) buttons{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.leftSlideButtons = buttons;
        self.cellSlideWidth = [self setSwipeWidth];
        self.tableView = tableView;
        self.height = rowHeight;
        self.width = CGRectGetWidth(tableView.bounds);
        self.frame = CGRectMake(0, 0, self.width, self.height);
        self.autoresizesSubviews = YES; //TODO
        
        //tune in - listen for other cell's state (open/close)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didOpen:)
                                                     name:kCellOpenNotification
                                                   object:nil];
        [self performLayout];
    }
    return self;
}

- (void)performLayout{
    self.cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.cellContentView setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(self.frame.size.width + self.cellSlideWidth, self.height)];
    [scrollView setTag:kScrollViewTag];
    scrollView.delegate = self;
    
    self.buttonsView = [self performButtomsLayout];
    
    [scrollView addSubview: self.buttonsView];
    [scrollView addSubview: self.cellContentView];
    
    UITapGestureRecognizer *didSelectRowTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contentView addGestureRecognizer: didSelectRowTapRecognizer];
    
    [self repositionScrollViewSubView:scrollView];
    [self.contentView addSubview:scrollView];
}

- (UIView *)performButtomsLayout{
    self.buttonsView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.cellSlideWidth, self.height)];
    __block UIView *localButtonsView = self.buttonsView;
    
    [self.leftSlideButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        float buttonWidth = [obj[@"width"] floatValue] ?: kDefaultButtonSize; // use default width if not specified
        CGFloat buttonX = 0.0;
        
        // get x position
        if (index > 0) {
            UIButton *lastButton = (UIButton *)[localButtonsView viewWithTag:(kButtonTag + (index-1))];
            buttonX = lastButton.frame.origin.x + lastButton.frame.size.width;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0.0, buttonWidth, self.height);
        button.backgroundColor = obj[@"bgcolor"] ?: [UIColor lightGrayColor];
        button.tag = kButtonTag + index;
        [button.titleLabel setFont: [UIFont systemFontOfSize:14.0]]; //** set button title font here
        [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];  //** set button title color here
        [button setTitle:obj[@"title"] ?: @"None" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [localButtonsView addSubview:button];
    }];
    
    return localButtonsView;
}

- (CGFloat)setSwipeWidth{
    CGFloat revealWidthCount = 0.0;
    for (NSDictionary *button in self.leftSlideButtons){
        revealWidthCount += [button[@"width"] floatValue] ?: kDefaultButtonSize; // use default width if not specified
    }
    return revealWidthCount > 0 ? revealWidthCount : kDefaultSlideWidth;
}

- (void)didOpen: (NSNotification *)notification{
    UIScrollView *scrollview = (UIScrollView *)[self viewWithTag:kScrollViewTag];
    if (notification.object != self){
        if (self.isCellOpen) {
            //**CAUTION - notification can be fired on any thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.20 animations:^{
                    scrollview.contentOffset = CGPointZero;
                }];
            });
        }
    }
}

- (void)repositionScrollViewSubView: (UIScrollView *)scrollView{
    CGRect frame = self.buttonsView.frame;
    frame.origin.x = self.frame.size.width - self.cellSlideWidth + scrollView.contentOffset.x;
    self.buttonsView.frame = frame;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    self.cellContentView.backgroundColor = [UIColor lightGrayColor];
    
    if (self.cellDelegate && self.tableView) {
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            [self.tableView selectRowAtIndexPath:[self.tableView indexPathForCell:self] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[self.tableView indexPathForCell:self]];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:self] animated:NO];
        }
    }
    
    // handle cell highlighting
    [UIView animateWithDuration:0.25 animations:^{
        self.cellContentView.backgroundColor = [UIColor whiteColor];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < 0){//no right swipe allowed
        scrollView.contentOffset = CGPointZero;
    }else if(scrollView.contentOffset.x > 0){ //0 - prevent multiple swipe
        self.cellOpen = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCellOpenNotification object:self];
    }else{
        self.cellOpen = NO;
    }
    
    [self repositionScrollViewSubView:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.x > 0 || ((* targetContentOffset).x > self.cellSlideWidth / 2)) { //snap open/close based on drag speed or position (halfway point)
        (* targetContentOffset).x = self.cellSlideWidth; //snap to position (fully opened)
    }else{
        (* targetContentOffset).x = 0; //snap to position (fully closed)
    }
}

#pragma mark - LeftSlideTableViewCellDelegate

- (void)buttonPressed: (UIButton *) button{
    //highlight button
    UIColor *titleColor = button.currentTitleColor;
    UIColor *bgColor = button.backgroundColor;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.layer.shadowColor = [titleColor CGColor];
    button.titleLabel.layer.shadowRadius = 4.0f;
    button.titleLabel.layer.shadowOpacity = .9;
    button.titleLabel.layer.shadowOffset = CGSizeZero;
    button.titleLabel.layer.masksToBounds = NO;
    
    int buttonTag = (int)button.tag - kButtonTag ?: 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        UIScrollView *scrollview = (UIScrollView *)[self viewWithTag:kScrollViewTag];
        scrollview.contentOffset = CGPointZero;
        
        //restore button
        button.backgroundColor = bgColor;
        button.titleLabel.textColor = titleColor;
    }];
    
    if (self.cellDelegate){
        [self.cellDelegate slideLeftDidPushButtonAtIndex:buttonTag atIndexPath:[self.tableView indexPathForCell:self]];
    }
}


@end
