//
//  MKKindergarten.m
//  MyKindergarten
//
//  Created by XXX on 28/04/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKKindergarten.h"

@implementation MKKindergarten
//@synthesize name, street, postalCode, block, building, coordinate, floor , latitude, longitude, x_addr, y_addr;

//- (id)initWithCoordiniate:(CLLocationCoordinate2D)coordinate name:(NSString *)name address:(NSString *)address postalCode:(NSString *)postalCode website:(NSString *)website phoneNum:(NSString *)phoneNum email:(NSString *)email {
//    self = [super init];
//    if (self) {
//        _coordinate = coordinate;
//        _name = name;
//        _address = address;
//        _postalCode = postalCode;
//        _website = website;
//        _phoneNum = phoneNum;
//        _email = email;
//    }
//    return self;
//}

-(id)initWithCoordiniate:(CLLocationCoordinate2D)coordinate name:(NSString *)name street:(NSString *)street postalCode:(NSString *)postalCode block:(NSString *)block building:(NSString *)building floor:(NSString *)floor x_addr:(NSString *)x_addr y_addr:(NSString *)y_addr longitude:(NSString *)longitude latitude:(NSString *)latitude kindergartenID:(NSString *)kindergartenID{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _name = name;
        _street =street;
        _postalCode = postalCode;
        _block = block;
        _building = building;
        _coordinate = coordinate;
        _floor = floor;
        _latitude = latitude;
        _longitude = longitude;
        _x_addr = x_addr;
        _y_addr = y_addr;
        _ID = kindergartenID;
    }
    return self;
}

- (NSString *)title {
        return _name;
}

- (NSString *)subtitle {
    NSString *s = @"";
    s = [s stringByAppendingString:_street];
    s = [s stringByAppendingString:@" "];
    s = [s stringByAppendingString:_postalCode];
    return s;
}

@end
