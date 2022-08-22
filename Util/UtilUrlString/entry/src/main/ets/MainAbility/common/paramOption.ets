/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import url from '@ohos.url'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdded(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChanged(index)
    })
  }
}

class MyDataSource extends BasicDataSource {
  public dataArray: string[] = []

  constructor(ele) {
    super()
    for (var index = 0;index < ele.length; index++) {
      this.dataArray.push(ele[index])
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): any {
    return this.dataArray[index]
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

var urlObject = new url.URL('https://gitee.com/openharmony')
var paramsObject = new url.URLSearchParams(urlObject.search.slice(1))

@Component
export struct FirstOption{
  private options:Resource[] = [$r('app.string.insert'), $r('app.string.delete'),
                                $r('app.string.getFirst'), $r('app.string.setValue')]
  private nodeValue:string = 'nodeValue'
  private nodeKey:string = 'node'
  private nodeNum:number = 0

  @Link outputs:string

  insertNode(){
    this.nodeNum ++
    paramsObject.append(this.nodeKey, this.nodeValue + this.nodeNum)
    this.outputs = urlObject.toString() + paramsObject.toString()
  }

  deleteNode(){
    if(paramsObject.has(this.nodeKey)){
      paramsObject.delete(this.nodeKey)
      this.outputs = urlObject.toString() + paramsObject.toString()
      this.nodeNum = 0
    }
    else{
      this.outputs = "It does not exist. Please insert first"
    }
  }

  getFirstNode(){
    if(paramsObject.has(this.nodeKey)){
      var fod = paramsObject.get(this.nodeKey);
      this.outputs = fod.toString()
    }
    else{
      this.outputs = "It does not exist. Please insert first"
    }
  }

  changeValue(){
    paramsObject.set(this.nodeKey, 'newValue')
    this.nodeNum = 0
    this.outputs = urlObject.toString() + paramsObject.toString()
  }

  build(){
    Column(){
      Column() {
        LazyForEach(new MyDataSource(this.options),item=> {
          Button() {
            Text(item)
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .width('340')
          }
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .padding(5)
          .margin({top:10 })
          .onClick(() => {
            var index = this.options.indexOf(item)
            switch(index) {
              case 0:
                this.insertNode()
                break
              case 1:
                this.deleteNode()
                break
              case 2:
                this.getFirstNode()
                break
              case 3:
                this.changeValue()
                break
              default:
                break
            }
          })
        },item=>JSON.stringify(item))
      }.width('100%')
    }.width('100%')
  }
}