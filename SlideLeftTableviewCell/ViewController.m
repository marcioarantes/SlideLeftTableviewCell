//
//  ViewController.m
//  SlideLeftTableviewCell
//
//  Created by Marcio R. Arantes on 4/14/14.
//  Copyright (c) 2014 Creative Lenses. All rights reserved.
//

#import "ViewController.h"
#import "LoremIpsum.h"

@interface ViewController ()

FOUNDATION_EXPORT const CGFloat kRowHeight;

@property (nonatomic, strong) NSArray *dataSourceSections;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

const CGFloat kRowHeight = 60.00;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Strech horizontal row seperator
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self loadDataSource];
}

- (void)loadDataSource{
    self.dataSourceSections = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    self.dataSource = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *dataSourceWithBlock = self.dataSource;
    
    [self.dataSourceSections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int numberOfWordsForSection = (arc4random() % (5 - 2)) + 2;
        [dataSourceWithBlock addObject:[NSString stringWithFormat:@"%@", [self phraseGenenerator: numberOfWordsForSection]]];
    }];
}

- (NSString *)phraseGenenerator: (NSInteger) numberOfWords{
    LoremIpsum* loremIpsum = [LoremIpsum new];
    NSString *phrase = [NSString stringWithFormat:@"%@", [loremIpsum words:numberOfWords]];
    return phrase;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRowHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dataSourceSections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    SlideLeftTableViewCell *cell = (SlideLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        // Width and bgcolor is optional
        cell = [SlideLeftTableViewCell initWithReuseIdentifier:cellIdentifier
                                                     tableView:tableView
                                                     rowHeight:kRowHeight
                                          withLeftSlideButtons:@[@{@"title": @"More..", @"bgcolor": [UIColor blueColor]},
                                                                 @{@"title": @"Delete", @"width": [NSNumber numberWithFloat:80.0], @"bgcolor": [UIColor redColor]},
                                                                 @{@"title": @"Archive", @"width": [NSNumber numberWithFloat:80.0]}]];
        cell.cellDelegate = self;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [nameLabel setTag:1000];
        
        [cell.cellContentView addSubview:nameLabel];
    }
    
    UILabel *title = (UILabel *)[cell viewWithTag:1000];
    title.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.section]];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-> %@", self.dataSource[indexPath.section]);
}

#pragma mark LeftSlideTableViewCell Delegate

- (void) slideLeftDidPushButtonAtIndex: (NSInteger)index atIndexPath:(NSIndexPath *)indexPath{
    switch (index) {
        case 0:
            NSLog(@"More - %@", self.dataSource[indexPath.section]);
            break;
        case 1:
            NSLog(@"Delete - %@", self.dataSource[indexPath.section]);
            break;
        case 2:
            NSLog(@"Archive - %@", self.dataSource[indexPath.section]);
            break;
        default:
            break;
    }
}

@end
