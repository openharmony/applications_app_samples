//
// Created on 2024/4/7.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".
//
// Created on 2024/4/2.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include <bits/alltypes.h>
#include <linux/kd.h>
#include <malloc.h>
#include <string>

#include <string>
#include "napi/native_api.h"
#include "hilog/log.h"
#include "multimedia/image_framework/image/image_common.h"
#include "multimedia/image_framework/image/image_source_native.h"
#include "rawfile/raw_file.h"
#include "multimedia/image_framework/image/image_packer_native.h"
#include "hilog/log.h"
#include <assert.h>
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_TAG"

/*
OH_ImageSource2_CreateDecodingOptions(OH_ImageSource_DecodingOptions **opts);
return: OH_ImageSource_DecodingOptions*
*/
static napi_value CreateDecodingOptions(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;
    napi_value thisVar = nullptr;


    napi_get_undefined(env, &result);

    OH_DecodingOptions *deops;
    Image_ErrorCode errCode = OH_DecodingOptions_Create(&deops);
    if (IMAGE_SUCCESS != errCode) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(deops), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

/*
OH_ImageSource2_CreateFromUri(char *uri, size_t uriSize, OH_ImageSource **res);
argument[1]:url
argument[2]:SourceOptions sourceOpts
return: OH_ImageSource*
*/

static napi_value CreateFromUri(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1) {
        return result;
    }

    const size_t maxUrlLen = 512;
    char url[maxUrlLen];
    size_t urlSize = 0;
    napi_get_value_string_utf8(env, argValue[0], url, maxUrlLen, &urlSize);


    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(url, urlSize, &res);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

/*
OH_ImageSource2_CreateFromFd(int32_t fd, OH_ImageSource** res);
argument[1]:fd
return: OH_ImageSource*
*/

static napi_value CreateFromFd(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1) {
        return result;
    }
    int32_t fd;
    napi_get_value_int32(env, argValue[0], &fd);
    if (fd < 0) {
        napi_create_int32(env, -1, &result);
        return result;
    }


    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromFd(fd, &res);
    //    OH_LOG_INFO(LOG_APP, "CreateFromFd CreateFromFd fd: %{public}d,errCode: %{public}d",fd, errCode);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }

    return result;
}

/*
OH_ImageSource2_CreateFromData(uint8_t* data, size_t dataSize, OH_ImageSource**
res);
argument[1]: buffer
return: OH_ImageSource*
*/

static napi_value CreateFromData(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1) {
        return result;
    }

    void *data = nullptr;
    size_t dataSize = 0;

    napi_status status = napi_get_buffer_info(env, argValue[0], &data, &dataSize);
    if (status != napi_ok) {
        //        napi_throw_error(env, nullptr, "Failed to create napi_get_buffer_info object");
        return result;
    }

    //    memset(data_mod, 0, 1024*10);
    //    memcpy(data_mod, data, dataSize);
    OH_LOG_INFO(LOG_APP, "end OH_ImageSource2_CreatePixelMapList 721aaaa:%{public}d", dataSize);
    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode error = OH_ImageSourceNative_CreateFromData(reinterpret_cast<uint8_t *>(data), dataSize, &res);
    if (error != IMAGE_SUCCESS) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSource2_CreateFromData create external object,");
        return result;
    }

    status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSource2_CreateFromData create external object");
        return result;
    }

    return result;
}

