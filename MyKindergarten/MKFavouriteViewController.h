//
//  MKFavouriteViewController.h
//  MyKindergarten
//
//  Created by sgp0607 on 28/04/14.
//  Copyright (c) 2014 Li YuFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MKKindergarten.h"
#import "MKDetailViewController.h"

@interface MKFavouriteViewController : UITableViewController{
    NSString *databasePath;
    
    sqlite3 *contactDB;
    sqlite3_stmt *selectStatement;
    sqlite3_stmt *insertStatement;
}

@property(strong, nonatomic) NSMutableArray *arrayData;
-(void)readFavouriteFromDB;

@end
