//
//  ZZJsonHelper.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/26.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZJsonHelper.h"

#define kNSObjectProtocolProperties @[@"hash", @"superclass", @"description", @"debugDescription"]

#pragma mark - static
static void __swizzleInstanceMethod(Class c, SEL original, SEL replacement);

#pragma mark - NSObject (ZZProperties)
@interface NSObject (ZZProperties)

const char *property_getTypeString(objc_property_t property);
// 返回属性列表
- (NSArray *)__jsonPropertiesOfClass:(Class)classType;
// 返回符合协议的属性
+ (NSString *)__propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName;
@end

#pragma mark - NSObject (ZZJsonHelper_helper)
@interface NSObject (ZZJsonHelper_helper)
+ (NSDateFormatter *)__jsonDateFormatter;
@end
#pragma mark -
@interface NSDictionary (__ZZJsonHelper)
- (id)__objectForKey:(id)key;
@end

#pragma mark - ZZJsonParser
@implementation ZZJsonParser
- (instancetype)initWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single
{
    self = [super init];
    if (self)
    {
        self.key    = key;
        self.clazz  = clazz;
        self.single = single;
    }
    return self;
}

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single
{
    return [[self alloc] initWithKey:key clazz:clazz single:single];
}

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz
{
    return [[self alloc] initWithKey:key clazz:clazz single:NO];
}

/**
 *   如果result是一个集合，并且只有一个元素，就直接返回集合中的元素。
 */
- (id)smartResult
{
    if ([_result isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray *) _result;
        if (array.count == 1)
        {
            return array.firstObject;
        }
    }
    return _result;
}
@end

#pragma mark - NSObject (ZZJsonHelper)
@implementation NSObject (ZZJsonHelper)

// 待重构
static NSMutableDictionary *ZZ_JSON_OBJECT_KEYDICTS = nil;

+ (BOOL)hasSuperProperties
{
    return NO;
}

+ (NSDictionary *)jsonKeyPropertyDictionary
{
    return [self __jsonKeyPropertyDictionary];
}

+ (NSMutableDictionary *)__jsonKeyPropertyDictionary
{
    if (!ZZ_JSON_OBJECT_KEYDICTS)
    {
        ZZ_JSON_OBJECT_KEYDICTS = [[NSMutableDictionary alloc] init];
    }
    
    NSString *objectKey = [NSString stringWithFormat:@"ZZ_JSON_%@", NSStringFromClass([self class])];
    NSMutableDictionary *dictionary = [ZZ_JSON_OBJECT_KEYDICTS __objectForKey:objectKey];
    if (!dictionary)
    {
        dictionary = [[NSMutableDictionary alloc] init];
        if ([self hasSuperProperties] && ![[self superclass] isMemberOfClass:[NSObject class]])
        {
            [dictionary setValuesForKeysWithDictionary:[[self superclass] jsonKeyPropertyDictionary]];
        }
        
        __swizzleInstanceMethod(self, @selector(valueForUndefinedKey:), @selector(__valueForUndefinedKey:));
        __swizzleInstanceMethod(self, @selector(setValue:forUndefinedKey:), @selector(__setValue:forUndefinedKey:));
        
        NSArray *properties = [self __jsonPropertiesOfClass:[self class]];
        [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *typeName = [self __propertyConformsToProtocol:@protocol(ZZJsonAutoBinding) propertyName:obj];
            if (typeName)
            {
                [dictionary setObject:typeName forKey:obj];
            }
            else
            {
                [dictionary setObject:obj forKey:obj];
            }
        }];
        
        if ([self conformsToProtocol:@protocol(NSObject)])
        {
            [dictionary removeObjectsForKeys:kNSObjectProtocolProperties];
        }
        
        [ZZ_JSON_OBJECT_KEYDICTS setObject:dictionary forKey:objectKey];
    }
    
    return dictionary;
}

+ (void)bindJsonKey:(NSString *)jsonKey toProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __jsonKeyPropertyDictionary];
    [dic removeObjectForKey:property];
    [dic setObject:property forKey:jsonKey];
}

+ (void)removeJsonKeyWithProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __jsonKeyPropertyDictionary];
    [dic removeObjectForKey:property];
}

- (NSString *)jsonString
{
    return self.jsonDictionary.jsonString;
}

