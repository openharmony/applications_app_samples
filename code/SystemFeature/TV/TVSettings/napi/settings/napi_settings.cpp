/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi_settings.h"

#include <pthread.h>
#include <unistd.h>

#include "abs_shared_result_set.h"
#include "data_ability_helper.h"
#include "data_ability_predicates.h"
#include "napi_settings_log.h"
#include "values_bucket.h"

#include "napi_base_context.h"
#include "datashare_helper.h"
#include "datashare_predicates.h"


using namespace OHOS::AppExecFwk;
using namespace OHOS::DataShare;

namespace OHOS {
namespace Settings {
const OHOS::HiviewDFX::HiLogLabel SETTINGS_LABEL = { LOG_APP, 0x0500, "Settings" };
const std::string SETTINGS_DATA_BASE_URI = "datashare:///com.ohos.settingsdata.DataAbility";
const std::string SETTINGS_DATA_FIELD_KEYWORD = "KEYWORD";
const std::string SETTINGS_DATA_FIELD_VALUE = "VALUE";

/**
 * @brief Wrap void to js value.
 * ability_context
 * @param env the environment that the Node-API call is invoked under
 * @return napi_value napi_value after wrapped
 */
napi_value wrap_void_to_js(napi_env env)
{
    napi_value result = nullptr;
    NAPI_CALL(env, napi_get_null(env, &result));
    return result;
}

/**
 * @brief Unwrap string from js value.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param param js value to unwrap
 * @return std::string string value after unwrapped
 */
std::string unwrap_string_from_js(napi_env env, napi_value param)
{
    std::string defaultValue("");

    size_t size = 0;
    if (napi_get_value_string_utf8(env, param, nullptr, 0, &size) != napi_ok) {
        return defaultValue;
    }

    if (size == 0) {
        return defaultValue;
    }

    std::string value("");

    char *buf = new (std::nothrow) char[size + 1];
    if (buf == nullptr) {
        SETTING_LOG_INFO("settingsnapi : unwarp");
        return value;
    }
    memset_s(buf, size + 1, 0, size + 1);

    bool rev = napi_get_value_string_utf8(env, param, buf, size + 1, &size) == napi_ok;
    if (rev) {
        value = buf;
    } else {
        value = defaultValue;
    }

    delete[] buf;
    buf = nullptr;
    SETTING_LOG_INFO("settingsnapi : unwarp string is : %{public}s", value.c_str());
    return value;
}

/**
 * @brief Wrap string to js value.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param value string value to be wrap
 * @return napi_value js value after wrapped
 */
napi_value wrap_string_to_js(napi_env env, const std::string &value)
{
    napi_value result = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, value.c_str(), NAPI_AUTO_LENGTH, &result));
    return result;
}

/**
 * @brief Wrap bool to js value.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param value bool value to be wrap
 * @return napi_value js value after wrapped
 */
napi_value wrap_bool_to_js(napi_env env, bool value)
{
    napi_value result = nullptr;
    NAPI_CALL(env, napi_get_boolean(env, value, &result));
    return result;
}

struct AsyncCallbackInfo {
    napi_env env;
    napi_async_work asyncWork;
    napi_deferred deferred;
    napi_ref callbackRef;
    DataAbilityHelper *dataAbilityHelper;
    std::string key;
    std::string value;
    std::string uri;
    int status;
    std::shared_ptr<DataShareHelper> dataShareHelper = nullptr;
};

struct AsyncWorkCallbacks {
    napi_async_execute_callback executeCallback;
    napi_async_complete_callback completeCallback;
};

void GetValueExecuteExt(napi_env env, void *data);
void CompleteCall(napi_env env, napi_status status, void *data, const napi_value retVaule);
void CompletePromise(napi_env env, napi_status status, void *data, const napi_value retVaule);
void SetValueExecuteExt(napi_env env, void *data, const std::string setValue);
void DeleteCallbackInfo(napi_env env, AsyncCallbackInfo *asyncCallbackInfo);
napi_value napi_set_value_ext(napi_env env, napi_callback_info info, const bool stageMode);

AsyncCallbackInfo* CreateAsyncCallbackInfo(napi_env env)
{
    return new AsyncCallbackInfo {
        .env = env,
        .asyncWork = nullptr,
        .deferred = nullptr,
        .callbackRef = nullptr,
        .dataAbilityHelper = nullptr,
        .key = "",
        .value = "",
        .uri = "",
        .status = false,
    };
}

napi_value QueueCallbackWork(napi_env env, AsyncCallbackInfo* asyncCallbackInfo, napi_value callback,
    napi_value resource, const AsyncWorkCallbacks &callbacks)
{
    napi_create_reference(env, callback, 1, &asyncCallbackInfo->callbackRef);
    napi_create_async_work(
        env,
        nullptr,
        resource,
        callbacks.executeCallback,
        callbacks.completeCallback,
        static_cast<void*>(asyncCallbackInfo),
        &asyncCallbackInfo->asyncWork);
    NAPI_CALL(env, napi_queue_async_work(env, asyncCallbackInfo->asyncWork));
    return wrap_void_to_js(env);
}

napi_value QueuePromiseWork(napi_env env, AsyncCallbackInfo* asyncCallbackInfo, napi_value resource,
    napi_async_execute_callback executeCallback, napi_async_complete_callback completeCallback)
{
    napi_value promise = nullptr;
    napi_deferred deferred = nullptr;
    NAPI_CALL(env, napi_create_promise(env, &deferred, &promise));
    asyncCallbackInfo->deferred = deferred;
    napi_create_async_work(
        env,
        nullptr,
        resource,
        executeCallback,
        completeCallback,
        static_cast<void*>(asyncCallbackInfo),
        &asyncCallbackInfo->asyncWork);
    NAPI_CALL(env, napi_queue_async_work(env, asyncCallbackInfo->asyncWork));
    return promise;
}

