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

import AccessibilityUtils from '../utils/AccessibilityUtils'
import ResourceUtils from '../utils/ResourceUtils'
import Logger from '../utils/Logger'

const wantedAttribute = ["componentId", "componentType", "bundleName", "text", "hintText", "description",
  "focusable", "clickable", "longClickable", "accessibilityFocused", "windowId"]

export default class AccessibilityManager {
  private static instance = null
  accessibleContext = null
  currentPageElementArray = null
  targetElement = {
    KEY: "text",
    VALUE: null
  }

  static getInstance() {
    if (this.instance == null) {
      this.instance = new AccessibilityManager()
    }
    return this.instance
  }

  onStart(context) {
    Logger.info("AccessibilityManager onStart")
    this.accessibleContext = context
  }

  onStop() {
    Logger.info("AccessibilityManager onStop")
    this.accessibleContext = null
  }

  onEvent(accessibilityEvent) {
    Logger.info("AccessibilityManager onEvent")
    switch (accessibilityEvent.eventType) {
      case "rightThenDown":
        this.getCurrentPageAllElement()
        break
      case "leftThenDown":
        this.printAllElementInfo()
        break
      case "left":
        this.setAccessibilityFocused()
        break
      case "right":
        this.clearAccessibilityFocus()
        break
      case "down":
        this.clickTargetElement()
        break
      default:
        break
    }
  }

  async getCurrentPageAllElement() {
    Logger.info("AccessibilityManager getCurrentPageAllElement")
    let rootElement = null
    try {
      rootElement = await this.accessibleContext.getWindowRootElement()
    } catch (error) {
      Logger.error("AccessibilityExtAbility Failed to getWindowRootElement. Cause: " + JSON.stringify(error))
    }
    this.currentPageElementArray = await AccessibilityUtils.createElementArray(rootElement)
  }

  async printAllElementInfo() {
    Logger.info("AccessibilityManager printAllElementInfo")
    if (this.currentPageElementArray == null || this.currentPageElementArray.length == 0) {
      Logger.error("AccessibilityManager currentPageElementArray is null")
      return
    }
    let info = null
    for (let element of this.currentPageElementArray) {
      info = await AccessibilityUtils.getElementWantedInfo(element, wantedAttribute)
      Logger.info("AccessibilityManager element information: " + info)
    }
  }

  async setAccessibilityFocused() {
    Logger.info("AccessibilityManager setAccessibilityFocused")
    this.targetElement.VALUE = ResourceUtils.getStringByName(this.accessibleContext, "accessibility_focus")
    let element = await AccessibilityUtils.findElementByKey(this.currentPageElementArray, this.targetElement)
    if (element == null) {
      Logger.error("AccessibilityManager Target element not found")
      return
    }
    let isFocusable = await AccessibilityUtils.getAttributeValue(element, "focusable")
    let isAccessibilityFocused = await AccessibilityUtils.getAttributeValue(element, "accessibilityFocused")
    if (!isFocusable || isAccessibilityFocused) {
      return
    }
    try {
      element.performAction("accessibilityFocus") // 元素可执行的行为可通过actionNames()获取
      Logger.info("AccessibilityManager Succeed in perform action: accessibilityFocus")
      this.getCurrentPageAllElement() // 执行完动作后需更新界面信息
    } catch (error) {
      Logger.error("AccessibilityManager Failed to perform action: accessibilityFocus. Cause: " + JSON.stringify(error))
    }
  }

  async clearAccessibilityFocus() {
    Logger.info("AccessibilityManager clearAccessibilityFocus")
    this.targetElement.VALUE = ResourceUtils.getStringByName(this.accessibleContext, "accessibility_focus")
    let element = await AccessibilityUtils.findElementByKey(this.currentPageElementArray, this.targetElement)
    if (element == null) {
      Logger.error("AccessibilityManager Target element not found")
      return
    }
    let isAccessibilityFocused = await AccessibilityUtils.getAttributeValue(element, "accessibilityFocused")
    if (!isAccessibilityFocused) {
      return
    }
    try {
      element.performAction("clearAccessibilityFocus").then(() => {
        Logger.info("AccessibilityManager Succeed in perform action: clearAccessibilityFocus")
        this.getCurrentPageAllElement()
      }).catch((err) => {
        Logger.error("AccessibilityManager Failed to perform action: clearAccessibilityFocus. Cause: " + JSON.stringify(err))
      })
    } catch (error) {
      Logger.error("AccessibilityManager Failed to perform action: clearAccessibilityFocus. Cause: " + JSON.stringify(error))
    }

  }

  async clickTargetElement() {
    Logger.info("AccessibilityManager clickTargetElement")
    this.targetElement.VALUE = ResourceUtils.getStringByName(this.accessibleContext, "accessibility_not_clicked")
    let tmpElementNotClicked = await AccessibilityUtils.findElementByKey(this.currentPageElementArray, this.targetElement)
    this.targetElement.VALUE = ResourceUtils.getStringByName(this.accessibleContext, "accessibility_clicked")
    let tmpElementClicked = await AccessibilityUtils.findElementByKey(this.currentPageElementArray, this.targetElement)
    let element = null
    if (tmpElementClicked != null) {
      element = tmpElementClicked
    } else if (tmpElementNotClicked != null) {
      element = tmpElementNotClicked
    } else {
      Logger.error("AccessibilityManager Target element not found")
      return
    }
    let isClickable = await AccessibilityUtils.getAttributeValue(element, "clickable")
    if (!isClickable) {
      Logger.error("AccessibilityManager Target element cannot be clicked")
      return
    }
    try {
      element.performAction("click").then((data) => {
        Logger.info("AccessibilityManager Succeed in perform action: click")
        this.getCurrentPageAllElement()
      }).catch((err) => {
        Logger.error("AccessibilityManager Failed to perform action: click. Cause: " + JSON.stringify(err))
      })
    } catch (error) {
      Logger.error("AccessibilityManager Failed to perform action: click. Cause: " + JSON.stringify(error))
    }

  }
}