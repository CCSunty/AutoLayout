//
//  BDPanThreadSafeDictionary.h
//  BusinessLayer
//
//  Created by Ducky on 2019/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDPanThreadSafeDictionary : NSObject

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary;
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithMutableDictionary:(NSMutableDictionary * _Nullable)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)numItems;

- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)removeObjectForKey:(id)aKey;

- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSArray *)allKeysForObject:(id)object;

- (void)setDictionary:(NSMutableDictionary*)dictionary;
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;

- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keys;

- (NSUInteger)count;

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

- (NSDictionary *)fetchDictionary;
- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
