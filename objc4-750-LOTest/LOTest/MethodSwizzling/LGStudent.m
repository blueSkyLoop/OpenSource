//
//  LGStudent.m
//  01-Runtime 初探
//
//  Created by cooci on 2018/11/27.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "LGStudent.h"
#import <objc/runtime.h>
@implementation LGStudent
//- (void)run{
//    NSLog(@"%s",__func__);
//}
//+ (void)walk{
//    NSLog(@"%s",__func__);
//}

+ (void)eat {
    NSLog(@"%s",__func__);
}

- (void)read {
    NSLog(@"%s",__func__);
}

void lg_classMethod (){
    NSLog(@"--- lg_classMethod");
}

#pragma mark - 动态方法解析

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"来了 老弟--- resolveInstanceMethod");
    /*
     运行
     执行 run sel -- imp
     objc_msgSend
     run sel + imp
     imp
     重新再查找一次 sel imp --> imp
     汇编之后 -- 漫长的查找过程
     快速查找
     动态方法解析的实质 -- sel : imp(无)
     系统调用 resolveInstanceMethod
     sel + imp 系统自动再次查找 imp
     重定向
     */

    if (sel == @selector(run)) {
        const char *type = method_getTypeEncoding(class_getInstanceMethod(self, @selector(read)));
        return class_addMethod(self, sel, (IMP)lg_classMethod, type);
    }
   return [super resolveInstanceMethod:sel];
}



//+ (BOOL)resolveClassMethod:(SEL)sel{
//    NSLog(@"来了 老弟--- resolveClassMethod");
//    if(sel == @selector(walk)){
//        // 类对象 要获取 元类存储的类方法 取出 type
//        const char *type = method_getTypeEncoding(class_getInstanceMethod(object_getClass(self), @selector(eat)));
//        return class_addMethod(object_getClass(self), sel, (IMP)lg_classMethod,type);
//    }
//    // 如果是其他方法的话，就再往上层查找，若一直没有处理的话，就会找到 NSObject 里面 return NO 直接崩溃
//    return  [super resolveClassMethod:sel];
//}

// 只有汇编调用，没有源码实现
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}



/// 方法名注册
+ (NSMethodSignature* )methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(walk)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    //NSLog(@"%s", __func__);
    
    // [anInvocation invokeWithTarget:[TZDog new]];
    
    /// 转发给自己
    NSString *sto = @"奔跑少年";
    [anInvocation setArgument:&sto atIndex:2];
    anInvocation.selector = @selector(run);
    anInvocation.target = self;
    [anInvocation invoke];
}
@end
