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

import window from '@ohos.window';
import { FlowItemContentsData, FlowItemContent, JsonObject } from '../model/BasicDataSource';
import { XVideoComponent } from './XComponentVideo';
import { promptAction } from '@kit.ArkUI';

// window.setWindowSystemBarEnable方法的预设值，设置窗口全屏模式时状态栏和导航栏是否显示
const WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const JSON_URI: string = 'media_full_screen_mockData.json'; // 获取mock数据的json名称
const ASPECT_RATIO: number = 1.77777778; //元素宽高比
const VIDEO_Z_INDEX: number = 30; // 组件zIndex

/**
 * 功能描述: 本示例介绍了使用@ohos.multimedia.media接口和@ohos.window接口配合XComponent组件实现媒体全屏的功能。
 *
 * 推荐场景: 多用于首页瀑布流媒体播放等场景
 *
 * 核心组件:
 * 1. window
 * 2. XComponent
 *
 * 实现步骤:
 * 1. 在自定义组件XVideoComponent内调用changeOrientation方法，实现媒体全屏效果。
 * 2. 调用@ohos.window的getLastWindow方法获取当前应用内最上层的子窗口，若无应用子窗口，则返回应用主窗口。
 * 3. 利用获取到的窗口对象，调用setWindowSystemBarEnable方法设置窗口是否显示导航栏和状态栏。
 * 4. 调用窗口对象的setPreferredOrientation方法设置窗口旋转方向和重力感应。
 * 5. 调用窗口对象的setWindowLayoutFullScreen方法实现沉浸式布局。
 */
@Entry
@Component
export struct MediaFullScreenComponent {
  popPage: (() => void) | undefined = undefined;
  @State maskShow: boolean = false; // 遮罩层是否显示
  @State isLandscape: boolean = false; // 是否横屏状态
  @State cachedCountNumber: number = 6; // 懒加载缓存数
  @State contentData: FlowItemContentsData = new FlowItemContentsData(); // 瀑布流内容
  @State selectedVideo: string = ''; // 选择的视频名称
  @Provide pageMediaFullScreen: NavPathStack = new NavPathStack();
  @State videoLocation: Area = {
    // 视频在屏幕中的位置信息
    width: 0,
    height: 0,
    position: { x: 0, y: 0 },
    globalPosition: { x: 0, y: 0 }
  };

  async aboutToAppear() {
    // 获取JSON中的列表数据
    const jsonObj: JsonObject = new JsonObject(JSON_URI);
    const array = await jsonObj.getFlowItemContentObj();
    this.contentData.pushData(array);
  }

