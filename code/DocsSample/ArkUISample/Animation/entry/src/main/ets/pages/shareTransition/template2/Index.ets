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
import { common } from '@kit.AbilityKit';

// [Start post_data]
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
  // [StartExclude post_data]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // [EndExclude post_data]
  @State isExpand: boolean = false;
  @State @Watch('onItemClicked') selectedIndex: number = -1;
  // 数组中图片均使用Resource资源，需用户自定义
  private allPostData: PostData[] = [
    {
      avatar: $r('app.media.flower'),
      name: 'Alice',
      message: this.context.resourceManager.getStringByNameSync('shareTransition_text1'),
      images: [$r('app.media.spring'), $r('app.media.tall_tree')]
    },
    {
      avatar: $r('app.media.sunset_sky'),
      name: 'Bob',
      message: this.context.resourceManager.getStringByNameSync('shareTransition_text2'),
      images: [$r('app.media.island')]
    },
    {
      avatar: $r('app.media.tall_tree'),
      name: 'Carl',
      message: this.context.resourceManager.getStringByNameSync('shareTransition_text3'),
      images: [$r('app.media.flower'), $r('app.media.sunset_sky'), $r('app.media.spring')]
    }];

  private onItemClicked(): void {
    if (this.selectedIndex < 0) {
      return;
    }
    this.getUIContext()?.animateTo({
      duration: 350,
      curve: Curve.Friction
    }, () => {
      this.isExpand = !this.isExpand;
    });
  }

  build() {
    Column({ space: 20 }) {
      ForEach(this.allPostData, (postData: PostData, index: number) => {
        // 当点击了某个post后，会使其余的post消失下树
        if (!this.isExpand || this.selectedIndex === index) {
          Column() {
            Post({ data: postData, selectedIndex: this.selectedIndex, index: index });
          }
          .width('100%')
          // 对出现消失的post添加透明度转场和位移转场效果
          .transition(TransitionEffect.OPACITY
            .combine(TransitionEffect.translate({ y: index < this.selectedIndex ? -250 : 250 }))
            .animation({ duration: 350, curve: Curve.Friction }))
        }
      }, (postData: PostData, index: number) => index.toString())
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#40808080')
  }
}

@Component
export default struct Post {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @Link selectedIndex: number;
  @Prop data: PostData;
  @Prop index: number;
  @State itemHeight: number = 250;
  @State isExpand: boolean = false;
  @State expandImageSize: number = 100;
  @State avatarSize: number = 50;

  build() {
    Column({ space: 20 }) {
      Row({ space: 10 }) {
        Image(this.data.avatar)
          .size({ width: this.avatarSize, height: this.avatarSize })
          .borderRadius(this.avatarSize / 2)
          .clip(true)

        Text(this.data.name);
      }
      .justifyContent(FlexAlign.Start)

      Text(this.data.message);

      Row({ space: 15 }) {
        ForEach(this.data.images, (imageResource: Resource, index: number) => {
          Image(imageResource)
            .size({ width: this.expandImageSize, height: this.expandImageSize })
        }, (imageResource: Resource, index: number) => index.toString())
      }

      // 展开态下组件增加的内容
      if (this.isExpand) {
        Column() {
          Text(this.context.resourceManager.getStringByNameSync('shareTransition_text4'))
          // 对评论区文本添加出现消失转场效果
            .transition(TransitionEffect.OPACITY
              .animation({ duration: 350, curve: Curve.Friction }))
            .padding({ top: 10 })
        }
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.opacity(0.99)
            .animation({ duration: 350, curve: Curve.Friction }),
          TransitionEffect.OPACITY.animation({ duration: 0 })
        ))
        .size({ width: '100%' })
      }
    }
    .backgroundColor(Color.White)
    .size({ width: '100%', height: this.itemHeight })
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 10, top: 10 })
    .onClick(() => {
      this.selectedIndex = -1;
      this.selectedIndex = this.index;
      this.getUIContext()?.animateTo({
        duration: 350,
        curve: Curve.Friction
      }, () => {
        // 对展开的post做宽高动画，并对头像尺寸和图片尺寸加动画
        this.isExpand = !this.isExpand;
        this.itemHeight = this.isExpand ? 780 : 250;
        this.avatarSize = this.isExpand ? 75 : 50;
        this.expandImageSize = (this.isExpand && this.data.images.length > 0)
          ? (360 - (this.data.images.length + 1) * 15) / this.data.images.length : 100;
      })
    })
  }
}

// [End post_data]