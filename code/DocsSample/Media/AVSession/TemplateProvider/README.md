# 音频模板——提供方

### 介绍

本示例主要展示了音频模板（模板提供方）的相关功能，使用[@ohos.multimedia.avMusicTemplate](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-avsession-kit/arkts-apis-avsession-AVMusicTemplate.md)等接口实现音频模板提供方与音频模板控制方自定义信息的交互功能。

> 注意：
> 此示例仅展示音频模板提供方的相关功能，如果需要音频模板提供的完整的自定义信息交互功能，请将本示例与[音频模板控制方示例](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/AVSession/TemplateController)共同使用。

### 效果预览

无直接界面，主要提供数据。

#### 使用说明（需与音频模板控制方一起使用）

1. 打开音频模板提供方示例应用。
2. 音频模板按需注册相应的数据获取方法监听。
3. 针对无法直接获取结果的数据，在发生变化时，主动调用相应的设置方法。
4. 拉起音频模板控制方实例应用。


### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets/
|---entryAbility
|---|---EntryAbility.ets                             //逻辑实现
```

### 具体实现

* 界面相关的实现都封装在entryAbility/EntryAbility.ets下，源码参考：[entryAbility/EntryAbility.ets](./entry/src/main/ets/entryAbility/EntryAbility.ets)
  * 创建音频模板对象，关键代码段：

    ```js
    import avMusicTemplate from '@ohos.multimedia.avMusicTemplate';
    import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';

    export default class EntryAbility extends UIAbility {
      private template: avMusicTemplate.AVMusicTemplate | undefined = undefined;
    
      onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        console.info('onCreate');
        this.createTemplate();
      }
    
      onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        console.info('onNewWant');
        this.createTemplate();
      }
    
      /**
       * 创建音频模板
       */
      private createTemplate() {
        if (this.template) {
          console.warn('createTemplate: template not undefined');
          return
        }
        try {
          this.template = avMusicTemplate.createAVMusicTemplate(avMusicTemplate.AVMusicTemplateType.DEFAULT);
          console.info('createTemplate: success');
        } catch (e) {
          console.error(`createTemplate, errCode: ${e?.code}`);
        }
      }
    }
    ```

    * 根据需要注册相关监听，注册后控制方可以读取使用该信息。

      onQueryMainTabs：注册查询主标签事件监听。

      onQueryMediaTabContent：注册查询媒体标签内容事件监听。

      onQueryMediaEntity：注册查询媒体实体事件监听。

      onQueryCompilation：注册查询合集事件监听。

      onQueryPlaylist：注册查询播放列表事件监听。

      onQueryCurrentSingle：注册查询当前单曲事件监听。

      onQueryCompilationByKeyword：注册按关键字查询合集事件监听。

      onQueryMediaEntityByKeyword：注册按关键字查询媒体实体事件监听。

      onQueryRecommendMediaEntityList：注册查询推荐媒体列表事件监听。

      onQueryHotWords：注册查询热词事件监听。

      onQuerySearchHistory：注册查询搜索历史事件监听。

      onClearSearchHistory：注册清除搜索历史事件监听。

      onLogin：注册登录事件监听。

      onRequestDialogInfo：注册请求对话框信息监听。

      onHandleMemberPurchase：注册处理购买会员事件监听。

      onQueryCustomContent：注册查询自定义内容事件监听。

      onDownloadMediaEntity：注册下载媒体实体事件监听。

      onSettingsChange：注册设置改变事件监听。

      onProblemAndAdvice：注册问题与建议活动事件监听。

      onPlayForSearch：注册搜播事件监听。

      onExecuteAction：注册执行操作事件监听。

      onPlayMediaEntity：注册播放媒体实体事件监听。

      onFavoriteMediaEntity：注册收藏媒体实体事件监听。

  * 也可以主动向模板控制方同步数据。需要控制方注册相应的监听。

    setUserInfo：向媒体中心同步用户信息。

    setDialogCommand：向媒体中心同步对话框命令。

    setCurrentSingle：向媒体中心同步当前单曲。

    setMediaEntities：向媒体中心同步媒体资源变更信息。

    setTabContent：向媒体中心同步标签页内容信息。

    setPlaylist：向媒体中心同步播放列表。

    setDownloadMediaEntityStatus：向媒体中心同步单曲下载状态信息。

    setCustomElements：向媒体中心同步自定义元素变更信息。

    setSettings：向媒体中心同步设置信息。

    reportExecuteAction：向媒体中心同步执行操作信息。

    setExtensionAbility：向媒体中心同步用于被拉起的Ability。


### 相关权限

1. 长时任务权限ohos.permission.KEEP_BACKGROUND_RUNNING

   如果需要让媒体提供方应用在后台运行或响应命令，需要注册长时任务权限[ohos.permission.KEEP_BACKGROUND_RUNNING](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionkeep_background_running)

   请在需要后台运行的Ability的`module.json5`中添加以下配置：

   ```json5
   {
      "module": {
         "requestPermissions": [
           {
              "name": "ohos.permission.KEEP_BACKGROUND_RUNNING"
           }
         ]
      }
   }
   ```

   添加配置后，需要在逻辑代码中进行申请长时任务的操作，示例代码如下：

   ```ets
   async startContinuousTask(){
     let wantAgentInfo = {
       wants:[
         {
           bundleName:"com.samples.mediaprovider",
           abilityName:"com.samples.mediaprovider.EntryAbility"
         }
       ],
       operationType : WantAgent.OperationType.START_ABILITY,
       requestCode: 0,
       wantAgentFlags: [WantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
     };
     let want = await WantAgent.getWantAgent(wantAgentInfo);
     await backgroundTaskManager.startBackgroundRunning(globalThis.context,      backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,want);
   }
   ```

### 依赖

此示例仅展示音频模板提供方的相关功能，如果需要音频模板提供的完整的自定义信息交互功能，请将本示例与[[音频模板控制方示例](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/AVSession/TemplateController)](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/Media/AVSession/TemplateController)共同使用。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：智选车。
2. 本示例为Stage模型，支持API23版本SDK，SDK版本号(API Version 23 Release),镜像版本号(6.1 Release)
3. 本示例需要使用DevEco Studio 版本号(6.1 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/Media/AVSession/TemplateProvider > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```