  async aboutToDisappear() {
    // 销毁组件时恢复window方向
    const currentWindow = await window.getLastWindow(getContext(this));
    currentWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR);
  }

  build() {
    // 应用主页用NavDestination承载，用于显示Navigation的内容区
    Navigation(this.pageMediaFullScreen) {

    }
    .mode(NavigationMode.Stack)
    .onAppear(() => {
      this.pageMediaFullScreen.pushPathByName("MediaFullScreen", null, false);
    })
    // 创建NavDestination组件，需使用此组件的onBackPressed回调拦截返回事件
    .navDestination(this.videoArea)
  }

  @Builder
  videoArea() {
    // 性能知识点: 功能是以har的形式集成在主工程中，没有@Entry修饰的组件，无法使用@Entry组件的onBackPress生命周期函数。
    NavDestination() {
      Column() {
        // 引入自定义视频组件
        XVideoComponent({
          fileName: this.selectedVideo,
          videoLocation: this.videoLocation,
          isLandscape: this.isLandscape,
          maskShow: this.maskShow
        })
        Column() {
        }
        .width($r('app.string.media_full_screen_layout_100'))
        .height($r('app.string.media_full_screen_layout_100'))
        .backgroundColor(Color.Transparent)
        .position({ x: 0, y: 0 })
        .zIndex(VIDEO_Z_INDEX)
        .visibility(this.maskShow ? Visibility.Visible : Visibility.None)

        WaterFlow() {
          // 性能知识点: LazyForEach 懒加载优化，详情请见 https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/lazyforeach_optimization.md/
          LazyForEach(this.contentData, (moment: FlowItemContent) => {
            FlowItem() {
              ReusableComponent({
                moment,
                selectedVideo: this.selectedVideo,
                videoLocation: this.videoLocation,
                maskShow: this.maskShow
              })
            }
            .width($r('app.string.media_full_screen_video_width'))
          }, (moment: FlowItemContent) => moment.id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap($r('app.integer.media_full_screen_main_page_row_padding_left'))
        .rowsGap($r('app.integer.media_full_screen_main_page_row_padding_left'))
        .cachedCount(this.cachedCountNumber) // 懒加载缓存配置
        .width($r('app.string.media_full_screen_layout_100'))
        .height($r('app.string.media_full_screen_layout_100'))
      }
      .backgroundColor($r('app.color.media_full_screen_search_border_color'))
      .height($r('app.string.media_full_screen_layout_100'))
      .layoutWeight(LAYOUT_WEIGHT)
    }
    .hideTitleBar(true)
    // TODO：知识点：返回时进行判断，如果在非全屏状态则返回首页，否则仅退出全屏
    .onBackPressed(() => {
      if (this.selectedVideo === '') {
        if (this.popPage) {
          this.popPage();
        } else {
          // 未传入返回接口时给出弹框提示
          promptAction.showToast({
            message: $r('app.string.media_full_screen_back_error_message'),
            duration: 1000
          })
        }
        return true;
      } else {
        this.maskShow = false;
        this.isLandscape = !this.isLandscape;
        return true;
      }
    })
  }
}

// 性能知识点: @Reusable复用组件优化，详情请见 https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/component-recycle.md/
@Reusable
@Component
struct ReusableComponent {
  @Prop moment: FlowItemContent;
  @Link selectedVideo: string;
  @Link videoLocation: Area;
  @Link maskShow: boolean;

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Image($r(`app.media.${this.moment.mediaPreview}`))
          .width('100%')
          .aspectRatio(ASPECT_RATIO)
        Image($r("app.media.media_full_screen_play"))
          .width($r('app.integer.media_full_screen_main_page_icon_play_width'))
          .height($r('app.integer.media_full_screen_main_page_icon_play_height'))
      }
      .onClick((event?: ClickEvent) => {
        if (this.selectedVideo !== '') {
          return;
        }
        this.maskShow = true;
        this.selectedVideo = this.moment.media; // 将选中视频名称赋值给@Link selectedVideo，以便传到自定义组件XVideoComponent内
        if (event) {
          this.videoLocation = event.target.area; // 将选中视频位置信息赋值给@Link videoLocation，以便传到自定义组件XVideoComponent内
        }
      })

      Text(this.moment.text)
        .lineHeight($r('app.integer.media_full_screen_main_page_useName_line_height'))
        .fontFamily($r('app.string.media_full_screen_harmony_hei_ti'))
        .fontWeight(FontWeight.Medium)
        .fontSize($r('app.integer.media_full_screen_main_page_userText_fontSize'))
        .fontColor($r('app.color.media_full_screen_title_font_color'))
        .padding($r('app.integer.media_full_screen_main_page_row_padding_left'))
      Row() {
        Image($r(`app.media.${this.moment.user.userImage}`))
          .autoResize(false)
          .width($r('app.integer.media_full_screen_main_page_user_image_width'))
          .height($r('app.integer.media_full_screen_main_page_user_image_height'))
          .borderRadius($r('app.integer.media_full_screen_main_page_user_image_border_radius'))
        Text(this.moment.user.userName)
          .fontSize($r('app.integer.media_full_screen_main_page_useName_fontSize'))
          .fontColor($r('app.color.media_full_screen_title_font_color'))
          .lineHeight($r('app.integer.media_full_screen_main_page_userText_line_height'))
          .fontFamily($r('app.string.media_full_screen_harmony_hei_ti'))
          .margin({ left: $r('app.integer.media_full_screen_main_page_user_col_margin_left') })
          .layoutWeight(LAYOUT_WEIGHT)
      }
      .padding({
        left: $r('app.integer.media_full_screen_main_page_row_padding_left'),
        right: $r('app.integer.media_full_screen_main_page_row_padding_right'),
        top: $r('app.integer.media_full_screen_main_page_row_padding_top'),
        bottom: $r('app.integer.media_full_screen_main_page_row_padding_bottom')
      })
    }
    .shadow({ radius: $r('app.integer.media_full_screen_stack_shadow_radius'), color: Color.Gray })
    .border({ radius: $r('app.integer.media_full_screen_main_page_row_padding_left') })
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
  }
}