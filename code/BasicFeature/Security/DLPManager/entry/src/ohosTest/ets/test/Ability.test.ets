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

import { describe , it , expect } from '@ohos/hypium'
import { Driver , ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog';
import mediaLibrary from '@ohos.multimedia.mediaLibrary'

const TAG = '[Sample_Dlp]'
const BUNDLE = 'dlp_'
const DOMAIN = 0xF811
// 屏幕上最多显示11条记录
const MAX_NUM = 11

const TYPE : [ mediaLibrary.MediaType , string , mediaLibrary.DirectoryType ][] = [
  [ mediaLibrary.MediaType.FILE, '.txt', mediaLibrary.DirectoryType.DIR_DOCUMENTS ],
]

// 检查页面是否正常显示
async function checkPage( library : mediaLibrary.MediaLibrary , driver : Driver , type : mediaLibrary.MediaType ) {
  hilog.info( DOMAIN , TAG , 'checkPage begin ' )
  let fileFetchOption : mediaLibrary.MediaFetchOptions = {
    selections : mediaLibrary.FileKey.MEDIA_TYPE + '= ?' ,
    selectionArgs : [ type.toString() ] ,
  }
  let fetchFileResult : mediaLibrary.FetchFileResult | undefined = undefined
  try {
    fetchFileResult = await library.getFileAssets( fileFetchOption )
  } catch( error ) {
    expect().assertFail()
  }
  if( fetchFileResult?.getCount() === 0 ) {
    await driver.assertComponentExist( ON.id( 'no_file' ) )
    await driver.delayMs( 1000 )
  } else {
    await driver.assertComponentExist( ON.type( 'ListItem' ) )
    let btnItem = await driver.findComponents( ON.type( 'ListItem' ) )
    hilog.info( DOMAIN , TAG , 'item length = ' + btnItem.length + ' and file count =' + fetchFileResult?.getCount() )
    if( fetchFileResult!.getCount() <= MAX_NUM ) {
      await expect( btnItem.length ).assertEqual( fetchFileResult?.getCount() )
    } else {
      await expect( btnItem.length ).assertEqual( MAX_NUM )
    }
  }
  hilog.info( DOMAIN , TAG , 'checkPage end ' )
}

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

// 资源本地化
async function getResourceString( resource : Resource ) : Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue( resource )
  return text
}

async function onAbilityCreateCallback() {
  hilog.info( DOMAIN , TAG , "onAbilityCreateCallback" )
}

export default function abilityTest() {
  describe( 'ActsAbilityTest' , () => {
    /**
     * 打开应用
     */
    it( 'StartAbility_001' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'StartAbility_001 begin' );
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility( {
          bundleName : 'com.sample.dlpmanager' ,
          abilityName : 'EntryAbility'
        } );
        done();
      } catch( exception ) {
        hilog.info( DOMAIN , TAG , `StartAbility_001 exception = ${ JSON.stringify( exception ) }` );
        expect().assertFail();
      }
      hilog.info( DOMAIN , TAG , BUNDLE + 'StartAbility_001 end' );
    } )

    /**
     * 获取权限
     */
    it( 'RequestPermissionFunction_001' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'RequestPermissionFunction begin' );
      let driver = await Driver.create();
      await driver.delayMs(2000);
      let permit = await getResourceString($r('app.string.permit'));
      await driver.assertComponentExist(ON.text(permit));
      let permit1 = await driver.findComponent(ON.text(permit));
      await permit1.click();
      await driver.delayMs(1000);
      let permit2 = await driver.findComponent(ON.text(permit));
      await permit2.click();
      await driver.delayMs(1000);
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'RequestPermissionFunction_001 end' );
    } )

    /**
     * 点击主页中更多图标
     */
    it( 'IndexMoreIcon' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'Function_001 begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'moreIcon' ) );
      await btnStart.click()
      await driver.delayMs( 1000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexMoreIcon end' );
    } )

    /**
     * 点击主页中更多图标的菜单1
     */
    it( 'IndexMoreIcon_Menu1' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexMoreIcon_Menu1 begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'obtain_visit_record' ) );
      await btnStart1.click()
      await driver.delayMs( 1000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexMoreIcon_Menu1 end' );
    } )

    /**
     * 点击主页中更多图标的菜单2
     */
    it( 'IndexMoreIcon_Menu2' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexMoreIcon_Menu2 begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'moreIcon' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart2 = await driver.findComponent( ON.type( 'Text' ).id( 'obtain_sandbox_retention_information' ) );
      await btnStart2.click();
      await driver.delayMs( 1000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexMoreIcon_Menu2 end' );
    } )

    /**
     * 点击add图标 拉取picker
     */
    it( 'IndexIcon_add' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexIcon_add begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'add' ) );
      await btnStart.click()
      await driver.delayMs( 3000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexIcon_add end' );
    } )

    /**
     * picker中选取txt文件
     */
    it( 'picker_txt' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'picker_txt begin' );
      let driver = await Driver.create();
      await driver.delayMs( 1000 );
      await driver.click(100,100);
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'picker_txt end' );
    } )

    /**
     * Picker 编辑文件
     */
    // 编辑文件并保存
    it('EditFileFunction_001', 0,  async( done: () => void )=> {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFileFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileEdit'));
      let editable = await driver.findComponent( ON.type( 'Image' ).id( 'fileEdit' ) );
      await editable.click();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.id('fileTextArea'));
      let textArea = await driver.findComponent(ON.id('fileTextArea'));
      await textArea.inputText('File Content test');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileSave'));
      let save = await driver.findComponent( ON.type( 'Image' ).id( 'fileSave' ) );
      await save.click();
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFileFunction_001 end');
    })

    /**
     * txt文件更多按钮
     */
    it( 'txt_more' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'txt_more begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'fileMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'txt_more end' );
    } )

    /**
     * txt文件更多按钮菜单1:另存为
     */
    it( 'txt_more_save_as' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'begin begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Text' ).id( 'file_save_as' ) );
      await btnStart.click()
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.type('Image'))
      let imgs = await driver.findComponents(ON.type('Image'));
      await imgs[9].click(); // 新建文件夹
      await driver.delayMs(1000);
      let newDir = await getResourceString($r('app.string.new_dir'));
      let confirm = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(newDir));
      await driver.assertComponentExist(ON.text(confirm));
      await driver.delayMs(2000);
      let createDir = await driver.findComponent(ON.text(confirm));
      await createDir.click(); // 新建文件夹-点击确定图标
      await driver.delayMs(2000);
      await imgs[10].click(); // 新建文件并保存-点击保存图标
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'txt_more_save_as end');
    } )

    /**
     * txt文件更多按钮菜单2:设置权限
     */
    it( 'txt_set_permissions' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'txt_set_permissions begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'fileMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'txt_set_permissions end' );
    } )

    /**
     * 返回首页
     */
    it( 'backIndex_001' , 1 , async() => {
      hilog.info( DOMAIN , TAG , 'backIndex_001 begin' );
      let driver = Driver.create();
      await driver.delayMs( 1000 );
      await driver.assertComponentExist( ON.id( 'backIndex' ) );
      let backIndex = await driver.findComponent( ON.id( 'backIndex' ) );
      await backIndex.click();
      await driver.delayMs( 1000 );
      hilog.info( DOMAIN , TAG , 'backIndex_001 end' );
    } )

  } )
}