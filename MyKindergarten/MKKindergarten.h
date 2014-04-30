//
//  MKKindergarten.h
//  MyKindergarten
//
//  Created by XXX on 28/04/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKKindergarten : NSObject <MKAnnotation>
//@property (nonatomic, readwrite) NSString *name;
//@property (nonatomic, readwrite) NSString *address;
//@property (nonatomic, readwrite) NSString *postalCode;
//@property (nonatomic, readwrite) NSString *website;
//@property (nonatomic, readwrite) NSString *phoneNum;
//@property (nonatomic, readwrite) NSString *email;
@property(readwrite, nonatomic)NSString *ID;
@property(readwrite, nonatomic)NSString *name;
@property(readwrite, nonatomic)NSString *street;
@property(readwrite, nonatomic)NSString *block;
@property(readwrite, nonatomic)NSString *postalCode;
@property(readwrite, nonatomic)NSString *building;
@property(readwrite, nonatomic)NSString *floor;
@property(readwrite, nonatomic)NSString *x_addr;
@property(readwrite, nonatomic)NSString *y_addr;
@property(readwrite, nonatomic)NSString *longitude;
@property(readwrite, nonatomic)NSString *latitude;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

//- (id)initWithCoordiniate:(CLLocationCoordinate2D)coordinate name:(NSString *)name address:(NSString *)address postalCode:(NSString *)postalCode website:(NSString *)website phoneNum:(NSString *)phoneNum email:(NSString *)email;

- (id)initWithCoordiniate:(CLLocationCoordinate2D)coordinate name:(NSString *)name street:(NSString *)street postalCode:(NSString *)postalCode block:(NSString *)block building:(NSString *)building floor:(NSString *)floor x_addr:(NSString *)x_addr y_addr:(NSString *)y_addr longitude:(NSString *)longitude latitude:(NSString *)latitude kindergartenID:(NSString *)kindergartenID;
@end
