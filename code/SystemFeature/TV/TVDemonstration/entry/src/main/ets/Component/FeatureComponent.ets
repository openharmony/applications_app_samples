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

import { router } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { globalIdle } from '../utils/GlobalScreenSaver';

export interface ContentList {
  label: ResourceStr;
  content: ResourceStr;
}

export interface ExperienceList {
  packageName: string;
  classname: string;
}

interface IDetails {
  imageResources: ResourceStr;
  title: ResourceStr;
  maskVideoIntroduction: boolean;
  experienceAble: boolean;
  contentList: ContentList[];
}

interface IRouter {
  index: number;
}

@Entry
@Component
struct FeatureComponent {
  // 在组件类中添加防抖变量
  private lastHoverTime: number = 0;
  private readonly HOVER_DEBOUNCE_TIME = 1000; // 500ms内不重复触发
  @State isFocus: boolean = true;
  @State isRouter: boolean = false;
  private swiperController: SwiperController = new SwiperController();
  @State currentImageIndex: number = 0;
  // 通用互联
  interContentList1: ContentList = {
    label: $r('app.string.inter_label_1'),
    content: $r('app.string.inter_content_1')
  };
  interContentList2: ContentList = {
    label: $r('app.string.inter_label_2'),
    content: $r('app.string.inter_content_2')
  };
  interContentList3: ContentList = {
    label: $r('app.string.inter_label_3'),
    content: $r('app.string.inter_content_3')
  };
  // 投屏能力：Miracast、DLNA
  castList1: ContentList = {
    label: $r('app.string.cast_label_1'),
    content: $r('app.string.cast_content_1')
  };
  castList2: ContentList = {
    label: $r('app.string.cast_label_2'),
    content: $r('app.string.cast_content_2')
  };
  castList3: ContentList = {
    label: $r('app.string.cast_label_3'),
    content: $r('app.string.cast_content_3')
  };
  // 智能AI：DeepSeek
  aiList1: ContentList = {
    label: $r('app.string.ai_label_1'),
    content: $r('app.string.ai_content_1')
  };
  aiList2: ContentList = {
    label: $r('app.string.ai_label_2'),
    content: $r('app.string.ai_content_2')
  };
  aiList3: ContentList = {
    label: $r('app.string.ai_label_3'),
    content: $r('app.string.ai_content_3')
  };
  // 指向遥控
  pointingContentList1: ContentList = {
    label: $r('app.string.pointing_label_1'),
    content: $r('app.string.pointing_content_1')
  };
  pointingContentList2: ContentList = {
    label: $r('app.string.pointing_label_2'),
    content: $r('app.string.pointing_content_2')
  };
  pointingContentList3: ContentList = {
    label: $r('app.string.pointing_label_3'),
    content: $r('app.string.pointing_content_3')
  };
  // 智慧屏保
  screenSaverList1: ContentList = {
    label: $r('app.string.screensaver_label_1'),
    content: $r('app.string.screensaver_content_1')
  };
  screenSaverList2: ContentList = {
    label: $r('app.string.screensaver_label_2'),
    content: $r('app.string.screensaver_content_2')
  };
  screenSaverList3: ContentList = {
    label: $r('app.string.screensaver_label_3'),
    content: $r('app.string.screensaver_content_3')
  };
  // 语音交互
  voiceList1: ContentList = {
    label: $r('app.string.voice_label_1'),
    content: $r('app.string.voice_content_1')
  };
  voiceList2: ContentList = {
    label: $r('app.string.voice_label_2'),
    content: $r('app.string.voice_content_2')
  };
  voiceList3: ContentList = {
    label: $r('app.string.voice_label_3'),
    content: $r('app.string.voice_content_3')
  };
  // 分布式能力：白板、图库、相机
  distributedList1: ContentList = {
    label: $r('app.string.distributed_label_1'),
    content: $r('app.string.distributed_content_1')
  };
  distributedList2: ContentList = {
    label: $r('app.string.distributed_label_2'),
    content: $r('app.string.distributed_content_2')
  };
  distributedList3: ContentList = {
    label: $r('app.string.distributed_label_3'),
    content: $r('app.string.distributed_content_3')
  };
  ContentList1: ContentList[] = [this.interContentList1, this.interContentList2, this.interContentList3];
  ContentList2: ContentList[] = [this.castList1, this.castList2, this.castList3];
  ContentList3: ContentList[] = [this.aiList1, this.aiList2, this.aiList3];
  ContentList4: ContentList[] = [this.pointingContentList1, this.pointingContentList2, this.pointingContentList3];
  ContentList5: ContentList[] = [this.screenSaverList1, this.screenSaverList2, this.screenSaverList3];
  ContentList6: ContentList[] = [this.voiceList1, this.voiceList2, this.voiceList3];
  ContentList7: ContentList[] = [this.distributedList1, this.distributedList2, this.distributedList3];
  private details: IDetails[] = [
    {
      imageResources: $r('app.media.UniversalInterconnection'),
      title: $r('app.string.feature_universal_interconnection'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList1
    },
    {
      imageResources: $r('app.media.Cast'),
      title: $r('app.string.feature_screen_cast'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList2
    },
    {
      imageResources: $r('app.media.AI'),
      title: $r('app.string.feature_smart_ai'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList3
    },
    {
      imageResources: $r('app.media.PointingRemoteControl'),
      title: $r('app.string.feature_pointing_remote'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList4
    },
    {
      imageResources: $r('app.media.ScreenSaver'),
      title: $r('app.string.feature_smart_screensaver'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList5
    },
    {
      imageResources: $r('app.media.Voice'),
      title: $r('app.string.feature_voice_interaction'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList6
    },
    {
      imageResources: $r('app.media.Distributed'),
      title: $r('app.string.feature_distributed'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList7
    }

  ];
  @State scale1: number = 1;
  @State opacity1: number = 1;
  @State focusId: number = 0;
  @State routerIndex: IRouter | undefined = undefined;

  aboutToAppear(): void {

  }

  onPageShow(): void {
    globalIdle.startDetect();
    this.routerIndex = router.getParams() as IRouter;
    if (this.routerIndex !== undefined) {
      this.currentImageIndex = this.routerIndex.index;
      this.isRouter = true;
      setTimeout(() => {
        this.swiperController.changeIndex(this.routerIndex!.index);
        console.log('hsq+++1', this.routerIndex!.index);
      }, 100);

    }

  }

  onPageHide(): void {
    globalIdle.stopDetect();
    this.isRouter = false;
  }

  build() {
    Stack() {
      Swiper(this.swiperController) {
        ForEach(this.details, (item: IDetails, index: number) => {
          Stack() {
            Image(item.imageResources)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Fill);
            // 左边遮罩层
            Row() {
            }
            .width('50%')
            .height('100%')
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['rgba(0, 0, 0, 0.2)', 0.0], ['rgba(0, 0, 0, 0.2)', 0.3],
                ['rgba(0, 0, 0, 0.2)', 0.5], ['rgba(0, 0, 0, 0)', 1]]
            });

            // 左右跳转图片
            Row() {
              Image($r('app.media.swiper_arrow_left'))
                .width(this.focusId == 1 ? '45lpx' : '40lpx')
                .id('FeatureComponent1' + index)
                .onClick(() => {
                  globalIdle.resetTimer();
                  this.swiperController.showPrevious();
                })
                .focusable(false)
                .onFocus(() => {
                  this.focusId = 1;
                })
                .onHover((isHover: boolean) => {
                  if (isHover) {
                    const currentTime = Date.now();
                    if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                      this.focusId = 1;
                      this.lastHoverTime = currentTime;
                    }
                  }
                })
                .visibility(index <= 0 ? Visibility.None : Visibility.Visible)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.White
                    });
                  }
                });
              // 占位放置焦点
              Text('   ')
                .fontSize(16)
                .focusable(true)
                .defaultFocus(this.currentImageIndex == index)
                .id('FeatureComponent0' + index)
                .onAttach(() => {
                  if (this.isRouter) {
                    setTimeout(() => {
                      try {
                        focusControl.requestFocus('FeatureComponent0' + this.routerIndex!.index);
                      } catch (e) {
                        console.debug('hsqrequestFocusFeatureComponent', JSON.stringify(e));
                      }
                    }, 100);
                  }
                })
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.White
                    });
                  }
                });
              Image($r('app.media.swiper_arrow_right'))
                .id('FeatureComponent2' + index)
                .width(this.focusId == 2 ? '45lpx' : '40lpx')
                .onClick(() => {
                  globalIdle.resetTimer();
                  this.swiperController.showNext();
                })
                .onHover((isHover: boolean) => {
                  if (isHover) {
                    const currentTime = Date.now();
                    if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                      this.focusId = 2;
                      this.lastHoverTime = currentTime;
                    }
                  }
                })
                .focusable(false)
                .visibility(index >= this.details.length - 1 ? Visibility.None : Visibility.Visible)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.White
                    });
                  }
                });
            }
            .width('100%')
            .padding('12lpx')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .height('70lpx')
            .position({ top: '46%' });

            // 文本区域
            Column() {
              // 总标题
              Text(item.title).textExtend(48, 700, 58)
                .margin({ bottom: '50lpx' });
              ForEach(item.contentList, (item1: ContentList, index1: number) => {
                Text(item1.label).textExtend(28, 400, 33)
                  .margin({ bottom: '12lpx' });
                Text(item1.content).textExtend(22, 400, 26)
                  .margin({ bottom: '36lpx' });
              });
              Column({ space: '20lpx' }) {
                // 没有视频资源，先屏蔽入口
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .margin({ bottom: '116lpx' })
              .justifyContent(FlexAlign.End)
              .layoutWeight(1);

            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .margin({ left: 196 + 'lpx', top: 97 + 'lpx' })
            .width('40%')
            .alignItems(HorizontalAlign.Start);

          }
          .alignContent(Alignment.Start)
          .width('100%')
          .height('100%');

        });
      }
      .onChange((index) => {
        this.currentImageIndex = index;
      })

      .loop(false)
      .onHover(() => {
        globalIdle.resetTimer();
      })
      .onKeyEvent(() => {
        globalIdle.resetTimer();
      })

      .indicator( // 设置圆点导航点样式
        new DotIndicator()
          .itemWidth('10lpx')
          .itemHeight('10lpx')
          .selectedItemWidth('16lpx')
          .selectedItemHeight('10lpx')
          .color('rgba(241, 243, 245, 0.2)')
          .selectedColor(Color.White)
          .bottom('40lpx')
      )

      .curve(Curve.Linear);
    }.width('100%')

    .height('100%');

  }
}


@Extend(Text)
function textExtend(size: number, fontWeight: number, lineHeight: number) {
  .fontColor('rgba(255,255,255,0.9)')
  .fontSize(size + 'lpx')

  .width('100%')
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .fontWeight(fontWeight)
  .lineHeight(lineHeight + 'lpx')
  .letterSpacing(0)
  .textAlign(TextAlign.Start);
}