- (NSData *)jsonData
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error) return jsonData;
    }
#ifdef DEBUG
    else
    {
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
    }
#endif
    return self.jsonDictionary.jsonData;
}


// 应该比较脆弱，不支持太复杂的对象。
- (NSDictionary *)jsonDictionary
{
    NSDictionary        *keyDict  = [self.class jsonKeyPropertyDictionary];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithCapacity:keyDict.count];
    [keyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value         = nil;
        id originalValue = [self valueForKey:key];
        if (NSClassFromString(obj))
        {
            if ([originalValue isKindOfClass:[NSArray class]])
            {
                value = [[originalValue jsonData] jsonString];
                //value = @{key : [[originalValue jsonData] jsonString]};
            }
            else
            {
                value = [originalValue jsonDictionary];
            }
        }
        else
        {
            value = [self valueForKey:obj];
        }
        if (value)
        {
            if ([value isKindOfClass:[NSDate class]]) {
                NSDateFormatter * formatter = [NSObject __jsonDateFormatter];
                value = [formatter stringFromDate:value];
            }
            [jsonDict setValue:value forKey:key];
        }
    }];
    return jsonDict;
}

// 待重构
static void __swizzleInstanceMethod(Class c, SEL original, SEL replacement)
{
    Method a = class_getInstanceMethod(c, original);
    Method b = class_getInstanceMethod(c, replacement);
    if (class_addMethod(c, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(c, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}

- (id)__valueForUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    // NSLog(@"%@ undefinedKey %@", self.class, key);
#endif
    return nil;
}

- (void)__setValue:(id)value forUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    // NSLog(@"%@ undefinedKey %@ and value is %@", self.class, key, value);
#endif
}

- (NSArray *)toModels:(Class)classType
{
    return nil;
}

- (NSArray *)toModels:(Class)classType forKey:(NSString *)key
{
    return nil;
}

- (id)toModel:(Class)classType
{
    return nil;
}

- (id)toModel:(Class)classType forKey:(NSString *)key
{
    return nil;
}

@end


#pragma mark - NSObject (Properties)
@implementation NSObject (Properties)
- (NSArray *)__jsonPropertiesOfClass:(Class)classType
{
    NSMutableArray  *propertyNames = [[NSMutableArray alloc] init];
    id              obj            = objc_getClass([NSStringFromClass(classType) cStringUsingEncoding:4]);
    unsigned int    outCount, i;
    objc_property_t *properties    = class_copyPropertyList(obj, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property      = properties[i];
        NSString        *propertyName = [NSString stringWithCString:property_getName(property) encoding:4];
        [propertyNames addObject:propertyName];
    }
    free(properties);
    
    return propertyNames;
}

+ (NSString *)__propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName
{
    NSString *typeName = [self typeOfPropertyNamed:propertyName];
    if (!typeName) return nil;
    
    typeName = [typeName stringByReplacingOccurrencesOfString:@"T@" withString:@""];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // nsarray对象符合自动绑定协议的
    NSRange range = [typeName rangeOfString:@"Array"];
    if (range.location != NSNotFound)
    {
        // todo, array对象里有多个协议
        NSRange beginRange = [typeName rangeOfString:@"<"];
        NSRange endRange   = [typeName rangeOfString:@">"];
        if (beginRange.location != NSNotFound && endRange.location != NSNotFound)
        {
            NSString *protocalName = [typeName substringWithRange:NSMakeRange(beginRange.location + beginRange.length, endRange.location - beginRange.location - 1)];
            if (NSClassFromString(protocalName))
            {
                return protocalName;
            }
        }
    }
    
    // 普通对象符合自动绑定协议的
    if ([NSClassFromString(typeName) conformsToProtocol:protocol])
    {
        return typeName;
    }
    
    return nil;
}

+ (NSString *)typeOfPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    return property ? [NSString stringWithUTF8String:(property_getTypeString(property))] : nil;
}
@end

