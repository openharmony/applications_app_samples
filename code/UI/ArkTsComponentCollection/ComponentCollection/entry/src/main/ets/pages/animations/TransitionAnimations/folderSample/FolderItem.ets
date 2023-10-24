/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import prompt from '@system.prompt';

@Component
export default struct FolderItem {
  @Link isOpen: boolean;
  private img: Resource | null = null;
  private name: string | null = null;

  build() {
    Stack() {
      if (!this.isOpen) {
        Image(this.img)
          .width('80%')
          .height('80%')
          .borderRadius(3)
          .geometryTransition(`shareIcon${this.name}`)
          .transition({ type: TransitionType.All, opacity: 0 })
      }

      if (this.isOpen) {
        Column() {
          Image(this.img)
            .width('80%')
            .height('80%')
            .borderRadius(10)
          Text(`APP ${this.name}`)
            .margin({ top: 3 })
        }
        .onClick(() => {
          prompt.showToast({
            message: `click APP ${this.name}`,
            duration: 1000,
          });
        })
        .geometryTransition(`shareIcon${this.name}`)
        .transition({ type: TransitionType.All, opacity: 0 })
      }
    }
  }
}