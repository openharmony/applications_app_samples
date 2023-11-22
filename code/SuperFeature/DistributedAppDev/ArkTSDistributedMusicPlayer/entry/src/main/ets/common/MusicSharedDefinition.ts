/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
export const APPLICATION_BUNDLE_NAME = 'ohos.samples.distributedmusicplayer'
export const APPLICATION_SERVICE_NAME = 'ServiceAbility'
export const APPLICATION_ABILITY_NAME = 'ohos.samples.distributedmusicplayer.MainAbility'

export const enum MusicSharedEventCode {
  START_DISTRIBUTED_MUSIC_SERVICE = 1,
  STOP_DISTRIBUTED_MUSIC_SERVICE = 2,
  PLAY_MUSIC_SERVICE = 3,
  PAUSE_MUSIC_SERVICE = 4,
  PLAY_MUSIC_SERVICE_REMOTE = 5,
  PAUSE_MUSIC_SERVICE_REMOTE = 6,
  STOP_LOCAL_SERIVCE = 7,
}

export const enum MusicSharedStatus {
  MUSIC_SHARED = 0,
  MUSIC_REMOTING = 1,
  MUSIC_STOP_SHARED = 2
}

export const enum MusicConnectEvent {
  EVENT_CONNECT = 'ONCONNECT',
  EVENT_DISCONNECT = 'ONDISCONNECT',
  EVENT_FAILED = 'ONFAILED',
  EVENT_TIMEOUT = 'CONNECTTIMEOUT'
}