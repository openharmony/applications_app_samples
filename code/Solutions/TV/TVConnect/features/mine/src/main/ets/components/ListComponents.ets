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
import { HMRouterMgr } from '@hadss/hmrouter';
import { LengthMetrics, router } from '@kit.ArkUI';
import { scale } from '../model/utils/ScreenAdaptation';

/**
 * 通用列表组件封装
 */
@Component
export struct CommonList {
  @BuilderParam groups: () => void = this.doNothing;

  @Builder
  doNothing() {
  }

  build() {
    Column() {
      this.groups();
    }.padding(scale(5)).margin(scale(5));
  }
}

/**
 * 通用列表-组UI组件封装
 */
@Component
export struct CommonGroup {
  @BuilderParam items: () => void = this.doNothing;

  @Builder
  doNothing() {
  }

  build() {
    Column() {
      ColumnSplit() {
        this.items();
      }
      .margin({
        left: scale(15),
        right: scale(15),
        top: scale(5),
        bottom: scale(5)
      });
    }
    .backgroundColor($r('app.color.default_component_color'))
    .borderRadius(scale(15))
    .margin({
      left: scale(10),
      right: scale(10),
      top: scale(10),
      bottom: scale(10)
    });
  }
}

/**
 * 通用列表-列表项UI组件封装
 */
@Component
export struct CommonItem {
  @BuilderParam item: () => void = this.doNothing;
  num: number = 0;

  @Builder
  doNothing() {
  }

  build() {
    Row() {
      Column() {
        this.item();
      };
    };
  }
}

/**
 * 通用列表-可跳转页面的列表项UI组件封装
 */
@Component
export struct NavItem {
  @BuilderParam item: () => void = this.doNothing;
  pushName: string = '';

  @Builder
  doNothing() {
  }

  build() {
    CommonItem() {
      Row() {
        Column() {
          this.item();
        }.onClick(() => {
          HMRouterMgr.push({ pageUrl: this.pushName });
        });
      };
    };
  }
}

/**
 * 通用列表-带文件和图标的普通列表项UI组件封装
 */
@Component
export struct SimpleItem {
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontSize: ResourceStr = $r('app.string.font_20');
  @State isFontWeight: boolean = false;
  name: Resource | string = '';

  build() {
    Row() {
      Text(this.name)
        .fontColor(this.fontColor)
        .fontWeight(this.isFontWeight ? FontWeight.Bold : FontWeight.Medium)
        .fontSize(this.fontSize)
        .focusable(true)
        .focusBox({
          strokeWidth: LengthMetrics.px(0)
        })
        .onFocus(() => {
          this.fontColor = $r('app.color.text_color_white');
          this.fontSize = $r('app.string.font_22');
          this.isFontWeight = true;
        })
        .onBlur(() => {
          this.fontColor = $r('app.color.default_text_color');
          this.fontSize = $r('app.string.font_20');
          this.isFontWeight = false;
        });
      Blank();
      Image($r('app.media.ic_public_arrow_right')).height($r('app.string.font_16'));
    }.margin(scale(10)).padding({ left: scale(10) }).width('100%');
  }
}

// 带文件图标和信息
@Component
export struct SimpleMessageItem {
  name: Resource | string = '';
  @Prop message: Resource | string = '';

  build() {
    Row() {
      Text(this.name);
      Blank();
      Text(this.message).fontSize(scale(15)).fontColor(0x808080);
      Image($r('app.media.ic_public_arrow_right')).height(20).margin({ right: scale(5) });
    }.margin(scale(10)).width('100%');
  }
}