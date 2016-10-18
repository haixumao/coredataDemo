//
//  ViewController.m
//  coredata
//
//  Created by haixu on 16/10/14.
//  Copyright © 2016年 haixu. All rights reserved.
//

#import "ViewController.h"
#import "Entity.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *mutableArray;
//@property (nonatomic, strong) 
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UITextField *showTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.mutableArray = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加数据
- (IBAction)addData:(id)sender {
    
    //建立一个实体描述文件
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.appDelegate.managedObjectContext];
    //通过描述文件创建一个实体
    Entity * person = [[Entity alloc] initWithEntity: entityDescription insertIntoManagedObjectContext:self.appDelegate.managedObjectContext];
    
    if (_showTextField.text != nil) {
         person.name = _showTextField.text;
    } else {
        person.name = @"帅哥";
    }
   
    person.gender = @"男";
    
    //随机生成一个年龄
    int age = arc4random()%20 + 1;
    person.agg  = [NSNumber numberWithInt:age];
    //添加到数据中
//    [self.mutableArray insertObject:person atIndex:0];
    
    //调用持久化save方法保存到CoreData中
    [self.appDelegate saveContext];
    
    
}

- (IBAction)setMutableArrayWithCoredata:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age = 21", ];
    //    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"agg" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"数据查询错误%@",error);
    }else{
        //将查询到的数据添加到数据源中
        [self.mutableArray addObjectsFromArray:fetchedObjects];
    }
    if(self.mutableArray.count > 0) {
        NSString *tempString = @"";
        for(Entity * entity in self.mutableArray) {
            tempString = [tempString stringByAppendingString:entity.name];
        }
        self.textField.text = @"";
        self.textField.text = tempString;
    }
    
}
- (IBAction)deleteData:(id)sender {
    if (self.mutableArray.count == 0) {
        return;
    }
    Entity *person = self.mutableArray[0];
    [self.mutableArray removeObject:person];
    
    //删除CoreData中的数据
    [self.appDelegate.managedObjectContext deleteObject:person];
    
    //持久化一下
    [self.appDelegate saveContext];
}

@end
