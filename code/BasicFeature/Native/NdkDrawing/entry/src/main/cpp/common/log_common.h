//
// Created on 2023/10/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef LOG_COMMON_H
#define LOG_COMMON_H
#include <hilog/log.h>
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
#define APP_LOG_DOMAIN 0x0001
#define APP_LOG_TAG "DrawingSample"
#define DRAWING_LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, APP_LOG_TAG, __VA_ARGS__))
#define DRAWING_LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, APP_LOG_TAG, __VA_ARGS__))
#define DRAWING_LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, APP_LOG_TAG, __VA_ARGS__))
#define DRAWING_LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, APP_LOG_TAG, __VA_ARGS__))

#endif // LOG_COMMON_H
