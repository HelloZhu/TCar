//
//  ViewController.h
//  TCar
//
//  Created by ap2 on 2017/11/20.
//  Copyright © 2017年 ap2. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTabViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableView *carTableView;
@property (weak) IBOutlet NSTableView *companyTableView;
@property (weak) IBOutlet NSButton *addNewCar;


@end

