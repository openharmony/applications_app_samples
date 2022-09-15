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

import nativerender from "libnativerender.so";
import { ContextType } from "./common/Constants"

const nativeAppLifecycle = nativerender.getContext(ContextType.APP_LIFECYCLE);

export default {
  onCreate() {
    console.info('[LIFECYCLE-App] onCreate')
    nativeAppLifecycle.onCreate();
  },
  onShow() {
    console.info('[LIFECYCLE-App] onShow')
    nativeAppLifecycle.onShow();
  },
  onHide() {
    console.info('[LIFECYCLE-App] onHide')
    nativeAppLifecycle.onHide();
  },
  onDestroy() {
    console.info('[LIFECYCLE-App] onDestroy')
    nativeAppLifecycle.onDestroy();
  },
}
