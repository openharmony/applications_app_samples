/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

/**
 * Constants of events that will be registered to system.
 */
export class EventConstants {
  static readonly EVENT_PACKAGE_ADDED: string = 'usual.event.PACKAGE_ADDED';
  static readonly EVENT_PACKAGE_REMOVED: string = 'usual.event.PACKAGE_REMOVED';
  static readonly EVENT_BADGE_UPDATE: string = 'launcher.event.EVENT_BADGE_UPDATE';
  static readonly EVENT_ENTER_HOME: string = 'launcher.event.EVENT_ENTER_HOME';
  static readonly EVENT_ENTER_RECENTS: string = 'launcher.event.EVENT_ENTER_RECENTS';
  static readonly EVENT_CLEAR_RECENTS: string = 'launcher.event.EVENT_CLEAR_RECENTS';
  static readonly EVENT_ENTER_FORM_MANAGER: string = 'launcher.event.EVENT_ENTER_FORM_MANAGER';
}