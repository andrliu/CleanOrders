//
//  DetailViewController.m
//  CleanOrders
//
//  Created by Andrew Liu on 6/13/15.
//  Copyright (c) 2015 Andrew Liu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = self.dic[@"cleanerName"];
}

@end
