//
//  DetailViewController.m
//  CleanOrders
//
//  Created by Andrew Liu on 6/13/15.
//  Copyright (c) 2015 Andrew Liu. All rights reserved.
//

#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "Order.h"

#define margin 20.0f
#define zoomInLevel 14
#define keyboardHeight 253.0f
#define naviBarHeight 64.0f
#define buttonWidth 50.0f
#define buttonHeight 30.0f

@interface DetailViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property IBOutlet UITextView *textView;
@property NSManagedObjectContext *moc;
@property Order *order;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Order"];
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"orderID == %@",self.dictionaryOfDetail[@"id"]]];
    NSArray *array = [self.moc executeFetchRequest:request error:nil];
    if (array.count == 0) {
        Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:self.moc];
        order.orderID = [NSString stringWithFormat:@"%@",self.dictionaryOfDetail[@"id"]];
        order.note = @"";
        [self.moc save:nil];
    }
    else {
        self.order = array.firstObject;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.dictionaryOfDetail[@"latitude"] doubleValue]
                                                            longitude:[self.dictionaryOfDetail[@"longitude"] doubleValue]
                                                                 zoom:zoomInLevel];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(margin, margin, self.view.frame.size.width-margin*2, self.view.frame.size.height/3) camera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = [NSString stringWithFormat:@"%@\n%@",self.dictionaryOfDetail[@"customerName"],self.dictionaryOfDetail[@"address"]];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    mapView.layer.borderColor = [UIColor blackColor].CGColor;
    mapView.layer.borderWidth = 2.0f;
    [self.detailScrollView addSubview: mapView];

    UILabel *customerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, self.view.frame.size.height/3+margin*2, self.view.frame.size.width-margin*2, margin)];
    customerNameLabel.text = [NSString stringWithFormat:@"Customer Name: %@",self.dictionaryOfDetail[@"customerName"]];
    [self.detailScrollView addSubview: customerNameLabel];

    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, customerNameLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin*2.1)];
    addressLabel.numberOfLines = 0;
    addressLabel.text = [NSString stringWithFormat:@"Address: %@",self.dictionaryOfDetail[@"address"]];
    [self.detailScrollView addSubview: addressLabel];
    
    UILabel *cleanerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, addressLabel.frame.origin.y+margin*3.1, self.view.frame.size.width-margin*2, margin)];
    cleanerNameLabel.text = [NSString stringWithFormat:@"Cleaner Name: %@",self.dictionaryOfDetail[@"cleanerName"]];
    [self.detailScrollView addSubview: cleanerNameLabel];
    
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, cleanerNameLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    startTimeLabel.text = [NSString stringWithFormat:@"Start Time: %@",self.dictionaryOfDetail[@"startTime"]];
    [self.detailScrollView addSubview: startTimeLabel];
    
    UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startTimeLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    endTimeLabel.text = [NSString stringWithFormat:@"End Time: %@",self.dictionaryOfDetail[@"endTime"]];
    [self.detailScrollView addSubview: endTimeLabel];
    
    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, endTimeLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    durationLabel.text = [NSString stringWithFormat:@"Duration: %@ hr",self.dictionaryOfDetail[@"duration"]];
    [self.detailScrollView addSubview: durationLabel];
    
    UILabel *numberOfBedroomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, durationLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    numberOfBedroomsLabel.text = [NSString stringWithFormat:@"Bedroom: %@",self.dictionaryOfDetail[@"numberOfBedrooms"]];
    [self.detailScrollView addSubview: numberOfBedroomsLabel];
    
    UILabel *numberOfBathroomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, numberOfBedroomsLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    numberOfBathroomsLabel.text = [NSString stringWithFormat:@"Bathroom: %@",self.dictionaryOfDetail[@"numberOfBathrooms"]];
    [self.detailScrollView addSubview: numberOfBathroomsLabel];
    
    UILabel *fridgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, numberOfBathroomsLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    if ([self.dictionaryOfDetail[@"fridge"] boolValue] == 1) {
        fridgeLabel.text = @"Fridge ☑︎";
    }
    else {
        fridgeLabel.text = @"Fridge ☒";
    }
    [self.detailScrollView addSubview: fridgeLabel];
    
    UILabel *ovenLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, fridgeLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin)];
    if ([self.dictionaryOfDetail[@"oven"] boolValue] == 1) {
        ovenLabel.text = @"Oven ☑︎";
    }
    else {
        ovenLabel.text = @"Oven ☒";
    }
    [self.detailScrollView addSubview: ovenLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(margin, ovenLabel.frame.origin.y+margin*2, self.view.frame.size.width-margin*2, margin*7)];
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 2.0f;
    self.textView.delegate = self;
    self.textView.text = self.order.note;
    [self.detailScrollView addSubview: self.textView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.textView.frame.size.width-buttonWidth, self.textView.frame.size.height-buttonHeight, buttonWidth, buttonHeight)];
    [button setTitle: @"Done" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveNoteOnButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2.0f;
    [self.textView addSubview: button];

    self.detailScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.textView.frame.origin.y+margin*8);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
    self.detailScrollView.contentInset = UIEdgeInsetsMake(naviBarHeight, 0, 0, 0);
}

- (void)saveNoteOnButtonPressed {
    self.order.note = self.textView.text;
    [self.moc save:nil];
    [self.textView resignFirstResponder];
    self.detailScrollView.contentInset = UIEdgeInsetsMake(naviBarHeight, 0, 0, 0);
}

#pragma mark - UITextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.detailScrollView.contentInset = UIEdgeInsetsMake(naviBarHeight, 0, keyboardHeight, 0);
    [self.detailScrollView scrollRectToVisible:CGRectMake(margin, self.textView.frame.origin.y, self.view.frame.size.width-margin*2, margin*8) animated:YES];
}

#pragma mark - Gesture Actions
- (IBAction)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.textView resignFirstResponder];
    self.detailScrollView.contentInset = UIEdgeInsetsMake(naviBarHeight, 0, 0, 0);
}

@end
