//
//  NSObject+LGKC.m
//  LOTest
//
//  Created by Lucas on 2019/2/28.
//

#import "NSObject+LGKC.h"
#import <objc/runtime.h>
@implementation NSObject (LGKC)
void lg_crashMethod(){
    NSLog(@"%s",__func__);
//    show_alterView();
}

/*
 Student 使用了 -(void)run ,但并未实现；
 会调用了 NSObject (LGKC) 的 +(void)run
 类方法 -- 父类 动态方法解析
 实例方法 --
 元类列表是否有 -- 对象方法
 对象方法的储存 -- 类
 类方法的储存 -- 元类
 class_getInstanceMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)
 class_getClassMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)
 */

+ (void)run{
    NSLog(@"%s",__func__);
}


@end