napi_value CreateUnsupportedError(napi_env env)
{
    napi_value error = nullptr;
    napi_create_object(env, &error);
    constexpr int unsupportedCode = 801;
    napi_value errCode = nullptr;
    napi_create_int32(env, unsupportedCode, &errCode);
    napi_set_named_property(env, error, "code", errCode);
    return error;
}

void UnsupportedExecuteCB(napi_env env, void *data)
{
}

void UnsupportedCallbackComplete(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : callback async end data is null");
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result[PARAM2] = { CreateUnsupportedError(env), nullptr };
    napi_get_undefined(env, &result[PARAM1]);
    napi_value callback = nullptr;
    napi_value undefined = nullptr;
    napi_get_undefined(env, &undefined);
    napi_get_reference_value(env, asyncCallbackInfo->callbackRef, &callback);
    napi_value callResult = nullptr;
    napi_call_function(env, undefined, callback, PARAM2, result, &callResult);
    SETTING_LOG_INFO("settingsnapi : callback aysnc end called");
    DeleteCallbackInfo(env, asyncCallbackInfo);
    SETTING_LOG_INFO("settingsnapi : callback change callback complete");
}

void UnsupportedBoolCallbackComplete(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : callback async end data is null");
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result[PARAM2] = { CreateUnsupportedError(env), wrap_bool_to_js(env, false) };
    napi_value callback = nullptr;
    napi_value undefined = nullptr;
    napi_get_undefined(env, &undefined);
    napi_get_reference_value(env, asyncCallbackInfo->callbackRef, &callback);
    napi_value callResult = nullptr;
    napi_call_function(env, undefined, callback, PARAM2, result, &callResult);
    SETTING_LOG_INFO("settingsnapi : callback aysnc end called");
    DeleteCallbackInfo(env, asyncCallbackInfo);
    SETTING_LOG_INFO("settingsnapi : callback change callback complete");
}

void UnsupportedPromiseComplete(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_reject_deferred(env, asyncCallbackInfo->deferred, CreateUnsupportedError(env));
    DeleteCallbackInfo(env, asyncCallbackInfo);
}

void GetUriExecuteCB(napi_env env, void *data)
{
    SETTING_LOG_INFO("settingsnapi : uri async execute callback");
}

void GetUriCompleteCB(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : uri callback async end data is null");
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value callback = nullptr;
    napi_get_reference_value(env, asyncCallbackInfo->callbackRef, &callback);
    napi_value result = wrap_string_to_js(env, asyncCallbackInfo->uri);
    napi_value returnValue = nullptr;
    napi_call_function(env, nullptr, callback, ARGS_ONE, &result, &returnValue);
    DeleteCallbackInfo(env, asyncCallbackInfo);
    SETTING_LOG_INFO("settingsnapi : uri callback change callback complete");
}

void GetUriCompletePromise(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result = wrap_string_to_js(env, asyncCallbackInfo->uri);
    napi_resolve_deferred(asyncCallbackInfo->env, asyncCallbackInfo->deferred, result);
    DeleteCallbackInfo(env, asyncCallbackInfo);
}

void QueryValueFromDataAbilityHelper(AsyncCallbackInfo *asyncCallbackInfo)
{
    if (asyncCallbackInfo == nullptr || asyncCallbackInfo->dataAbilityHelper == nullptr) {
        return;
    }

    std::vector<std::string> columns;
    columns.push_back(SETTINGS_DATA_FIELD_VALUE);
    OHOS::NativeRdb::DataAbilityPredicates predicates;
    predicates.EqualTo(SETTINGS_DATA_FIELD_KEYWORD, asyncCallbackInfo->key);

    std::shared_ptr<Uri> uri = std::make_shared<Uri>(SETTINGS_DATA_BASE_URI);
    std::shared_ptr<OHOS::NativeRdb::AbsSharedResultSet> resultset =
        asyncCallbackInfo->dataAbilityHelper->Query(*uri, columns, predicates);

    int numRows = 0;
    if (resultset != nullptr) {
        resultset->GetRowCount(numRows);
    }

    if (resultset != nullptr && numRows > 0) {
        int32_t columnIndex = 0;
        resultset->GoToFirstRow();
        resultset->GetString(columnIndex, asyncCallbackInfo->value);
    }
    if (resultset != nullptr) {
        resultset->Close();
    }

    asyncCallbackInfo->status = napi_ok;
}

void GetValueExecuteCB(napi_env env, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : callback async execute data is null");
        return;
    }
    QueryValueFromDataAbilityHelper(static_cast<AsyncCallbackInfo*>(data));
}

void GetValueCompleteCB(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : callback async end data is null");
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result = wrap_string_to_js(env, asyncCallbackInfo->value);
    CompleteCall(env, status, data, result);
}

void GetValueCompletePromise(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result = wrap_string_to_js(env, asyncCallbackInfo->value);
    CompletePromise(env, status, data, result);
}

