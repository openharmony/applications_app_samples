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

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import { TouchEvent, TextInputController, RowAttribute, FlexAlign, EditableTextOnChangeCallback, TextInput, Margin, Row, VerticalAlign, HorizontalAlign, AlignRuleOption, Padding, $r, Image, Text,
  TextAttribute, Column, UIRowAttribute, Component, Button, ButtonAttribute, ClickEvent, UserView, Offset, Position, ResourceStr} from '@ohos.arkui.component'  // TextAttribute should be insert by ui-plugins
import { Link, StorageLink, Consume, State, StateDecoratedVariable, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import hilog from '@ohos.hilog'
import { Comment } from '../model/CommentModel';
import common from '@ohos.app.ability.common'
import { UIContext } from '@ohos.arkui.UIContext';
import { Constants } from '../constants/Constants';
import { BusinessError } from '@ohos.base'
import Want from '@ohos.app.ability.Want'
import image from '@ohos.multimedia.image'

@Component
export struct Navigation {
  @Link items: Array<Comment> = new Array<Comment>();
  @State commentContent: string = ''
  @State imagePath: string = '';
  controller: TextInputController = new TextInputController();
  getCurrentDate(): string {
    const date: Date = new Date();
    return `${date.getFullYear()}-${date.getMonth()}-${date.getDay()} ${date.getHours()}:${date.getMinutes()}`;
  }
  cameraCapture(context: common.UIAbilityContext) {
    try {
      let want: Want = {
        action: Constants.ACTION_PICKER_CAMERA,
        parameters: {
          'supportMultiMode': false,
          'callBundleName': context.abilityInfo.bundleName
        } as Record<String,Object>
      };
      context.startAbilityForResult(want, (err: BusinessError, result: common.AbilityResult) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', `startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        if(result.resultCode === 0) {
          const param: Record<string, Object> | undefined = result.want?.parameters;
          if (param !== undefined) {
            const resourceUri: string = param[Constants.KEY_RESULT_PICKER_CAMERA] as string;
            this.imagePath = resourceUri;
          }
        }
      });
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'testTag', `startAbilityForResult failed, code is ${code}, message is ${message}`);
    }
  }
  build() {
    Column() {
      Row() {
        TextInput({placeholder: $r('app.string.TextInput_placeholder'), text: this.commentContent})
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
              hilog.info(0x0000, 'testTag', 'camera capture error：-----------' + error.code);
            }
          })
        Button($r('app.string.Comment_publish'))
          .height(30)
          .width(60)
          .onClick((e: ClickEvent) => {
            if(this.imagePath !== '') {
              let mockData2: Comment = new Comment();
              mockData2.name = 'LiHua';
              mockData2.comment = this.commentContent;
              mockData2.avatar = $r('app.media.icon_comment_app_logo2');
              mockData2.images = [this.imagePath];
              mockData2.time = this.getCurrentDate();
              this.items = [...this.items, mockData2];
              this.imagePath = '';
              this.commentContent = '';
            }
          })
      }.justifyContent(FlexAlign.End)
    }
  }
}