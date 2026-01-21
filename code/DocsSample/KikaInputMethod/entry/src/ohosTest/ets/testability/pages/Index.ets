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

import inputMethod from '@ohos.inputMethod';
import { logger } from '../../util/Logger';

const LINE_HEIGHT: number = 20;
const TAG: string = 'Index';

@Entry
@Component
struct Index {
  @State inputText: string = '';
  @State lastInput: string = '';
  @State selectInput: string = '';
  @State cursorInfo: inputMethod.CursorInfo = { top: 0, left: 0, width: 1, height: 20 };
  @State cursorLeft: number = 0;
  @State selectIndex: number = 0;
  private isAttach: boolean = false;
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Column() {
      Stack() {
        Row() {
          Text(this.inputText)
            .fontSize('32px')
            .fontFamily('sans-serif')
            .id('inputText')
            .lineHeight(LINE_HEIGHT)
          Text(this.selectInput)
            .fontSize('32px')
            .fontFamily('sans-serif')
            .lineHeight(LINE_HEIGHT)
            .id('selectInput')
            .backgroundColor($r('app.color.select_color'))
          Text(this.lastInput)
            .fontSize('32px')
            .fontFamily('sans-serif')
            .lineHeight(LINE_HEIGHT)
            .id('lastInput')
        }
        .width('100%')

        Text('')
          .width(this.cursorInfo.width)
          .height(this.cursorInfo.height)
          .backgroundColor(Color.Blue)
          .margin({ top: 5 })
          .position({ x: this.cursorLeft, y: this.cursorInfo.top })
        Canvas(this.context)
          .width('100%')
          .height(45)
          .onReady(() => {
            this.context.font = '32px sans-serif'
          })
      }
      .id('customInputText')
      .width('100%')
      .border({ width: 1, radius: 16 })
      .padding(5)
      .height(45)
      .onClick((event?: ClickEvent) => {
        if(event) {
          logger.info(TAG, `click event= ${ JSON.stringify(event)}`);
          focusControl.requestFocus('customInputText');
          this.initTextInput(event);
        }
      })
    }
    .height('100%')
    .width('100%')
    .padding(12)
  }

  aboutToAppear() {
    this.cursorInfo.left = this.inputText.length;
  }

  async initTextInput(event: ClickEvent): Promise<void> {
    focusControl.requestFocus('customInputText');
    if (this.isAttach) {
      await this.detach();
    }
    await this.inputController.attach(true, {
      inputAttribute: {
        textInputType: inputMethod.TextInputType.NONE,
        enterKeyType: inputMethod.EnterKeyType.NONE
      }
    });
    this.initListener();
    this.isAttach = true;
    this.calculateCursor(event.x);
  }

  async detach(): Promise<void> {
    logger.info(TAG, `detach`);
    await this.off();
    this.inputController.detach();
  }

  async off(): Promise<void> {
    logger.info(TAG, `off`);
    this.inputController.off('insertText');
    this.inputController.off('deleteLeft');
    this.inputController.off('moveCursor');
    this.inputController.off('selectByMovement');
    this.inputController.off('selectByRange');
    this.inputController.off('sendFunctionKey')
  }

  initListener() {
    this.inputController.on('insertText', (text) => {
      logger.info(TAG, `insertText, text: ${text}`);
      this.inputText += text;
      this.cursorInfo.left = this.inputText.length;
      this.selectIndex = this.cursorInfo.left;
      this.selectInput = '';
      this.cursorLeft = this.context.measureText(this.inputText).width;
    })
    this.inputController.on('deleteLeft', (length) => {
      this.inputText = this.inputText.substring(0, this.inputText.length - length);
      this.cursorInfo.left = this.inputText.length;
      this.selectIndex = this.cursorInfo.left;
      this.cursorLeft = this.context.measureText(this.inputText).width;
    })
    this.inputController.on('moveCursor', (direction) => {
      logger.info(TAG, `Succeeded in moveCursor, direction: ${direction}`);
      let message = this.inputText + this.selectInput + this.lastInput;
      this.selectInput = '';
      if (direction === inputMethod.Direction.CURSOR_UP) {
        this.cursorInfo.left = 0;
      }
      if (direction === inputMethod.Direction.CURSOR_DOWN) {
        this.cursorInfo.left = message.length;
      }
      if (direction === inputMethod.Direction.CURSOR_LEFT) {
        this.cursorInfo.left--;
      }
      if (direction === inputMethod.Direction.CURSOR_RIGHT) {
        if (this.cursorInfo.left < message.length) {
          this.cursorInfo.left++;
        }
      }
      this.selectIndex = this.cursorInfo.left;
      this.inputText = message.substring(0, this.cursorInfo.left);
      this.lastInput = message.substring(this.cursorInfo.left, message.length);
      this.cursorLeft = this.context.measureText(this.inputText).width;
    });
    this.inputController.on('selectByMovement', (movement) => {
      logger.info(TAG, `Succeeded in selectByMovement, direction: ${movement.direction}`);
      let message = this.inputText + this.selectInput + this.lastInput;
      if (movement.direction === inputMethod.Direction.CURSOR_UP) {
        this.selectIndex = 0;
      }
      if (movement.direction === inputMethod.Direction.CURSOR_LEFT) {
        if (this.selectIndex > 0) {
          this.selectIndex--;
        }
      }
      if (movement.direction === inputMethod.Direction.CURSOR_RIGHT) {
        if (this.selectIndex < message.length) {
          this.selectIndex++;
        }
      }
      if (movement.direction === inputMethod.Direction.CURSOR_DOWN) {
        this.selectIndex = message.length;
      }
      if (this.selectIndex > this.cursorInfo.left) {
        this.inputText = message.substring(0, this.cursorInfo.left);
        this.selectInput = message.substring(this.cursorInfo.left, this.selectIndex);
        this.lastInput = message.substring(this.selectIndex, message.length);
      } else {
        this.inputText = message.substring(0, this.selectIndex);
        this.selectInput = message.substring(this.selectIndex, this.cursorInfo.left);
        this.lastInput = message.substring(this.cursorInfo.left, message.length);
      }
    });
    this.inputController.on('selectByRange', (range) => {
      logger.info(TAG, `selectByRange this.range: ${JSON.stringify(range)}`);
      let message = this.inputText + this.selectInput + this.lastInput;
      if (range.start === 0 && range.end === 0) {
        this.cursorInfo.left = 0;
        let message = this.inputText + this.selectInput + this.lastInput;
        this.selectInput = '';
        this.selectIndex = this.cursorInfo.left;
        this.inputText = message.substring(0, this.cursorInfo.left);
        this.lastInput = message.substring(this.cursorInfo.left, message.length);
        this.cursorLeft = this.context.measureText(this.inputText).width;
      } else if (range.end > range.start) {
        let end = range.end;
        if (range.end > message.length) {
          end = message.length;
          this.lastInput = '';
        }else{
          this.lastInput = message.substring(end, message.length);
        }
        if(this.cursorInfo.left > range.start){
          this.selectIndex = range.start;
        }else{
          this.selectIndex = range.end;
        }
        this.inputText = message.substring(0, range.start);
        this.selectInput = message.substring(range.start, end);
      } else {
        this.cursorInfo.left = message.length;
        this.selectIndex = this.cursorInfo.left;
        this.inputText = message.substring(0, this.cursorInfo.left);
        this.lastInput = message.substring(this.cursorInfo.left, message.length);
        this.cursorLeft = this.context.measureText(this.inputText).width;
      }
      logger.info(TAG, `selectByRange this.selectInput: ${this.selectInput}`);
    })
  }

  calculateCursor(x: number) {
    let message = this.inputText + this.selectInput + this.lastInput;
    let charWidth = this.context.measureText(message).width / message.length;
    this.cursorInfo.left = Math.floor(x / charWidth);
    if (this.cursorInfo.left < 0) {
      this.cursorInfo.left = 0;
      this.inputText = '';
      this.lastInput = message;
    } else if (this.cursorInfo.left > message.length) {
      this.cursorInfo.left = message.length;
      this.inputText = message;
      this.lastInput = '';
    } else {
      this.inputText = message.substring(0, this.cursorInfo.left);
      this.lastInput = message.substring(this.cursorInfo.left, message.length);
    }
    this.selectIndex = this.cursorInfo.left;
    this.selectInput = '';
    this.cursorLeft = this.context.measureText(message.substring(0, this.cursorInfo.left)).width;
  }
}