void SetValueExecuteExtCB(napi_env env, void *data)
{
    if (data == nullptr) {
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    GetValueExecuteExt(env, data);
    SetValueExecuteExt(env, data, asyncCallbackInfo->uri);
}

void SetValueCompleteCB(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result = wrap_bool_to_js(env, asyncCallbackInfo->status != 0);
    asyncCallbackInfo->status = napi_ok;
    CompleteCall(env, status, data, result);
}

void SetValueCompletePromise(napi_env env, napi_status status, void *data)
{
    if (data == nullptr) {
        return;
    }
    AsyncCallbackInfo* asyncCallbackInfo = static_cast<AsyncCallbackInfo*>(data);
    napi_value result = wrap_bool_to_js(env, asyncCallbackInfo->status != 0);
    asyncCallbackInfo->status = napi_ok;
    CompletePromise(env, status, data, result);
}

/**
 * @brief getUri NAPI implementation.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param info the callback info passed into the callback function
 * @return napi_value the return value from NAPI C++ to JS for the module.
 */
napi_value napi_get_uri_sync(napi_env env, napi_callback_info info)
{
    SETTING_LOG_INFO("napi_get_uri called...");

    napi_value retUri = nullptr;

    // Check the number of the arguments
    size_t argc = ARGS_ONE;
    napi_value args[ARGS_ONE] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != ARGS_ONE) {
        SETTING_LOG_ERROR("%{public}s, wrong number of arguments.", __func__);
        return wrap_void_to_js(env);
    }

    // Check the value type of the arguments
    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument type. String expected.");

    std::string uriArgStr = unwrap_string_from_js(env, args[PARAM0]);
    uriArgStr = uriArgStr.empty() ? SETTINGS_DATA_BASE_URI : (SETTINGS_DATA_BASE_URI + "/" + uriArgStr);

    retUri = wrap_string_to_js(env, uriArgStr);
    return retUri;
}

napi_value napi_get_uri(napi_env env, napi_callback_info info)
{
    SETTING_LOG_INFO("settingsnapi : uri napi_set_value called...");
    size_t argc = ARGS_TWO;
    napi_value args[ARGS_TWO] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != ARGS_ONE && argc != ARGS_TWO) {
        SETTING_LOG_ERROR("settingsnapi : uri %{public}s, wrong number of arguments, expect 1 or 2 but get %{public}zd",
            __func__, argc);
        return wrap_void_to_js(env);
    }

    SETTING_LOG_INFO("settingsnapi : uri arg count is %{public}zd", argc);
    SETTING_LOG_INFO("settingsnapi : uri start create aysnc call back info");
    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);

    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "settingsnapi : uri Wrong argument type. String expected.");

    std::string uriArgStr = unwrap_string_from_js(env, args[PARAM0]);
    uriArgStr = uriArgStr.empty() ? SETTINGS_DATA_BASE_URI : (SETTINGS_DATA_BASE_URI + "/" + uriArgStr);
    asyncCallbackInfo->uri = uriArgStr;
    SETTING_LOG_INFO("settingsnapi : uri after uri is %{public}s", asyncCallbackInfo->uri.c_str());
    SETTING_LOG_INFO("settingsnapi : uri after create aysnc call back info");

    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, "getUri", NAPI_AUTO_LENGTH, &resource));

    if (argc == ARGS_TWO) {
        SETTING_LOG_INFO("settingsnapi : uri do callback");
        return QueueCallbackWork(
            env, asyncCallbackInfo, args[PARAM1], resource, {GetUriExecuteCB, GetUriCompleteCB});
    }
    SETTING_LOG_INFO("settingsnapi : uri do promise");
    return QueuePromiseWork(env, asyncCallbackInfo, resource, GetUriExecuteCB, GetUriCompletePromise);
}

std::shared_ptr<DataShareHelper> getDataShareHelper(napi_env env, const napi_value context, const bool stageMode)
{
    std::shared_ptr<OHOS::DataShare::DataShareHelper> dataShareHelper = nullptr;
    std::string strUri = "datashare:///com.ohos.settingsdata.DataAbility";
    std::string strProxyUri = "datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true";
    OHOS::Uri proxyUri(strProxyUri);
    SETTING_LOG_INFO("getDataShareHelper called");
    auto contextS = OHOS::AbilityRuntime::GetStageModeContext(env, context);

    dataShareHelper = OHOS::DataShare::DataShareHelper::Creator(contextS->GetToken(), strProxyUri);
    SETTING_LOG_INFO("getDataShareHelper called");

    DataSharePredicates predicates;
    predicates.Limit(1, 0);
    std::vector<std::string> columns;
    if (dataShareHelper == nullptr) {
        SETTING_LOG_INFO("getDataShareHelper dataShareHelper = nullptr");
    }
    if (dataShareHelper == nullptr || dataShareHelper->Query(proxyUri, predicates, columns) == nullptr) {
        dataShareHelper =  OHOS::DataShare::DataShareHelper::Creator(contextS->GetToken(), strUri);
        return dataShareHelper;
    }

    return dataShareHelper;
}

void GetValueExecuteExt(napi_env env, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : execute data is null");
        return;
    }

    SETTING_LOG_INFO("settingsnapi : GetValueExecuteExt start");
    AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;

    std::vector<std::string> columns;
    columns.push_back(SETTINGS_DATA_FIELD_VALUE);

    OHOS::DataShare::DataSharePredicates predicates;
    predicates.EqualTo(SETTINGS_DATA_FIELD_KEYWORD, asyncCallbackInfo->key);

    std::string strUri =
        "datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=" +
        asyncCallbackInfo->key;
    OHOS::Uri uri(strUri);

    std::shared_ptr<OHOS::DataShare::DataShareResultSet> resultset = nullptr;
    if (asyncCallbackInfo->dataShareHelper != nullptr) {
        resultset = asyncCallbackInfo->dataShareHelper->Query(uri, predicates, columns);
    }
    int numRows = 0;
    if (resultset != nullptr) {
        SETTING_LOG_INFO("settingsnapi : GetValueExecuteExt called... resultset is NOT empty");
        resultset->GetRowCount(numRows);
    }

    if (resultset == nullptr || numRows == 0) {
        SETTING_LOG_INFO("settingsnapi : GetValueExecuteExt called... return error");
        asyncCallbackInfo->status = -1;
        return;
    }

    std::string val;
    int32_t columnIndex = 0;
    resultset->GoToFirstRow();

    resultset->GetString(columnIndex, val);
    SETTING_LOG_INFO("napi_get_value_ext called... %{public}s", val.c_str());
    asyncCallbackInfo->value = val;
    asyncCallbackInfo->status = napi_ok;
}

