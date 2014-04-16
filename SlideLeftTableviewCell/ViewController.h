//
//  ViewController.h
//  SlideLeftTableviewCell
//
//  Created by Marcio R. Arantes on 4/14/14.
//  Copyright (c) 2014 Creative Lenses. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideLeftTableViewCell.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SlideLeftTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
