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
  label: string;
  content: string;
}

export interface ExperienceList {
  packageName: string;
  classname: string;
}

interface IDetails {
  videoSrc: Resource
  previewUri: Resource
  curRate: PlaybackSpeed
  imageResources: ResourceStr
  title: string;
  maskVideoIntroduction: boolean;
  experienceAble: boolean;
  contentList: ContentList[];
}

interface IRouter {
  index: number
}

@Entry
@Component
struct SmartLifeComponent {
  // 在组件类中添加防抖变量
  private lastHoverTime: number = 0
  private readonly HOVER_DEBOUNCE_TIME = 1000 // 1000ms内不重复触发
  @StorageLink('BeforeIndex') beforeFocusIndex: number = -1
  @State scale1: number = 1;
  @State opacity1: number = 1;
  @State focusId: number = 0
  @State currentIndex: number = -1
  @State ifPrepared: boolean = false
  @State isOn: boolean = false
  controller: VideoController = new VideoController()
  @State isFocus: boolean = true;
  @State isRouter: boolean = false
  private swiperController: SwiperController = new SwiperController();
  @State currentImageIndex: number = 0
  @State videoSrcList: Resource[] = [
    $rawfile('videoTest.mp4'),
    $rawfile('videoTest.mp4'),
    $rawfile('videoTest.mp4')
  ]
  @State previewUriList: Resource[] = [
    $r('app.media.cat'),
    $r('app.media.cat'),
    $r('app.media.cat')
  ]
  @State curRateList: PlaybackSpeed[] = [
    PlaybackSpeed.Speed_Forward_1_00_X,
    PlaybackSpeed.Speed_Forward_1_00_X,
    PlaybackSpeed.Speed_Forward_1_00_X
  ]
  // 影音娱乐
  mediaList1: ContentList = {
    label: '沉浸式视听，客厅变身私人影院',
    content: '搭载4K超高清画质引擎与影院级音效系统，让每一次观影都身临其境。暗场细节层次分明，亮部色彩鲜活通透，配合杜比全景声的立体环绕音效，无论是科幻大片的宇宙激战，还是文艺电影的雨滴落地，都能精准还原导演镜头下的每一个情绪细节。关灯，打开电视，客厅即刻升级为专属家庭影院。'
  }
  mediaList2: ContentList = {
    label: '海量内容聚合，全家人各有所爱',
    content: '整合主流视频平台资源，电影、电视剧、综艺、纪录片、少儿动漫一站式配齐。基于家庭成员的观看习惯，智能推荐算法为每个人定制专属内容页。爸妈追的年代剧、孩子看的启蒙动画、你想补档的经典老片，打开电视就能找到，不再为遥控器争夺发愁，让全家人的闲暇时光各得其所。'
  }
  mediaList3: ContentList = {
    label: 'K歌娱乐升级，聚会氛围随时点燃',
    content: '内置专业卡拉OK系统，海量正版伴奏曲库持续更新，从经典老歌到抖音热曲一应俱全。支持双麦克风连接，智能评分、混响调节、一键消原唱等功能，让家庭聚会瞬间升温。朋友来做客、家人过生日，不用转场KTV，在客厅就能尽情欢唱，把每一次团聚都变成难忘的欢乐派对。'
  }
  // 儿童关怀
  ChildCareContentList1: ContentList = {
    label: '健康用眼守护，平衡娱乐与健康',
    content: '具备距离感应与时长管控功能，孩子离屏幕过近时自动弹窗提醒并降低亮度，累计观看达到设定时长后，电视会温和提示休息并锁定画面。同时支持蓝光过滤模式，减少屏幕蓝光对孩子视力的伤害，从用眼距离、时间、光线三方面守护，让孩子健康享受观影时光。'
  }
  ChildCareContentList2: ContentList = {
    label: '互动成长引导，边玩边学更高效',
    content: '融合互动式教育内容，如语音问答、动画绘本、益智游戏等，将知识融入趣味互动中，激发孩子学习兴趣。家长可通过手机端查看孩子的观看与学习记录，了解兴趣偏好与成长进度，还能推送定制化教育内容，让电视从娱乐工具转变为助力孩子成长的智能伙伴'
  }
  // 高效办公
  officeList1: ContentList = {
    label: '大屏文档处理，视野更开阔',
    content: '将笔记本电脑的文档、表格、演示文稿一键投射至电视大屏，告别长时间低头伏案的疲惫。4K超清画质让文字锐利清晰，数据图表细节分毫毕现。无论是审阅百页报告、校对复杂报表，还是修改设计稿，大屏呈现让信息一目了然，办公效率倍增。'
  }
  officeList2: ContentList = {
    label: '无线投屏演示，会议更流畅',
    content: '支持Miracast、DLNA等多种无线投屏协议，无需繁琐接线，会议开始前即可快速将方案投射至电视。演讲者在会议室自由走动，用指向遥控翻页批注，重点内容实时圈画。客户到访或团队讨论，无需围挤在小屏幕前，让每一次演示都从容自信。'
  }
  officeList3: ContentList = {
    label: '分屏协作模式，多任务并行',
    content: '电视支持分屏显示功能，一边开启视频会议，一边展示相关文档资料。远程沟通时，对方画面与讨论内容同屏呈现，无需频繁切换窗口。团队成员可同时接入，共享屏幕、共同批注，异地协作如同面对面，让办公突破空间限制。'
  }
  ContentList1: ContentList[] = [this.mediaList1, this.mediaList2, this.mediaList3]
  ContentList2: ContentList[] = [this.ChildCareContentList1, this.ChildCareContentList1]
  ContentList3: ContentList[] = [this.officeList1, this.officeList2, this.officeList3]
  private details: IDetails[] = [
    {
      videoSrc: $rawfile('videoTest.mp4'),
      previewUri: $r('app.media.cat'),
      curRate: PlaybackSpeed.Speed_Forward_1_00_X,
      imageResources: $r('app.media.cat'),
      title: '娱乐影音',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList1
    },
    {
      videoSrc: $rawfile('videoTest.mp4'),
      previewUri: $r('app.media.cat'),
      curRate: PlaybackSpeed.Speed_Forward_1_00_X,
      imageResources: $r('app.media.cat'),
      title: '儿童关怀',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList2
    },
    {
      videoSrc: $rawfile('videoTest.mp4'),
      previewUri: $r('app.media.cat'),
      curRate: PlaybackSpeed.Speed_Forward_1_00_X,
      imageResources: $r('app.media.cat'),
      title: '高效办公',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList3
    }
  ]

