//
//  ViewController.m
//  Test
//
//  Created by Swati Wadhera on 7/19/16.
//  Copyright © 2016 Swati Wadhera. All rights reserved.
//

#import "ViewController.h"

@class AppDelegate;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    [object setValue:nameTF.text forKey:@"name"];
    [object setValue:[NSNumber numberWithInteger:[contactTF.text intValue]] forKey:@"contact"];
    [object setValue:[NSNumber numberWithInteger:[idTF.text intValue]] forKey:@"id"];
    
    NSError *error = nil;
    [context save:&error];
    if(error)
        NSLog(@"error - %@",[error localizedDescription]);
}

- (IBAction)get:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
    for(NSManagedObject *object in list)
    {
        NSLog(@"employee name - %@\nemployee contact - %@\nemployee id - %@", [object valueForKey:@"name"], [object valueForKey:@"contact"], [object valueForKey:@"id"]);
    }
}

@end