void DeleteCallbackInfo(napi_env env, AsyncCallbackInfo *asyncCallbackInfo)
{
    if (env != nullptr) {
        napi_delete_reference(env, asyncCallbackInfo->callbackRef);
        napi_delete_async_work(env, asyncCallbackInfo->asyncWork);
    }
    asyncCallbackInfo->dataShareHelper = nullptr;
    delete asyncCallbackInfo;
}

void CompleteCall(napi_env env, napi_status status, void *data, const napi_value retVaule)
{
    AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;
    napi_value result[PARAM2] = {0};
    if (status == napi_ok && asyncCallbackInfo->status == napi_ok) {
        napi_get_undefined(env, &result[PARAM0]);
        result[PARAM1] = retVaule;
    } else {
        napi_value message = nullptr;
        napi_create_string_utf8(env, "async call failed", NAPI_AUTO_LENGTH, &message);
        napi_create_error(env, nullptr, message, &result[PARAM0]);
        napi_get_undefined(env, &result[PARAM1]);
    }
    SETTING_LOG_INFO("settingsnapi : callback aysnc end called");
    napi_value callback = nullptr;
    napi_get_reference_value(env, asyncCallbackInfo->callbackRef, &callback);
    napi_value returnValue;
    napi_call_function(env, nullptr, callback, PARAM2, result, &returnValue);
    SETTING_LOG_INFO("settingsnapi : callback aysnc end called");
    DeleteCallbackInfo(env, asyncCallbackInfo);
    SETTING_LOG_INFO("settingsnapi : callback change callback complete");
}

void CompletePromise(napi_env env, napi_status status, void *data, const napi_value retVaule)
{
    SETTING_LOG_INFO("settingsnapi : promise async end called callback");
    AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;
    napi_value result = nullptr;
    if (status == napi_ok && asyncCallbackInfo->status == napi_ok) {
        napi_resolve_deferred(env, asyncCallbackInfo->deferred, retVaule);
    } else {
        napi_get_undefined(env, &result);
        napi_reject_deferred(env, asyncCallbackInfo->deferred, result);
    }
    DeleteCallbackInfo(env, asyncCallbackInfo);
}

void SetValueExecuteExt(napi_env env, void *data, const std::string setValue)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : SetValueExecuteExt data is null");
        return;
    }
    SETTING_LOG_INFO("settingsnapi : execute start");
    AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;

    OHOS::DataShare::DataShareValuesBucket val;
    val.Put(SETTINGS_DATA_FIELD_KEYWORD, asyncCallbackInfo->key);
    val.Put(SETTINGS_DATA_FIELD_VALUE, setValue);

    std::string strUri =
        "datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=" +
        asyncCallbackInfo->key;
    SETTING_LOG_INFO("strUri = %{public}s", strUri.c_str());
    OHOS::Uri uri(strUri);

    OHOS::DataShare::DataSharePredicates predicates;
    predicates.EqualTo(SETTINGS_DATA_FIELD_KEYWORD, asyncCallbackInfo->key);

    int retInt = 0;
    if (asyncCallbackInfo->status == -1 || asyncCallbackInfo->value.size() <= 0) {
        SETTING_LOG_INFO("napi_set_value_ext called... before Insert");
        if (asyncCallbackInfo->dataShareHelper != nullptr) {
            retInt = asyncCallbackInfo->dataShareHelper->Insert(uri, val);
        }
        SETTING_LOG_INFO("napi_set_value_ext called... after Insert");
    } else {
        SETTING_LOG_INFO("napi_set_value_ext called... before Update");
        if (asyncCallbackInfo->dataShareHelper != nullptr) {
            retInt = asyncCallbackInfo->dataShareHelper->Update(uri, predicates, val);
        }
        SETTING_LOG_INFO("napi_set_value_ext called... after Update");
    }
    asyncCallbackInfo->status = retInt;
}

