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
import { BarState, ScrollDirection, Scroll, Scroller, AlertDialogParamWithOptions, ForEach, ListItem, BarState, TextAlign, LazyForEach, List, ScrollAlign, ListScroller, RowAttribute, FlexAlign,
  Color, EditableTextOnChangeCallback, TextInput, Margin, Row, VerticalAlign, HorizontalAlign,
  EdgeWidths, EdgeColors, AlignRuleOption, Padding, BorderOptions, $r, Image, Text,
  TextAttribute, Column, UIRowAttribute, Component, Button, ButtonAttribute, ClickEvent, UserView, Offset, Position, ResourceStr} from '@ohos.arkui.component'  // TextAttribute should be insert by ui-plugins
import { StorageLink, Consume, State, StateDecoratedVariable, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import hilog from '@ohos.hilog'
import common from '@ohos.app.ability.common'
import { UIContext } from '@ohos.arkui.UIContext';
import { Comment } from './model/CommentModel';
import { CommentView } from './Components/CommentItemView';
import { Navigation } from './Components/CommentInputAndCameraCapture';
import { ImageListView } from './Components/ImageListView'
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { BusinessError } from '@ohos.base'

@Component
struct MyStateSample {
  @State commentList: Array<Comment> = new Array<Comment>();
  aboutToAppear() {
    let mockData1: Comment = new Comment();
    mockData1.name = 'Cloud';
    mockData1.comment = $r('app.string.Comment_text');
    mockData1.avatar = $r('app.media.icon_comment_app_logo1');
    mockData1.images.push($r('app.media.icon_comment_landscape1'));
    mockData1.images.push($r('app.media.icon_comment_launch_advert'));
    mockData1.time = '02-07 13:25';
    this.commentList.push(mockData1);
  }

  build() {
    Scroll() {
      Column() {
        Navigation({ items: this.commentList })
        ForEach(this.commentList, (item: Comment) => {
          Column() {
            Row() {
              Image(item.avatar)
                .width(50)
                .height(50)
                .borderRadius(25)
              Column() {
                Text(item.name)
                Text(item.time)
              }
              .alignItems(HorizontalAlign.Start)
              .margin({
                left: 5
              } as Margin)
            }
            .width('100%')

            Text(item.comment)
              .width('100%')
              .margin({
                top: 5
              } as Margin)
            if (item.images.length > 0) {
              ImageListView({ selectedImages: item.images })
            }
          }
          .width('100%')
          .padding(10)
        }
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .scrollable(ScrollDirection.Vertical)
  }
}

export class ComExampleTrivialApplication extends UserView {
  getBuilder() {
    let wrapper = @memo () => {
      MyStateSample(undefined)
    }
    return wrapper
  }
}
