/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { SettingBackground } from '../../default/layout/SettingBackground';
import lpx from '../../common/Lpx';
import router from '@ohos.router';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { CustomDialogContentStyle, SettingItemStyle } from '../../common/constants/StyleConstants';
import audioSetting from '@ohos.tvservice.audioSetting';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';
import { Ratio } from '../../common/Ratio';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import customizesounds from './Customizesounds';

interface geqParmasList{
  band?: number,      /*自定义音效均衡器的频段[0-9]*/
  gain?: number       /*自定义音效均衡器频段的增益值[-10-10]*/
}
interface customDataList{
  referMode?: number,     /*自定义音效参考模式[1-标准,2-影院,3-音乐,4-新闻]*/
  geqParams?: geqParmasList,
  volParams?: number,    /*自定义音效人声参数[0-10]*/
  vSurround?: number,     /*自定义音效垂直环绕参数[0-10]*/
  hSurround?: number,     /*自定义音效水平环绕参数[0-10]*/
  resetData?: boolean  /*重置自定义音效数据[true-重置,false-不重置]*/
}
interface volumeList {
  audioEffectMode: number,   /*音效模式[0-自动,1-标准,2-影院,3-音乐,4-新闻,5-自定义]*/
  customData: customDataList
}

const TAG = 'CustomEffectsIndex'
const getDciLevelMap: Record<number, string> = {
  1: '标准',
  2: '影院',
  3: '音乐',
  4: '新闻',
};

