//
//  ViewController.m
//  Lesson_14_Blocks
//
//  Created by Andrey Proskurin on 26.09.17.
//  Copyright © 2017 Andrey Proskurin. All rights reserved.
//

// http://fuckingblocksyntax.com - шпаргалка по блокам
// http://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a1

#import "ViewController.h"

typedef void (^CompletionBlock)(BOOL success, NSError *error);
static NSString *const kWeatherURL = @"http://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a1";

@interface ViewController ()

@property (nonatomic, copy) void (^SomeBlock)(void);
@property (nonatomic, copy) NSInteger (^SomeBlock_2)(void);
@property (nonatomic, copy) NSInteger (^SomeBlock_3)(NSString *name, NSUInteger age);
@property (nonatomic, copy) NSString *(^BlockWithBlock)(NSString *name, void(^block)(NSString * string));


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // СИНТАКСИС БЛОКА: возвращаемый тип (^ИмяБлока)(принимаемые параметры) = ^{ тело блока (какой-то код для выполнения) }
    
    // обращение к property
    
    self.SomeBlock = ^{
        NSLog(@"Some Block");
    };
    self.SomeBlock_3 = ^NSInteger(NSString *name, NSUInteger age) {
        return name.length;
    };
    
    if (self.SomeBlock_3) {
        self.SomeBlock_3(@"Name", 32);
    }
    
    self.BlockWithBlock = ^NSString *(NSString *name, void (^block)(NSString *string)) {
        if (block) {
            block(name);
        }
        
        return [NSString stringWithFormat:@"String: %@", name];
    };
    
    self.BlockWithBlock(@"Peter", nil);
    
//    CompletionBlock blockName = ^void(BOOL success, NSError *error) {
//
//    };
    
    
    
    __block NSInteger value = 5; // __block всегда используется, что-бы можно было менять значение переменной в блоке
                                 // (для использования переменной внутри блока)
    
    void (^TestBlock)(void) = ^{
        NSLog(@"Test Block Code Here... %lu", value);
        value = 4;
    };
    
    TestBlock();
    
    NSInteger (^BlockName)(void) = ^NSInteger(){
        return 24;
    };
    
    NSInteger someIntegerValue = BlockName();
    NSLog(@"Some Value = %lu", someIntegerValue);
    
    [self runWithCompletionBlock:TestBlock];
    [self runWithCompletionBlock:nil];
    [self runWithCompletionBlock:^{
        // внутри этого тела передается параметр (сразу реализовывается тело блока)
        NSLog(@"Run Block With Method...");
    }];
    
    [self runWithBlockWithParameters:^(NSString *name, NSUInteger age) {
        NSLog(@"Name: %@, Age: %lu", name, age); // передаваемый параметр
    }];
    
    // Запрос погоды
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kWeatherURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            // Error Parsing JSON
            NSLog(@"%@",jsonError.localizedDescription);
        } else {
            // Success Parsing JSON
            // Log NSDictionary response:
            NSLog(@"%@",jsonResponse);
        }
    }];
    
    [dataTask resume];
    
}

// Метод, который принимает в качестве параметра блок с параметрами
- (void)runWithBlockWithParameters:(void(^)(NSString *name, NSUInteger age))completionBlock {
    if (completionBlock) {
        completionBlock(@"John", 23);
    }
}

// Метод, который принимает в качестве параметра блок без параметров
- (void)runWithCompletionBlock:(void(^)(void))completionBlock {
    if (completionBlock) {
        completionBlock();
    }
}

// // Метод, который принимает в качестве параметра блок, записанный в typedef
- (void)runWithTypeDefBlock:(CompletionBlock)completionBlock {
    if (completionBlock) {
        completionBlock(YES, nil);
    }
}

// --------------------------- UIAlertController ---------------------------

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self displayAlertController];
}

- (void)displayAlertController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Do you want to become iOS Developer?"
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1 UIAlertControllerStyleActionSheet
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"NO"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button NO");
                                                          }]; // 2
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"YES"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button YES");
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"Hello");
    }]; // 6
}

@end
