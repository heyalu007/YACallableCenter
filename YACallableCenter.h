
#import <Foundation/Foundation.h>

typedef id (^CallableBlock)(id data);

@interface YACallableCenter : NSObject

+ (instancetype)defaultCenter;
- (void)addCallable:(CallableBlock)callable tag:(NSString *)tag;
- (void)removeCallable:(CallableBlock)callable tag:(NSString *)tag;
- (void)removeCallable:(CallableBlock)callable;
- (void)removeCallablesWithKey:(NSString *)key;
- (void)removeAllCallables;
- (NSArray *)getEach:(NSString *)tag data:(id)data;
- (id)getFirst:(NSString *)tag data:(id)data;

@end