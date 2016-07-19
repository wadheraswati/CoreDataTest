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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
    BOOL found = NO;
    for(NSManagedObject *object in list)
    {
        if([[object valueForKey:@"id"] isEqualToString:idTF.text])
        {
            found = YES;
            [object setValue:nameTF.text forKey:@"name"];
            [object setValue:contactTF.text forKey:@"contact"];
            [object setValue:idTF.text forKey:@"id"];
        }
    }
    
    if(!found)
    {
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
        [newObject setValue:nameTF.text forKey:@"name"];
        [newObject setValue:contactTF.text forKey:@"contact"];
        [newObject setValue:idTF.text forKey:@"id"];
    }
    
    NSError *error = nil;
    [context save:&error];
    if(error)
        NSLog(@"error - %@",[error localizedDescription]);
    else
        NSLog(@"%@ Successfully",found?@"Updated":@"Added");
}

- (IBAction)get:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
    for(NSManagedObject *object in list)
    {
        NSLog(@"\nEmployee Name - %@\nEmployee Contact - %@\nEmployee ID - %@", [object valueForKey:@"name"], [object valueForKey:@"contact"], [object valueForKey:@"id"]);
    }
}

- (IBAction)delete:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
    BOOL found = NO;
    for(NSManagedObject *object in list)
    {
        if([[object valueForKey:@"id"] isEqualToString:idTF.text])
        {
            found = YES;
            [context deleteObject:object];
        }
    }
    NSError *error = nil;
    [context save:&error];
    if(error)
        NSLog(@"error - %@",[error localizedDescription]);
    else
        NSLog(@"%@",found?@"Deleted Successfully":@"ID not found");

}

@end
