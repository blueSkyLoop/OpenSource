//
//  main.m
//  LOTest
//
//  Created by Lucas on 2019/2/20.
//

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>
int main(int argc, const char * argv[]) {
	@autoreleasepool {
		
		void *p = calloc(1, 24); // 32
		NSLog(@"······%lu",malloc_size(p));
		
	}
	return 0;
}
