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
import { router, Router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
build() {
 Column(){
   Column(){
     Text($r('app.string.Twoway_Binding')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/TwowayBinding'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.No_Twoway_Binding')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/NoTwowayBinding'})
   })
   Column(){
     Text($r('app.string.Decorative_Array')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DecorativeArray'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Decorative_Date')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DecorativeDate'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Decorative_Map')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DecorativeMap'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Decorative_Set')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DecorativeSet'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Drag_Drop')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DragDrop'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Decorative_Complex')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DecorativeComplex'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Provider_Same')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/ProviderSame'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Decorative_Initialized')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/DecorativeInitialized'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Code_First')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/CodeFirst'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Code_Second')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/CodeSecond'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Code_Three')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/CodeThree'})
   }).margin({top:'50'})
   Column(){
     Text($r('app.string.Builder_Node')).backgroundColor(Color.Green)
   }.width('100%').height(50)
   .onClick(()=>{
     this.getUIContext().getRouter().pushUrl({url:'homePage/BuilderNode'})
   }).margin({top:'50'})
 }
}
}