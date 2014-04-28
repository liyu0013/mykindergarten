//
//  MKDetailViewController.m
//  MyKindergarten
//
//  Created by XXX on 26/4/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKDetailViewController.h"
#import "MKFeedbackViewController.h"

@interface MKDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textName;
- (IBAction)sendFeedback:(id)sender;

@end

@implementation MKDetailViewController
@synthesize kindergarten, textName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    textName.text = kindergarten.name;
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
@end
