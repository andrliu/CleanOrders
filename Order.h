//
//  Order.h
//  CleanOrders
//
//  Created by Andrew Liu on 6/14/15.
//  Copyright (c) 2015 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSString * note;

@end
