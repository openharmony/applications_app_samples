/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import inputMonitor from '@ohos.multimodalInput.inputMonitor'
import pointer from '@ohos.multimodalInput.pointer'
import { formatJson } from '@ohos/common/src/main/ets/util/JSONUtils';
import { logger } from '@ohos/common/src/main/ets/util/Logger';
import { MouseEvent } from '@ohos.multimodalInput.mouseEvent'
import common from '@ohos.app.ability.common'
import window from '@ohos.window'

/**
 * 鼠标管理器
 */

const TAG: string = '[Sample_MouseManagerUtil]'

/**
 * 设置鼠标指针显示或者隐藏
 * @param visible 是否显示 true-显示 false-隐藏
 */
export function setPointerVisible(visible: boolean): void {
  try {
    pointer.setPointerVisible(visible, (error) => {
      if (error) {
        logger.error(`${TAG} Set pointer visible failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
        return
      }
      logger.info(`${TAG} Set pointer visible success`)
    });
  } catch (error) {
    logger.error(`${TAG} Set pointer visible failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
  }
}

/**
 * 获取鼠标指针是否显示
 */
export async function isPointerVisible(): Promise<boolean | undefined> {
  try {
    let result: boolean;
    result = await pointer.isPointerVisible();
    return result;
  } catch (error) {
    logger.error(`${TAG} Get pointer visible failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
  }
  return undefined;
}

/**
 * 设置鼠标移动速度
 * @param speed 速度值，取值范围[1-11] 默认5
 */
export function setPointerSpeed(speed: number): void {
  try {
    pointer.setPointerSpeed(speed).then(() => {
      logger.info(`${TAG} Set pointer speed success`)
    });
  } catch (error) {
    logger.error(`${TAG} Set pointer speed failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
  }
}

/**
 * 设置鼠标指针样式
 * @param style 样式
 */
export function setPointerStyle(style: pointer.PointerStyle): void {
  let context = getContext() as common.UIAbilityContext;
  window.getLastWindow(context, (error, win) => {
    if (error.code) {
      logger.error(`${TAG} Failed to obtain the top window. Cause: ${JSON.stringify(error)}`)
      return
    }
    let windowId = win.getWindowProperties().id
    if (windowId < 0) {
      logger.error(`${TAG} Invalid windowId`)
      return
    }
    try {
      pointer.setPointerStyle(windowId, style, error => {
        logger.info(`${TAG} Set pointer style success`)
      });
    } catch (error) {
      logger.error(`${TAG} Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }
  })
}

/**
 * 获取鼠标样式
 */
export async function getPointerStyle(): Promise<pointer.PointerStyle> {
  let result: pointer.PointerStyle = pointer.PointerStyle.DEFAULT
  let context = getContext() as common.UIAbilityContext;
  try {
    let lastWindow = await window.getLastWindow(context)
    let windowId = lastWindow.getWindowProperties().id
    if (windowId < 0) {
      logger.error(`${TAG} Invalid windowId`)
      return result
    }
    try {
      result = await pointer.getPointerStyle(windowId)
    } catch (error) {
      logger.error(`${TAG} Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }
  } catch (error) {
    logger.error(`${TAG} Failed to obtain the top window. Cause: ${JSON.stringify(error)}`)
  }
  return result
}

class MouseManagerUtil {
  private callback: Function | null = null;

  public registerMouse(callback: Function): void {
    logger.info(`${TAG} registerMouse`)
    try {
      this.callback = callback
      inputMonitor.on('mouse', (event: MouseEvent): boolean => this.onMouseCallback(event));
    } catch (error) {
      logger.error(`${TAG} register mouse on failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }
  }

  public unregisterMouse(): void {
    try {
      inputMonitor.off('mouse', (event: MouseEvent): boolean => this.onMouseCallback(event));
      this.callback = null
      logger.info(`${TAG} Monitor off success`)
    } catch (error) {
      logger.error(`${TAG} unregister mouse  execute failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }

  }

  private onMouseCallback(event: MouseEvent): boolean {
    logger.info(`${TAG} onMouseCallback event: ${JSON.stringify(event)}`)
    if (this.callback && this.callback !== null && this.callback !== undefined) {
      this.callback(formatJson(JSON.stringify(event)))
    }
    return false
  }
}

export default new MouseManagerUtil()