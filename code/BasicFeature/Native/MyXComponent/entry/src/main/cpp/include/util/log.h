/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#ifndef LOG_H
#define LOG_H

#include <hilog/log.h>

#ifndef LOGI
#define LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif

#ifndef LOGD
#define LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif

#ifndef LOGW
#define LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif

#ifndef LOGE
#define LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif
#endif // _LOG_H_