#pragma mark - NSObject (ZZJsonHelper_helper)
@implementation NSObject (ZZJsonHelper_helper)
+ (NSDateFormatter *)__jsonDateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"__jsonDateFormatter"];
    
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter            = [[NSDateFormatter alloc] init];
                dateFormatter.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
                threadDictionary[@"__jsonDateFormatter"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
@end

const char *property_getTypeString(objc_property_t property)
{
    const char *attrs = property_getAttributes(property);
    if (attrs == NULL )
        return (NULL);
    
    static char buffer[256];
    const char *e = strchr(attrs, ',');
    if (e == NULL )
        return (NULL);
    
    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';
    
    return (buffer);
}

#pragma mark - NSString (ZZJsonHelper)
@implementation NSString (ZZJsonHelper)
- (id)toModel:(Class)classType
{
    return [self.__toData toModel:classType];
}

- (id)toModel:(Class)classType forKey:(NSString *)jsonKey
{
    return [self.__toData toModel:classType forKey:jsonKey];
}

- (NSArray *)toModels:(Class)classType
{
    return [self.__toData toModels:classType];
}

- (NSArray *)toModels:(Class)classType forKey:(NSString *)jsonKey
{
    return [self.__toData toModels:classType forKey:jsonKey];
}



- (id)jsonValue
{
    return self.__toData.jsonValue;
}

#pragma mark - private
- (NSData *)__toData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end

#pragma mark - NSDictionary (ZZJsonHelper)
@implementation NSDictionary (ZZJsonHelper)
- (NSString *)jsonString
{
    NSData *jsonData = self.jsonData;
    
    return jsonData ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : nil;
}

- (id)__objectForKey:(id)key
{
    return key ? [self objectForKey:key] : nil;
}
@end


#pragma mark - NSData (ZZJsonHelper)
@implementation NSData (ZZJsonHelper)

- (id)toModel:(Class)classType
{
    return [self toModel:classType forKey:nil];
}

- (id)toModel:(Class)classType forKey:(NSString *)key
{
    if (classType == nil)
        return nil;
    
    id jsonValue = [self __jsonValueForKey:key];
    if (jsonValue == nil)
        return nil;
    
    NSDictionary *dic = [classType jsonKeyPropertyDictionary];
    id model          = [NSData objectForClassType:classType fromDict:jsonValue withJsonKeyPropertyDictionary:dic];
    
    return model;
}

- (NSArray *)toModels:(Class)classType
{
    return [self toModels:classType forKey:nil];
}

- (NSArray *)toModels:(Class)classType forKey:(NSString *)key
{
    if (classType == nil)
        return nil;
    
    id jsonValue = [self __jsonValueForKey:key];
    if (jsonValue == nil)
        return nil;
    
    NSDictionary *dic = [classType jsonKeyPropertyDictionary];
    if ([jsonValue isKindOfClass:[NSArray class]])
    {
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[jsonValue count]];
        [jsonValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForClassType:classType fromDict:obj withJsonKeyPropertyDictionary:dic];
            if (model)
            {
                [models addObject:model];
            }
        }];
        
        return models;
    }
    else if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        return [NSData objectForClassType:classType fromDict:jsonValue withJsonKeyPropertyDictionary:dic];
    }
    
    return nil;
}

- (id)jsonValue
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:Json_string_options error:&error];
    
#ifdef DEBUG
    if (error != nil) NSLog(@"%@", error);
#endif
    
    if (error != nil)
        return nil;
    
    return result;
}

+ (id)__objectsForClassType:(Class)classType fromArray:(NSArray *)array
{
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSDictionary *dic      = [classType jsonKeyPropertyDictionary];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [self objectForClassType:classType fromDict:obj withJsonKeyPropertyDictionary:dic];
        if (model)
        {
            [models addObject:model];
        }
    }];
    return models;
}

+ (id)objectForClassType:(Class)classType
                fromDict:(NSDictionary *)dict