int ExecuteSetValueByDataAbilityHelper(DataAbilityHelper *dataAbilityHelper, const std::string &key,
    const std::string &value, const char *logPrefix)
{
    if (dataAbilityHelper == nullptr) {
        return 0;
    }

    OHOS::NativeRdb::ValuesBucket val;
    val.PutString(SETTINGS_DATA_FIELD_KEYWORD, key);
    val.PutString(SETTINGS_DATA_FIELD_VALUE, value);

    std::vector<std::string> columns;
    columns.push_back(SETTINGS_DATA_FIELD_VALUE);
    OHOS::NativeRdb::DataAbilityPredicates predicates;
    predicates.EqualTo(SETTINGS_DATA_FIELD_KEYWORD, key);

    std::shared_ptr<Uri> uri = std::make_shared<Uri>(SETTINGS_DATA_BASE_URI);
    SETTING_LOG_INFO("%{public}s before dataAbilityHelper->Query", logPrefix);
    std::shared_ptr<OHOS::NativeRdb::AbsSharedResultSet> resultset =
        dataAbilityHelper->Query(*uri, columns, predicates);
    SETTING_LOG_INFO("%{public}s after dataAbilityHelper->Query", logPrefix);

    int retInt = 0;
    int numRows = 0;
    if (resultset != nullptr) {
        SETTING_LOG_INFO("%{public}s resultset is NOT empty", logPrefix);
        resultset->GetRowCount(numRows);
    }

    if (resultset == nullptr || numRows == 0) {
        SETTING_LOG_INFO("%{public}s before Insert", logPrefix);
        retInt = dataAbilityHelper->Insert(*uri, val);
        SETTING_LOG_INFO("%{public}s after Insert", logPrefix);
    } else {
        SETTING_LOG_INFO("%{public}s before Update", logPrefix);
        retInt = dataAbilityHelper->Update(*uri, val, predicates);
        SETTING_LOG_INFO("%{public}s after Update", logPrefix);
    }

    if (retInt != 0) {
        SETTING_LOG_INFO("%{public}s retInt is NOT zero", logPrefix);
        std::string uriWithNameStr = key.empty() ? SETTINGS_DATA_BASE_URI : (SETTINGS_DATA_BASE_URI + "/" + key);
        std::shared_ptr<Uri> uriWithName = std::make_shared<Uri>(uriWithNameStr);
        dataAbilityHelper->NotifyChange(*uriWithName);
        SETTING_LOG_INFO("%{public}s after NotifyChange with uri: %{public}s", logPrefix, uriWithNameStr.c_str());
    }

    if (resultset != nullptr) {
        resultset->Close();
    }
    return retInt;
}

napi_value GetValueFromStageContextSync(napi_env env, napi_value *args, bool stageMode)
{
    SETTING_LOG_INFO("argv[0] is a context, Stage Model: %{public}d", stageMode);
    AsyncCallbackInfo asyncCallbackInfo {};
    asyncCallbackInfo.key = unwrap_string_from_js(env, args[PARAM1]);
    asyncCallbackInfo.dataShareHelper = getDataShareHelper(env, args[PARAM0], stageMode);
    GetValueExecuteExt(env, static_cast<void*>(&asyncCallbackInfo));
    SETTING_LOG_INFO("settingsnapi : napi_get_value_sync called... return  %{public}s",
        asyncCallbackInfo.value.c_str());
    if (asyncCallbackInfo.value.empty()) {
        return args[PARAM2];
    }
    return wrap_string_to_js(env, asyncCallbackInfo.value);
}

napi_value GetValueFromDataAbilityHelperSync(napi_env env, napi_value *args)
{
    DataAbilityHelper *dataAbilityHelper = nullptr;
    NAPI_CALL(env, napi_unwrap(env, args[PARAM0], reinterpret_cast<void **>(&dataAbilityHelper)));

    AsyncCallbackInfo asyncCallbackInfo {};
    asyncCallbackInfo.dataAbilityHelper = dataAbilityHelper;
    asyncCallbackInfo.key = unwrap_string_from_js(env, args[PARAM1]);
    SETTING_LOG_INFO("napi_get_value called... before dataAbilityHelper->Query");
    QueryValueFromDataAbilityHelper(&asyncCallbackInfo);
    SETTING_LOG_INFO("napi_get_value called... after dataAbilityHelper->Query");
    SETTING_LOG_INFO("napi_get_value called... END!");
    if (asyncCallbackInfo.value.empty()) {
        return args[PARAM2];
    }
    return wrap_string_to_js(env, asyncCallbackInfo.value);
}

napi_value SetValueFromStageContextSync(napi_env env, napi_value *args, bool stageMode)
{
    SETTING_LOG_INFO("argv[0] is a context, Stage Model: %{public}d", stageMode);
    AsyncCallbackInfo asyncCallbackInfo {};
    asyncCallbackInfo.key = unwrap_string_from_js(env, args[PARAM1]);
    asyncCallbackInfo.dataShareHelper = getDataShareHelper(env, args[PARAM0], stageMode);
    GetValueExecuteExt(env, static_cast<void*>(&asyncCallbackInfo));
    SetValueExecuteExt(env, static_cast<void*>(&asyncCallbackInfo), unwrap_string_from_js(env, args[PARAM2]));
    return wrap_bool_to_js(env, asyncCallbackInfo.status != 0);
}

napi_value SetValueFromDataAbilityHelperSync(napi_env env, napi_value *args)
{
    DataAbilityHelper *dataAbilityHelper = nullptr;
    NAPI_CALL(env, napi_unwrap(env, args[PARAM0], reinterpret_cast<void **>(&dataAbilityHelper)));
    std::string key = unwrap_string_from_js(env, args[PARAM1]);
    std::string value = unwrap_string_from_js(env, args[PARAM2]);
    int retInt = ExecuteSetValueByDataAbilityHelper(dataAbilityHelper, key, value, "napi_set_value called...");
    SETTING_LOG_INFO("napi_set_value called... END!");
    return wrap_bool_to_js(env, retInt != 0);
}

/**
 * @brief getValue NAPI implementation.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param info the callback info passed into the callback function
 * @return napi_value the return value from NAPI C++ to JS for the module.
 */
