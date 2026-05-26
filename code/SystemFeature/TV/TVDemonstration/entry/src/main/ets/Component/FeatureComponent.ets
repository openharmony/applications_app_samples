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
  imageResources: ResourceStr;
  title: string;
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
    label: '多端无缝连接，设备协同无界',
    content: '电视支持手机、电脑、智能家居等多设备跨品牌互联，无需繁琐配对，靠近即可快速连接。手机视频一键投屏至电视，电脑文档同步显示办公，智能家居状态在电视屏幕集中呈现，让各类设备融为一体，操作更便捷，体验更连贯。'
  };
  interContentList2: ContentList = {
    label: '数据流转自如，内容随心切换',
    content: '实现跨设备数据实时共享与接续，手机上未看完的剧集，投屏到电视可续播；电视上浏览的图片，能同步保存至手机。文件传输无需依赖第三方软件，拖拽即可完成，让内容在不同设备间自由流转，满足用户多场景使用需求。'
  };
  interContentList3: ContentList = {
    label: '场景生态拓展，智慧体验升级',
    content: '基于通用互联能力，电视可作为智慧家庭控制中枢，联动灯光、窗帘、空调等设备实现场景化控制；也能对接教育、健身等应用，将手机端课程同步至电视大屏学习。从娱乐到生活再到办公，全方位拓展场景生态，升级智慧生活体验。'
  };
  // 投屏能力：Miracast、DLNA
  castList1: ContentList = {
    label: 'Miracast投屏，镜像丝滑流畅',
    content: '基于Miracast协议，手机、电脑屏幕实时镜像至电视。游戏激战、办公演示无延迟，点对点直连不依赖网络，郊游露营也能将手机电影投到大屏，与好友共享露天影院。'
  };
  castList2: ContentList = {
    label: 'DLNA投屏，内容直接推送',
    content: '支持DLNA多媒体共享，将视频App中的电影、本地音乐直接“推送”至电视播放。推送后手机可独立操作，打电话、回消息均不影响电视播放，追剧听歌互不干扰。'
  };
  castList3: ContentList = {
    label: '全协议覆盖，投屏随心所欲',
    content: 'Miracast与DLNA两大主流投屏协议互补，满足不同场景需求。无论是镜像游戏、推送视频，还是分享照片，都能找到最适合的投屏方式，让内容轻松上大屏。'
  };
  // 智能AI：DeepSeek
  aiList1: ContentList = {
    label: '知识百科，有问必答',
    content: '内置DeepSeek大模型，电视变身家庭知识库。孩子问“为什么天是蓝的？”，老人想了解养生知识，只需对着遥控器说出问题，电视便深度理解、给出详尽解答，满足全家人的好奇心。'
  };
  aiList2: ContentList = {
    label: '文档助手，摘要生成一键搞定',
    content: '将工作文档、学习资料上传至电视，DeepSeek AI自动提炼核心摘要，生成思维导图或PPT大纲。甚至能帮你润色邮件、撰写周报，让繁琐的文字工作变得轻松高效，电视也能成为生产力工具。'
  };
  aiList3: ContentList = {
    label: '生活管家，规划你的日常',
    content: '从“周末家庭聚餐食谱”到“三天两夜亲子游路线”，DeepSeek AI结合你的偏好，定制个性化方案。还能根据冰箱剩余食材推荐菜谱，根据天气提醒增减衣物，让电视为你打理生活琐事。'
  };
  // 指向遥控
  pointingContentList1: ContentList = {
    label: '精准指向操控，效率翻倍',
    content: '告别传统遥控器逐行移动光标的繁琐，指向遥控器只需对准电视屏幕目标区域，即可实现“指哪选哪”的精准操控。无论是切换频道、打开应用还是选中菜单选项，都能瞬间响应，大幅减少操作步骤，让电视交互更高效便捷。'
  };
  pointingContentList2: ContentList = {
    label: '极简交互逻辑，上手零门槛',
    content: '无需记忆复杂按键组合，指向+确认两步就能完成绝大多数操作。老人、小孩都能快速掌握使用方法，避免因操作复杂导致的使用困扰。简洁的按键布局搭配直观的指向功能，让全家成员都能轻松享受电视娱乐，无需额外学习成本。'
  };
  pointingContentList3: ContentList = {
    label: '远距离稳定响应，无死角覆盖',
    content: '具备超强信号接收能力，有效操控距离可达8米，且支持广角度信号覆盖。即使在客厅角落、沙发另一侧等位置，也能稳定控制电视，不会出现信号中断或操控延迟的情况。无论是家庭聚会多人共用，还是日常远距离操控，都能保持流畅体验。'
  };
  // 智慧屏保
  screenSaverList1: ContentList = {
    label: '名画轮播，每日艺术熏陶',
    content: '电视待机时，自动切换梵高的《向日葵》、莫奈的《睡莲》等世界名画，搭配优雅边框和舒缓音乐，让客厅秒变私人美术馆。支持设定画派偏好，每天推陈出新，提升家居格调。'
  };
  screenSaverList2: ContentList = {
    label: '家庭时光机，回忆常伴左右',
    content: '将分布式图库中的家庭照片设为屏保，电视待机便自动播放孩子的成长相册、父母的旅行留影。每张照片标注时间地点，仿佛一部家庭纪录片，让温馨回忆随时浮现。'
  };
  screenSaverList3: ContentList = {
    label: '信息看板，实用与美学兼具',
    content: '智慧屏保可自定义显示时间、天气、日程提醒等实用信息。简约时钟、渐变色背景，信息一目了然却不打扰。早上出门前瞥一眼天气，晚上回家看看明日安排，电视待机也能成为生活信息中心。'
  };
  // 语音交互
  voiceList1: ContentList = {
    label: '全时唤醒，随时待命',
    content: '无需反复说出唤醒词，一次唤醒即可连续对话。“播放周杰伦的歌”，“下一首”，“音量调到50%”，电视准确理解上下文，一一执行。交流如真人般自然顺畅，彻底解放双手。'
  };
  voiceList2: ContentList = {
    label: '方言识别，沟通零障碍',
    content: '支持四川话、粤语、上海话等多种方言识别，老人小孩都能轻松使用。姥姥用方言说“我想看京剧”，电视立刻调出戏曲频道；孩子奶声奶气说“我要看佩奇”，动画片即刻播放。'
  };
  voiceList3: ContentList = {
    label: '智能家居中枢，一句话控全屋',
    content: '通过电视语音控制接入生态的灯光、空调、窗帘等设备。说“我要看电影”，电视自动调暗灯光、关闭窗帘、开启影院模式。语音交互让智慧家庭真正懂你，一句话掌控全屋。'
  };
  // 分布式能力：白板、图库、相机
  distributedList1: ContentList = {
    label: '分布式白板，灵感跨端挥洒',
    content: '分布式白板打破设备孤岛，支持手机、平板、电脑多人同时接入。家庭聚会时一起绘制贺卡，工作会议中同步批注方案草图。笔迹、图形实时流转，每个人都能看见彼此的修改，如同共处一室挥洒创意，让协作效率倍增。'
  };
  distributedList2: ContentList = {
    label: '分布式图库，回忆自动汇聚',
    content: '开启分布式图库，家人手机中的照片自动同步至电视家庭相册。孩子的成长点滴、父母的旅行足迹，无需手动传输，所有设备拍摄的美好瞬间都会按时间地点智能归类。茶余饭后，全家围坐大屏前，一起重温那些温馨时刻。'
  };
  distributedList3: ContentList = {
    label: '分布式相机，视界多维延伸',
    content: '视频通话时可调用手机摄像头，让远方父母看清孩子的涂鸦；居家健身时连接智能摄像头，AI实时捕捉动作并进行矫正。分布式相机让电视调用其他设备的镜头，解锁更多智慧生活新可能。'
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
      title: '通用互联',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList1
    },
    {
      imageResources: $r('app.media.Cast'),
      title: '投屏',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList2
    },
    {
      imageResources: $r('app.media.AI'),
      title: '智能AI',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList3
    },
    {
      imageResources: $r('app.media.PointingRemoteControl'),
      title: '指向遥控',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList4
    },
    {
      imageResources: $r('app.media.ScreenSaver'),
      title: '智慧屏保',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList5
    },
    {
      imageResources: $r('app.media.Voice'),
      title: '语音交互',
      maskVideoIntroduction: true,
      experienceAble: true,
      contentList: this.ContentList6
    },
    {
      imageResources: $r('app.media.Distributed'),
      title: '分布式',
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

