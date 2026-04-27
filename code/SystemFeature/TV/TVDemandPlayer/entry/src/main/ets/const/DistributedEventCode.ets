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

export enum DistributedEventCode {
  START_DISTRIBUTED_PLAYER_SERVICE = 1,
  STOP_DISTRIBUTED_PLAYER_SERVICE = 2,
  PLAY_PLAYER_SERVICE = 3,
  PAUSE_PLAYER_SERVICE = 4,
  PLAY_PLAYER_SERVICE_REMOTE = 5,
  PAUSE_PLAYER_SERVICE_REMOTE = 6,
  STOP_LOCAL_SERVICE = 7,
  PRE_PLAYER_SERVICE = 8,
  NEXT_PLAYER_SERVICE = 9,
  PRE_PLAYER_SERVICE_REMOTE = 10,
  NEXT_PLAYER_SERVICE_REMOTE = 11,
  SYNC_PLAYER_TIME_SERVICE = 12,
  SYNC_PLAYER_TIME_SERVICE_REMOTE = 13,
  SYNC_PLAYER_TIME_SERVICE_REPLAY = 14,
  SYNC_PLAYER_TIME_SERVICE_SET_TIME = 15,
  STOP_DISTRIBUTED_PLAYER_SERVICE_REMOTE = 16,
  PLAYER_SERVICE = 3,
  START_DISTRIBUTED_PLAYER = 1,
  STOP_DISTRIBUTED_PLAYER = 2
}
