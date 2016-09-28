//
//  ViewController.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "MainViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];;
    currentAlbumIndex = 0;
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    // the uitableview that presents the album data
    dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    [self.view addSubview:dataTable];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentAlbumData[@"titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
        cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    }
    return cell;
}
- (void)showDataForAlbumAtIndex:(int)albumIndex {
    if (albumIndex <allAlbums.count) {
        Album *album= allAlbums[albumIndex];
        currentAlbumData = [album tr_tableRepresentation];
    } else {
        currentAlbumData = nil;
    }
    [dataTable reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
