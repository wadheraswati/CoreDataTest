//
//  ViewController.h
//  Test
//
//  Created by Swati Wadhera on 7/19/16.
//  Copyright © 2016 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ViewController : UIViewController
{
    IBOutlet UITextField *nameTF;
    IBOutlet UITextField *contactTF;
    IBOutlet UITextField *idTF;
}

- (NSManagedObjectContext *) managedObjectContext;

@end

