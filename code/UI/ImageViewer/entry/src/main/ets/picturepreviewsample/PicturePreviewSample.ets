/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { PicturePreview } from '../view/PicturePreview';

// 图片预览使用案例
/**
 * 功能说明：本示例介绍使用List、LazyForEach、matrix4、组合手势实现图片预览功能
 *
 * 推荐场景：需要图片预览的场景
 *
 * 核心组件：
 * 1. PicturePreview：实现图片预览的布局和循环设置多图预览
 * 2. PicturePreviewImage ： 具体某个图片预览
 *
 * 实现步骤：
 * 1. 数据准备：首先构建一个需要预览的图片数组
 *  @example
 *  @State imageList: string[] = [$r("app.media.picturepreview_image")];
 * 2. 数据准备：创建好主轴方向
 *  @example
 *  @State listDirection: Axis = Axis.Horizontal;
 * 3.构建图片预览
 *  @example
 *  PicturePreview({ imageList: this.imageList, listDirection: this.listDirection })
 */
@Component
export struct PicturePreviewSample {
  @State imageList: string[] = [];
  @State listDirection: Axis = Axis.Horizontal;

  aboutToAppear(): void {
    let imageSource:string = $r('app.media.picturepreview_image') as ESObject;
    this.imageList.push(
      imageSource,
      imageSource,
      imageSource
    )
  }

  build() {
    PicturePreview({ imageList: this.imageList, listDirection: this.listDirection })
  }
}