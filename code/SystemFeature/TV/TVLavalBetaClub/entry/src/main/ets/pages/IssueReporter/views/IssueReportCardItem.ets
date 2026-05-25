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
import { fpChangeLpx, vpChangeLpx } from '../models/IssueDetailInfo';

class TagItem {
  public key: string = '';
  public color: ResourceColor = '';
}

@Component
export default struct cardItem {
  itemLabel: ResourceStr = '';
  @Prop itemValue: string = '';
  isBold: boolean = false;
  isDecItem: boolean = false;
  @State isShowAllDec: boolean = false;
  isShow: boolean = false;
  @Prop isFocus: boolean;

  @Builder
  tagBuilder(btnKey: string, btnColor: ResourceColor) {
    if (this.isShow) {
      Row() {
        Text(btnKey)
          .fontSize(fpChangeLpx(36))
          .fontColor(Color.White)
          .fontWeight(900);
      }
      .borderRadius(8)
      .backgroundColor(btnColor)
      .height(vpChangeLpx(51))
      .padding({ left: vpChangeLpx(9), right: vpChangeLpx(9) });
    }
  }

  tagItem: TagItem = new TagItem();

  build() {
    if (!this.isDecItem) {
      Row() {
        Column() {
          Text(this.itemLabel)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .fontSize(fpChangeLpx(36))
            .fontWeight(600);
        };

        Row({ space: vpChangeLpx(12) }) {
          this.tagBuilder(this.tagItem.key, this.tagItem.color);
          Text(this.itemValue)
            .fontSize(fpChangeLpx(36))
            .fontWeight(this.isBold ? 900 : 400)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'));
        }
        .justifyContent(FlexAlign.End);
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);
    } else {
      Column() {
        Column() {
          Text(this.itemLabel)
            .fontSize(fpChangeLpx(36))
            .fontWeight(600)
            .width('100%')
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'));
        }
        .margin({ bottom: vpChangeLpx(18) });


        Column() {
          Text(this.itemValue)
            .width('100%')
            .fontSize(fpChangeLpx(36))
            .fontWeight(400)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(this.isShowAllDec ? 1000 : 3);

        }
        .width('100%')
        .margin({ bottom: this.itemValue.length > 70 ? '24lpx' : 0 });
      }
      .width('100%');
    }
  }
}