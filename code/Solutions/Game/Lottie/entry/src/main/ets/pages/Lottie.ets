/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

/*
 * Copyright (C) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the MIT License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://mit-license.org/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lottie from '@ohos/lottieETS'
import Logger from '../util/Logger'

const TAG: string = 'Lottie'
const SELECT_OPACITY: number = 0.5
const BUTTON_OPACITY: number = 0.8

@Entry
@Component
struct Lottie {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private settingsYear: RenderingContextSettings = new RenderingContextSettings(true)
  private contextYear: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settingsYear)
  private scroller: Scroller = new Scroller()
  private animateItem: any = null
  private animateName: string = 'grunt'
  private animationResources: string | Resource = $r('app.string.select_please')
  private controller: TabsController = new TabsController()
  @State valueS: AnimationStatus = AnimationStatus.Initial
  @State imagePath: Resource = $r('app.media.play')
  @State isPlaying: boolean = true

  callbackItem() {
    Logger.info(TAG, 'grunt loopComplete')
  }

  build() {
    Column() {
      Canvas(this.context)
        .width('540px')
        .height('360px')
        .backgroundColor(Color.Gray)
        .onDisAppear(() => {
          lottie.destroy(this.animateName)
        })
        .margin({ top: 10 })

      Canvas(this.contextYear)
        .width('540px')
        .height('360px')
        .backgroundColor(Color.Gray)
        .onReady(() => {
          let animation = lottie.loadAnimation({
            container: this.contextYear,
            renderer: 'canvas',
            loop: true,
            autoplay: true,
            name: 'year',
            path: 'common/lottie/data.json',
          })
          animation.addEventListener('loopComplete', this.callbackItem)
        })
        .onDisAppear(() => {
          lottie.destroy('year')
        })
        .margin({ bottom: 10 })

      Scroll(this.scroller) {
        Column() {
          Row() {
            Animator('__lottie_ets')

            Text($r('app.string.select'))
              .fontSize(16)
              .fontColor($r('app.color.font_color'))
              .fontWeight(FontWeight.Medium)
              .opacity(SELECT_OPACITY)

            Column() {
              Text(this.animationResources)
                .fontSize(16)
                .fontColor($r('app.color.font_color'))
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
            }
            .key('selectAnimationBtn')
            .bindMenu([
              {
                value: 'grunt动画',
                action: () => {
                  this.animateItem = lottie.loadAnimation({
                    container: this.context,
                    renderer: 'canvas',
                    loop: true,
                    autoplay: true,
                    name: this.animateName,
                    path: 'common/lottie/grunt.json',
                  })
                  this.animationResources = 'grunt'
                }
              },
              {
                value: 'year动画',
                action: () => {
                  lottie.loadAnimation({
                    container: this.contextYear,
                    renderer: 'canvas',
                    loop: true,
                    autoplay: true,
                    name: 'year',
                    path: 'common/lottie/data.json',
                  })
                  this.animationResources = 'year'
                }
              },
            ])
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor('#FFFFFF')
          .padding(10)
          .borderRadius(24)
          .margin({ bottom: 8 })

          Column() {
            Row() {
              Column() {
                Image($r('app.media.suspend'))
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    this.isPlaying = !this.isPlaying
                    lottie.togglePause()
                    if (!this.isPlaying) {
                      this.imagePath = $r('app.media.suspend')
                    } else {
                      this.imagePath = $r('app.media.play')
                    }
                  })

                Text($r('app.string.play_pause'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')

              Column() {
                Image($r('app.media.stop_playing'))
                  .objectFit(ImageFit.Cover)
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    lottie.stop()
                    this.isPlaying = false
                  })

                Text($r('app.string.stop'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')

              Column() {
                Image($r('app.media.pause'))
                  .objectFit(ImageFit.Cover)
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    lottie.pause()
                    this.isPlaying = false
                  })

                Text($r('app.string.pause'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')

              Column() {
                Image($r('app.media.start'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Fill)
                  .onClick(() => {
                    lottie.play()
                    this.isPlaying = true
                  })

                Text($r('app.string.start_play'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')
            }

            Row() {
              Column() {
                Image($r('app.media.speed'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Fill)
                  .bindMenu([
                    {
                      value: '×1',
                      action: () => {
                        lottie.setSpeed(1)
                      }
                    },
                    {
                      value: '×2',
                      action: () => {
                        lottie.setSpeed(2)
                      }
                    },
                    {
                      value: '×3',
                      action: () => {
                        lottie.setSpeed(5)
                      }
                    }
                  ])

                Text($r('app.string.speed'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')

              Column() {
                Image($r('app.media.forward'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Fill)
                  .bindMenu([
                    {
                      value: '正向',
                      action: () => {
                        lottie.setDirection(1)
                      }
                    },
                    {
                      value: '反向',
                      action: () => {
                        lottie.setDirection(-1)
                      }
                    }
                  ])

                Text($r('app.string.play_order'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')

              Column() {
                Image($r('app.media.ic_public_delete_filled'))
                  .width(30)
                  .height(30)
                  .colorBlend(Color.White)
                  .onClick(() => {
                    lottie.destroy()
                  })

                Text($r('app.string.destruction_animation'))
                  .fontSize(14)
                  .fontColor($r('app.color.font_color'))
                  .fontWeight(FontWeight.Medium)
                  .opacity(BUTTON_OPACITY)
                  .margin({ top: 6 })
                  .fontFamily('Microsoft YaHei')
              }
              .width('25%')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
          }
          .justifyContent(FlexAlign.SpaceAround)
          .backgroundColor('#FFFFFF')
          .padding(10)
          .borderRadius(24)
          .margin({ bottom: 8 })

          Column() {
            Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
              TabContent() {
                Column() {
                  Text($r('app.string.display_effect'))
                    .fontSize(14)
                    .margin({ top: 10, bottom: 10 })

                  Column() {
                    Row() {
                      Column() {
                        Image($r('app.media.start_stop'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            lottie.togglePause(this.animateName)
                          })

                        Text($r('app.string.play_pause'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }.width('33%')

                      Column() {
                        Image($r('app.media.stop_playing'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            lottie.stop(this.animateName)
                          })

                        Text($r('app.string.stop'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }.width('33%')

                      Column() {
                        Image($r('app.media.pause'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            lottie.pause(this.animateName)
                          })

                        Text($r('app.string.pause'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')
                    }

                    Row() {
                      Column() {
                        Image($r('app.media.start'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            lottie.play(this.animateName)
                          })

                        Text($r('app.string.start_play'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')

                      Column() {
                        Image($r('app.media.speed'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            lottie.setSpeed(2, this.animateName)
                          })

                        Text($r('app.string.double_speed'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')

                      Column() {
                        Image($r('app.media.forward'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            lottie.setDirection(-1, this.animateName)
                          })

                        Text($r('app.string.reverse_playback'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')
                    }
                  }
                  .justifyContent(FlexAlign.SpaceAround)
                  .height('65%')
                }
                .width('100%')
                .height('100%')
                .borderRadius(24)
                .backgroundColor($r('app.color.tab_content_background'))
              }
              .tabBar($r('app.string.play_pause'))

              TabContent() {
                Column() {
                  Text($r('app.string.display_effect_this'))
                    .fontSize(14)
                    .margin({ top: 10, bottom: 10 })
                  Column() {

                    Row() {
                      Column() {
                        Image($r('app.media.start_stop'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            if (this.animateItem !== null) {
                              this.animateItem.togglePause()
                            }
                          })

                        Text($r('app.string.play_pause'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')

                      Column() {
                        Image($r('app.media.stop_playing'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            if (this.animateItem !== null) {
                              this.animateItem.stop()
                            }
                          })

                        Text($r('app.string.stop'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')

                      Column() {
                        Image($r('app.media.pause'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            if (this.animateItem !== null) {
                              this.animateItem.pause()
                            }
                          })

                        Text($r('app.string.pause'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')
                    }

                    Row() {
                      Column() {
                        Image($r('app.media.start'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            if (this.animateItem !== null) {
                              this.animateItem.play()
                            }
                          })
                        Text($r('app.string.start_play'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')

                      Column() {
                        Image($r('app.media.speed'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            if (this.animateItem !== null) {
                              this.animateItem.setSpeed(5)
                            }
                          })

                        Text($r('app.string.five_speed'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')

                      Column() {
                        Image($r('app.media.forward'))
                          .width(30)
                          .height(30)
                          .onClick(() => {
                            if (this.animateItem !== null) {
                              this.animateItem.setDirection(-1)
                            }
                          })

                        Text($r('app.string.reverse_playback'))
                          .fontSize(14)
                          .fontColor($r('app.color.font_color'))
                          .fontWeight(FontWeight.Medium)
                          .opacity(BUTTON_OPACITY)
                          .margin({ top: 6 })
                          .fontFamily('Microsoft YaHei')
                      }
                      .width('33%')
                    }
                  }
                  .justifyContent(FlexAlign.SpaceEvenly)
                  .height('65%')
                }
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor($r('app.color.tab_content_background'))
              }
              .tabBar($r('app.string.play_pause'))

              TabContent() {
                Column() {
                  Row() {
                    Column() {
                      Image($r('app.media.loop'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.setSegment(20, 30)
                          }
                        })

                      Text($r('app.string.fragment_cycle'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')

                    Column() {
                      Image($r('app.media.loop'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.playSegments([[5, 15], [20, 30]], true)
                          }
                        })

                      Text($r('app.string.play_segments'))
                        .padding({ left: 5, right: 5 })
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')
                  }

                  Row() {
                    Column() {
                      Image($r('app.media.reset'))
                        .width(30)
                        .height(30)
                        .bindMenu([
                          {
                            value: '即时生效播放',
                            action: (() => {
                              if (this.animateItem !== null) {
                                this.animateItem.resetSegments(true)
                              }
                            })
                          },
                          {
                            value: '延迟到下轮循环播放再生效',
                            action: (() => {
                              if (this.animateItem !== null) {
                                this.animateItem.resetSegments(false)
                              }
                            })
                          }
                        ])

                      Text($r('app.string.reset_play'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')

                    Column() {
                      Image($r('app.media.subframe'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.setSubframe(false)
                          }
                        })

                      Text($r('app.string.float_integer'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')
                  }
                }
                .justifyContent(FlexAlign.SpaceEvenly)
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor($r('app.color.tab_content_background'))
              }
              .tabBar($r('app.string.cycle'))

              TabContent() {
                Column() {
                  Row() {
                    Column() {
                      Image($r('app.media.destination'))
                        .width(30)
                        .height(30)
                        .bindMenu([
                          {
                            value: '250帧时停止',
                            action: (() => {
                              if (this.animateItem !== null) {
                                this.animateItem.goToAndStop(250, true)
                              }
                            })
                          },
                          {
                            value: '5000ms时停止',
                            action: (() => {
                              if (this.animateItem !== null) {
                                this.animateItem.goToAndStop(5000, false)
                              }
                            })
                          }
                        ])
                      Text($r('app.string.animation_stop'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')

                    Column() {
                      Image($r('app.media.begin'))
                        .width(30)
                        .height(30)
                        .bindMenu([
                          {
                            value: '从250帧开始播放',
                            action: (() => {
                              if (this.animateItem !== null) {
                                this.animateItem.goToAndPlay(250, true);
                              }
                            })
                          },
                          {
                            value: '从12000ms开始播放',
                            action: (() => {
                              if (this.animateItem !== null) {
                                this.animateItem.goToAndPlay(12000, false)
                              }
                            })
                          }
                        ])

                      Text($r('app.string.animation_play'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')
                  }

                  Row() {
                    Column() {
                      Image($r('app.media.refresh'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.resize()
                          }
                        })

                      Text($r('app.string.refresh_animation'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')

                    Column() {
                      Image($r('app.media.destory'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.destroy(this.animateName)
                          }
                        })

                      Text($r('app.string.destruction_grunt_animation'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')
                  }
                }
                .justifyContent(FlexAlign.SpaceEvenly)
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor($r('app.color.tab_content_background'))
              }
              .tabBar($r('app.string.playback_position'))

              TabContent() {
                Column() {
                  Row() {
                    Column() {
                      Image($r('app.media.addevent'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.addEventListener('loopComplete', this.callbackItem)
                          }
                        })

                      Text($r('app.string.add_listen'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')

                    Column() {
                      Image($r('app.media.delete'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.stop()
                          }
                        })

                      Text($r('app.string.delete_listen'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')
                  }

                  Row() {
                    Column() {
                      Image($r('app.media.addall'))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.pause()
                          }
                        })

                      Text($r('app.string.triggers_all_callbacks'))
                        .padding({ left: 5, right: 5 })
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')

                    Column() {
                      Image($r("app.media.delete_all"))
                        .width(30)
                        .height(30)
                        .onClick(() => {
                          if (this.animateItem !== null) {
                            this.animateItem.play()
                          }
                        })

                      Text($r('app.string.delete_all_Listen'))
                        .fontSize(14)
                        .fontColor($r('app.color.font_color'))
                        .fontWeight(FontWeight.Medium)
                        .opacity(BUTTON_OPACITY)
                        .margin({ top: 6 })
                        .fontFamily('Microsoft YaHei')
                    }
                    .width('50%')
                  }
                }
                .justifyContent(FlexAlign.SpaceEvenly)
                .borderRadius(24)
                .width('100%')
                .height('100%')
                .backgroundColor($r('app.color.tab_content_background'))
              }
              .tabBar($r('app.string.listen'))
            }
            .vertical(true)
            .scrollable(true)
            .barMode(BarMode.Fixed)
            .barWidth(100)
            .barHeight(230)
            .animationDuration(0)
            .onChange((index: number) => {
              Logger.info(TAG, index.toString())
            })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
          }
          .width('100%')
          .height(230)
          .margin({ bottom: 8 })
        }
      }
      .scrollBar(BarState.Off)
      .height('100%')
      .padding({ left: 10, right: 10, bottom: '720px' })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
  }
}