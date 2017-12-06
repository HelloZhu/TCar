//
//  ViewController.m
//  TCar
//
//  Created by ap2 on 2017/11/20.
//  Copyright © 2017年 ap2. All rights reserved.
//

#import "ViewController.h"
#import "LKDBHelper.h"
#import "Car.h"
#import "Company.h"
#import "NSString+Resolver.h"
#import "Keywords.h"
#import "Article.h"
#import "CompanyDesc.h"
#import "Appearance.h"
#import "Inner.h"
#import "Power.h"
#import "OtherDesc.h"

static NSString *const keyword_Appearance = @"外形";
static NSString *const keyword_Inner = @"内饰";
static NSString *const keyword_Power = @"动力";

@interface ViewController ()
{
    NSInteger _selectCompanyIndex;
    NSInteger _selectCarIndex;
    NSInteger _addNewCarCompanyIndex;
}

@property (nonatomic, strong) NSArray *carList;
@property (nonatomic, strong) NSArray *companyList;
@property (unsafe_unretained) IBOutlet NSTextView *yuanwenTextView;
@property (weak) IBOutlet NSTextField *keywordA;
@property (weak) IBOutlet NSTextField *carNameTXFD;
@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic, strong) Car *currentCar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  
    
    self.companyList = [self searchCompanyList];
    
    [self.tableView reloadData];
    [self.companyTableView reloadData];
}

// The only essential/required tableview dataSource method.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == self.tableView) {
         return self.companyList.count;
    }else if (tableView == self.carTableView){
         return self.carList.count;
    }else if (tableView == self.companyTableView){
        return self.companyList.count;
    }
    
    return 0;
}

// This method is optional if you use bindings to provide the data.
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
    if (tableView == self.tableView)
    {
        // Group our "model" object, which is a dictionary.
        Company *comINF = self.companyList[row];
        
        // In IB the tableColumn has the identifier set to the same string as the keys in our dictionary.
        NSString *identifier = tableColumn.identifier;
        
        if ([identifier isEqualToString:@"MainCell"]) {
            // We pass us as the owner so we can setup target/actions into this main controller object.
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            // Then setup properties on the cellView based on the column.
            cellView.textField.stringValue = comINF.name;
            return cellView;
        }
        return nil;
    }
    else if (tableView == self.carTableView)
    {
        Car *car = self.carList[row];
        
        NSString *identifier = tableColumn.identifier;
        
        if ([identifier isEqualToString:@"subCell"]) {
            // We pass us as the owner so we can setup target/actions into this main controller object.
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            // Then setup properties on the cellView based on the column.
            cellView.textField.stringValue = car.name;
            return cellView;
        }
        
        return nil;
    }
    else if (tableView == self.companyTableView)
    {
        Company *comINF = self.companyList[row];
        
        NSString *identifier = tableColumn.identifier;
        
        if ([identifier isEqualToString:@"comanyCell"]) {
            // We pass us as the owner so we can setup target/actions into this main controller object.
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            // Then setup properties on the cellView based on the column.
            cellView.textField.stringValue = comINF.name;
            return cellView;
        }
        
        return nil;
    }
    
    
    return nil;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
    NSLog(@"%@",tableColumn.title);
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    if (tableView == self.tableView) {
       
        _selectCompanyIndex = row;
        Company *comINF = self.companyList[row];
        NSArray *arr = [self searchCarListWithCompanyID:comINF.companyID];
        self.carList = arr;
        [self.carTableView reloadData];
        
    }else if (tableView == self.carTableView){
       
        _selectCarIndex = row;
        
       
    }
    else if (tableView == self.companyTableView){
        
        _addNewCarCompanyIndex = row;
    }
    
    return YES;
}


- (IBAction)addNewCarAction:(NSButton *)sender {
    
    if (self.carNameTXFD.stringValue)
    {
        NSString *sql = [NSString stringWithFormat:@"name='%@'", self.carNameTXFD.stringValue];
        NSMutableArray *list = [Car searchWithWhere:sql];
        
        if (!list.count)
        {
           Company *cpy = [self.companyList objectAtIndex:_addNewCarCompanyIndex];
            
            Car *car = [Car new];
            car.companyID = cpy.companyID;
            car.name = self.carNameTXFD.stringValue;
            car.carID = [self createUUID];
            [car saveToDB];
        }
    }
}

- (IBAction)startParase:(NSButton *)sender {
    
    NSArray *keywors = [self searchKeywordsList];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (Keywords *key in keywors)
    {
        NSString *string = [_yuanwenTextView.string resolverWithKeyWord:key.keyword previousCount:key.previousCount forward:key.forwardCount];
        
        if (!string) {
            string = @"";
        }
        
        [dict setObject:string forKey:key.keyword];
        
        if ([key.keyword isEqualToString:keyword_Appearance])
        {
            [self addAppearance:string];
        }
        else if ([key.keyword isEqualToString:keyword_Inner])
        {
            [self addInner:string];
        }
        else if ([key.keyword isEqualToString:keyword_Power])
        {
            [self addPower:string];
        }
        
        OtherDesc *desc = [OtherDesc new];
        desc.keyword = key.keyword;
        desc.articleID = self.currentArticle.articleID;
        desc.carID = self.currentCar.carID;
        desc.desc = string;
        [desc saveToDB];
    }
    NSLog(@"resolve result = %@", dict);
}

- (IBAction)saveArticle:(id)sender {
    
    self.currentArticle =  [self addArticle];
}

- (IBAction)resolveA:(id)sender {
    
    NSString *string = [_yuanwenTextView.string resolverWithKeyWord:_keywordA.stringValue previousCount:10 forward:30];
    NSLog(@"%@", string);
}

- (NSArray *)searchCarListWithCompanyID:(NSString *)companyID
{
    NSString *sql = [NSString stringWithFormat:@"companyID='%@'", companyID];
    NSArray *list = [Car searchWithWhere:sql];
    if (!list) {
        list = @[];
    }
    return list;
}

- (NSArray *)searchCompanyList
{
    NSArray *list = [Company searchWithSQL:@"select * from Company"];
    if (!list) {
        list = @[];
    }
    return list;
}

- (NSArray *)searchKeywordsList
{
    NSArray *list = [Keywords searchWithSQL:@"select * from Keywords"];
    if (!list) {
        list = @[];
    }
    return list;
}


- (void)addKeyword:(NSString *)keyword
{
    Keywords *key = [Keywords new];
    key.keyword = keyword;
    key.previousCount = 10;
    key.forwardCount = 10;
    [key saveToDB];
}

- (Article *)addArticle
{
    Article *info = [Article new];
    info.link = @"";
    info.title = @"";
    info.content = _yuanwenTextView.string;
    info.articleID = [self createUUID];
    [info saveToDB];
    return info;
}

- (Appearance *)addAppearance:(NSString *)text
{
    Appearance *appearance = [Appearance new];
    appearance.articleID = self.currentArticle.articleID;
    appearance.carID = self.currentCar.carID;
    appearance.desc = text;
    
    return appearance;
}

- (Inner *)addInner:(NSString *)text
{
    Inner *inner = [Inner new];
    inner.articleID = self.currentArticle.articleID;
    inner.carID = self.currentCar.carID;
    inner.desc = text;
    
    return inner;
}

- (Power *)addPower:(NSString *)text
{
    Power *power = [Power new];
    power.articleID = self.currentArticle.articleID;
    power.carID = self.currentCar.carID;
    power.desc = text;
    
    return power;
}

// 创建UUID
- (NSString *)createUUID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString *sUUID = [NSString stringWithString:(__bridge NSString *)uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return sUUID;
}


@end
