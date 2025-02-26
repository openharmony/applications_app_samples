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

import { uiObserver, UIObserver } from '@kit.ArkUI';
import CustomScanViewModel, { ScanResults } from '../viewmodel/CustomScanViewModel';
import CustomScanCameraComp from '../components/CustomScanCameraComp';
import CustomScanCtrlComp from '../components/CustomScanCtrlComp';
import CommonConstants from '../common/constants/CommonConstants';
import { CommonTipsDialog } from '../components/CommonTipsDialog';
import { DetectBarcodePage } from './DetectBarcodePage';

/**
 * 二维码扫描页面
 * 实现步骤：
 * 1.用户授权相机后初始化页面内子组件
 * 2.进二维码扫描路由时监控折叠屏状态变化，实时重新初始化扫码服务和相机流尺寸
 */
@Component
export struct CustomScanPage {
  // 应用前后台标记
  @StorageProp('isBackground') @Watch('onBackgroundUpdate') isBackground: boolean = false;
  // 自页面栈
  @Provide('subPageStack') subPageStack: NavPathStack = new NavPathStack();
  // 自定义扫码vm实例
  @Provide('customScanVM') customScanVM: CustomScanViewModel = CustomScanViewModel.getInstance();
  // 授权标志
  @State scanResult: ScanResults = this.customScanVM.scanResult
  @State isGranted: boolean = false;
  // 提示授权弹框
  @State isDialogShow: boolean = false;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CommonTipsDialog({
      isDialogShow: this.isDialogShow
    }),
    autoCancel: false,
    customStyle: false,
    alignment: DialogAlignment.Center
  });
  listener: (info: uiObserver.RouterPageInfo) => void = (info: uiObserver.RouterPageInfo) => {
    let routerInfo: uiObserver.RouterPageInfo | undefined = this.queryRouterPageInfo();
    if (info.pageId == routerInfo?.pageId) {
      if (info.state == uiObserver.RouterPageState.ON_PAGE_SHOW) {
        this.onComponentShow();
      } else if (info.state == uiObserver.RouterPageState.ON_PAGE_HIDE) {
        this.onComponentHide();
      }
    }
  }

  @Builder
  pageMap(name: string) {
    if (name === CommonConstants.SUB_PAGE_DETECT_BARCODE) {
      NavDestination() {
        DetectBarcodePage()
      }
      .hideTitleBar(true)
    }
  }

  async aboutToAppear() {
    // 注册routerPage更新监听
    let uiObserver: UIObserver = this.getUIContext().getUIObserver();
    uiObserver.on('routerPageUpdate', this.listener);

    this.onComponentShow();
  }

  /**
   * 组件出现时执行，包括前后台切换
   */
  async onComponentShow() {
    // TODO：知识点：检测应用是否已被用户允许使用相机权限，未授权向申请授权
    const isGranted = await this.customScanVM.reqCameraPermission();
    if (!isGranted && !this.isDialogShow) {
      // 用户未授权，给出提示
      this.dialogController.open();
      this.isDialogShow = true;
    }
    this.isGranted = isGranted;
  }

  aboutToDisappear() {
    // 取消监听
    let uiObserver: UIObserver = this.getUIContext().getUIObserver();
    uiObserver.off('routerPageUpdate', this.listener);
  }

  /**
   * 应用前后台切换回调，进后台时需要释放扫码资源，进前台时需要重启扫码功能
   * @returns {void}
   */
  onBackgroundUpdate(): void {
    if (this.subPageStack.size() > 0) {
      return;
    }

    if (this.isBackground) {
      this.customScanVM.stopCustomScan();
    } else {
      this.customScanVM.restartCustomScan();
    }
  }

  /**
   * 组件隐藏时执行
   */
  onComponentHide() {
    this.isDialogShow = false;
    this.dialogController.close();
  }

  initScan(): void {
    this.customScanVM.initCustomScan();
  }

  build() {
    Navigation(this.subPageStack) {
      Stack() {
        if (this.isGranted) {
          CustomScanCameraComp()
        }
        CustomScanCtrlComp()
      }
      .alignContent(Alignment.Center)
      .backgroundColor(Color.Black)
      .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .navDestination(this.pageMap)
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}