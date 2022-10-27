/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

export const WindowEventId = {
  SUB_WINDOW_INNER_EVENT_ID: 1001,
}

export const WindowColor = {
  statusBarColor: "#ffffff",
  navigationBarColor: '#ffffff',
  statusBarContentColor: '#000000',
  navigationBarContentColor: '#000000'
}

export class WindowType {
  moveToWidth: number
  moveToHeight: number
  setTouchable: boolean
  resetSizeWidth: number
  resetSizeHeight: number
  setPrivacyMode: boolean
  setBrightness: number
}
