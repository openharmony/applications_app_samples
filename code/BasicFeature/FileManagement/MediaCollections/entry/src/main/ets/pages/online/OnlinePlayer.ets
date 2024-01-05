/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import window from '@ohos.window'
import Logger from '../../model/Logger'
import { AVPlayer } from '../../model/AVPlayer'
import { samplesData } from '../../model/JsonListData'
import OnlinePlayerView from '../../phoneView/online/OnlinePlayerView'

const TAG = 'OnlinePlayer'

@Entry
@Component
struct OnlinePlayer {
  @State myMedia: AVPlayer = new AVPlayer()
  @State onlineVideoData: samplesData = {} as samplesData
  @State currentTime: number = 0
  @State surfaceId: number = -1
  @State isXComponent: boolean = true
  @State @Watch('onChangeLoop') isLoop: boolean = false
  @State @Watch('onChangePlay') isPlaying: boolean = false
  @State @Watch('changeOrientation') isLandscape: boolean = false
  private mXComponentController: XComponentController = new XComponentController()

  /**
   * 监听 isLandscape 手动触发设备横竖屏状态函数
   */
  changeOrientation() {
    // 获取UIAbility实例的上下文信息
    let context = getContext(this)
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      lastWindow.setPreferredOrientation(this.isLandscape ? window.Orientation.LANDSCAPE_INVERTED : window.Orientation.PORTRAIT)
      lastWindow.setPreferredOrientation(this.isLandscape ? window.Orientation.AUTO_ROTATION_LANDSCAPE : window.Orientation.PORTRAIT)
    })
  }

  async aboutToAppear() {
    this.getRouterParams()
    this.myMedia.setCompleteCallback(() => {
      this.isPlaying = !this.isPlaying
    })
  }

  aboutToDisappear() {
    this.myMedia.release()
    this.isLandscape = false
  }

  onPageShow() {
    this.myMedia.getPlay()
  }

  onPageHide() {
    this.myMedia.getPause()
  }

  /**
   * 路由传参，接收video数据
   */
  getRouterParams() {
    let routerParams: Record<string, Object> = router.getParams() as Record<string, Object>
    if (!routerParams) {
      Logger.error(TAG, 'routerParams is undefined.')
      return
    }
    this.onlineVideoData = routerParams['videoParams'] as samplesData
  }

  onChangeLoop() {
    this.myMedia.getPlayMode(this.isLoop)
  }

  onChangePlay() {
    this.isPlaying ? this.myMedia.getPlay() : this.myMedia.getPause()
  }

  build() {
    Column() {
      OnlinePlayerView({
        myMedia: $myMedia,
        currentTime: $currentTime,
        surfaceId: $surfaceId,
        isXComponent: $isXComponent,
        isPlaying: $isPlaying,
        isLoop: $isLoop,
        isLandscape: $isLandscape,
        onlineVideoData: this.onlineVideoData,
        mXComponentController: this.mXComponentController,
      })
    }.height('100%').backgroundColor('#222324')
  }
}
