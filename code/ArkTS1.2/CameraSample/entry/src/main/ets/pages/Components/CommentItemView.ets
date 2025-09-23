'use static';
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

import { Comment } from '../model/CommentModel';
import { ImageListView } from './ImageListView';
import {
  __memo_context_type,
  __memo_id_type,
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
  HorizontalAlign,
  Image,
  ImageAttribute,
  Margin,
  Row,
  Text,
  TextAttribute,
} from '@ohos.arkui.component';

@Component
export struct CommentView {
  private comment: Comment = new Comment();

  build() {
    Column() {
      Row() {
        Image(this.comment.avatar)
          .width(50)
          .height(50)
          .borderRadius(25)
        Column() {
          Text(this.comment.name)
          Text(this.comment.time)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: 5
        } as Margin)
      }
      .width('100%')

      Text(this.comment.comment)
        .width('100%')
        .margin({
          top: 5
        } as Margin)
      if (this.comment.images.length > 0) {
        ImageListView({ selectedImages: this.comment.images })
      }
    }
    .width('100%')
    .padding(10)
  }
}