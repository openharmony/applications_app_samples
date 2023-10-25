/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 计算，当固定容器宽高，选择Contain模式后，图片的实际宽高
 * @param componentW 容器宽
 * @param componentH
 * @param imageW 图片宽
 * @param imageH
 * @returns
 */
export function getContainSize(componentW: number, componentH: number, imageW: number, imageH: number): Size {
  const size: Size = new Size();
  // 如果组件宽高比更小，那么宽度会最大
  const isWidthMax: boolean = componentW / componentH - imageW / imageH <= 0;
  if (isWidthMax) {
    size.width = componentW;
    size.height = componentW / imageW * imageH;
  } else {
    size.height = componentH;
    size.width = componentH / imageH * imageW;
  }
  size.scale = size.width / imageW;
  return size;
}

export class Size {
  width: number = 0;
  height: number = 0;
  // 缩放比
  scale: number = 0;
}