napi_value napi_get_value_sync(napi_env env, napi_callback_info info)
{
    SETTING_LOG_INFO("napi_get_value called...");
    size_t argc = ARGS_THREE;
    napi_value args[ARGS_THREE] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != ARGS_THREE) {
        SETTING_LOG_ERROR("%{public}s, wrong number of arguments.", __func__);
        return wrap_void_to_js(env);
    }
    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    NAPI_ASSERT(env, valueType == napi_object, "Wrong argument[0] type. Object expected.");
    NAPI_CALL(env, napi_typeof(env, args[PARAM1], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[1] type. String expected.");
    NAPI_CALL(env, napi_typeof(env, args[PARAM2], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[2] type. String expected.");

    bool stageMode = false;
    napi_status status = OHOS::AbilityRuntime::IsStageContext(env, args[PARAM0], stageMode);
    if (status == napi_ok) {
        return GetValueFromStageContextSync(env, args, stageMode);
    }
    return GetValueFromDataAbilityHelperSync(env, args);
}

napi_value napi_get_value(napi_env env, napi_callback_info info)
{
    const size_t paramOfPromise = ARGS_TWO;
    const size_t paramOfCallback = ARGS_THREE;
    size_t argc = ARGS_THREE;
    napi_value args[ARGS_THREE] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != paramOfCallback && argc != paramOfPromise) {
        SETTING_LOG_ERROR("settingsnapi : %{public}s, wrong number of arguments, expect 2 or 3 but get %{public}zd",
            __func__, argc);
        return wrap_void_to_js(env);
    }

    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    bool stageMode = false;
    napi_status status = OHOS::AbilityRuntime::IsStageContext(env, args[PARAM0], stageMode);
    if (status == napi_ok) {
        return napi_get_value_ext(env, info, stageMode);
    }
    NAPI_ASSERT(env, valueType == napi_object, "Wrong argument[0] type. Object expected.");
    NAPI_CALL(env, napi_typeof(env, args[PARAM1], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[1], type. String expected");

    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);
    NAPI_CALL(env, napi_unwrap(env, args[PARAM0], reinterpret_cast<void **>(&asyncCallbackInfo->dataAbilityHelper)));
    asyncCallbackInfo->key = unwrap_string_from_js(env, args[PARAM1]);
    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, "getValue", NAPI_AUTO_LENGTH, &resource));
    if (argc == paramOfCallback) {
        return QueueCallbackWork(
            env, asyncCallbackInfo, args[PARAM2], resource, {GetValueExecuteCB, GetValueCompleteCB});
    }
    return QueuePromiseWork(env, asyncCallbackInfo, resource, GetValueExecuteCB, GetValueCompletePromise);
}

// api9
napi_value napi_get_value_ext(napi_env env, napi_callback_info info, const bool stageMode)
{
    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);
    size_t argc = ARGS_THREE;
    napi_value args[ARGS_THREE] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    asyncCallbackInfo->dataShareHelper = getDataShareHelper(env, args[PARAM0], stageMode);
    asyncCallbackInfo->key = unwrap_string_from_js(env, args[PARAM1]);
    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, "getValue", NAPI_AUTO_LENGTH, &resource));
    if (argc == ARGS_THREE) {
        return QueueCallbackWork(
            env, asyncCallbackInfo, args[PARAM2], resource, {GetValueExecuteExt, GetValueCompleteCB});
    }
    return QueuePromiseWork(env, asyncCallbackInfo, resource, GetValueExecuteExt, GetValueCompletePromise);
}


/**
 * @brief setValue NAPI implementation.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param info the callback info passed into the callback function
 * @return napi_value the return value from NAPI C++ to JS for the module.
 */
napi_value napi_set_value_sync(napi_env env, napi_callback_info info)
{
    SETTING_LOG_INFO("napi_set_value called...");
    size_t argc = ARGS_THREE;
    napi_value args[ARGS_THREE] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != ARGS_THREE) {
        SETTING_LOG_ERROR("%{public}s, wrong number of arguments.", __func__);
        return wrap_void_to_js(env);
    }
    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    NAPI_ASSERT(env, valueType == napi_object, "Wrong argument[0] type. Object expected.");
    NAPI_CALL(env, napi_typeof(env, args[PARAM1], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[1] type. String expected.");
    NAPI_CALL(env, napi_typeof(env, args[PARAM2], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[2] type. String expected.");

    bool stageMode = false;
    napi_status status = OHOS::AbilityRuntime::IsStageContext(env, args[PARAM0], stageMode);
    if (status == napi_ok) {
        return SetValueFromStageContextSync(env, args, stageMode);
    }
    return SetValueFromDataAbilityHelperSync(env, args);
}

void SetValueExecuteCB(napi_env env, void *data)
{
    if (data == nullptr) {
        SETTING_LOG_INFO("settingsnapi : execute data is null");
        return;
    }
    SETTING_LOG_INFO("settingsnapi : execute start");
    AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;
    int retInt = ExecuteSetValueByDataAbilityHelper(
        asyncCallbackInfo->dataAbilityHelper, asyncCallbackInfo->key, asyncCallbackInfo->value,
        "settingsnapi : execute...");
    SETTING_LOG_INFO("settingsnapi : execute... END!");
    asyncCallbackInfo->status = retInt;
}

napi_value SetValueAsync(napi_env env, AsyncCallbackInfo* asyncCallbackInfo)
{
    SETTING_LOG_INFO("settingsnapi : set do callback");
    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, __func__, NAPI_AUTO_LENGTH, &resource));

    napi_create_async_work(
        env,
        nullptr,
        resource,
        SetValueExecuteCB,
        [](napi_env env, napi_status status, void* data) {
            if (data == nullptr) {
                SETTING_LOG_INFO("settingsnapi : callback set async end data is null");
                return;
            }
            SETTING_LOG_INFO("settingsnapi : callback set async end called callback");
            AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;
            napi_value undefine;
            napi_get_undefined(env, &undefine);
            SETTING_LOG_INFO("settingsnapi : callback set aysnc end called");
            napi_value callback = nullptr;
            napi_value result = wrap_bool_to_js(env, asyncCallbackInfo->status != 0);
            SETTING_LOG_INFO("settingsnapi : callback set aysnc end called");
            napi_get_reference_value(env, asyncCallbackInfo->callbackRef, &callback);
            napi_call_function(env, nullptr, callback, 1, &result, &undefine);
            SETTING_LOG_INFO("settingsnapi : callback set aysnc end called");
            napi_delete_reference(env, asyncCallbackInfo->callbackRef);
            napi_delete_async_work(env, asyncCallbackInfo->asyncWork);
            asyncCallbackInfo->dataAbilityHelper = nullptr;
            delete asyncCallbackInfo;
            SETTING_LOG_INFO("settingsnapi : callback set change callback complete");
        },
        (void*)asyncCallbackInfo,
        &asyncCallbackInfo->asyncWork);
    SETTING_LOG_INFO("settingsnapi : callback set start async work");
    NAPI_CALL(env, napi_queue_async_work(env, asyncCallbackInfo->asyncWork));
    SETTING_LOG_INFO("settingsnapi : callback set end async work");
    return wrap_void_to_js(env);
}

napi_value SetValuePromise(napi_env env, AsyncCallbackInfo* asyncCallbackInfo)
{
    SETTING_LOG_INFO("settingsnapi : set  do promise");
    napi_value promise;
    napi_deferred deferred;
    NAPI_CALL(env, napi_create_promise(env, &deferred, &promise));
    asyncCallbackInfo->deferred = deferred;

    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, __func__, NAPI_AUTO_LENGTH, &resource));

    napi_create_async_work(
        env,
        nullptr,
        resource,
        SetValueExecuteCB,
        [](napi_env env, napi_status status, void* data) {
            SETTING_LOG_INFO("settingsnapi : promise set async end called callback");
            AsyncCallbackInfo* asyncCallbackInfo = (AsyncCallbackInfo*)data;
            SETTING_LOG_INFO("settingsnapi : promise set end get callback value is %{public}d",
                asyncCallbackInfo->status);
            napi_value result = wrap_bool_to_js(env, asyncCallbackInfo->status != 0);
            napi_resolve_deferred(asyncCallbackInfo->env, asyncCallbackInfo->deferred, result);
            napi_delete_async_work(env, asyncCallbackInfo->asyncWork);
            asyncCallbackInfo->dataAbilityHelper = nullptr;
            delete asyncCallbackInfo;
        },
        (void*)asyncCallbackInfo,
        &asyncCallbackInfo->asyncWork);
    napi_queue_async_work(env, asyncCallbackInfo->asyncWork);
    return promise;
}

