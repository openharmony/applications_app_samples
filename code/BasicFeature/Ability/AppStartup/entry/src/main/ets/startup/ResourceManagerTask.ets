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

import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';


@Sendable
export default class ResourceManagerTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    try {
      let value = context.resourceManager.getMediaContentSync($r('app.media.startIcon').id); // 默认屏幕密度
      let imageSource: image.ImageSource = image.createImageSource(value.buffer);
      let pixelMap = imageSource.createPixelMapSync();
      pixelMap.rotateSync(45);
      AppStorage.setAndLink<PixelMap>('image', pixelMap);
    } catch (error) {
    }
  }

  onDependencyCompleted(dependence: string): void {
  }
}

