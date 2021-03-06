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
    
    [self getObjectWithProperty:nil andValue:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getObjectWithObjectID:(NSManagedObjectID *)objectID
{
    NSManagedObjectContext *context = [self managedObjectContext];
    //NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSManagedObject *object = [context existingObjectWithID:objectID error:nil];
    NSLog(@"\nEmployee Name - %@\nEmployee Contact - %@\nEmployee ID - %@", [object valueForKey:@"name"], [object valueForKey:@"contact"], [object valueForKey:@"id"]);
}

- (void)getObjectWithProperty:(NSString *)key andValue:(NSString *)value
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == 1"];
    [request setPredicate:predicate];
    NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSManagedObject *object = [list lastObject];
    NSLog(@"\nEmployee Name - %@\nEmployee Contact - %@\nEmployee ID - %@", [object valueForKey:@"name"], [object valueForKey:@"contact"], [object valueForKey:@"id"]);
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
    
    NSFetchRequest *newRequest = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
    NSArray *newList = [[context executeFetchRequest:newRequest error:nil] mutableCopy];
    for(NSManagedObject *object in newList)
    {
        NSLog(@"\nCompany Name - %@\nCompany Location - %@\nCompany ID - %@", [object valueForKey:@"name"], [object valueForKey:@"location"], [object valueForKey:@"id"]);
        for(NSManagedObject *nobject in [object valueForKey:@"employee"])
        {
            NSLog(@"\nEmployee Name - %@\nEmployee Contact - %@\nEmployee ID - %@", [nobject valueForKey:@"name"], [nobject valueForKey:@"contact"], [nobject valueForKey:@"id"]);
        }
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

- (IBAction)addCompany:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
    NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
    BOOL found = NO;
    for(NSManagedObject *object in list)
    {
        if([[object valueForKey:@"id"] isEqualToString:idTF.text])
        {
            found = YES;
            [object setValue:nameTF.text forKey:@"name"];
            [object setValue:contactTF.text forKey:@"location"];
            [object setValue:idTF.text forKey:@"id"];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
            NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
            NSSet *employees = [object valueForKey:@"employee"];
            if(!employees)
                employees = [NSSet set];
            for(NSManagedObject *object in list)
            {
                if([[object valueForKey:@"id"] isEqualToString:eidTF.text])
                {
                    employees = [employees setByAddingObject:object];
                }
            }
            [object setValue:employees forKey:@"employee"];

        }
    }
    
    if(!found)
    {
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:context];
        [newObject setValue:nameTF.text forKey:@"name"];
        [newObject setValue:contactTF.text forKey:@"location"];
        [newObject setValue:idTF.text forKey:@"id"];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
        NSArray *list = [[context executeFetchRequest:request error:nil] mutableCopy];
        NSSet *employees = [newObject valueForKey:@"employee"];
        if(!employees)
            employees = [NSSet set];
        for(NSManagedObject *object in list)
        {
            if([[object valueForKey:@"id"] isEqualToString:eidTF.text])
            {
                employees = [employees setByAddingObject:object];
            }
        }
        [newObject setValue:employees forKey:@"employee"];
    }
    

    
    NSError *error = nil;
    [context save:&error];
    if(error)
        NSLog(@"error - %@",[error localizedDescription]);
    else
        NSLog(@"Company %@ Successfully",found?@"Updated":@"Added");
}

@end
