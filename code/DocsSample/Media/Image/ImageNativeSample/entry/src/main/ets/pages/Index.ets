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
import image from '@ohos.multimedia.image';
import { GotoButton } from '../utils/MyButton'

@Entry
@Component
struct Index {
  @State message: number = 0;
  @State picture: image.Picture | null = null;
  @State returnMessage: string = 'No';

  build() {
    Row() {
      Column() {
        List() {
          ListItem() {
            GotoButton({ text: '跳转到图片编解码操作页面', dstUri: 'pages/ImageCodec'})
          }

          ListItem() {
            GotoButton({ text: '跳转到Gif编解码操作页面', dstUri: 'pages/GifCodec'})
          }

          ListItem() {
            GotoButton({ text: '跳转到Picture编解码演示页面', dstUri: 'pages/PictureCodec'})
          }

          ListItem() {
            GotoButton({ text: '跳转到读取和修改Exif信息页面', dstUri: 'pages/EditExif'})
          }

          ListItem() {
            GotoButton({ text: '跳转到图片接收页面', dstUri: 'pages/ImageReceiver'})
          }
        }
        .width('%100')
        .height('%100')
      }
    }
  }
}
