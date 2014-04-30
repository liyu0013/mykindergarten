//
//  MKDetailViewController.m
//  MyKindergarten
//
//  Created by XXX on 26/4/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKDetailViewController.h"
#import "MKFeedbackViewController.h"
#import <sqlite3.h>

@interface MKDetailViewController (){
     sqlite3_stmt *insertStatement;
     NSString *databasePath;
    sqlite3 *contactDB;
}
@property (weak, nonatomic) IBOutlet UILabel *street;
@property (weak, nonatomic) IBOutlet UILabel *block;
@property (weak, nonatomic) IBOutlet UILabel *building;
@property (weak, nonatomic) IBOutlet UILabel *floor;
@property (weak, nonatomic) IBOutlet UILabel *postalcode;
@property (weak, nonatomic) IBOutlet UILabel *textName;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)addAsFavourite:(id)sender;

@end

@implementation MKDetailViewController
@synthesize kindergarten, textName , street, block , building, floor ,postalcode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    textName.text = kindergarten.name;
    street.text = kindergarten.street;
    block.text = kindergarten.block;
    floor.text = kindergarten.floor;
    postalcode.text =kindergarten.postalCode;
    building.text = kindergarten.building;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail2Feedback"]) {
        MKFeedbackViewController *feedbackViewController = segue.destinationViewController;
        feedbackViewController.kindergarten = kindergarten;
    }
}

- (IBAction)sendFeedback:(id)sender {
    [self performSegueWithIdentifier:@"Detail2Feedback" sender:self];
}

- (IBAction)addAsFavourite:(id)sender{
    
    //insert some data
    sqlite3_bind_text(insertStatement, 1, [kindergarten.ID UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 2, [kindergarten.name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 3, [kindergarten.street UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 4, [kindergarten.block UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 5, [kindergarten.building UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 6, [kindergarten.floor UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 7, [kindergarten.postalCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 8, [kindergarten.x_addr UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 9, [kindergarten.y_addr UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 10, [kindergarten.longitude UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 11, [kindergarten.latitude UTF8String], -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(insertStatement) == SQLITE_DONE) {
            NSLog(@"hahaha");
        [ToastView showInView:[self view] withText:@"Added successfully" duration:3];
        }else{
          NSLog(@"error happen : %s", sqlite3_errmsg(contactDB));
        }
    
    sqlite3_reset(insertStatement);
    sqlite3_clear_bindings(insertStatement);
}
-(void) prepareStatement{
    
    NSString *sqlString;
    const char *sql_stmt;
    
    //prepare insert sQL statement
    sqlString = [NSString stringWithFormat:@"INSERT INTO FAVOURITE (ID, NAME, STREET, BLOCK, BUILDING, FLOOR, POSTALCODE, X_ADDR,Y_ADDR,LONGITUDE,LATITUDE) VALUES(? ,?,? ,? ,?,?,?,?,?, ?, ?)"];
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &insertStatement, NULL);
}
@end
