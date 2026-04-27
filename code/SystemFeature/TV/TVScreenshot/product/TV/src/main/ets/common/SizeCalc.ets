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
import { display } from '@kit.ArkUI'

/**
 * 缓存默认显示设备的信息。
 * 获取 display 对象是一个涉及跨进程通信的系统调用，同步获取后缓存，
 * 可以避免在 UI 渲染过程中因频繁调用而产生的性能开销。
 */
const dftDisplay = display.getDefaultDisplaySync()

/**
 * 根据屏幕宽度进行等比例缩放计算。
 * 业务背景：TV 端设备分辨率差异巨大（从 720P 到 4K），UI 必须具备自适应能力。
 * 原理：以 1920px 为基准设计宽度，根据实际物理屏幕宽度的比例实时计算目标尺寸。
 * 这种计算方式确保了 UI 元素在不同分辨率的电视上保持一致的比例关系，避免布局溢出或过小。
 */
export let sizeCalc = (number: number): number => {
  return dftDisplay.width / 1920 * number
}
