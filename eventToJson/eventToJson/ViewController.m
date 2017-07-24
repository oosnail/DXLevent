//
//  ViewController.m
//  eventToJson
//
//  Created by ztc on 2017/7/24.
//  Copyright © 2017年 ZTC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // appEventJson 是 excel 生成的json文件
    //使用 http://www.bejson.com/json/col2json/ 转json文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"appEventJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    //对excel数据进行修改
    NSMutableDictionary*newDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in list){
        if([dic objectForKey:@"event"]){
            [newDic setObject:dic forKey:[dic objectForKey:@"event"]];
        }
    }
    NSString *json = [self convertToJsonData: newDic];
    //打印json
    NSLog(@"%@", json);
    
    NSError *error;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:&error];
    if(!error){
        //生成json 写到桌面
        [jsonData2 writeToFile:@"/Users/simple/Desktop/test.json" atomically:YES];
        //生成plist 写到桌面
        [@[newDic] writeToFile:@"/Users/simple/Desktop/appEvent.plist" atomically:YES];
        
    }
    

    


    
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
