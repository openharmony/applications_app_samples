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
import { CommonConstants, Device } from '@ohos/common';
import StringUtil from './StringUtil';

export async function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve();
    }, ms);
  });
}

/**
 * 从资源库device对象中，获取缩略图资源，固定在 deviceIcons[1] 字段; 格式：file://<bundleName>/<sandboxPath>
 * @param libDevice
 * @returns
 */
export function getImageFromDevice(libDevice: Device): string | Resource {
  if (!libDevice.deviceIcons || libDevice.deviceIcons.length < 2 || StringUtil.isEmpty(libDevice.deviceIcons[1])) {
    return CommonConstants.DEFAULT_DEVICE_ICON;
  } else {
    return libDevice.deviceIcons[1];
  }
}