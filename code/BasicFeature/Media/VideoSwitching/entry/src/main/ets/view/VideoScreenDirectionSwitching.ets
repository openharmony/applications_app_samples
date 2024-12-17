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


import { VideoComponent } from '../component/VideoComponent';
import { FlowItemContent, FlowItemContentsData, JsonObject } from '../model/BasicDataSource';

const JSON_URI: string = 'video_screen_direction_switching_mockData.json'; // 获取mock数据的json名称

/**
 * 功能描述: 本示例介绍了@ohos.multimedia.media组件和@ohos.window接口以及使用触摸热区实现视频横竖屏切换及进度条热区拖动的功能
 *
 * 推荐场景: 横竖屏视频等媒体播放场景
 *
 * 核心组件:
 * 1. AVPlayer
 *
 * 实现步骤:
 * 1. 初始化@ohos.multimedia.media的AVPlayer。
 * 2. 当AVPlayer初始化完毕进入initialized状态时，将XComponent和AVPlayer通过surfaceId绑定。
 * 3. 使用AVPlayer中的width和height属性判断是横屏视频还是竖屏视频，方便判断是否需要展示全屏观看按钮。
 * 4. 调用@ohos.window的 getLastWindow 方法获取当前应用内最上层的子窗口
 * 5. 利用获取到的窗口对象，调用 setWindowSystemBarEnable 方法设置窗口是否显示导航栏和状态栏。
 * 6. 调用窗口对象的 setPreferredOrientation 方法设置窗口旋转方向以及是否应用重力感应。
 * 7. 调用窗口对象的setWindowLayoutFullScreen方法实现沉浸式布局。
 * 8. 对进度条整个组件设置触摸热区。
 */
@Component
export struct VideoScreenDirectionSwitchingComponent {
  @State contentData: FlowItemContentsData = new FlowItemContentsData(); // 瀑布流内容
  @State selectedVideo: string = ''; // 选择的视频名称
  @State selectedIndex: number = 0; // 选择的视频index
  @State isLandscape: boolean = false; // 是否横屏状态
  @State isLandscapeStart: boolean = false; // 是否开始横屏动画

  async aboutToAppear() {
    // 获取JSON中的列表数据
    const jsonObj: JsonObject = new JsonObject(JSON_URI);
    const array = await jsonObj.getFlowItemContentObj();
    this.contentData.pushData(array);
    this.selectedVideo = this.contentData.getData(this.selectedIndex).media;
  }

  aboutToDisappear() {
    this.isLandscapeStart = false;
    this.isLandscape = false;
  }

  build() {
    Column() {
      Swiper() {
        LazyForEach(this.contentData, (moment: FlowItemContent) => {
          VideoComponent({
            selectedVideo: this.selectedVideo,
            fileName: moment.text,
            fileUrl: moment.media,
            isLandscape: this.isLandscape,
            isLandscapeStart: this.isLandscapeStart
          })
        }, (moment: FlowItemContent) => moment.id)
      }
      .cachedCount(1)
      .index(this.selectedIndex)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.selectedIndex = targetIndex;
        this.selectedVideo = this.contentData.getData(targetIndex).media;
      })
      .indicator(false)
      .vertical(true)
      .height($r('app.string.video_screen_direction_switching_layout_100'))
    }
    .height($r('app.string.video_screen_direction_switching_layout_100'))
    .width($r('app.string.video_screen_direction_switching_layout_100'))
  }
}
