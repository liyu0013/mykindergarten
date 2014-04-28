//
//  MKKindergarten.m
//  MyKindergarten
//
//  Created by XXX on 28/04/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKKindergarten.h"

@implementation MKKindergarten
//@synthesize name, address, postalCode, website, phoneNum, coordinate;

- (id)initWithCoordiniate:(CLLocationCoordinate2D)coordinate name:(NSString *)name address:(NSString *)address postalCode:(NSString *)postalCode website:(NSString *)website phoneNum:(NSString *)phoneNum email:(NSString *)email {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _name = name;
        _address = address;
        _postalCode = postalCode;
        _website = website;
        _phoneNum = phoneNum;
        _email = email;
    }
    return self;
}

- (NSString *)title {
        return _name;
}

- (NSString *)subtitle {
    NSString *s = @"";
    s = [s stringByAppendingString:_address];
    s = [s stringByAppendingString:@" "];
    s = [s stringByAppendingString:_postalCode];
    return s;
}

@end
