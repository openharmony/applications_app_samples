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

import CustomScanViewModel from '../viewmodel/CustomScanViewModel';
import CommonConstants from '../common/constants/CommonConstants';
import { logger } from '../common/util/Logger';

/**
 * 扫码相机流组件
 * 实现步骤：
 * 1.使用XComponent展示相机流内容
 * 2.XComponent加载完成之后开启扫码服务
 * 3.监控应用前后台切换、折叠屏状态变更，释放和重启扫码服务
 */
@Component
export default struct CustomScanCameraComp {
  // 自定义扫码vm实例
  @Consume('customScanVM') customScanVM: CustomScanViewModel;
  // 相机流展示组件控制器
  private cameraSurfaceController: XComponentController = new XComponentController();

  aboutToAppear() {
    // 注册屏幕状态监听（仅折叠屏）
    this.customScanVM.regDisplayListener();
    // 注册XComp尺寸修改回调
    this.customScanVM.regXCompSizeUpdateListener((width: number, height: number, offsetX: number, offsetY: number) => {
      this.updateCameraSurfaceSize(width, height, offsetX, offsetY);
    });
  }

  aboutToDisappear() {
    // 释放相机流
    this.customScanVM.initScanData();

    this.customScanVM.releaseCustomScan();
    // 清除surfaceId
    this.customScanVM.surfaceId = '';
  }


  build() {
    Column() {
      // TODO：知识点：相机流显示依赖XComponent
      XComponent({
        type: XComponentType.SURFACE,
        controller: this.cameraSurfaceController
      })
        .onLoad(() => {
          // TODO：知识点：customScan依赖XComponent组件的surfaceId，对图像进行扫描
          this.customScanVM.surfaceId = this.cameraSurfaceController.getXComponentSurfaceId();
          // TODO：知识点：初始化XComponent组件的surface流的尺寸
          this.updateCameraSurfaceSize(this.customScanVM.cameraCompWidth, this.customScanVM.cameraCompHeight
                                        , this.customScanVM.cameraCompOffsetX, this.customScanVM.cameraCompOffsetY);
          // TODO：知识点：XComponent加载完成后，启动相机进行扫码
          this.customScanVM.initCustomScan();
        })
        .clip(true)
        .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .height('100%')
    .width('100%')
  }

  /**
   * 动态更新XComponent的Suerface尺寸
   * @param {number} width 新宽度
   * @param {number} height 新高度
   * @returns {void}
   */
  updateCameraSurfaceSize(width: number, height: number, offsetX: number, offsetY: number): void {
    this.cameraSurfaceController.setXComponentSurfaceRect({
      offsetX: vp2px(offsetX),
      offsetY: vp2px(offsetY),
      surfaceWidth: vp2px(width),
      surfaceHeight: vp2px(height),
    })

    logger.info(`setXComponentSurfaceRect: ${width}, ${height}`);
  }
}
