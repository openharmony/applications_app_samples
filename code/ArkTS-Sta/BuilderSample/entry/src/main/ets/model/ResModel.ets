'use static'
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

export interface ColorOptions {
  primary: string, // 主色调
  bgPage: string, // 页面背景
  bgCard: string, // 卡片背景
  textMain: string, // 主要文字
  textSub: string, // 次要文字
  border: string, // 边框色
  btnText: string // 按钮文字色
}

export interface SizeOptions {
  radius: int, // 通用圆角
  padding: int, // 通用内边距
  fontSizeTitle: int, // 标题字号
  fontSizeNormal: int, // 常规字号
  fontSizeSmall: int, // 小字号
  spacing: int // 通用间距
}