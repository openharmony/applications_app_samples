/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi/native_api.h"
// [Start avSession_include]
#include <multimedia/av_session/native_avmetadata.h>
#include <multimedia/av_session/native_avsession.h>
#include <multimedia/av_session/native_avsession_errors.h>
// [End avSession_include]
const int ELAPSED_TIME = 1000;
const int UPDATE_TIME = 16111150;
const int DURATION_TIME = 3600;

static napi_value SetMetadata(napi_env env, napi_callback_info info)
{
    napi_value result;
    OH_AVSession* avsession;
    
    // [Start construct_metadata]
    // 创建OH_AVMetadataBuilder构造器。
    OH_AVMetadataBuilder* builder;
    OH_AVMetadataBuilder_Create(&builder);
    
    OH_AVMetadata* ohMetadata;
    OH_AVMetadataBuilder_SetTitle(builder, "Anonymous title");
    OH_AVMetadataBuilder_SetArtist(builder, "Anonymous artist");
    OH_AVMetadataBuilder_SetAuthor(builder, "Anonymous author");
    OH_AVMetadataBuilder_SetAlbum(builder, "Anonymous album");
    OH_AVMetadataBuilder_SetWriter(builder, "Anonymous writer");
    OH_AVMetadataBuilder_SetComposer(builder, "Anonymous composer");
    OH_AVMetadataBuilder_SetDuration(builder, DURATION_TIME); // DURATION_TIME = 3600
    // MediaImageUri只支持网络地址。
    OH_AVMetadataBuilder_SetMediaImageUri(builder, "https://xxx.xxx.xx");
    OH_AVMetadataBuilder_SetSubtitle(builder, "Anonymous subtitle");
    OH_AVMetadataBuilder_SetDescription(builder, "For somebody");
    // Lyric只支持媒体歌词内容（应用需将歌词内容拼接为一个字符串传入）。
    OH_AVMetadataBuilder_SetLyric(builder, "balabala");
    OH_AVMetadataBuilder_SetAssetId(builder, "000");
    OH_AVMetadataBuilder_SetSkipIntervals(builder, SECONDS_30);
    OH_AVMetadataBuilder_SetDisplayTags(builder,  AVSESSION_DISPLAYTAG_AUDIO_VIVID);

    /**
     * generate an AVMetadata 构造AVMetadata对象
     */
    OH_AVMetadataBuilder_GenerateAVMetadata(builder, &ohMetadata);
    
    /**
     * set AVMetadata 设置AVMetadata对象
     */
    OH_AVSession_SetAVMetadata(avsession, ohMetadata);
    // [End construct_metadata]
    
    // [Start destroy_metadata]
    OH_AVMetadata_Destroy(ohMetadata);
    OH_AVMetadataBuilder_Destroy(builder);
    // [End destroy_metadata]
    
    napi_create_string_utf8(env, "设置媒体元数据成功", NAPI_AUTO_LENGTH, &result);
    return result;
}

static napi_value SetPlaybackState(napi_env env, napi_callback_info info)
{
    napi_value result;
    // [Start create]
    OH_AVSession* avsession;
    OH_AVSession_Create(SESSION_TYPE_AUDIO, "testsession", "com.example.application", "MainAbility", &avsession);
    OH_AVSession_Activate(avsession);
    // [End create]
    
    // [Start state_change]
    AVSession_ErrCode ret = AV_SESSION_ERR_SUCCESS;
    
    // 设置播放状态，其中state范围应为[0,11]。
    AVSession_PlaybackState state = PLAYBACK_STATE_PREPARING;
    ret = OH_AVSession_SetPlaybackState(avsession, state);
    // [StartExclude state_change]
    if (ret != AV_SESSION_ERR_SUCCESS) {
        napi_create_string_utf8(env, "设置播放状态失败", NAPI_AUTO_LENGTH, &result);
        return result;
    }
    // [EndExclude state_change]
    
    // 设置播放位置。
    AVSession_PlaybackPosition* playbackPosition = new AVSession_PlaybackPosition;
    playbackPosition->elapsedTime = ELAPSED_TIME; // ELAPSED_TIME = 1000
    playbackPosition->updateTime = UPDATE_TIME; // UPDATE_TIME = 16111150
    ret = OH_AVSession_SetPlaybackPosition(avsession, playbackPosition);
    // [End state_change]
    if (ret != AV_SESSION_ERR_SUCCESS) {
        napi_create_string_utf8(env, "设置播放位置失败", NAPI_AUTO_LENGTH, &result);
        return result;
    }
    OH_AVSession_Destroy(avsession);
    napi_create_string_utf8(env, "设置播放状态和位置成功", NAPI_AUTO_LENGTH, &result);
    return result;
}

static napi_value RegisterPlayCallback(napi_env env, napi_callback_info info)
{
    napi_value result;
    OH_AVSession* avsession;
    OH_AVSession_Create(SESSION_TYPE_AUDIO, "testsession",
        "com.samples.AVSessionProviderNative", "EntryAbility", &avsession);
    OH_AVSession_Activate(avsession);
    
    // [Start control_command]
    // 设置播放/暂停/停止/上一首/下一首回调。
    // CONTROL_CMD_PLAY = 0; 播放。
    // CONTROL_CMD_PAUSE = 1; 暂停。
    // CONTROL_CMD_STOP = 2;  停止。
    // CONTROL_CMD_PLAY_NEXT = 3; 下一首。
    // CONTROL_CMD_PLAY_PREVIOUS = 4; 上一首。
    AVSession_ControlCommand command = CONTROL_CMD_PLAY;
    OH_AVSessionCallback_OnCommand commandCallback = [](OH_AVSession* session, AVSession_ControlCommand command,
        void* userData) -> AVSessionCallback_Result {
        return AVSESSION_CALLBACK_RESULT_SUCCESS;
    };
    int userData = 0;
    OH_AVSession_RegisterCommandCallback(avsession, command, commandCallback, (void *)(&userData));
    
    // 设置快进回调。
    OH_AVSessionCallback_OnFastForward fastForwardCallback = [](OH_AVSession* session, uint32_t seekTime,
        void* userData) -> AVSessionCallback_Result {
        return AVSESSION_CALLBACK_RESULT_SUCCESS;
    };
    OH_AVSession_RegisterForwardCallback(avsession, fastForwardCallback, (void *)(&userData));
    // [End control_command]
    // [Start destroy]
    OH_AVSession_Destroy(avsession);
    // [End destroy]
    napi_create_string_utf8(env, "注册播放命令回调成功", NAPI_AUTO_LENGTH, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"SetMetadata", nullptr, SetMetadata, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SetPlaybackState", nullptr, SetPlaybackState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"RegisterPlayCallback", nullptr, RegisterPlayCallback, nullptr, nullptr, nullptr, napi_default, nullptr }
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}