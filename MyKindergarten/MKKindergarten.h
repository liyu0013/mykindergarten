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
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *address;
@property (nonatomic, readwrite) NSString *postalCode;
@property (nonatomic, readwrite) NSString *website;
@property (nonatomic, readwrite) NSString *phoneNum;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithCoordiniate:(CLLocationCoordinate2D)coordinate name:(NSString *)name address:(NSString *)address postalCode:(NSString *)postalCode website:(NSString *)website phoneNum:(NSString *)phoneNum email:(NSString *)email;
@end
