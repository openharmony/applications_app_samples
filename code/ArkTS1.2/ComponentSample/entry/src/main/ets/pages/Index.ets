/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import { Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, UserView, Row, TextAlign, Visibility,
  List, WordBreak,ListItem,TextInput, InputType,TextOverflow, Image, HorizontalAlign,Tabs,$r,TabContent, Progress, ProgressType} from '@ohos.arkui.component'  // TextAttribute should be insert by ui-plugins
import { State, Link, StateDecoratedVariable, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import hilog from '@ohos.hilog'
import common from '@ohos.app.ability.common';
import {globalContext}  from '../entryability/GlobalContext';
import { Context,UIContext} from '@ohos.arkui.UIContext'

@Component
struct MyStateSample {
  private context :common.UIAbilityContext = globalContext.getAbilityContext();
  build() {
    Column() {
      Button($r('app.string.example4'))
        .onClick((e: ClickEvent)=>{
          this.getUIContext().getRouter().pushUrl({url:'pages/Example4/Example4'})
        }).fontSize(18).margin(15).width('100%')
      Button($r('app.string.example3'))
        .onClick((e: ClickEvent)=>{
          this.getUIContext().getRouter().pushUrl({url:'pages/Example3/Example3'})
        }).fontSize(20).width('100%')
      Button($r('app.string.example2'))
        .onClick((e: ClickEvent)=>{
          this.getUIContext().getRouter().pushUrl({url:'pages/Example2/Example2'})
        }).fontSize(20).margin(15).width('100%')
      Button($r('app.string.example1'))
        .onClick((e: ClickEvent)=>{
          this.getUIContext().getRouter().pushUrl({url:'pages/Example1/Example1'})
        }).fontSize(20).width('100%')
    }
    .padding(15)
    .width('100%')
  }
}

export class ComExampleTrivialApplication extends UserView {
  getBuilder() {
    hilog.info(0x0000, 'testTag', 'getBuilder');
    let wrapper = @memo () => {
      hilog.info(0x0000, 'testTag', 'MyStateSample');
      MyStateSample(undefined)
    }
    return wrapper;
  }
}