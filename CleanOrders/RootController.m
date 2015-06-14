//
//  ViewController.m
//  CleanOrders
//
//  Created by Andrew Liu on 6/12/15.
//  Copyright (c) 2015 Andrew Liu. All rights reserved.
//

#import "RootController.h"
#import "DetailViewController.h"

#define api @"http://beta.json-generator.com/api/json/get/BFRwUh6"

@interface RootController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayOfOrders;

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Orders";
    
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError && data) {
            NSError *error = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if(!error && jsonDictionary)
            {
                self.arrayOfOrders = jsonDictionary[@"orders"];
                [self.tableView reloadData];
            }
            else {
                [self displayAlert:error.localizedDescription];
            }
        }
        else {
            [self displayAlert:connectionError.localizedDescription];
        }
    }];
}

- (void)displayAlert:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = segue.destinationViewController;
    detailVC.dictionaryOfDetail = sender;
}

#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = self.arrayOfOrders[indexPath.row];
    cell.textLabel.text = dic[@"customerName"];
    cell.detailTextLabel.text = dic[@"startTime"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detailSegue" sender:self.arrayOfOrders[indexPath.row]];
}

@end
