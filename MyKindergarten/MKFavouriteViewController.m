//
//  MKFavouriteViewController.m
//  MyKindergarten
//
//  Created by sgp0607 on 28/04/14.
//  Copyright (c) 2014 Li YuFeng. All rights reserved.
//

#import "MKFavouriteViewController.h"

@interface MKFavouriteViewController ()

@end

@implementation MKFavouriteViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *docsDir;
    
    docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"favourite.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) ==SQLITE_OK) {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FAVOURITE( ID TEXT PRIMARY KEY,NAME TEXT, STREET TEXT, BLOCK TEXT, BUILDING TEXT,  FLOOR TEXT,  POSTALCODE TEXT, X_ADDR TEXT, Y_ADDR TEXT, LONGITUDE TEXT, LATITUDE TEXT)";
        if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"Failed to create table");
        }
    }else{
        NSLog(@"Failed to open/create database");
    }
    [self prepareStatement];
    [self readFavouriteFromDB];
}

-(void) prepareStatement{
    
    NSString *sqlString;
    const char *sql_stmt;
    
    //prepare insert sQL statement
    sqlString = [NSString stringWithFormat:@"INSERT INTO FAVOURITE (ID, NAME, STREET, BLOCK, BUILDING, FLOOR, POSTALCODE, X_ADDR,Y_ADDR,LONGITUDE,LATITUDE) VALUES(? ,?,? ,? ,?,?,?,?,?, ?, ?)"];
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &insertStatement, NULL);
    
//    //prepare delete SQL statement
//    sqlString = [NSString stringWithFormat:@"DELETE FROM FAVOURITE WHERE name = ?"];
//    sql_stmt = [sqlString UTF8String];
//    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &deleteStatement, NULL);
    
    //prepare select SQL statement
    sqlString = [NSString stringWithFormat:@"SELECT ID, NAME, STREET, BLOCK, BUILDING, FLOOR, POSTALCODE, X_ADDR,Y_ADDR,LONGITUDE,LATITUDE FROM FAVOURITE"];
    
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &selectStatement, NULL);
}

-(void)readFavouriteFromDB{
    _arrayData = [[NSMutableArray alloc]init];
    
    
    //    sqlite3_bind_text(selectStatement, 1, [name.text UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(selectStatement) == SQLITE_ROW) {
        //        status.text = @"Match found";
        MKKindergarten *m = [[MKKindergarten alloc ]init];
        NSString *ID = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 0)];
        NSString *name = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 1)];
        NSString *street = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 2)];
        NSString *block = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 3)];
        NSString *building = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 4)];
        NSString *floor = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 5)];
        NSString *postalcode = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 6)];
        NSString *x_addr = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 7)];
        NSString *y_addr = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 8)];
        NSString *longitude = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 9)];
        NSString *latitude = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 10)];
        
        m.ID = ID;
        m.block = block;
        m.building = building;
        m.floor = floor;
        m.latitude = latitude;
        m.longitude = longitude;
        m.name = name;
        m.postalCode = postalcode;
        m.street = street;
        m.x_addr = x_addr;
        m.y_addr = y_addr;
        [_arrayData addObject:m];
    }
    
    NSLog(@"Count is : %d", [_arrayData count]);
    sqlite3_reset(selectStatement);
    sqlite3_clear_bindings(selectStatement);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_arrayData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    MKKindergarten *model = _arrayData[indexPath.row];
    cell.textLabel.text = [model name];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Fav2Detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MKDetailViewController *detailController = [segue destinationViewController];
        detailController.kindergarten = _arrayData[indexPath.row];
    }
}


@end