withJsonKeyPropertyDictionary:(NSDictionary *)jsonKeyPropertyDictionary
{
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (![jsonKeyPropertyDictionary isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (!classType)
    {
        return nil;
    }
    
    id model = [[classType alloc] init];
    [jsonKeyPropertyDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([[dict valueForKeyPath:key] isKindOfClass:[NSArray class]])
        {
            if ([self __classForString:obj valueKey:nil])
            {
                NSString *valueKey = nil;
                NSArray *array = [self __objectsForClassType:[self __classForString:obj valueKey:&valueKey] fromArray:[dict valueForKeyPath:key]];
                if (array.count)
                {
                    if (valueKey)
                    {
                        key = valueKey;
                    }
                    [model setValue:array forKey:key];
                }
            }
            else
            {
                [model setValue:[dict valueForKeyPath:key] forKey:obj];
            }
        }
        else if ([[dict valueForKeyPath:key] isKindOfClass:[NSDictionary class]])
        {
            NSString *valueKey = nil;
            Class otherClass = [self __classForString:obj valueKey:&valueKey];
            if (otherClass)
            {
                id object = [self objectForClassType:classType fromDict:[dict valueForKeyPath:key] withJsonKeyPropertyDictionary:[otherClass jsonKeyPropertyDictionary]];
                if (object)
                {
                    if (valueKey)
                    {
                        key = valueKey;
                    }
                    [model setValue:object forKeyPath:key];
                }
            }
            else
            {
                [model setValue:[dict valueForKeyPath:key] forKey:obj];
            }
        }
        else
        {
            id value = [dict valueForKeyPath:key];
            if (![value isKindOfClass:[NSNull class]] && value != nil)
            {
                [model setValue:value forKey:obj];
            }
        }
    }];
    return model;
}

- (NSString *)jsonString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (id)__jsonValueForKey:(NSString *)key
{
    if (key && [[self jsonValue] isKindOfClass:[NSDictionary class]])
    {
        return [[self jsonValue] valueForKeyPath:key];
    }
    else
    {
        return [self jsonValue];
    }
}

+ (Class)__classForString:(NSString *)string valueKey:(NSString **)key
{
    if (string.length > 0)
    {
        if ([string rangeOfString:@"."].length>0)
        {
            NSArray *strings = [string componentsSeparatedByString:@"."];
            if (strings.count>1)
            {
                *key = strings.firstObject;
                return NSClassFromString(strings.lastObject);
            }
        }
        else
        {
            return NSClassFromString(string);
        }
    }
    return nil;
}

- (id)jsonValueForKeyPath:(NSString *)key
{
    id jsonValue = [self jsonValue];
    if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)jsonValue;
        return [dic valueForKeyPath:key];
    }
    return nil;
}

- (NSDictionary *)dictionaryForKeyPaths:(NSArray *)keys
{
    id jsonValue = [self jsonValue];
    if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)jsonValue;
        NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            id jsonValue = [dic valueForKeyPath:key];
            if (jsonValue)
            {
                [jsonDic setObject:jsonValue forKey:key];
            }
        }];
        return jsonDic;
    }
    return nil;
}

- (void)parseToObjectWithParsers:(NSArray *)parsers
{
    id jsonValue = [self jsonValue];
    if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        [parsers enumerateObjectsUsingBlock:^(ZZJsonParser *parser, NSUInteger idx, BOOL *stop) {
            id obj = [jsonValue objectForKey:parser.key];
            id result = nil;
            //如果没有clazz，则说明不是Model，直接原样返回
            if (parser.clazz)
            {
                if (parser.single)
                {
                    result = [obj toModel:parser.clazz];
                }
                else
                {
                    if ([obj isKindOfClass:[NSDictionary class]])
                    {
                        result = [[(NSDictionary *)obj jsonString] toModel:parser.clazz];
                    }
                    else
                    {
                        result = [obj toModels:parser.clazz];
                    }
                }
            }
            else
            {
                result = obj;
            }
            parser.result = result;
        }];
    }
}

@end


#pragma mark - NSArray (ZZJsonHelper)
@implementation NSArray (ZZJsonHelper)

- (NSString *)jsonString
{
    return self.jsonData.jsonString;
}

//  循环集合将每个对象转为字典，得到字典集合，然后转为jsonData
- (NSData *)jsonData
{
    NSMutableArray *jsonDictionaries = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        [jsonDictionaries addObject:obj.jsonDictionary];
    }];
    if ([NSJSONSerialization isValidJSONObject:jsonDictionaries])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionaries options:kNilOptions error:&error];
        if (!error)
        {
            return jsonData;
        }
    }
#ifdef DEBUG
    else
    {
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
    }
#endif
    return nil;
}

- (NSArray *)toModels:(Class)classType
{
    if ([self isKindOfClass:[NSArray class]] && self.count > 0)
    {
        NSDictionary *dic      = [classType jsonKeyPropertyDictionary];
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[self count]];
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForClassType:classType fromDict:obj withJsonKeyPropertyDictionary:dic];
            if (model)
            {
                [models addObject:model];
            }
        }];
        return models;
    }
    return nil;
}
@end