napi_value HandleSetValueStageMode(napi_env env, napi_callback_info info, napi_value contextArg, bool& handled)
{
    bool stageMode = false;
    napi_status status = OHOS::AbilityRuntime::IsStageContext(env, contextArg, stageMode);
    if (status != napi_ok) {
        handled = false;
        return nullptr;
    }
    SETTING_LOG_INFO("argv[0] is a context, Stage Model: %{public}d", stageMode);
    handled = true;
    return napi_set_value_ext(env, info, stageMode);
}

void InitSetValueCallbackInfo(napi_env env, napi_value* args, AsyncCallbackInfo* asyncCallbackInfo)
{
    NAPI_CALL(env, napi_unwrap(env, args[PARAM0], reinterpret_cast<void **>(&asyncCallbackInfo->dataAbilityHelper)));
    SETTING_LOG_INFO("settingsnapi : input paramter is (DataAbilityHelper)");
    asyncCallbackInfo->key = unwrap_string_from_js(env, args[PARAM1]);
    asyncCallbackInfo->value = unwrap_string_from_js(env, args[PARAM2]);
    SETTING_LOG_INFO("settingsnapi : set  input parameter is : (key %{public}s, value %{public}s)",
        asyncCallbackInfo->key.c_str(), asyncCallbackInfo->value.c_str());
}

napi_value ReturnSetValueResult(napi_env env, size_t argc, size_t paramOfCallback, napi_value callback,
    AsyncCallbackInfo* asyncCallbackInfo)
{
    if (argc == paramOfCallback) {
        napi_create_reference(env, callback, 1, &asyncCallbackInfo->callbackRef);
        return SetValueAsync(env, asyncCallbackInfo);
    }
    return SetValuePromise(env, asyncCallbackInfo);
}

/**
 * @brief setValue NAPI implementation.
 *
 * @param env the environment that the Node-API call is invoked under
 * @param info the callback info passed into the callback function
 * @return napi_value the return value from NAPI C++ to JS for the module.
 */