/*
OH_ImageSource2_CreateFromRawFile(RawFileDescriptor rawFile,  OH_ImageSource**
res);
argument[1]: RawFileDescriptor{"fd","offset","length"}
return: result
*/
static napi_value CreateFromRawFile(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[3] = {0};
    size_t argCount = 3;
    napi_status status;

    napi_get_undefined(env, &result);

    OH_LOG_INFO(LOG_APP, "lhb CreateFromRawFile errCode====");

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 3) {
        return result;
    }

    RawFileDescriptor rawDesc;
    napi_get_value_int32(env, argValue[0], &rawDesc.fd);
    if (rawDesc.fd < 0) {
        napi_create_int32(env, -1, &result);
        return result;
    }
    int64_t tmp;
    napi_get_value_int64(env, argValue[1], &tmp);
    rawDesc.start = static_cast<long>(tmp);
    napi_get_value_int64(env, argValue[2], &tmp);
    rawDesc.length = static_cast<long>(tmp);

    OH_LOG_INFO(LOG_APP, "lhb CreateFromRawFile fd:%{public}d, start:%{public}ld, length:%{public}ld", rawDesc.fd,
                rawDesc.start, rawDesc.length);

    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromRawFile(&rawDesc, &res);
    if (errCode != IMAGE_SUCCESS) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSource2_CreateFromData create external object,");
        napi_create_int32(env, errCode, &result);
        return result;
    }
    status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

/*
OH_ImageSource2_CreatePixelMap(OH_ImageSource* source, OH_ImageSource_DecodingOptions* ops,OH_Pixelmap** resPixMap);
argument[1]: OH_ImageSource *
argument[2]: OH_ImageSource_DecodingOptions *
return: result
*/

static napi_value CreatePixelMap(napi_env env, napi_callback_info info) {
    // OH_LOG_ERROR(LOG_APP, "ImagePixelmapNativeCTest setInitializationOptions
    // OH_PixelMap2_InitializationOptionsGetWidth failed, ""errCode:");
    napi_value result = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[2] = {0};
    size_t argCount = 2;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 2) {
        return result;
    }
    OH_LOG_INFO(LOG_APP, "CreatePixelMap errCode====");
    // 检查第一个参数是否是一个对象
    //    napi_valuetype value;
    //    napi_status status = napi_typeof(env, argValue[0], &value);
    //    if (status != napi_ok || value != napi_object) {
    //        napi_throw_type_error(env, nullptr, "CreateFromRawFile First argument must be an object");
    //        return nullptr;
    //    }
    // get OH_ImageSource ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImageSourceNative *imageSource = reinterpret_cast<OH_ImageSourceNative *>(ptr);


    // get OH_ImageSource_DecodingOptions ptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_DecodingOptions *decodeOpts = reinterpret_cast<OH_DecodingOptions *>(ptr);

    // create pix map
    OH_PixelmapNative *resPixMap = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreatePixelmap(imageSource, decodeOpts, &resPixMap);
    if (IMAGE_SUCCESS != errCode) {
        //        napi_throw_type_error(env, nullptr, "OH_ImageSource2_CreatePixelMap First argument must be an
        //        object");
        napi_create_int32(env, errCode, &result);
        return result;
    }

    status = napi_create_external(env, reinterpret_cast<void *>(resPixMap), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return result;
    }
    return result;
}

/*
OH_ImagePacker2_CreatePackingOptions();
return: OH_ImagePacker_PackingOptions*
*/
static napi_value CreatePackingOptions(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_get_undefined(env, &result);


    OH_PackingOptions *res = nullptr;
    Image_ErrorCode errorCode = OH_PackingOptions_Create(&res);
    if (errorCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errorCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

/*
OH_ImagePacker2_PackingOptionsSetMimeType(OH_ImagePacker_PackingOptions *opts, Image_MimeType format);
arguments[1]: OH_ImagePacker_PackingOptions
arguments[2]: minetype string
return: errorcode
*/
static napi_value PackingOptionsSetMimeType(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[2] = {0};
    size_t argCount = 2;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 2) {
        return result;
    }

    // get OH_ImagePacker_PackingOptions ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_PackingOptions *packingOptions = reinterpret_cast<OH_PackingOptions *>(ptr);

    const uint32_t maxMineTypeLen = 512;
    char mineType[maxMineTypeLen];
    size_t mineTypeSize = 0;

    napi_get_value_string_utf8(env, argValue[1], mineType, maxMineTypeLen, &mineTypeSize);

    Image_MimeType tmpMineType;
    tmpMineType.data = new (std::nothrow) char[512];
    memcpy(tmpMineType.data, mineType, mineTypeSize);
    tmpMineType.data[mineTypeSize] = '\0';

    tmpMineType.size = mineTypeSize;
    Image_ErrorCode errCode = OH_PackingOptions_SetMimeType(packingOptions, &tmpMineType);

    napi_create_int32(env, errCode, &result);
    return result;
}

/*
OH_ImagePacker2_PackingOptionsSetQuality(OH_ImagePacker_PackingOptions *opts,uint32_t quality);
arguments[1]: OH_ImagePacker_PackingOptions *opts
arguments[2]: quality uint32_t
return: error code
*/
static napi_value PackingOptionsSetQuality(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[2] = {0};
    size_t argCount = 2;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 2) {
        return result;
    }

    // get OH_ImagePacker_PackingOptions ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_PackingOptions *packingOptions = reinterpret_cast<OH_PackingOptions *>(ptr);

    // get quality;
    uint32_t quality;
    status = napi_get_value_uint32(env, argValue[1], &quality);

    Image_ErrorCode errCode = OH_PackingOptions_SetQuality(packingOptions, quality);
    napi_create_int32(env, errCode, &result);
    return result;
}

