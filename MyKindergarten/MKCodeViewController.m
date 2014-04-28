//
//  MKCodeViewController.m
//  MyKindergarten
//
//  Created by XXX on 26/4/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKCodeViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MKCodeViewController ()
{
    MKPointAnnotation *point;
}
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)search:(id)sender;
@end

@implementation MKCodeViewController
@synthesize textCode, mapView, indicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textCode setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Code2Detail"]) {
        
    } 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textCode resignFirstResponder];
    [self searchCode];
    return YES;
}

- (void)searchCode {
    [indicator startAnimating];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:textCode.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [indicator stopAnimating];
        
        CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
        CLLocationCoordinate2D coordinate = firstPlacemark.location.coordinate;
        
//        double latitude = coordinate.latitude;
//        double longitude = coordinate.longitude;
        
        MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
        if (point) {
            [self.mapView removeAnnotation:point];
        }
        point = [[MKPointAnnotation alloc] init];
        point.coordinate = coordinate;
        point.title = @"I am here!";
        
        [self.mapView addAnnotation:point];
        
        if (error) {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (void)showDetail {
    [self performSegueWithIdentifier:@"Code2Detail" sender:self];
}

- (IBAction)search:(id)sender {
    [self.textCode resignFirstResponder];
    [self searchCode];
}
@end