napi_value napi_set_value(napi_env env, napi_callback_info info)
{
    SETTING_LOG_INFO("settingsnapi : set  napi_set_value called...");
    const size_t paramOfPromise = ARGS_THREE;
    const size_t paramOfCallback = ARGS_FOUR;
    size_t argc = ARGS_FOUR;
    napi_value args[ARGS_FOUR] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != paramOfPromise && argc != paramOfCallback) {
        SETTING_LOG_ERROR("settingsnapi : set %{public}s, wrong number of arguments, expect 3 or 4 but get %{public}zd",
            __func__, argc);
        return wrap_void_to_js(env);
    }

    SETTING_LOG_INFO("settingsnapi : set  arg count is %{public}zd", argc);
    SETTING_LOG_INFO("settingsnapi : set  start create aysnc call back info");
    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);
    SETTING_LOG_INFO("settingsnapi : set  after create aysnc call back info");
    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    bool handled = false;
    napi_value stageModeResult = HandleSetValueStageMode(env, info, args[PARAM0], handled);
    if (handled) {
        delete asyncCallbackInfo;
        return stageModeResult;
    }
    NAPI_ASSERT(env, valueType == napi_object, "Wrong argument[0] type. Object expected.");
    NAPI_CALL(env, napi_typeof(env, args[PARAM1], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[1], type. String expected");
    NAPI_CALL(env, napi_typeof(env, args[PARAM2], &valueType));
    NAPI_ASSERT(env, valueType == napi_string, "Wrong argument[2], type. String expected");
    InitSetValueCallbackInfo(env, args, asyncCallbackInfo);
    napi_value ret = ReturnSetValueResult(env, argc, paramOfCallback, args[PARAM3], asyncCallbackInfo);
    SETTING_LOG_INFO("settingsnapi : set  value end");
    return ret;
}

napi_value napi_set_value_ext(napi_env env, napi_callback_info info, const bool stageMode)
{
    const size_t paramOfCallback = ARGS_FOUR;
    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);
    size_t argc = ARGS_FOUR;
    napi_value args[ARGS_FOUR] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    asyncCallbackInfo->dataShareHelper = getDataShareHelper(env, args[PARAM0], stageMode);
    asyncCallbackInfo->key = unwrap_string_from_js(env, args[PARAM1]);
    asyncCallbackInfo->uri = unwrap_string_from_js(env, args[PARAM2]);
    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, "napi_set_value_ext", NAPI_AUTO_LENGTH, &resource));
    if (argc == paramOfCallback) {
        return QueueCallbackWork(
            env, asyncCallbackInfo, args[PARAM3], resource, {SetValueExecuteExtCB, SetValueCompleteCB});
    }
    return QueuePromiseWork(env, asyncCallbackInfo, resource, SetValueExecuteExtCB, SetValueCompletePromise);
}
/**
 * @brief enableAirplaneMode NAPI implementation.
 * @param env the environment that the Node-API call is invoked under
 * @param info the callback info passed into the callback function
 * @return napi_value the return value from NAPI C++ to JS for the module.
 */
napi_value napi_enable_airplane_mode(napi_env env, napi_callback_info info)
{
    const size_t paramOfPromise = ARGS_ONE;
    const size_t paramOfCallback = ARGS_TWO;

    size_t argc = ARGS_TWO;
    napi_value args[ARGS_TWO] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != paramOfCallback && argc != paramOfPromise) {
        SETTING_LOG_ERROR("settingsnapi : %{public}s, wrong number of arguments, expect 1 or 2 but get %{public}zd",
            __func__, argc);
        return wrap_void_to_js(env);
    }

    SETTING_LOG_INFO("settingsnapi : napi_enable_airplane_mode arg count is %{public}zd", argc);
    SETTING_LOG_INFO("settingsnapi : napi_enable_airplane_mode start create aysnc call back info");
    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);
    SETTING_LOG_INFO("settingsnapi : after create aysnc call back info");

    napi_valuetype valueType;
    NAPI_CALL(env, napi_typeof(env, args[PARAM0], &valueType));
    NAPI_ASSERT(env, valueType == napi_boolean, "Wrong argument[0], type. Boolean expected");

    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, "enableAirplaneMode", NAPI_AUTO_LENGTH, &resource));

    if (argc == paramOfCallback) {
        SETTING_LOG_INFO("%{public}s, asyncCallback.", __func__);
    }
    if (argc == paramOfCallback) {
        return QueueCallbackWork(
            env,
            asyncCallbackInfo,
            args[PARAM1],
            resource,
            {UnsupportedExecuteCB, UnsupportedCallbackComplete});
    }
    SETTING_LOG_INFO("%{public}s, promise.", __func__);
    return QueuePromiseWork(env, asyncCallbackInfo, resource, UnsupportedExecuteCB, UnsupportedPromiseComplete);
}

/**
 * @brief canShowFloating NAPI implementation.
 * @param env the environment that the Node-API call is invoked under
 * @param info the callback info passed into the callback function
 * @return napi_value the return value from NAPI C++ to JS for the module.
 */
napi_value napi_can_show_floating(napi_env env, napi_callback_info info)
{
    const size_t paramOfPromise = PARAM0;
    const size_t paramOfCallback = PARAM1;

    size_t argc = PARAM1;
    napi_value args[PARAM1] = {nullptr};
    NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, nullptr, nullptr));
    if (argc != paramOfCallback && argc != paramOfPromise) {
        SETTING_LOG_ERROR("settingsnapi : %{public}s, wrong number of arguments, expect 0 or 1 but get %{public}zd",
            __func__, argc);
        return wrap_void_to_js(env);
    }

    SETTING_LOG_INFO("settingsnapi : napi_enable_airplane_mode arg count is %{public}zd", argc);
    SETTING_LOG_INFO("settingsnapi : napi_enable_airplane_mode start create aysnc call back info");
    AsyncCallbackInfo* asyncCallbackInfo = CreateAsyncCallbackInfo(env);
    SETTING_LOG_INFO("settingsnapi : after create aysnc call back info");

    napi_value resource = nullptr;
    NAPI_CALL(env, napi_create_string_utf8(env, "enableAirplaneMode", NAPI_AUTO_LENGTH, &resource));

    if (argc == paramOfCallback) {
        SETTING_LOG_INFO("%{public}s, asyncCallback.", __func__);
    }
    if (argc == paramOfCallback) {
        return QueueCallbackWork(
            env,
            asyncCallbackInfo,
            args[PARAM0],
            resource,
            {UnsupportedExecuteCB, UnsupportedBoolCallbackComplete});
    }
    SETTING_LOG_INFO("%{public}s, promise.", __func__);
    return QueuePromiseWork(env, asyncCallbackInfo, resource, UnsupportedExecuteCB, UnsupportedPromiseComplete);
}
}  // namespace Settings
}  // namespace OHOS
