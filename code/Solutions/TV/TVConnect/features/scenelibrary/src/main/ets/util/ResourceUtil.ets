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
import { Logger } from '@ohos/common';

export default class ResourceUtil {
  /**
   * 返回float资源值表示的px
   * @param context
   * @param floatResource
   * @returns
   */
  public static getNumberToPx(context: Context, floatResource: Resource): number {
    try {
      // float对应返回的是真实像素点值
      return context.resourceManager.getNumber(floatResource.id);
    } catch (error) {
      Logger.error(`getNumber failed, error code: ${error}.`);
      return 0;
    }
  }

  /**
   * 返回float资源值标识的vp
   * @param context
   * @param floatResource
   * @returns
   */
  public static getNumberToVp(context: Context, floatResource: Resource): number {
    const result = ResourceUtil.getNumberToPx(context, floatResource);
    return px2vp(result);
  }


  public static getStringSync(context: Context, resource: Resource): string {
    return context.resourceManager.getStringSync(resource.id);
  }
};