/*
Image_ErrorCode OH_ImagePacker2_Create(OH_ImagePacker **imagePacker);
return: OH_ImagePacker*
*/
static napi_value PackerCreate(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;
    napi_get_undefined(env, &result);


    OH_ImagePackerNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&res);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }

    return result;
}

/*
OH_ImagePacker2_PackToDataFromImageSource(OH_ImagePacker *imagePacker,
                                                          OH_ImagePacker_PackingOptions *option,
                                                          OH_ImageSource *imageSource, uint8_t **outData, size_t *size);
arugment[1]:OH_ImagePacker*
arugment[2]:OH_ImagePacker_PackingOptions*
arugment[3]:OH_ImageSource*
argument[4]:uint8_t* output,
return: OH_ImagePacker*
*/
static napi_value PackToDataFromImageSource(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 4) {
        return result;
    }

    // get OH_ImagePacker ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    // get OH_ImagePacker_PackingOptions ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    // get OH_ImageSource ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[2], &ptr);
    OH_ImageSourceNative *imageSource = reinterpret_cast<OH_ImageSourceNative *>(ptr);


    //    size_t size = 0;
    //    uint8_t *outBuffer = new (std::nothrow) uint8_t[1024 * 1024 * 32];
    //    if (!outBuffer) {
    //        return result;
    //    }
    uint8_t *outBuffer = nullptr;
    size_t outBufferSize = 0;

    status = napi_get_buffer_info(env, argValue[3], (void **)&outBuffer, &outBufferSize);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create napi_get_buffer_info object");
        return result;
    }

    Image_ErrorCode errCode =
        OH_ImagePackerNative_PackToDataFromImageSource(packer, opts, imageSource, outBuffer, &outBufferSize);
    if (IMAGE_SUCCESS != errCode) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    napi_create_int32(env, outBufferSize, &result);
    //    delete[] outBuffer;

    //    OH_LOG_ERROR(LOG_APP,
    //                 "PackToDataFromImageSource,OH_ImagePacker: %{public}p,OH_ImagePacker_PackingOptions: "
    //                 "%{public}p,OH_ImageSource:%{public}p,errCode:%{public}d,size:%{public}d",
    //                 packer, opts, imageSource, errCode,size);
    return result;
}

/*
OH_ImagePacker2_PackToDataFromPixelMap(OH_ImagePacker* imagePacker, OH_ImagePacker_PackingOptions*
        option, OH_Pixelmap* pixelMap, uint8_t** outData, size_t* size); arugment[1]:OH_ImagePacker*
arugment[1]:OH_ImagePacker*
arugment[2]:OH_ImagePacker_PackingOptions*
arugment[3]:OH_Pixelmap*
argument[4]: uint8_t* outbuffer
return: Image_ErrorCode
*/

