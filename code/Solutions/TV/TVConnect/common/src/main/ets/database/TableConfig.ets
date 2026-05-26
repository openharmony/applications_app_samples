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

/*
 * connect数据库名称
 * */
export const CONNECT_DATABASE_NAME: string = 'connect.db';

/*
 * connect数据库表类型
 * */
export enum TableType {
  DEVICE_LIBRARY = 'device_table', SCENE_LIBRARY = 'scene_table',
}

/*
 * 设备库表字段
 * */
export enum DeviceLibraryField {
  PID = 'pid', VALUE = 'value'
}

/*
 * 场景库表字段
 * */
export enum SceneLibraryField {
  SCENE_ID = 'scenario_card_id', LANGUAGE = 'language', VALUE = 'value'
}