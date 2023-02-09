/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import Logger from '../utils/Logger'

export default class AccessibilityUtils {
  constructor() {
  }

  static async getAttributeValue(accessibilityElement, key) {
    Logger.info("AccessibilityUtils getAttributeValue")
    if (accessibilityElement == null) {
      Logger.error("AccessibilityUtils accessibilityElement is null")
      return null
    }

    let keys = await accessibilityElement.attributeNames()
    let value = undefined
    let isExit = false
    for (let keyString of keys) {
      if (key == keyString) {
        isExit = true
      }
    }
    if (isExit) {
      try {
        value = await accessibilityElement.attributeValue(key)
      } catch (error) {
        Logger.error("AccessibilityUtils Failed to get attributeValue of " + key + ". Cause: " + JSON.stringify(error))
      }
    }
    return value
  }

  static async getElementWantedInfo(accessibilityElement, wantedAttribute) {
    Logger.info("AccessibilityUtils getElementAllInfo")
    if (accessibilityElement == null) {
      Logger.error("AccessibilityUtils accessibilityElement is null")
      return null
    }

    let info = ""
    let value = undefined
    for (let name of wantedAttribute) {
      value = await AccessibilityUtils.getAttributeValue(accessibilityElement, name);
      info = info.concat(name + ": " + value + " ")
    }
    return info
  }

  static async createElementArray(accessibilityElement) {
    Logger.info("AccessibilityUtils createElementArray")
    let resultArray = []
    if (accessibilityElement == null) {
      Logger.error("AccessibilityUtils accessibilityElement is null.")
      return resultArray
    }

    let stack = []
    stack.push(accessibilityElement)
    let tmpElement
    while (stack.length > 0) {
      tmpElement = stack.pop()
      resultArray.push(tmpElement)
      let childElements = await AccessibilityUtils.getAttributeValue(tmpElement, "children")
      if (childElements) {
        for (let childElement of childElements) {
          if (childElement != null) {
            stack.push(childElement)
          }
        }
      } else {
        Logger.error("AccessibilityUtils this node does not have childElement")
      }
    }
    return resultArray
  }

  static async findElementByKey(elementArray, targetElement) {
    Logger.info("AccessibilityUtils findElementByKey")
    if (elementArray == null || elementArray.length == 0 || targetElement == null) {
      return null
    }

    let value = undefined
    for (let element of elementArray) {
      value = await AccessibilityUtils.getAttributeValue(element, targetElement.KEY)
      if (value == targetElement.VALUE) {
        return element
      }
    }
    Logger.error("AccessibilityUtils Failed to find target element.")
    return null
  }
}