static napi_value PackToDataFromPixelMap(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 4) {
        return result;
    }


    // get OH_ImagePacker ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    // get OH_ImagePacker_PackingOptions ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    // get OH_Pixelmap ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[2], &ptr);
    OH_PixelmapNative *pixMap = reinterpret_cast<OH_PixelmapNative *>(ptr);

    Image_MimeType mineType;
    OH_PackingOptions_GetMimeType(opts, &mineType);
    
    uint8_t *outBuffer = nullptr;
    size_t outBufferSize = 0;

    status = napi_get_buffer_info(env, argValue[3], (void **)&outBuffer, &outBufferSize);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create napi_get_buffer_info object");
        return result;
    }

    Image_ErrorCode errCode =
        OH_ImagePackerNative_PackToDataFromPixelmap(packer, opts, pixMap, outBuffer, &outBufferSize);
    if (IMAGE_SUCCESS != errCode) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_create_int32(env, outBufferSize, &result);
    return result;
}

/*
OH_ImagePacker2_PackToFileFromImageSource(OH_ImagePacker* imagePacker, OH_ImagePacker_PackingOptions* option,
    OH_ImageSource* imageSource, int32_t fd);
arugment[1]:OH_ImagePacker*
arugment[2]:OH_ImagePacker_PackingOptions*
arugment[3]:OH_ImageSource*
argument[4]: fd int32_t
return: Image_ErrorCode
*/
static napi_value PackToFileFromImageSource(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 4) {
        return result;
    }

    // get OH_ImagePacker ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    // get OH_ImagePacker_PackingOptions ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    // get OH_ImageSource ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[2], &ptr);
    OH_ImageSourceNative *imageSource = reinterpret_cast<OH_ImageSourceNative *>(ptr);

    // get fd ptr;
    int fd;
    status = napi_get_value_int32(env, argValue[3], &fd);

    Image_ErrorCode errCode = OH_ImagePackerNative_PackToFileFromImageSource(packer, opts, imageSource, fd);

    napi_create_int32(env, errCode, &result);
    return result;
}

/*
OH_ImagePacker2_PackToFileFromPixelMap(OH_ImagePacker* imagePacker, OH_ImagePacker_PackingOptions* option,
    OH_Pixelmap* pixelMap, int32_t fd)
arugment[1]:OH_ImagePacker*
arugment[2]:OH_ImagePacker_PackingOptions*
arugment[3]:OH_Pixelmap*
argument[4]: fd int32_t
return: Image_ErrorCode
*/
static napi_value PackToFileFromPixelMap(napi_env env, napi_callback_info info) {
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 4) {
        return result;
    }

    // get OH_ImagePacker ptr;
    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    // get OH_ImagePacker_PackingOptions ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    // get OH_ImageSource ptr;
    ptr = nullptr;
    status = napi_get_value_external(env, argValue[2], &ptr);
    OH_PixelmapNative *pixmap = reinterpret_cast<OH_PixelmapNative *>(ptr);

    // get fd ptr;
    int fd;
    status = napi_get_value_int32(env, argValue[3], &fd);

    Image_ErrorCode errCode = OH_ImagePackerNative_PackToFileFromPixelmap(packer, opts, pixmap, fd);

    napi_create_int32(env, errCode, &result);
    return result;
}

EXTERN_C_START static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"CreateDecodingOptions", nullptr, CreateDecodingOptions, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromUri", nullptr, CreateFromUri, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromFd", nullptr, CreateFromFd, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromData", nullptr, CreateFromData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromRawFile", nullptr, CreateFromRawFile, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreatePixelMap", nullptr, CreatePixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},

        {"CreatePackingOptions", nullptr, CreatePackingOptions, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"PackingOptionsSetMimeType", nullptr, PackingOptionsSetMimeType, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackingOptionsSetQuality", nullptr, PackingOptionsSetQuality, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackerCreate", nullptr, PackerCreate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"PackToDataFromImageSource", nullptr, PackToDataFromImageSource, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackToDataFromPixelMap", nullptr, PackToDataFromPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"PackToFileFromImageSource", nullptr, PackToFileFromImageSource, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackToFileFromPixelMap", nullptr, PackToFileFromPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
