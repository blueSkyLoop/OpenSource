//
//  main.m
//  LOTest
//
//  Created by Lucas on 2019/2/18.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "LGPerson.h"
#import "LGDog.h"
#import "LGStudent.h"

void lg_malloc () {
    LGPerson *p = [LGPerson alloc];
    NSLog(@"%zu",class_getInstanceSize([p class])); // 24?
    NSLog(@"%zu",malloc_size((__bridge const void *)(p)));
    // 查找方法的所在位置
    NSLog(@"%p",p.class); // 类对象 ---
    NSLog(@"%p",object_getClass(p.class)); // 元类对象 ---
    NSLog(@"end");  //class_data_bits_t
    // 1、类对象地址 0x1000012f0
    // 2、加两个偏移量打印，即：p (class_data_bits_t *)0x100001310
    // 3、打印：p $0->data() 得出： （class_rw_t *）$1 = 0x0712308fa88
    // 4、p *$1 打印出：（class_rw_t）$3 含有的内部数据 即如下：
    //   method_array_t methods; // 方法列表
    //   property_array_t properties; // 属性列表
    //   protocol_array_t protocols; // 协议列表
    
    // 5、获取ro里面的打印 p $3.ro 得到 baseMethodList
    
    // "v16@0:8", 16代表占总的字节数，@表示起始位置从 0 开始，“：“表示中间截断，8到后面第16位的空间
    // imp (id self SEL _cmd) 一共占16bit
    [p walk];
}

void lg_weaktable() {
    //        LGDog *d = [LGDog new];
    // 散列表中含有， weak_table
    // unregis old , regis new
    // 刷新数据
    // 如何存 -- 存到哪里去
    //        __weak id weakDog = d ;
}

void lg_methodSwizzling() {
    //  1. 没实现类方法，进行了方法交换
    [LGStudent walk];
    
    // 2. 没实现实例方法，进行了方法交换
    [[LGStudent new] run];
    /* LGPerson 没有实现 run 方法
      类方法的查找 -- 汇编
      找老爸类方法
      动态方法解析
      类的类方法 = 元类d实例方法 - (void)
      所以
     */
//    [LGPerson run];
    
}

void lg_category() {
    /* LGPerson ， LGPerson+Something 都有 walk 方法，但并不是进行了覆盖，
     而是 LGPerson+Something 的 walk 进行了先调用，并把它的 walk 排在了 LGPerson（walk）的前面
     
     */
    [[LGPerson new] walk];
    Class cls = [LGPerson class];
    unsigned int count;
    // 获得方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    // 存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    // 遍历所有的方法
    for (int i = 0; i < count; i++) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    // 释放
    free(methodList);
    // 打印方法名
    NSLog(@"%@ - %@", cls, methodNames);
    // 排序根据复杂度问题
    // LGPerson - walk(类别的方法), walk（类里的实例方法）, .cxx_destruct, name, setName:, age, setAge:,
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        lg_malloc();
//        lg_weaktable();
//        lg_methodSwizzling();
        lg_category();
    }
    return 0;
}
