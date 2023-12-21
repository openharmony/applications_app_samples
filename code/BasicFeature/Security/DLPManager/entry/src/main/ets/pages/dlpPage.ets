/**
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import MediaFileUri from '../media/MediaFileUri';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import Logger from '../utils/Logger'
import dlpPermission from '@ohos.dlpPermission';
import picker from '@ohos.file.picker';

const TAG = '[dlpmanager_dlpPage]'
const OPACITY_VALUE = 0.6; // 透明度

let storage = LocalStorage.getShared();

@Entry( storage )
@Component
struct DlpPage {
  @State inSandbox: boolean = false
  @State opacityValue: number = OPACITY_VALUE;
  @State myFileName: string = '';
  @State myUri: string = '';
  @State fd: number = 0;
  @State myPath: string = '';
  @State isDLPFile: boolean = false
  @State fileSuffix: string = ''
  @State fileSuffixIncludes: boolean = false
  @StorageLink( 'editable' ) editable: Boolean = false;
  @StorageLink( 'myFileContent' ) myFileContent: string = '';
  @StorageLink( 'myFileSize' ) myFileSize: number = 0;
  controller: TextAreaController = new TextAreaController();
  newFileContent: string = '';
  @State uriSave: string = '';
  mediaFileUri: MediaFileUri = new MediaFileUri();
  wantInfo: Want = new Want()
  scroller: Scroller = new Scroller();

  aboutToAppear() {
  }

  onPageShow(): void {
    this.wantInfo = AppStorage.get( "funcAbilityWant" ) as Want
    console.info( TAG , "funcAbilityWant:" + JSON.stringify( this.wantInfo ) )
    // let name = this.wantInfo.parameters.fileName
  }

  build() {
    Column() {
      Row() {
        Image( $r( 'app.media.ic_public_back' ) )
          .width( '24vp' )
          .height( '24vp' )
          .margin( { left : '24vp' , right : '16vp' , top : '16vp' , bottom : '16vp' } )
          .objectFit( ImageFit.Contain )
          .id( 'dlpPageBack' )
          .onClick( () => {
            router.back()
          } )
        Text( this.myFileName )
          .width( '296vp' )
          .height( '28vp' )
          .fontSize( '20vp' )
          .fontFamily( 'HarmonyHeiTi-Bold' )
          .fontColor( $r( 'app.color.font_color_182431' ) )
          .textAlign( TextAlign.Start )
          .lineHeight( '28vp' )
          .fontWeight( 700 )
          .margin( { top : '13vp' , bottom : '15vp' } )
      }
      .height( '56vp' )
      .width( '480vp' )

      Scroll( this.scroller ) {
        Column() {
          TextArea( { text : this.myFileContent , placeholder : 'Input text here...' , controller : this.controller } )
            .width( '372vp' )
            .height( '100vp' )
            .fontSize( '16vp' )
            .fontFamily( 'HarmonyHeiTi-Medium' )
            .fontColor( $r( 'app.color.font_color_182431' ) )
            .textAlign( TextAlign.Start )
            .fontWeight( 500 )
            .margin( { top : '10vp' , bottom : '32vp' , right : '8vp' } )
            .id( 'dlpTextArea' )
            .padding( {
              top : 0 ,
              right : 0 ,
              left : 0 ,
              bottom : 0
            } )
            .focusable( this.editable ? true : false )
            .focusOnTouch( true )
            .defaultFocus( false )
            .onFocus( () => {
              this.opacityValue = 1;
            } )
            .onBlur( () => {
              this.opacityValue = OPACITY_VALUE;
            } )
            .onChange( ( value: string ) => {
              this.myFileContent = value;
            } )
            .backgroundColor( '#FFFFFF' )

        }
        .width( '380vp' )
        .height( '64vp' )
        .margin( { left : '28vp' , right : '72vp' , top : '4vp' , bottom : '576vp' } )

      }

      Blank()

      Flex( { direction : FlexDirection.Row , justifyContent : FlexAlign.Center } ) {
        Column() {
          Image( $r( 'app.media.ic_public_edit' ) )
            .width( '24vp' )
            .height( '24vp' )
            .margin( { top : '8vp' , bottom : '3vp' , left : '40vp' , right : '40vp' } )
            .onClick( () => {
              this.editable = true;
              AppStorage.setOrCreate( 'editable' , this.editable );
              Logger.info( TAG , 'EditFile caretPosition length = ' + this.myFileContent.length );
              this.controller.caretPosition( this.myFileContent.length );
              promptAction.showToast( { message : $r( 'app.string.editable' ) , duration : 2000 } );
            } )

          Text( $r( 'app.string.edit' ) )
            .fontSize( '10vp' )
            .fontFamily( 'HarmonyHeiTi-Medium' )
            .fontColor( $r( 'app.color.font_color_182431' ) )
            .textAlign( TextAlign.Center )
            .lineHeight( '14vp' )
            .fontWeight( 500 )
            .width( '136vp' )
            .height( '14vp' )
            .margin( { left : '4vp' , right : '4vp' , bottom : '7vp' } )
            .id( 'dlpEdit' )

        }.width( '144vp' ).height( '56vp' )

        Column() {
          Image( $r( 'app.media.ic_public_save' ) )
            .width( '24vp' )
            .height( '24vp' )
            .margin( { top : '8vp' , bottom : '3vp' , left : '40vp' , right : '40vp' } )
            .onClick( () => {
              Logger.info( TAG , 'save onClick myFileContent is: ' + this.myFileContent );
              Logger.info( TAG , 'save onClick this.myUri: ' + this.myUri )
              this.mediaFileUri.writeFileContent( this.myUri , this.myFileContent );
              this.editable = false;
              AppStorage.setOrCreate( 'editable' , this.editable );
              promptAction.showToast( { message : $r( 'app.string.saved' ) , duration : 2000 } );
            } )
          Text( $r( 'app.string.save' ) )
            .fontSize( '10vp' )
            .fontFamily( 'HarmonyHeiTi-Medium' )
            .fontColor( $r( 'app.color.font_color_182431' ) )
            .textAlign( TextAlign.Center )
            .lineHeight( '14vp' )
            .fontWeight( 500 )
            .width( '136vp' )
            .height( '14vp' )
            .margin( { left : '4vp' , right : '4vp' , bottom : '7vp' } )
            .id( 'dlpSave' )
        }.width( '144vp' ).height( '56vp' )

        Column() {
          Image( $r( 'app.media.ic_public_more' ) )
            .width( '24vp' )
            .height( '24vp' )
            .margin( { top : '8vp' , bottom : '3vp' , left : '40vp' , right : '40vp' } )
            .bindMenu( this.filePageMenu , { placement : Placement.TopRight , offset : { x : '52vp' , y : '12vp' } } )
          Text( $r( 'app.string.more' ) )
            .fontSize( '10vp' )
            .fontFamily( 'HarmonyHeiTi-Medium' )
            .fontColor( $r( 'app.color.font_color_182431' ) )
            .textAlign( TextAlign.Center )
            .lineHeight( '14vp' )
            .fontWeight( 500 )
            .width( '136vp' )
            .height( '14vp' )
            .margin( { left : '4vp' , right : '4vp' , bottom : '7vp' } )
            .id( 'dlpMore' )
        }.width( '144vp' ).height( '56vp' )
      }
      .align( Alignment.Bottom )
      .height( '56vp' )
      .width( '480vp' )
      .backgroundColor( $r( 'app.color.bg_color_F1F3F5' ) )

    }.width( '480vp' ).height( '100%' )
  }

  @Builder
  filePageMenu() {
    Menu() {
      MenuItem( this.filePageTextMenu1 )
        .width( '124vp' )
        .height( '48vp' )
        .margin( { left : '16vp' , right : '16vp' } )
        .onClick( () => {
        } )

      MenuItem( this.filePageDivider )

      MenuItem( this.filePageTextMenu2 )
        .width( '124vp' )
        .height( '48vp' )
        .margin( { left : '16vp' , right : '16vp' } )
        .onClick( () => {
        } )
        .enabled( this.isDLPFile ? true : ( this.fileSuffixIncludes ? true : false ) )

      MenuItem( this.filePageDivider )

      MenuItem( this.filePageTextMenu3 )
        .width( '124vp' )
        .height( '48vp' )
        .margin( { left : '16vp' , right : '16vp' } )
        .onClick( () => {
        } )
        .enabled( this.inSandbox ? true : false )

    }
    .width( '156vp' ).height( '152vp' )
    .backgroundColor( '#FFFFFF' )
    .borderRadius( '16vp' )
  }

  @Builder
  filePageTextMenu1() {
    Text( '另存为' )
      .width( '91vp' )
      .height( '22vp' )
      .fontSize( '16vp' )
      .fontFamily( 'HarmonyHeiTi' )
      .fontWeight( 400 )
      .fontColor( $r( 'app.color.font_color_182431' ) )
      .align( Alignment.Start )
      .margin( { top : '13vp' , bottom : '13vp' , right : '33vp' } )
  }

  @Builder
  filePageTextMenu2() {
    Text( '设置权限' )
      .width( '122vp' )
      .height( '21vp' )
      .fontSize( '16vp' )
      .fontFamily( 'HarmonyHeiTi' )
      .fontWeight( 400 )
      .fontColor( this.isDLPFile ? $r( 'app.color.font_color_182431' ) : ( this.fileSuffixIncludes ? $r( 'app.color.font_color_182431' ) : $r( 'app.color.font_color_66182431' ) ) )
      .align( Alignment.Start )
      .margin( { top : '13vp' , bottom : '14vp' , right : '2vp' } )
  }

  @Builder
  filePageTextMenu3() {
    Text( '沙箱权限' )
      .width( '122vp' )
      .height( '21vp' )
      .fontSize( '16vp' )
      .fontFamily( 'HarmonyHeiTi' )
      .fontWeight( 400 )
      .fontColor( this.inSandbox ? $r( 'app.color.font_color_182431' ) : $r( 'app.color.font_color_66182431' ) )
      .align( Alignment.Start )
      .margin( { top : '13vp' , bottom : '14vp' , right : '2vp' } )
  }

  @Builder
  filePageDivider() {
    Divider()
      .width( '124vp' )
      .height( '0.5vp' )
      .opacity( 0.05 )
      .backgroundColor( $r( 'app.color.divider_color_182431' ) )
      .margin( { left : '16vp' , right : '16vp' } )
  }
}