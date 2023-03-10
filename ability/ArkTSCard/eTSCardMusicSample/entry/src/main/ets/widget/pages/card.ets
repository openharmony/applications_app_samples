/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

const TAG: string = 'EtsCard'

@Entry
@Component
struct CardDemo {
  @State selectedIndex: number = 0 // selected song;
  @State albumSrc: Resource = (this.selectedIndex % 2 === 0) ? $r('app.media.album') : $r('app.media.album2');
  @State imageArrays: Array<Resource> = [$r('app.media.ic_play_previous'), $r('app.media.ic_play'),
    $r('app.media.ic_pause'), $r('app.media.ic_play_next')];
  @State title: string = '';
  @State playing: boolean = false;
  @State widthSize: Array<number> = [60, 60, 60, 60];
  @State heightSize: Array<number> = [60, 60, 60, 60];
  @State rotateAngle: Array<number> = [0, 0, 0, 0];

  onPlayClick(): void {
    postCardAction(this, {
      'action': 'message',
      'params': {
        'message': 'play'
      }
    });
    console.info(TAG, 'postCardAction onPlayClick');
  }

  onPauseClick(): void {
    postCardAction(this, {
      'action': 'message',
      'params': {
        'message': 'pause'
      }
    });
    console.info(TAG, 'postCardAction onPauseClick');
  }

  onPreviousClick(): void {
    this.selectedIndex--
    if (this.selectedIndex < 0) {
      this.selectedIndex = 1
    }
    this.albumSrc = (this.selectedIndex % 2 === 0) ? $r('app.media.album') : $r('app.media.album2');
    postCardAction(this, {
      'action': 'message',
      'params': {
        'message': 'prev'
      }
    });
  }

  onNextClick(): void {
    this.selectedIndex++
    if (this.selectedIndex > 1) {
      this.selectedIndex = 0
    }
    this.albumSrc = (this.selectedIndex % 2 === 0) ? $r('app.media.album') : $r('app.media.album2');
    postCardAction(this, {
      'action': 'message',
      'params': {
        'message': 'next'
      }
    });
  }

  build() {
    Column() {
      Text(this.title)
        .width('100%')
        .fontSize(30)
        .margin({ top: '10%' })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
      Image(this.albumSrc)
        .width('70%')
        .height('45%')
        .objectFit(ImageFit.Contain)
        .margin({ top: 20, left: 40, right: 40 })
        .onClick(() => {
          postCardAction(this, {
            'action': 'router',
            'bundleName': 'com.samples.etscardmusic',
            'abilityName': 'com.samples.etscardmusic.MainAbility',
            'params': {
              'message': 'routerEvent'
            }
          })
        })

      Row() {
        ForEach(this.imageArrays, (item, index) => {
          Column() {
            Image(item)
              .size({ width: this.widthSize[index], height: this.heightSize[index] })
              .rotate({ x: 0, y: 0, z: 1, angle: this.rotateAngle[index] })
              .onClick(() => {
                animateTo({
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    animateTo({
                      curve: Curve.EaseOut,
                      iterations: 1,
                      playMode: PlayMode.Normal,
                      onFinish: () => {
                        this.rotateAngle[index] = 0;
                      }
                    }, () => {
                      this.rotateAngle[index] = 360;
                    })
                  }
                }, () => {
                  this.rotateAngle[index] = 180;
                })
                switch (index) {
                  case 0:
                    this.onPreviousClick();
                    break
                  case 1:
                    this.onPlayClick();
                    break
                  case 2:
                    this.onPauseClick();
                    break
                  case 3:
                    this.onNextClick();
                    break
                  default:
                    break
                }
              })
          }
          .width('25%')
          .margin({ top: '5%' })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .margin({ top: '5%' })
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .borderRadius('3%')
    .width('100%')
    .height('100%')
    .backgroundColor('#AFEEEE')
  }

  aboutToAppear() {
    console.info('etsCard aboutToDisappear');
    postCardAction(this, {
      'action': 'call',
      'abilityName': 'com.samples.etscardmusic.MainAbility',
      'params': {
        'message': 'backgroundEvent'
      }
    });
  }

  aboutToDisappear() {
    console.error(TAG, 'etsCard aboutToDisappear');
  }

  onPageShow() {
    console.error(TAG, 'etsCard onPageShow');
  }

  onPageHide() {
    console.error(TAG, 'etsCard onPageHide');
  }

  onBackPress() {
    console.error(TAG, 'etsCard onBackPress');
  }
}