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

import { ColorOptions, SizeOptions } from '../model/ResModel'


export const COLORS: ColorOptions = {
  primary: '#67C23A', // 主色调（清新绿）
  bgPage: '#F5F7FA', // 页面背景
  bgCard: '#FFFFFF', // 卡片背景
  textMain: '#303133', // 主要文字
  textSub: '#909399', // 次要文字
  border: '#E5E6EB', // 边框色
  btnText: '#FFFFFF'     // 按钮文字色
}

export const SIZES: SizeOptions = {
  radius: 12, // 通用圆角
  padding: 20, // 通用内边距
  fontSizeTitle: 22, // 标题字号
  fontSizeNormal: 16, // 常规字号
  fontSizeSmall: 14, // 小字号
  spacing: 16            // 通用间距
}