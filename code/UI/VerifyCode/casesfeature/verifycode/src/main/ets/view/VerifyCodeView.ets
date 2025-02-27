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

import { inputMethod } from '@kit.IMEKit';
import { VerifyCodeConstants } from '../constants/VerifyCodeConstants';
import { logger } from '../utils/Logger';
import { emitter } from '@kit.BasicServicesKit';

@Extend(Text)
function verifyCodeUnitStyle() {
  .fontSize($r('sys.float.ohos_id_text_size_body1'))
  .fontWeight(VerifyCodeConstants.VERIFY_CODE_FONTWEIGHT)
  .textAlign(TextAlign.Center)
  .width($r('app.integer.verify_code_code_unit_with'))
  .height('100%')
  .margin({
    left: $r('app.integer.verify_code_code_unit_margin'),
    right: $r('app.integer.verify_code_code_unit_margin')
  })
  .border({
    width: { bottom: $r('app.integer.verify_code_code_border_width') },
    color: { bottom: Color.Grey },
    style: { bottom: BorderStyle.Solid }
  })
}

@Component
struct VerifyCodeComponentWithoutCursor {
  @State codeText: string = '';
  private readonly verifyID: string = 'verifyCodeComponent';
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  // 监听键盘弹出收起状态
  @State isKeyboardShow: boolean = false;
  private verifyCodeLength: number = 6;
  private isListen: boolean = false;
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.GO
    },
  };
  private codeIndexArray: Array<number> = Array.from([0, 1, 2, 3, 4, 5]);
  // 注册路由返回函数，案例插件不触发
  popRouter: () => void = () => {
  };

  aboutToAppear(): void {
    // 注册返回监听，包括点击手机返回键返回与侧滑返回
    this.listenBackPress();
  }

  async attachAndListen(): Promise<void> {
    focusControl.requestFocus(this.verifyID);
    await this.inputController.attach(true, this.textConfig);
    logger.info('attached');
    this.listen();
    this.isKeyboardShow = true;
  }

  listenBackPress() {
    let innerEvent: emitter.InnerEvent = {
      eventId: 5
    };
    // 收到eventId为5的事件后执行回调函数
    emitter.on(innerEvent, () => {
      if (this.isKeyboardShow) {
        // 退出文本编辑状态
        this.inputController.hideTextInput();
        this.isKeyboardShow = false;
      } else {
        this.popRouter();
      }
    });
  }

  aboutToDisappear(): void {
    this.off();
    // 关闭事件监听
    emitter.off(5);
  }

  /**
   * TODO 知识点：绑定输入法
   */
  async attach() {
    await this.inputController.attach(true, this.textConfig);
    logger.info('attached');
  }

  /**
   * TODO：知识点：解绑
   */
  off(): void {
    this.inputController.off('insertText');
    this.inputController.off('deleteLeft');
    this.isListen = false;
    logger.info('detached');
    // 退出文本编辑状态
    this.inputController.hideTextInput();
    this.isKeyboardShow = false;
  }

  /**
   * TODO 知识点：订阅输入法代插入、向左删除事件，从而获得键盘输入内容
   */
  listen() {
    if (this.isListen) {
      return;
    }
    this.inputController.on('insertText', (text: string) => {
      if (this.codeText.length >= this.verifyCodeLength || isNaN(Number(text)) || text === ' ') {
        return;
      }
      this.codeText += text;
      if (this.codeText.length === this.verifyCodeLength) {
        logger.info('VerifyCode: %{public}s', this.codeText);
      }
      logger.info('VerifyCode [insert]: %{public}s', this.codeText);
    })

    this.inputController.on('deleteLeft', (length: number) => {
      this.codeText = this.codeText.substring(0, this.codeText.length - 1);
      logger.info('VerifyCode [delete left]: %{public}s', this.codeText);
    })
    this.isListen = true;
    logger.info('listener added');
  }

  /**
   * TODO 知识点：部分验证码场景要完全禁止对输入验证码的选中、复制等功能，因此可以使用Text组件完成
   */
  @Builder
  buildVerifyCodeComponent() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      ForEach(this.codeIndexArray, (item: number, index: number) => {
        Text(this.codeText[item])
          .verifyCodeUnitStyle()
      }, (item: number, index: number) => item.toString())
    }
    .id(this.verifyID)
    /**
     * TODO：知识点：当可视面积变化时进行绑定注册与解绑
     */
    .onBlur(() => {
      this.off();
    })
    .backgroundColor(Color.Transparent)
    .height($r('app.integer.verify_code_verify_code_height'))
    .margin({ left: $r('sys.float.ohos_id_card_margin_start'), right: $r('sys.float.ohos_id_card_margin_start') })
    .defaultFocus(true)
    .onClick(() => {
      // TODO 知识点：点击本组件时弹出输入法，因为这里使用的是Text组件，因此需要重新attach，而不能直接使用showSoftKeyboard
      this.attachAndListen();
    })
  }

  build() {
    Row() {
      this.buildVerifyCodeComponent()
    }
  }
}

/**
 * 验证码组件：禁用选中、复制、光标
 */
@Component
export struct VerifyCodeViewComponent {
  popRouter: () => void = () => {
  };

  build() {
    Column() {
      VerifyCodeComponentWithoutCursor({ popRouter: this.popRouter })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
