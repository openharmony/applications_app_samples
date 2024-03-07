/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {
  @State formId:number = 0;
  build() {
    Row() {
      Column() {
        Text("6*4StatMusicCard")
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        FormComponent({
          id: 0,
          name: "StaticMusicLockUltraLongCard",
          bundle: "com.samples.arktscard",
          ability: "EntryFormAbility",
          module: "entry",
          dimension: FormDimension.DIMENSION_6_4,
          temporary: false
        })
          .allowUpdate(true)
          .size({ width: 300, height: 200 })
          .visibility(Visibility.Visible)
          .onAcquired((form) => {
            console.log(`form info : ${JSON.stringify(form)}`);
            this.formId = form.id;
          })
          .onError((err) => {
            console.log(`fail to add form, err: ${JSON.stringify(err)}`);
          })
        Text("6*4DynamicMusicCard")
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        FormComponent({
          id: 0,
          name: "DynamicMusicLockUltraLongCard",
          bundle: "com.samples.arktscard",
          ability: "EntryFormAbility",
          module: "entry",
          dimension: FormDimension.DIMENSION_6_4,
          temporary: false
        })
          .allowUpdate(true)
          .size({ width: 300, height: 200 })
          .visibility(Visibility.Visible)
          .onAcquired((form) => {
            console.log(`form info : ${JSON.stringify(form)}`);
            this.formId = form.id;
          })
          .onError((err) => {
            console.log(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}