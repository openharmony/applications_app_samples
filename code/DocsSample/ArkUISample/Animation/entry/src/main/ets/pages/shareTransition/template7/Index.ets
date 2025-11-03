/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start geometry_transition]
import resource from '../../../common/resource';

class PostData {
  // 图片使用Resource资源，需用户自定义
  avatar: Resource = $r('app.media.flower');
  name: string = '';
  message: string = '';
  images: Resource[] = [];
}

@Entry
@Component
struct Index {
  @State isPersonalPageShow: boolean = false;
  @State selectedIndex: number = 0;
  @State alphaValue: number = 1;

  // 数组中图片均使用Resource资源，需用户自定义
  private allPostData: PostData[] = [
    {
      avatar: $r('app.media.flower'),
      name: 'Alice',
      message:resource.resourceToString($r('app.string.shareTransition_text1')),
      images: [$r('app.media.spring'), $r('app.media.tall_tree')]
    },
    {
      avatar: $r('app.media.sunset_sky'),
      name: 'Bob',
      message: resource.resourceToString($r('app.string.shareTransition_text2')),
      images: [$r('app.media.island')]
    },
    {
      avatar: $r('app.media.tall_tree'),
      name: 'Carl',
      message: resource.resourceToString($r('app.string.shareTransition_text3')),
      images: [$r('app.media.flower'), $r('app.media.sunset_sky'), $r('app.media.spring')]
    }];

  private onAvatarClicked(index: number): void {
    this.selectedIndex = index;
    this.getUIContext()?.animateTo({
      duration: 350,
      curve: Curve.Friction
    }, () => {
      this.isPersonalPageShow = !this.isPersonalPageShow;
      this.alphaValue = 0;
    });
  }

  private onPersonalPageBack(index: number): void {
    this.getUIContext()?.animateTo({
      duration: 350,
      curve: Curve.Friction
    }, () => {
      this.isPersonalPageShow = !this.isPersonalPageShow;
      this.alphaValue = 1;
    });
  }

  @Builder
  PersonalPageBuilder(index: number) {
    Column({ space: 20 }) {
      Image(this.allPostData[index].avatar)
        .size({ width: 200, height: 200 })
        .borderRadius(100)
        // 头像配置共享元素效果，与点击的头像的id匹配
        .geometryTransition(index.toString())
        .clip(true)
        .transition(TransitionEffect.opacity(0.99))

      Text(this.allPostData[index].name)
        .font({ size: 30, weight: 600 })
        // 对文本添加出现转场效果
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.OPACITY
            .combine(TransitionEffect.translate({ y: 100 })),
          TransitionEffect.OPACITY.animation({ duration: 0 })
        ))

      Text(resource.resourceToString($r('app.string.shareTransition_text11')) +
      this.allPostData[index].name)
      // 对文本添加出现转场效果
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.OPACITY
            .combine(TransitionEffect.translate({ y: 100 })),
          TransitionEffect.OPACITY.animation({ duration: 0 })
        ))
    }
    .padding({ top: 20 })
    .size({ width: 360, height: 780 })
    .backgroundColor(Color.White)
    .onClick(() => {
      this.onPersonalPageBack(index);
    })
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.opacity(0.99),
      TransitionEffect.OPACITY
    ))
  }

  build() {
    Column({ space: 20 }) {
      ForEach(this.allPostData, (postData: PostData, index: number) => {
        Column() {
          Post({
            data: postData, index: index, onAvatarClicked: (index: number) => {
              this.onAvatarClicked(index);
            }
          })
        }
        .width('100%')
      }, (postData: PostData, index: number) => index.toString())
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#40808080')
    .bindContentCover(this.isPersonalPageShow,
      this.PersonalPageBuilder(this.selectedIndex), { modalTransition: ModalTransition.NONE })
    .opacity(this.alphaValue)
  }
}

@Component
export default struct Post {
  @Prop data: PostData;
  @Prop index: number;
  @State expandImageSize: number = 100;
  @State avatarSize: number = 50;
  private onAvatarClicked: (index: number) => void = (index: number) => { };

  build() {
    Column({ space: 20 }) {
      Row({ space: 10 }) {
        Image(this.data.avatar)
          .size({ width: this.avatarSize, height: this.avatarSize })
          .borderRadius(this.avatarSize / 2)
          .clip(true)
          .onClick(() => {
            this.onAvatarClicked(this.index);
          })
          // 对头像绑定共享元素转场的id
          .geometryTransition(this.index.toString(), { follow: true })
          .transition(TransitionEffect.OPACITY.animation({ duration: 350, curve: Curve.Friction }))

        Text(this.data.name)
      }
      .justifyContent(FlexAlign.Start)

      Text(this.data.message)

      Row({ space: 15 }) {
        ForEach(this.data.images, (imageResource: Resource, index: number) => {
          Image(imageResource)
            .size({ width: 100, height: 100 })
        }, (imageResource: Resource, index: number) => index.toString())
      }
    }
    .backgroundColor(Color.White)
    .size({ width: '100%', height: 250 })
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 10, top: 10 })
  }
}

// [End geometry_transition]