  aboutToAppear(): void {
  }

  onPageShow(): void {
    // 页面跳转过来触发
    globalIdle.resetTimer();
    let routerIndex1 = router.getParams() as IRouter;
    // 用来轮播返回触发
    if (routerIndex1 === undefined) {
      // 轮播返回时先置为-1，后续再修改这个值才能刷新UI
      this.currentIndex = -1
      this.swiperController.changeIndex(this.beforeFocusIndex)
      setTimeout(() => {
        // 一定要异步修改这个值才会刷新UI(由于是自动播放，返回后就会播放，如果要暂停加控制器就行)
        this.currentIndex = this.beforeFocusIndex
      }, 100)
      setTimeout(() => {
        focusControl.requestFocus('SmartLifeComponent3' + this.beforeFocusIndex)
      }, 500)

    } else {
      if (routerIndex1.index >= 0) {
        this.isRouter = true
        this.swiperController.changeIndex(routerIndex1.index)
        this.currentIndex = routerIndex1.index
      }
    }
  }

  onPageHide(): void {
    globalIdle.stopDetect()
    this.isRouter = false
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
                  globalIdle.stopDetect()
                  console.log('hsq onStart')
                  this.ifPrepared = true
                })
                .onPause(() => {
                  globalIdle.startDetect()

                })
                .onFinish(() => {
                  globalIdle.startDetect()
                })
                .opacity(this.ifPrepared ? 1 : 0)
                .controls(false)
                .autoPlay(this.currentIndex === index ? true : false)
                .width('100%')
                .height('100%')
                .zIndex(1)
                .focusable(false)
            }
            Image(item.imageResources)
              .width('100%')
              .height('100%')
              .zIndex(0)
              .visibility(!this.ifPrepared ? Visibility.Visible : Visibility.Hidden)

            // 左边遮罩层
            Row() {
            }
            .width('50%')
            .height('100%')
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['rgba(0, 0, 0, 0.4)', 0.0], ['rgba(0, 0, 0, 0)', 1]]

            })
            .zIndex(2)

            // 左右跳转图片
            Row() {
              Image($r('app.media.swiper_arrow_left'))
                .width(this.focusId == 1 ? '45lpx' : '40lpx')
                .id('SmartLifeComponent1' + index)
                .onClick(() => {
                  globalIdle.resetTimer()
                  this.swiperController.showPrevious()
                })
                // 采用触摸事件  注释是因为只用点击事件
                /*      .onHover((isHover: boolean) => {
                        if (isHover) {
                          const currentTime = Date.now()
                          if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                            this.focusId = 1
                            this.swiperController.showPrevious()
                            this.lastHoverTime = currentTime
                          }
                        }
                      })*/
                .defaultFocus(false)
                .focusable(false)
                .visibility(index <= 0 ? Visibility.None : Visibility.Visible)
              // 占位
              Text('    ')
                .fontSize(16)
                .focusable(false)
              Image($r('app.media.swiper_arrow_right'))
                .id('SmartLifeComponent2' + index)
                .width(this.focusId == 2 ? '45lpx' : '40lpx')
                .onClick(() => {
                  globalIdle.resetTimer()
                  this.swiperController.showNext()
                })
                /*.onHover((isHover: boolean) => {
                  if (isHover) {
                    const currentTime = Date.now()
                    if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                      this.focusId = 2
                      this.swiperController.showNext()
                      this.lastHoverTime = currentTime
                    }
                  }
                })*/
                .focusable(false)
                .visibility(index >= this.details.length - 1 ? Visibility.None : Visibility.Visible)
            }
            .width('100%')
            .padding('12lpx')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .height('70lpx')
            .position({ top: '46%' })
            .zIndex(3)

            // 文本区域
            Column() {
              // 总标题
              Text(item.title).textExtend(48, 700, 58)
                .margin({ bottom: '50lpx' })
              ForEach(item.contentList, (item1: ContentList, index1: number) => {
                Text(item1.label).textExtend(28, 400, 33)
                  .margin({ bottom: '12lpx' })
                Text(item1.content).textExtend(22, 400, 26)
                  .margin({ bottom: '36lpx' })
              })

              Column({ space: '20lpx' }) {
                // if (item.experienceAble) {
                /*
                                Row({ space: '16lpx' }) {
                                  Text('视频播放')
                                    .textExtend(27, 500, 32)
                                    .textAlign(TextAlign.Center)
                                    .fontColor('rgba(0,0,0,0.86')
                                    .width('200lpx')
                                    .height('60lpx')
                                    .borderRadius('30lpx')
                                    .backgroundColor('#dde0e3')
                                    .focusable(true)
                                    .id('SmartLifeComponent0' + index)
                                    .onFocus(() => {
                                      this.focusId = 0
                                    })
                                    */
                /*        .onKeyEvent((e) => {
                                              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                                                focusControl.requestFocus('SmartLifeComponent1' + index)
                                              }
                                            })*/
                /*
                                   .stateStyles({
                                     focused: {
                                       .border({
                                         color: Color.White
                                       })
                                     }
                                   })
                                   .defaultFocus(true)
                                   .onClick(() => {
                                     globalIdle.resetTimer()
                                     router.pushUrl({
                                       url: 'Video/VideoPage',
                                     })
                                   })
                               }
                               .padding('2lpx')
                               .border({
                                 width: this.focusId == 0 ? '2lpx' : 0,
                                 color: Color.White,
                                 radius: '34lpx'
                               })*/
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
                          focusControl.requestFocus('SmartLifeComponent3' + this.currentIndex)
                        } catch (e) {
                          console.debug('requestFocusSmartLifeComponent', JSON.stringify(e))
                        }
                      }, 100)
                    }
                  })
                  .onFocus(() => {
                    this.focusId = 0
                  })
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.White
                      })
                    }
                  })
                  .defaultFocus(this.currentIndex == index)
                  .id('SmartLifeComponent3' + index)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .margin({ bottom: '116lpx' })
              .justifyContent(FlexAlign.End)
              .layoutWeight(1)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .margin({ left: 196 + 'lpx', top: 97 + 'lpx' })
            .width('40%')
            .alignItems(HorizontalAlign.Start)
            .zIndex(4)
          }
          .alignContent(Alignment.Start)
          .width('100%')
          .height('100%')

        }, (item: IDetails, index) => item.title + index)
      }
      .loop(false)
      .cachedCount(2)

      .onChange((index) => {
        this.currentIndex = index
      })
      .onBlur(() => {
        AppStorage.setOrCreate('BeforeIndex', this.currentIndex)
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
          // .maxDisplayCount(9))
          .bottom('40lpx')
      )

      .index(this.currentIndex)

      .duration(0) // 动画时长（ms）
      .curve(Curve.EaseInOut) // 缓动曲线
    }
    .onKeyEvent(() => {
      globalIdle.resetTimer()
    })
    .onHover(() => {
      globalIdle.resetTimer()
    })
    .width('100%')
    .height('100%')

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
  .textAlign(TextAlign.Start)
}
