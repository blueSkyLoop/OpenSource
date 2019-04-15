//
//  LGDog.m
//  LOTest
//
//  Created by Lucas on 2019/2/26.
//

#import "LGDog.h"
#import "LGDog+Cate1.h"
#import "LGDog+Cate2.h"
#import "LGDog+Cate3.h"
#import <objc/message.h>
@implementation LGDog
+ (void)load{
    NSLog(@"%s",__func__);
}

+ (void)initialize {
    NSLog(@"%s",__func__);
}

- (instancetype)init {
    self  = [super init];
    if (self) {
        // self class 方法 -- objc_msgSend
        NSLog(@"%@",NSStringFromClass([self class]));
        
        // super class 消息 -- objc_SendSuper()
//        objc_msgSendSuper()
        NSLog(@"%@",NSStringFromClass([super class]));
    }
    return self;
}

@end
