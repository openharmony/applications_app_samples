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
import { InputDeviceInfo } from '../model/InputDeviceInfo'
import { logger } from '@ohos/common/src/main/ets/util/Logger';
import inputDevice from '@ohos.multimodalInput.inputDevice'

const TAG: string = '[Sample_InputDeviceUtil]'

/**
 *  获取设备列表
 * @param callback 回调
 */
export function getDeviceList(callback: (data: InputDeviceInfo[]) => void) {
  // 获取所有输入设备ID列表
  try {
    inputDevice.getDeviceList().then(async (ids) => {
      logger.info(`${TAG} Device id list: ${JSON.stringify(ids)}`)
      if (!ids || ids.length <= 0) {
        return
      }
      // 根据设备ID获取设备信息
      try {
        let devices: InputDeviceInfo[] = []
        for (const item of ids) {
          logger.info(`${TAG} get device info, id: ${item}`)
          let deviceData: InputDeviceInfo | null = await getDeviceInfo(item);
          if (deviceData !== null && devices.indexOf(deviceData) === -1) {
            logger.info(`${TAG} add device, deviceId: ${deviceData.id}`)
            devices.push(deviceData)
          }
        }
        callback(devices)
      } catch (error) {
        logger.error(`${TAG} Failed to get device info, error: ${JSON.stringify(error, [`code`, `message`])}`)
      }
    })
  } catch (error) {
    logger.error(`${TAG} Failed to get device id list, error: ${JSON.stringify(error, [`code`, `message`])}`)
  }
}

/**
 * 获取设备信息
 * @param deviceId 设备ID
 */
export async function getDeviceInfo(deviceId: number): Promise<InputDeviceInfo | null> {

  try {
    let deviceData: InputDeviceInfo;
    let inputDeviceData: inputDevice.InputDeviceData = await inputDevice.getDeviceInfo(deviceId)
    logger.info(`${TAG} get device info ${JSON.stringify(inputDeviceData)}`)
    deviceData = {
      id: inputDeviceData.id,
      name: inputDeviceData.name,
      sources: inputDeviceData.sources,
      axisRanges: inputDeviceData.axisRanges,
      bus: inputDeviceData.bus,
      product: inputDeviceData.product,
      vendor: inputDeviceData.vendor,
      version: inputDeviceData.version,
      phys: inputDeviceData.phys,
      uniq: inputDeviceData.uniq,
      icon_source: getDeviceIcon(inputDeviceData.sources),
      connect: false
    }
    return deviceData;
  } catch (error) {
    logger.error(`${TAG} Failed to get device info, error: ${JSON.stringify(error, [`code`, `message`])}`)
  }

  return null;
}

/**
 * 获取设备的图标
 * @param sources 输入设备支持的源类型
 */
function getDeviceIcon(sources: string[]): Resource {
  logger.info(`${TAG} getDeviceIcon: ${sources}`)
  if (!sources || sources.length <= 0) {
    return $r('app.media.icon_input_device_default')
  }
  let res: Resource
  let sourceType = sources[0]
  if (sourceType === 'keyboard') {
    res = $r('app.media.icon_keyboard')
  } else if (sourceType === 'mouse') {
    res = $r('app.media.icon_mouse')
  } else if (sourceType === 'touchpad') {
    res = $r('app.media.icon_touchpad')
  } else if (sourceType === 'touchscreen') {
    res = $r('app.media.icon_touchscreen')
  } else if (sourceType === 'joystick') {
    res = $r('app.media.icon_joystick')
  } else if (sourceType === 'trackball') {
    res = $r('app.media.icon_trackball')
  } else {
    res = $r('app.media.icon_input_device_default')
  }
  return res
}

class InputDevice {
  private callback: Function | null = null;
  private deviceList: InputDeviceInfo[] = []

  public registerChange(callback: Function): void {
    logger.info(`${TAG} registerChange`)
    try {
      this.callback = callback
      inputDevice.on('change', (data: inputDevice.DeviceListener) => this.onChangeCallback(data));
    } catch (error) {
      logger.error(`${TAG} Listen device event failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }
  }

  public unregisterChange(): void {
    try {
      inputDevice.off('change')
      this.deviceList = []
      if (this.callback && this.callback !== null) {
        this.callback(this.deviceList)
        this.callback = null
      }
      logger.info(`${TAG} Monitor off success`)
    } catch (error) {
      logger.error(`${TAG} Cancel listening device event failed, error: ${JSON.stringify(error, [`code`, `message`])}`)
    }

  }

  private async onChangeCallback(data: inputDevice.DeviceListener) {
    logger.info(`${TAG} onChangeCallback event: ${JSON.stringify(data)}`)
    // 获取设备信息
    let deviceId: number = data.deviceId
    let deviceInfo: InputDeviceInfo | null = null;
    let curIndex: number = -1
    let tempIndex: number = -1
    let delCount: number = 0
    if (this.deviceList && this.deviceList.length > 0) {
      for (const element of this.deviceList) {
        tempIndex++
        if (element.id === deviceId) {
          deviceInfo = element
          curIndex = tempIndex
          delCount = 1
          break
        }
      }
    }

    if (deviceInfo == null) {
      deviceInfo = await getDeviceInfo(deviceId)
    }
    // 根据状态修改
    let type: inputDevice.ChangedType = data.type
    if (type === 'add' && deviceInfo !== null && deviceInfo !== undefined) {
      // 连接
      deviceInfo.connect = true
    } else if (type === 'remove' && deviceInfo !== null && deviceInfo !== undefined) {
      // 断开
      deviceInfo.connect = false
    }

    if (deviceInfo !== null) {
      this.deviceList.splice(curIndex, delCount, deviceInfo);
    }
    logger.info(`${TAG} get device info deviceId count:${this.deviceList.length}}`)
    // fixme xjs 当前OH 3.2 release系统存在应用多次启动后出现回调多次，所以这里进行数据去重处理
    this.deviceList = this.removeDuplicate(this.deviceList)
    logger.info(`${TAG} get device info deviceId: ${deviceId} deviceInfo: ${JSON.stringify(deviceInfo)} count:${this.deviceList.length}}`)

    if (this.callback && this.callback !== null) {
      this.callback(this.deviceList)
    }
  }

  /**
   * 列表对象去重
   * @param arr 列表
   */
  private removeDuplicate(arr: InputDeviceInfo[]): InputDeviceInfo[] {
    const newArr: InputDeviceInfo[] = [];
    for (const item of arr) {
      // 检查缓存中是否已经存在
      if (newArr.find((cur: InputDeviceInfo) =>
      cur.id === item.id &&
      cur.name === item.name &&
      cur.connect === item.connect)
      ) {
        // 已经存在说明以前记录过，现在这个就是多余的，直接忽略
        continue;
      }
      // 不存在就说明以前没遇到过，把它记录下来
      newArr.push(item)
    }
    // 记录结果就是过滤后的结果
    return newArr
  }
}

export default new InputDevice()