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

/**
 * 实现步骤：
 *  1. 集成三方库libheif及其依赖库libde265来实现软解码，集成网络库curl，这样在Native侧就可以直接请求到HEIF图片，并在Native侧解码，减少跨语言调用开销
 *  2. 网络请求和HEIF图片软解码使用Taskpool来实现多线程并发能力
 *  3. 在HEIF软解码过程中
 *    3.1 通过heif_context_read_from_memory_without_copy读取网络请求到的HEIF资源（已存在内存中）
 *    3.2 调用解码接口heif_decode_image解码HEIF图片
 *    3.3 调用heif_image_get_plane_readonly获取HEIF图片数据data
 *    3.4 字节对齐和颜色编码格式转换
 *    3.5 定义HEIF的宽高、颜色编码格式，调用NDK的OH_PixelMap_CreatePixelMap函数即可创建PixelMap
 *  4. WaterFlow + LazyForEach加载解码后的HEIF图片数据
 */

import { heifUrls, ImageInfo, WaterFlowDataSource } from './model/WaterFlowData';
import { ReusableFlowItem } from './components/ReusableFlowItem';
import { executeTasks } from './model/Taskpool';


@Component
export struct DecodeHEIFImageView {
  private dataSource: WaterFlowDataSource = new WaterFlowDataSource();

  aboutToAppear(): void {
    // TODO：知识点：在Taskpool中执行异步并发任务（网络请求和图片软解码）
    executeTasks(heifUrls, this.dataSource);
  }

  build() {
    Column() {
      WaterFlow() {
        // TODO: 知识点: LazyForEach提供列表数据按需加载能力，解决一次性加载长列表数据耗时长、占用过多资源的问题，可以提升页面响应速度
        LazyForEach(this.dataSource, (item: ImageInfo) => {
          FlowItem() {
            ReusableFlowItem({ item })
          }
          .width('100%')
          .margin({
            top: $r('app.integer.decode_heif_image_flow_item_margin_top'),
            bottom: $r('app.integer.decode_heif_image_flow_item_margin_bottom')
          })
        }, (item: ImageInfo, index: number) => index + JSON.stringify(item))
      }
      .cachedCount(1)  // 当前案例数据量少设置为1，如果数据量较多可适当调整
      .columnsTemplate('1fr 1fr')
      .columnsGap($r('app.integer.decode_heif_image_water_flow_column_gap'))
    }
    .width('100%')
    .height('100%')
    .padding($r('app.integer.decode_heif_image_padding'))
    .backgroundColor($r('app.color.decode_heif_image_background_color'))
  }
}
