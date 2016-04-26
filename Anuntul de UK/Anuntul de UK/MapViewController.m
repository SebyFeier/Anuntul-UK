//
//  MapViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 30/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AdsDetailsViewController.h"
#import "MenuTableViewController.h"

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.mapType = MKMapTypeStandard;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = 10;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *lastLocation = [locations lastObject];
    if (lastLocation) {
        
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    annot.title = @"Ad Name";
    [self.mapView addAnnotation:annot];
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}
- (IBAction)goToMainMenu:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    MenuTableViewController *menuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewControllerIdentifier"];
    [self.navigationController pushViewController:menuTableViewController animated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MyAnnotationView";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (view) {
        view.annotation = annotation;
//        view.image = [UIImage imageNamed:@"logo"];
    } else {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        view.canShowCallout = true;
        view.image = [UIImage imageNamed:@"logo"];
    }
    view.detailCalloutAccessoryView = [self detailViewForAnnotation:annotation];
    return view;
}

- (UIView *)detailViewForAnnotation:(id<MKAnnotation>)annotation {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.translatesAutoresizingMaskIntoConstraints = false;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Ad details";
    label.font = [UIFont systemFontOfSize:20];
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.numberOfLines = 0;
    [view addSubview:label];
    
    UIButton *button = [self yesButton];
    [view addSubview:button];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(label, button);
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:views]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]-[button]|" options:0 metrics:nil views:views]];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (UIButton *)yesButton {
    UIImage *image = [UIImage imageNamed:@"logo"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = false; // use auto layout in this case
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(detailButtonTapped:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    return button;
}

- (void)detailButtonTapped:(id)sender {
    
    AdsDetailsViewController *adsDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdsDetailsViewControllerIdentifier"];
    [self.navigationController pushViewController:adsDetailsViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
