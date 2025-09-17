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

import {
  __memo_context_type,
  __memo_id_type,
  Consume,
  Link,
  memo,
  MutableState,
  observableProxy,
  State,
  stateOf,
  StorageLink
} from '@ohos.arkui.stateManagement';
import {
  $r,
  Button,
  ButtonAttribute,
  ClickEvent,
  Column,
  Component,
  EditableTextOnChangeCallback,
  FlexAlign,
  Image,
  Margin,
  Padding,
  Row,
  Text,
  TextAttribute,
  TextInput,
  TextInputController
} from '@ohos.arkui.component';
import hilog from '@ohos.hilog';
import { Comment } from '../model/CommentModel';
import common from '@ohos.app.ability.common';
import { PromptAction, UIContext } from '@ohos.arkui.UIContext';
import { Constants } from '../constants/Constants';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import image from '@ohos.multimedia.image';

@Component
export struct Navigation {
  @Link items: Array<Comment>;
  @State commentContent: string = ''
  @State imagePath: string = '';
  controller: TextInputController = new TextInputController();
  uiContext: UIContext | undefined = undefined;

  aboutToAppear(): void {
    this.uiContext = this.getUIContext();
  }

  getCurrentDate(): string {
    const date: Date = new Date();
    return `${date.getFullYear()}-${date.getMonth()}-${date.getDay()} ${date.getHours()}:${date.getMinutes()}`;
  }

  // 定义相机捕获方法，接收一个UIAbilityContext对象作为参数
  cameraCapture(context: common.UIAbilityContext) {
    try {
      // 构造Want对象，用于描述要启动的Ability
      let want: Want = {
        action: Constants.ACTION_PICKER_CAMERA, // 使用预定义的相机选择器动作
        parameters: {
          // 设置启动参数
          'supportMultiMode': false, // 禁用多选模式（单张图片）
          'callBundleName': context.abilityInfo.bundleName // 传递调用方包名
        } as Record<String, Object>
      };
      // 启动Ability并等待结果（异步操作）
      context.startAbilityForResult(
        want, // 要启动的Ability描述
        // 结果回调函数（包含错误和结果处理）
        (err: BusinessError | null, result: common.AbilityResult | undefined) => {
          // 错误处理：如果存在错误码
          if (err && err.code) {
            hilog.error(0x0000, 'testTag',
              `startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          if (result && result.resultCode === 0) {
            // 从结果中获取参数对象
            const param: Record<string, Object> | undefined = result.want?.parameters as Record<string, Object>;
            // 确保参数存在
            if (param !== undefined) {
              // 获取相机返回的图片URI（类型断言为字符串）
              const resourceUri: string = param[Constants.KEY_RESULT_PICKER_CAMERA] as string;
              // 将图片路径保存到类成员变量中（用于后续显示/处理）
              this.imagePath = resourceUri;
            }
            let promptAction: PromptAction = this.uiContext!.getPromptAction();
            promptAction.showToast({
              message: '拍照成功',
              duration: 2000
            });
          }
        }
      );
    } catch (err) { // 同步错误捕获
      // 类型断言为业务错误类型
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;

      // 记录异常日志
      hilog.error(0x0000, 'testTag',
        `startAbilityForResult failed, code is ${code}, message is ${message}`);
    }
  }

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: $r('app.string.TextInput_placeholder'), text: this.commentContent })
          .height(40)
          .width('70%')
          .padding({
            left: 10,
            right: 50,
            top: 3,
            bottom: 3
          } as Padding)
          .margin({
            right: 10
          } as Margin)
          .onChange((textInComment: string) => {
            this.commentContent = textInComment;
          } as EditableTextOnChangeCallback)
        Image($r('app.media.icon_comment_camera'))
          .height(30)
          .width(30)
          .margin({
            right: 10
          } as Margin)
          .onClick((e: ClickEvent) => {
            try {
              this.cameraCapture(this.getUIContext().getHostContext() as common.UIAbilityContext);
            } catch (error: BusinessError) {
              hilog.info(0x0000, 'testTag', 'camera capture error：' + error.code);
            }
          })
        Button($r('app.string.Comment_publish'))
          .height(30)
          .width(60)
          .onClick((e: ClickEvent) => {
            if (this.imagePath !== '') {
              let mockData: Comment = new Comment();
              mockData.name = 'LiHua';
              mockData.comment = this.commentContent;
              mockData.avatar = $r('app.media.icon_comment_app_logo2');
              mockData.images = [this.imagePath];
              mockData.time = this.getCurrentDate();
              this.items = [...this.items, mockData];
              this.imagePath = '';
              this.commentContent = '';
            }
          })
      }.justifyContent(FlexAlign.End)
    }
  }
}