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
    it( 'RequestPermissionFunction' , 0 , async( done : () => void ) => {
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
      hilog.info( DOMAIN , TAG , BUNDLE + 'RequestPermissionFunction end' );
    } )

    /**
     * 点击主页中更多图标
     */
    it( 'IndexMoreIcon' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexMoreIcon begin' );
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
    it( 'IndexIcon_add_001' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexIcon_add_001 begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'add' ) );
      await btnStart.click()
      await driver.delayMs( 3000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexIcon_add_001 end' );
    } )

    /**
     * picker中选取txt文件
     */
    it( 'Picker_txt' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'picker_txt begin' );
      let driver = await Driver.create();
      await driver.delayMs( 1000 );
      await driver.click(200,300);
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
      await driver.pressBack()
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
    it( 'FilePage_more' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'fileMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more end' );
    } )

    /**
     * txt文件更多按钮菜单1:另存为
     */
    it( 'FilePage_more_save_as' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_save_as begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Text' ).id( 'file_save_as' ) );
      await btnStart.click()
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.type('Image'))
      let imgs = await driver.findComponents(ON.type('Image'));
      await imgs[11].click();
      await driver.delayMs(1000);
      await imgs[6].click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'FilePage_more_save_as end');
    } )

    /**
     * txt文件更多按钮菜单2:设置权限
     */
    it( 'FilePage_more_set_permissions' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_set_permissions begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'fileMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'file_set_permissions' ) );
      await btnStart1.click()
      await driver.delayMs( 2000 );
      await driver.pressBack()
      await driver.delayMs(1000);
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_set_permissions end' );
    } )

    /**
     * txt文件更多按钮菜单3:查询访问列表
     */
    it( 'FilePage_more_query_AccessList' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_query_AccessList begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'fileMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'file_query_AccessList' ) );
      await btnStart1.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_query_AccessList end' );
    } )

    /**
     * txt文件更多按钮菜单4:查询保留列表
     */
    it( 'FilePage_more_query_retentionList' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_query_retentionList begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'fileMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'file_query_retentionList' ) );
      await btnStart1.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'FilePage_more_query_retentionList end' );
    } )

    /**
     * 返回首页
     */
    it( 'BackIndex_001' , 1 , async() => {
      hilog.info( DOMAIN , TAG , 'BackIndex_001 begin' );
      let driver = Driver.create();
      await driver.delayMs( 1000 );
      await driver.assertComponentExist( ON.id( 'filePageBack' ) );
      let backIndex = await driver.findComponent( ON.type( 'Image' ).id( 'filePageBack' ) );
      await backIndex.click();
      await driver.delayMs( 1000 );
      hilog.info( DOMAIN , TAG , 'BackIndex_001 end' );
    } )

    /**
     * 点击add图标 拉取picker
     */
    it( 'IndexIcon_add_002' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexIcon_add_002 begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'add' ) );
      await btnStart.click()
      await driver.delayMs( 3000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'IndexIcon_add_002 end' );
    } )

    /**
     * picker中选取dlp文件
     */
    it( 'Picker_dlp' , 0 , async( done : () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'Picker_dlp begin' );
      let driver = await Driver.create();
      await driver.delayMs( 1000 );
      await driver.click(200,500);
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'Picker_dlp end' );
    } )

    /**
     * Picker 编辑文件
     */
    // 编辑文件并保存
    it('EditFileFunction_002', 0,  async( done: () => void )=> {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFileFunction_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('dlpEdit'));
      let editable = await driver.findComponent( ON.type( 'Image' ).id( 'dlpEdit' ) );
      await editable.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('dlpTextArea'));
      let textArea = await driver.findComponent(ON.id('dlpTextArea'));
      await textArea.inputText('test');
      await driver.delayMs(1000);
      await driver.pressBack()
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('dlpSave'));
      let save = await driver.findComponent( ON.type( 'Image' ).id( 'dlpSave' ) );
      await save.click();
      await driver.delayMs(2000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFileFunction_002 end');
    })

    /**
     * dlp文件更多按钮
     */
    it( 'DLPPage_more' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'dlpMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more end' );
    } )

    /**
     * dlp文件更多按钮菜单1:另存为
     */
    it( 'DLPPage_more_save_as' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_save_as begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Text' ).id( 'dlp_save_as' ) );
      await btnStart.click()
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.type('Image'))
      let imgs = await driver.findComponents(ON.type('Image'));
      await imgs[11].click();
      await driver.delayMs(1000);
      await imgs[6].click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DLPPage_more_save_as end');
    } )

    /**
     * dlp文件更多按钮菜单2:设置权限
     */
    it( 'DLPPage_more_set_permissions' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_set_permissions begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'dlpMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'dlp_set_permissions' ) );
      await btnStart1.click()
      await driver.delayMs( 2000 );
      await driver.pressBack()
      await driver.delayMs(1000);
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_set_permissions end' );
    } )

    /**
     * dlp文件更多按钮菜单3:设置沙箱保留
     */
    it( 'DLPPage_more_query_AccessList' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_query_AccessList begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'dlpMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'set_retention_sandbox' ) );
      await btnStart1.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_query_AccessList end' );
    } )

    /**
     * dlp文件更多按钮菜单4:取消沙箱保留
     */
    it( 'DLPPage_more_query_retentionList' , 0 , async( done: () => void ) => {
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_query_retentionList begin' );
      let driver = await Driver.create();
      await driver.delayMs( 2000 );
      let btnStart = await driver.findComponent( ON.type( 'Image' ).id( 'dlpMore' ) );
      await btnStart.click()
      await driver.delayMs( 2000 );
      let btnStart1 = await driver.findComponent( ON.type( 'Text' ).id( 'cancel_retention_sandbox' ) );
      await btnStart1.click()
      await driver.delayMs( 2000 );
      done();
      hilog.info( DOMAIN , TAG , BUNDLE + 'DLPPage_more_query_retentionList end' );
    } )

    /**
     * 返回
     */
    it( 'BackIndex_002' , 1 , async() => {
      hilog.info( DOMAIN , TAG , 'BackIndex_002 begin' );
      let driver = Driver.create();
      await driver.delayMs( 1000 );
      await driver.assertComponentExist( ON.id( 'dlpPageBack' ) );
      let backIndex = await driver.findComponent( ON.type( 'Image' ).id( 'dlpPageBack' ) );
      await backIndex.click();
      await driver.delayMs( 1000 );
      hilog.info( DOMAIN , TAG , 'BackIndex_002 end' );
    } )
  } )
}