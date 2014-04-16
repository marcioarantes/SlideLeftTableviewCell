//
//  SlideLeftTableViewCell.h
//  SlideTableViewCell
//
//  Created by Marcio R. Arantes on 3/31/14.
//  Copyright (c) 2014 Creative Lenses. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideLeftTableViewCellDelegate <NSObject>

@required

//  delegate
- (void) slideLeftDidPushButtonAtIndex: (NSInteger)index atIndexPath: (NSIndexPath *) indexPath;

@end

@interface SlideLeftTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *cellContentView;
@property (nonatomic, weak) id <SlideLeftTableViewCellDelegate> cellDelegate;

// convenience initializer
+ (id)initWithReuseIdentifier:(NSString *)reuseIdentifier tableView: (UITableView *) tableView rowHeight: (CGFloat) rowHeight withLeftSlideButtons: (NSArray *) buttons;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView: (UITableView *) tableView rowHeight: (CGFloat) rowHeight withLeftSlideButtons: (NSArray *) buttons;


@end