@Entry
@Component
struct CustomEffects {
  @State band:number = 0
  @State gain:number = -10
  @State imageUrl: string = Ratio.resName('icon_volume')
  @State des: string = '自定义音效'
  @State settingList: SettingItemTvModel[] = []
  // 垂直声场拓展
  @State brightnessValue: number = 0;
  // 人声增强
  @State gamma: number = 0;
  // 水平环绕增强
  @State blackValue: number = 0;
  // 参考模式
  @State dynamicContrast: string = '标准'
  @State contrastIndex: number = 0;
  @State resetData:boolean=false;
  private content: DialogContent = new DialogContent('确认重置自定义音效？', '此操作会将自定义音效参数恢复至所选参考模式默认值', '', '', 692, 332);
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.resetData=false
        this.dialogController.close();
      },
      confirm: async () => {
        this.resetData=true
        this.gamma = 0
        this.blackValue = 0
        this.brightnessValue =0
        this.settingList[2].setValue(this.gamma.toString())
        this.settingList[3].setValue(this.blackValue.toString())
        this.settingList[4].setValue(this.brightnessValue.toString())
        await this.setAudioEffect('重置自定义音效')
        this.dialogController.close();
      },
      content: this.content,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }
  controller: CustomDialogController = new CustomDialogController({
    builder: customizesounds({
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel:false
  })

  async aboutToAppear() {
    let item1 = new SettingItemTvModel();
    item1.name = '参考模式';
    item1.style = SettingItemStyle.valueChange;
    item1.value = this.dynamicContrast;

    let item2 = new SettingItemTvModel();
    item2.name = '均衡器设置';
    item2.style = SettingItemStyle.default;

    let item3 = new SettingItemTvModel();
    item3.name = '人声增强';
    item3.style = SettingItemStyle.valueChange;
    item3.value = this.gamma.toString();

    let item4 = new SettingItemTvModel();
    item4.name = '水平环绕增强';
    item4.style = SettingItemStyle.valueChange;
    item4.value = this.blackValue.toString();

    let item5 = new SettingItemTvModel();
    item5.name = '垂直声场拓展';
    item5.style = SettingItemStyle.valueChange;
    item5.value = this.brightnessValue.toString();

    let item6 = new SettingItemTvModel();
    item6.name = '重置自定义音效';
    item6.style = SettingItemStyle.default;

    this.settingList.push(item1, item2, item3, item4, item5, item6);

  }
  onPageShow(): void {
    // 初始化时读硬件数据
    this.getBrightnessValue();
    //人声增强
    this.getGamma()
    //水平环绕增强
    this.getBlack()
    //参考模式
    this.getDynamicContrast()
  }

  async getDynamicContrast(){
    try {
      let getAudioEffect: number = await audioSetting.getCustomReferMode();
      LogUtil.log(TAG + 'getCustomReferMode=' + getAudioEffect);
      this.dynamicContrast=getDciLevelMap[getAudioEffect]
      this.settingList[0].setValue(getDciLevelMap[getAudioEffect])
    } catch (error) {
      LogUtil.log(TAG + 'getCustomReferModError=' + JSON.stringify(error));
    }
  }
  async getGamma(){
    try {
      let getAudioEffect: number = await audioSetting.getCustomVocParams();
      LogUtil.log(TAG + 'getCustomVocParamsSucess=' + getAudioEffect);
      this.settingList[2].setIsShow(getAudioEffect != audioSetting.GetValue.UNSUPPORT);
      this.gamma=getAudioEffect
      this.settingList[2].setValue(getAudioEffect + '')
    } catch (error) {
      LogUtil.log(TAG + 'getCustomVocParamsERROR=' + JSON.stringify(error));
    }
  }
  async getBlack(){
    try {
      let getAudioEffect: number = await audioSetting.getCustomHSurround();
      LogUtil.log(TAG + 'getCustomHSurroundSUCESS=' + getAudioEffect);
      this.settingList[3].setIsShow(getAudioEffect != audioSetting.GetValue.UNSUPPORT);
      this.blackValue=getAudioEffect
      this.settingList[3].setValue(getAudioEffect + '')
    } catch (error) {
      LogUtil.log(TAG + 'getCustomHSurroundERROR=' + JSON.stringify(error));
    }
  }

  // 读硬件垂直声场拓展
  async getBrightnessValue() {
    try {
      let getAudioEffect:number = await audioSetting.getCustomVSurround();
      LogUtil.log(TAG + 'getCustomVSurroundSuccess=' + getAudioEffect);
      this.settingList[4].setIsShow(getAudioEffect != audioSetting.GetValue.UNSUPPORT);
      this.brightnessValue =getAudioEffect;
      this.settingList[4].setValue(this.brightnessValue.toString())
    } catch (error) {
      LogUtil.log(TAG + 'getCustomVSurroundFailed=' + JSON.stringify(error));
    }
  }
  async setAudioEffect(name1:string){
    try {
      if(name1=='参考模式'){
        let setAudioEffect:boolean = await audioSetting.setCustomReferMode(
          this.dynamicContrast == '标准' ? 1 :
          this.dynamicContrast == '影院' ? 2 :
          this.dynamicContrast == '音乐' ? 3 :
          this.dynamicContrast == '新闻' ? 4 : 0
        );
        LogUtil.log(TAG+'setCustomReferMode SuccessBoolean==:'+JSON.stringify(setAudioEffect));
        if(!setAudioEffect){
          promptAction.showToast({ message: `设置${name1}失败` })
        }
      } else if(name1=='人声增强'){
        let setAudioEffect:boolean=await audioSetting.setCustomVocParams(this.gamma); // 调用厂商api
        LogUtil.log(TAG+'setCustomVocParams SuccessBoolean==:'+JSON.stringify(setAudioEffect));
        if(!setAudioEffect){
          promptAction.showToast({ message: `设置${name1}失败` })
        }
      } else if(name1=='重置自定义音效'){
        let setAudioEffect:boolean=await audioSetting.reSetCustomizeData(); // 调用厂商api
        LogUtil.log(TAG+'reSetCustomizeData SuccessBoolean==:'+JSON.stringify(setAudioEffect));
        if(!setAudioEffect){
          promptAction.showToast({ message: `${name1}失败` })
        }
      } else if(name1=='水平环绕增强'){
        let setAudioEffect:boolean=await audioSetting.setCustomHSurround(this.blackValue); // 调用厂商api
        LogUtil.log(TAG+'setCustomHSurround SuccessBoolean==:'+JSON.stringify(setAudioEffect));
        if(!setAudioEffect){
          promptAction.showToast({ message: `设置${name1}失败` })
        }
      } else if(name1=='垂直声场拓展'){
        let setAudioEffect:boolean=await audioSetting.setCustomVSurround(this.brightnessValue); // 调用厂商api
        LogUtil.log(TAG+'setCustomVSurround SuccessBoolean==:'+JSON.stringify(setAudioEffect));
        if(!setAudioEffect){
          promptAction.showToast({ message: `设置${name1}失败` })
        }
      }
    } catch (error){
      LogUtil.log(TAG + 'CustomEffectsIndexFailed=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }


  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          settingList: this.settingList,
          title: '自定义音效',
          onClickHandle: (item: SettingItemTvModel) => {
          },
          onMouseClickHandle: (item: SettingItemTvModel) => {
            if (item.name=='均衡器设置') {
              //弹窗显示
              this.controller.open()
            }
            if (item.name=='重置自定义音效') {
              //弹窗显示
              this.dialogController.open();
            }

          },
          onValueChangeLeftHandle: (item: SettingItemTvModel) => {
            if (item.name === '垂直声场拓展') {
              if(this.brightnessValue==0){
                return
              }
              this.brightnessValue=this.brightnessValue-1
              item.setValue(this.brightnessValue.toString()); // 页面显示值修改
              this.setAudioEffect(item.name)
            } else if (item.name === '人声增强') {
              if(this.gamma==0){
                return
              }
              this.gamma -= 1
              item.setValue(this.gamma.toString()); // 页面显示值修改
              this.setAudioEffect(item.name)
            } else if (item.name === '水平环绕增强') {
              if(this.blackValue==0){
                return
              }
              this.blackValue=this.blackValue-1
              item.setValue(this.blackValue.toString()); // 页面显示值修改
              // 调用厂商api
              this.setAudioEffect(item.name)
            } else if (item.name === '参考模式') {
              let origins: string[] = ['标准', '影院', '音乐', '新闻']
              if(item.value=='标准'){
                this.contrastIndex=3
              } else if(item.value=='影院'){
                this.contrastIndex=0
              } else if(item.value=='音乐'){
                this.contrastIndex=1
              } else if(item.value=='新闻'){
                this.contrastIndex=2
              }
              this.dynamicContrast = origins[this.contrastIndex];
              item.setValue(origins[this.contrastIndex]);
              this.setAudioEffect(item.name)
            }
          },
          onValueChangeRightHandle: (item: SettingItemTvModel) => {
            if (item.name === '垂直声场拓展') {
              if(this.brightnessValue==10){
                return
              }
              this.brightnessValue=this.brightnessValue+1
              item.setValue(this.brightnessValue.toString()); // 页面显示值修改
              this.setAudioEffect(item.name)
            } else if (item.name === '人声增强') {
              if(this.gamma==10){
                return
              }
              this.gamma += 1
              item.setValue(this.gamma.toString()); // 页面显示值修改
              this.setAudioEffect(item.name)
            } else if (item.name === '水平环绕增强') {
              if(this.blackValue==10){
                return
              }
              this.blackValue=this.blackValue+1
              item.setValue(this.blackValue.toString()); // 页面显示值修改
              // 调用厂商api
              this.setAudioEffect(item.name)
            } else if (item.name === '参考模式') {
              let origins: string[] = ['标准', '影院', '音乐', '新闻']
              if(item.value=='标准'){
                this.contrastIndex=1
              } else if(item.value=='影院'){
                this.contrastIndex=2
              } else if(item.value=='音乐'){
                this.contrastIndex=3
              } else if(item.value=='新闻'){
                this.contrastIndex=0
              }
              this.dynamicContrast = origins[this.contrastIndex];
              item.setValue(origins[this.contrastIndex]);
              this.setAudioEffect(item.name)
            }
          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up&&item.name=='均衡器设置') {
              //弹窗显示
              this.controller.open()
            }
            if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up&&item.name=='重置自定义音效') {
              //弹窗显示
              this.dialogController.open();
            }
            if (event.keyCode == KeyCode.KEY_DPAD_LEFT&&event.type === KeyType.Up) {
                if (item.name === '垂直声场拓展') {
                  if(this.brightnessValue==0){
                    return
                  }
                  this.brightnessValue=this.brightnessValue-1
                  item.setValue(this.brightnessValue.toString()); // 页面显示值修改
                  this.setAudioEffect(item.name)
                } else if (item.name === '人声增强') {
                  if(this.gamma==0){
                    return
                  }
                  this.gamma -= 1
                  item.setValue(this.gamma.toString()); // 页面显示值修改
                  this.setAudioEffect(item.name)
                } else if (item.name === '水平环绕增强') {
                  if(this.blackValue==0){
                    return
                  }
                  this.blackValue=this.blackValue-1
                  item.setValue(this.blackValue.toString()); // 页面显示值修改
                  // 调用厂商api
                  this.setAudioEffect(item.name)
                } else if (item.name === '参考模式') {
                  let origins: string[] = ['标准', '影院', '音乐', '新闻']
                  if(item.value=='标准'){
                    this.contrastIndex=3
                  } else if(item.value=='影院'){
                    this.contrastIndex=0
                  } else if(item.value=='音乐'){
                    this.contrastIndex=1
                  } else if(item.value=='新闻'){
                    this.contrastIndex=2
                  }
                  this.dynamicContrast = origins[this.contrastIndex];
                  item.setValue(origins[this.contrastIndex]);
                  this.setAudioEffect(item.name)
                }
              }

            if (event.keyCode == KeyCode.KEY_DPAD_RIGHT&&event.type === KeyType.Up) {
              if (item.name === '垂直声场拓展') {
                if(this.brightnessValue==10){
                  return
                }
                this.brightnessValue=this.brightnessValue+1
                item.setValue(this.brightnessValue.toString()); // 页面显示值修改
                this.setAudioEffect(item.name)
              } else if (item.name === '人声增强') {
                if(this.gamma==10){
                  return
                }
                this.gamma += 1
                item.setValue(this.gamma.toString()); // 页面显示值修改
                this.setAudioEffect(item.name)
              } else if (item.name === '水平环绕增强') {
                if(this.blackValue==10){
                  return
                }
                this.blackValue=this.blackValue+1
                item.setValue(this.blackValue.toString()); // 页面显示值修改
                // 调用厂商api
                this.setAudioEffect(item.name)
              } else if (item.name === '参考模式') {
                let origins: string[] = ['标准', '影院', '音乐', '新闻']
                if(item.value=='标准'){
                  this.contrastIndex=1
                } else if(item.value=='影院'){
                  this.contrastIndex=2
                } else if(item.value=='音乐'){
                  this.contrastIndex=3
                } else if(item.value=='新闻'){
                  this.contrastIndex=0
                }
                this.dynamicContrast = origins[this.contrastIndex];
                item.setValue(origins[this.contrastIndex]);
                this.setAudioEffect(item.name)
              }
            }
          }
        })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
          .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
