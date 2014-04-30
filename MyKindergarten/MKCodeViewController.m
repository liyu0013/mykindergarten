//
//  MKCodeViewController.m
//  MyKindergarten
//
//  Created by XXX on 26/4/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKCodeViewController.h"
#import "MKKindergarten.h"
#import "MKDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MKCodeViewController ()
{
    MKPointAnnotation *point;
}
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, readwrite) NSMutableArray *kindergartens;
@property (nonatomic, strong) MKKindergarten *selectedKindergarten;

- (IBAction)search:(id)sender;
@end

@implementation MKCodeViewController
@synthesize textCode, mapView, indicator, kindergartens, selectedKindergarten;

- (void)viewDidLoad
{
    [super viewDidLoad];
    kindergartens = [[NSMutableArray alloc]init];
    [textCode setDelegate:self];
    [mapView setDelegate:self];
    MKCoordinateRegion defaultRegion;
    //TODO set default location to Singapore with appropriate zoom level
    defaultRegion.center = CLLocationCoordinate2DMake(1.352083, 103.819836);
    defaultRegion.span.latitudeDelta = .2;
    defaultRegion.span.longitudeDelta = .2;
    [mapView setRegion:defaultRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Code2Detail"]) {
        MKDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.kindergarten = selectedKindergarten;
    } 
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKKindergarten class]])
    {
        selectedKindergarten = annotation;
        [self performSegueWithIdentifier:@"Code2Detail" sender:self];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKKindergarten class]])
    {
        static NSString *kindergartenIdentifier = @"kindergartenIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kindergartenIdentifier];
        if (pinView == nil)
        {
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kindergartenIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = button;
            return customPinView;
        } else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    } else
    {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textCode resignFirstResponder];
    //TODO hardcoded
    [textCode setText:@"268155"];
    [self searchCode];
    return YES;
}

#pragma mark - Custom Methods

- (void)searchCode {
    //TODO API call here; mockup data here
    
    [indicator startAnimating];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:textCode.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [indicator stopAnimating];
        if (error) {
            NSLog(@"Error: %@", [error description]);
        }else{
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            [self relocate:firstPlacemark.location.coordinate];
            MKURLConnection *connection = [[MKURLConnection alloc]init];
            connection.delegate = self;
            NSString *searchURL = [NSString stringWithFormat:@"http://203.211.60.165/mtec-wlad/kindergarten/search/%f/%f/1.json",firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude];
            NSURL *url = [NSURL URLWithString:searchURL];
            [connection searchWithURL:url];
        }
    }];
    [indicator stopAnimating];
}

-(void)detailsReturned:(NSMutableData *)data{
    
}
-(void)suggestionsReturned:(NSMutableArray *)data{
    kindergartens = data;
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotations:kindergartens];
}

- (void)relocate: (CLLocationCoordinate2D) newCoordinate
{
    [mapView setCenterCoordinate:newCoordinate animated:YES];
    
    MKCoordinateRegion region;
    region.center = newCoordinate;
    region.span.latitudeDelta = .01;
    region.span.longitudeDelta = .01;
    
    [mapView setRegion:region animated:YES];
}

- (void)showDetail {
    [self performSegueWithIdentifier:@"Code2Detail" sender:self];
}

- (IBAction)search:(id)sender {
    [self.textCode resignFirstResponder];
    [self searchCode];
}

- (void)noConnection{
    NSLog(@"No WiFi connection") ;
}
@end
