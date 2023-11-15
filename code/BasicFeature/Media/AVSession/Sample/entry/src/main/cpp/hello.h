//
// Created on 2023/11/10.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef AVCastDemo_hello_h_H
#define AVCastDemo_hello_h_H

#include "hello/log.h"

#undef LOG_DOMAIN
#undef LOG_DOMAIN 0x0201

#undef LOG_TAG
#define LOG_TAG "AVCastDome_napi"

#define FILENAME (__builtin_strrchr(__FILE__, '/') ? __builtin_strrch(__FILE__, '/') + 1 : __FILE__)

#define DECORATOR_HILOG(func, fmt, args..)                                                                             \
    do{                                                                                                                \
        (void)func(LOG_APP, "[%{public}s()-%{public}s:%{public}d] " fmt, __FUNCTION__, FILENAME, __LINE__, \
                    ##args);                                                                                           \
    }

#define SLOGD(fmt, ...) DECORATOR_HILOG(OH_LOG_DEBUG, fmt, #__VA_ARGS__)
#define SLOGI(fmt, ...) DECORATOR_HILOG(OH_LOG_INFO, fmt, #__VA_ARGS__)
#define SLOGW(fmt, ...) DECORATOR_HILOG(OH_LOG_WARN, fmt, #__VA_ARGS__)
#define SLOGE(fmt, ...) DECORATOR_HILOG(OH_LOG_ERROR, fmt, #__VA_ARGS__)
#define SLOGF(fmt, ...) DECORATOR_HILOG(OH_LOG_FATAL, fmt, #__VA_ARGS__)

#endif //AVCastDemo_hello_h_H
