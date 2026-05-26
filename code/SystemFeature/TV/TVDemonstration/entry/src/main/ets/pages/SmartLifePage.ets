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

interface FeatureItem {
  icon: Resource;
  title: string;
  description: string;
}

@Component
export struct SmartLifePage {
  @Prop isOtherFocusable: boolean;
  @Link isTab: boolean;
  @State isFocusable: boolean = true;
  childrenOnBlur = () => {
  }; // 父组件的失焦处理函数
  @State focusIndex: number = -1;
  @State features: FeatureItem[] = [
    {
      icon: $r('app.media.Media'),
      title: '娱乐影音',
      description: '智能场景识别，自动优化画面参数'
    },
    {
      icon: $r('app.media.ChildCare'),
      title: '儿童关怀',
      description: '远场语音，无需遥控器操作'
    },
    {
      icon: $r('app.media.remoteAssistance'),
      title: '高效办公',
      description: '多设备协同，一键流转内容'
    }

  ];

  build() {
    Column() {
      Text('智慧生活')
        .fontSize('48lpx')
        .fontColor('rgba(255,255,255,0.9)')
        .fontWeight(700)

        .lineHeight('56lpx')
        .textAlign(TextAlign.Center)
        .margin({ top: '50lpx' });


      // 场景列表
      this.buildSceneList();
    }
    .width('100%')
    .height('100%');

  }

  @Builder
  buildSceneList() {
    Row() {
      ForEach(this.features, (scene: FeatureItem, index: number) => {
        Row() {
          Stack() {
            Image(scene.icon)
              .width(this.focusIndex === index ? '396lpx' : '360lpx')
              .height(this.focusIndex === index ? '624lpx' : '567lpx')
              .objectFit(ImageFit.Cover)
              .borderRadius(this.focusIndex === index ? '26.4lpx' : '24lpx')
              .border({
                width: this.focusIndex === index ? '3lpx' : 0,
                color: this.focusIndex === index ? '#fff' : Color.Transparent
              });
            // 遮罩层
            Column() {
            }
            .width(this.focusIndex === index ? '390lpx' : '360lpx')
            .height('30%')
            .borderRadius(this.focusIndex === index ? '26.4lpx' : '24lpx')
            .margin({ bottom: this.focusIndex === index ? '3lpx' : 0 })
            .linearGradient({

              colors: [['rgba(0, 0, 0, 0)', 0.0], ['rgba(0, 0, 0, 0.1)', 0.3],
                ['rgba(0, 0, 0, 0.3)', 0.5], ['rgba(0, 0, 0, 0.6)', 1]]
            });

            Text(scene.title)
              .fontSize('33lpx')
              .fontColor('rgba(255,255,255,0.86)')
              // .fontColor(this.focusIndex === index ? '#0A59F7' : '#666666')
              .margin({ bottom: '44lpx' })
              .lineHeight('40lpx')
              .textAlign(TextAlign.Center);
          }
          .alignContent(Alignment.Bottom)
          .onFocus(() => {
            this.focusIndex = index;
            this.isTab = false;
          })
          .onHover(() => {
            globalIdle.resetTimer();
            this.focusIndex = index;
            this.isTab = false;
          })
          .onClick(() => {
            globalIdle.resetTimer();
            router.pushUrl({
              url: 'Component/SmartLifeComponent',
              params: { index }
            });
          })
          .onBlur(() => {
            this.focusIndex = -1;
          })
          .onKeyEvent((e) => {
            globalIdle.resetTimer();
            if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
              this.childrenOnBlur();
              this.isFocusable = false;
              this.focusIndex = -1;
            }
          })
          .stateStyles({
            focused: {
              .border({
                color: Color.White
              });
            }
          });
        }.height('650lpx')
        .width('400lpx')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center);
      });
    }
    .focusable(this.isOtherFocusable)
    .width('100%')
    .height('650lpx')
    .margin({ top: '100lpx' })
    .justifyContent(FlexAlign.SpaceEvenly)
    .alignItems(VerticalAlign.Center);

  }
}



