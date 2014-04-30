//
//  MKNameViewController.m
//  MyKindergarten
//
//  Created by XXX on 26/4/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKNameViewController.h"
#import "MKKindergarten.h"
#import "MKDetailViewController.h"

@interface MKNameViewController ()
{
    MKPointAnnotation *point;
}
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UITableView *autocompleteView;
@property (nonatomic, retain) NSMutableArray *suggestions;
@property (nonatomic, strong) MKKindergarten *kindergarten;

@end

@implementation MKNameViewController
@synthesize textName, mapView, indicator, autocompleteView, suggestions, kindergarten;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [textName setDelegate:self];
    [mapView setDelegate:self];
    //TODO set default location to Singapore with appropriate zoom level
//    CLLocationCoordinate2D defaultCoordinate = CLLocationCoordinate2DMake(1.352083, 103.819836);
    
    CGRect rect = textName.frame;
    autocompleteView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, 120) style:UITableViewStylePlain];
    [autocompleteView setDelegate:self];
    [autocompleteView setDataSource:self];
    [autocompleteView setScrollEnabled:YES];
    [autocompleteView setHidden:YES];
    [self.view addSubview:autocompleteView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Name2Detail"]) {
        MKDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.kindergarten = kindergarten;
    } 
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKKindergarten class]])
    {
        kindergarten = annotation;
        [self performSegueWithIdentifier:@"Name2Detail" sender:self];
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

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return suggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *identifier = @"suggestionIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [suggestions objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    textName.text = selectedCell.textLabel.text;
    [autocompleteView setHidden:YES];
    [textName resignFirstResponder];
    [self searchName];
}

#pragma mark - UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [autocompleteView setHidden:NO];
    [self getSuggestions];
    
    return YES;
}

#pragma mark - Custom Methods

- (void)getSuggestions {
    NSString *keyword = textName.text;
    //TODO API call to get suggestions
    NSArray *results = [[NSArray alloc] initWithObjects:@"Nanyang Kindergarten", nil];
    suggestions = [[NSMutableArray alloc] initWithArray:results];
    [autocompleteView reloadData];
}

- (void)searchName {
    [indicator startAnimating];
    //TODO mockup data here
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 1.317682;
    coordinate.longitude = 103.80584;
//    kindergarten = [[MKKindergarten alloc] initWithCoordiniate:coordinate name:@"Nanyang Kindergarten" address:@"118 King's Road Singapore" postalCode:@"268155" website:@"http://www.nanyangkindergarten.com" phoneNum:@"64663375" email:@"nykadmin@nanyangkindergarten.com"];
        kindergarten = [[MKKindergarten alloc]initWithCoordiniate:coordinate name:@"Nanyang Kindergarten" street:@"AMK Street 62" postalCode:@"90932" block:@"2" building:@"NCS Hub" floor:@"" x_addr:@"" y_addr:@"" longitude:@"" latitude:@"" kindergartenID:@"22"];
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotation:kindergarten];
    
    MKCoordinateRegion defaultRegion;
    defaultRegion.center = kindergarten.coordinate;
    defaultRegion.span.latitudeDelta = .01;
    defaultRegion.span.longitudeDelta = .01;
    [mapView setRegion:defaultRegion animated:YES];
    [indicator stopAnimating];
}

- (void)viewDetail {
    [self performSegueWithIdentifier:@"Name2Detail" sender:self];
}

@end
