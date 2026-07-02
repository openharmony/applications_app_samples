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
  videoSrc: Resource;
  previewUri: Resource;
  curRate: PlaybackSpeed;
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
struct SmartLifeComponent {
  // 在组件类中添加防抖变量
  private lastHoverTime: number = 0;
  private readonly HOVER_DEBOUNCE_TIME = 1000; // 1000ms内不重复触发
  @StorageLink('BeforeIndex') beforeFocusIndex: number = -1;
  @State scale1: number = 1;
  @State opacity1: number = 1;
  @State focusId: number = 0;
  @State currentIndex: number = -1;
  @State ifPrepared: boolean = false;
  @State isOn: boolean = false;
  controller: VideoController = new VideoController();
  @State isFocus: boolean = true;
  @State isRouter: boolean = false;
  private swiperController: SwiperController = new SwiperController();
  @State currentImageIndex: number = 0;
  @State videoSrcList: Resource[] = [
    $rawfile('videoTest.mp4'),
    $rawfile('videoTest.mp4'),
    $rawfile('videoTest.mp4')
  ];
  @State previewUriList: Resource[] = [
    $r('app.media.cat'),
    $r('app.media.cat'),
    $r('app.media.cat')
  ];
  @State curRateList: PlaybackSpeed[] = [
    PlaybackSpeed.Speed_Forward_1_00_X,
    PlaybackSpeed.Speed_Forward_1_00_X,
    PlaybackSpeed.Speed_Forward_1_00_X
  ];
  // 影音娱乐
  mediaList1: ContentList = {
    label: $r('app.string.media_label_1'),
    content: $r('app.string.media_content_1')
  };
  mediaList2: ContentList = {
    label: $r('app.string.media_label_2'),
    content: $r('app.string.media_content_2')
  };
  mediaList3: ContentList = {
    label: $r('app.string.media_label_3'),
    content: $r('app.string.media_content_3')
  };
  // 儿童关怀
  ChildCareContentList1: ContentList = {
    label: $r('app.string.childcare_label_1'),
    content: $r('app.string.childcare_content_1')
  };
  ChildCareContentList2: ContentList = {
    label: $r('app.string.childcare_label_2'),
    content: $r('app.string.childcare_content_2')
  };
  // 高效办公
  officeList1: ContentList = {
    label: $r('app.string.office_label_1'),
    content: $r('app.string.office_content_1')
  };
  officeList2: ContentList = {
    label: $r('app.string.office_label_2'),
    content: $r('app.string.office_content_2')
  };
  officeList3: ContentList = {
    label: $r('app.string.office_label_3'),
    content: $r('app.string.office_content_3')
  };
  ContentList1: ContentList[] = [this.mediaList1, this.mediaList2, this.mediaList3];
  ContentList2: ContentList[] = [this.ChildCareContentList1, this.ChildCareContentList1];
  ContentList3: ContentList[] = [this.officeList1, this.officeList2, this.officeList3];
  private details: IDetails[] = [
    {
      videoSrc: $rawfile('videoTest.mp4'),
      previewUri: $r('app.media.cat'),
      curRate: PlaybackSpeed.Speed_Forward_1_00_X,
      imageResources: $r('app.media.cat'),
      title: $r('app.string.smartlife_entertainment_av'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList1
    },
    {
      videoSrc: $rawfile('videoTest.mp4'),
      previewUri: $r('app.media.cat'),
      curRate: PlaybackSpeed.Speed_Forward_1_00_X,
      imageResources: $r('app.media.cat'),
      title: $r('app.string.smartlife_child_care'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList2
    },
    {
      videoSrc: $rawfile('videoTest.mp4'),
      previewUri: $r('app.media.cat'),
      curRate: PlaybackSpeed.Speed_Forward_1_00_X,
      imageResources: $r('app.media.cat'),
      title: $r('app.string.smartlife_efficient_office'),
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList3
    }
  ];

  aboutToAppear(): void {
  }

  onPageShow(): void {
    // 页面跳转过来触发
    globalIdle.resetTimer();
    let routerIndex1 = router.getParams() as IRouter;
    // 用来轮播返回触发
    if (routerIndex1 === undefined) {
      // 轮播返回时先置为-1，后续再修改这个值才能刷新UI
      this.currentIndex = -1;
      this.swiperController.changeIndex(this.beforeFocusIndex);
      setTimeout(() => {
        // 一定要异步修改这个值才会刷新UI(由于是自动播放，返回后就会播放，如果要暂停加控制器就行)
        this.currentIndex = this.beforeFocusIndex;
      }, 100);
      setTimeout(() => {
        focusControl.requestFocus('SmartLifeComponent3' + this.beforeFocusIndex);
      }, 500);

    } else {
      if (routerIndex1.index >= 0) {
        this.isRouter = true;
        this.swiperController.changeIndex(routerIndex1.index);
        this.currentIndex = routerIndex1.index;
      }
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
            // 一定要加判断，不然页面跳转底层就黑的，不会刷新
            if (this.currentIndex === index) {
              Video({
                src: item.videoSrc,
                previewUri: item.previewUri,
                currentProgressRate: item.curRate,
                controller: this.controller
              })
                .onStart(() => {
                  globalIdle.stopDetect();
                  console.log('hsq onStart');
                  this.ifPrepared = true;
                })
                .onPause(() => {
                  globalIdle.startDetect();

                })
                .onFinish(() => {
                  globalIdle.startDetect();
                })
                .opacity(this.ifPrepared ? 1 : 0)
                .controls(false)
                .autoPlay(this.currentIndex === index ? true : false)
                .width('100%')
                .height('100%')
                .zIndex(1)
                .focusable(false);
            }
            Image(item.imageResources)
              .width('100%')
              .height('100%')
              .zIndex(0)
              .visibility(!this.ifPrepared ? Visibility.Visible : Visibility.Hidden);

            // 左边遮罩层
            Row() {
            }
            .width('50%')
            .height('100%')
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['rgba(0, 0, 0, 0.4)', 0.0], ['rgba(0, 0, 0, 0)', 1]]

            })
            .zIndex(2);

            // 左右跳转图片
            Row() {
              Image($r('app.media.swiper_arrow_left'))
                .width(this.focusId == 1 ? '45lpx' : '40lpx')
                .id('SmartLifeComponent1' + index)
                .onClick(() => {
                  globalIdle.resetTimer();
                  this.swiperController.showPrevious();
                })
                // 采用触摸事件  注释是因为只用点击事件

                .defaultFocus(false)
                .focusable(false)
                .visibility(index <= 0 ? Visibility.None : Visibility.Visible);
              // 占位
              Text('    ')
                .fontSize(16)
                .focusable(false);
              Image($r('app.media.swiper_arrow_right'))
                .id('SmartLifeComponent2' + index)
                .width(this.focusId == 2 ? '45lpx' : '40lpx')
                .onClick(() => {
                  globalIdle.resetTimer();
                  this.swiperController.showNext();
                })

                .focusable(false)
                .visibility(index >= this.details.length - 1 ? Visibility.None : Visibility.Visible);
            }
            .width('100%')
            .padding('12lpx')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .height('70lpx')
            .position({ top: '46%' })
            .zIndex(3);

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


                //            用来放置焦点
                Text('  ')
                  .textExtend(27, 500, 32)
                  .textAlign(TextAlign.Center)
                  .width('200lpx')
                  .height('60lpx')
                  .focusable(true)
                  .onAttach(() => {
                    if (this.isRouter) {
                      setTimeout(() => {
                        try {
                          focusControl.requestFocus('SmartLifeComponent3' + this.currentIndex);
                        } catch (e) {
                          console.debug('requestFocusSmartLifeComponent', JSON.stringify(e));
                        }
                      }, 100);
                    }
                  })
                  .onFocus(() => {
                    this.focusId = 0;
                  })
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.White
                      });
                    }
                  })
                  .defaultFocus(this.currentIndex == index)
                  .id('SmartLifeComponent3' + index);
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
            .alignItems(HorizontalAlign.Start)
            .zIndex(4);
          }
          .alignContent(Alignment.Start)
          .width('100%')
          .height('100%');

        }, (item: IDetails, index) => `${item.title} ${index}`);
      }
      .loop(false)
      .cachedCount(2)

      .onChange((index) => {
        this.currentIndex = index;
      })
      .onBlur(() => {
        AppStorage.setOrCreate('BeforeIndex', this.currentIndex);
      })
      .width('100%')
      .height('100%')
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

      .index(this.currentIndex)

      .duration(0) // 动画时长（ms）
      .curve(Curve.EaseInOut); // 缓动曲线
    }
    .onKeyEvent(() => {
      globalIdle.resetTimer();
    })
    .onHover(() => {
      globalIdle.resetTimer();
    })
    .width('100%')
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
