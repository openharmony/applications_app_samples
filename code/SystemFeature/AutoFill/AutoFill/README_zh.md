# AutoFill自动填充能力

### 介绍

本示例使用[application/AutoFillRequest](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/AutoFillRequest.d.ts)，[@ohos.app.ability.AutoFillExtensionAbility](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.AutoFillExtensionAbility.d.ts)，[application/ViewData](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/ViewData.d.ts)，[@ohos.app.ability.autoFillManager ](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.autoFillManager.d.ts)等接口，展示了如何使用AutoFill自动填充框架。具体而言实现了如下几点功能：

1.账号和密码的自动保存；
2.账号和密码的自动填充；
3.密码的自动生成并填充；
4.支持账号和密码自动填充后执行开发者的操作。

### 效果预览

| 登录页面                                | 注册页面                                   | 账号密码选择页面                              | 生物认证                                              | 生成密码页面                              |
| :-------------------------------------- | ------------------------------------------ | --------------------------------------------- | ----------------------------------------------------- | ----------------------------------------- |
| <img src="screenshots/loginPage.jpg" /> | <img src="screenshots/registerPage.jpg" /> | <img src="screenshots/autoFillControl.jpg" /> | <img src="screenshots/biometricauthentication.jpg" /> | <img src="screenshots/newPassWord.jpg" /> |

使用说明：

1.安装编译生成的hap包，点击PasswordBox图标即可进入应用。

2.进入应用显示登录页面，点击页面中账号输入框，在Popup中显示账号，选择其中任意账号后，页面会跳转到生物认证页面，注意需[配置账号密码自动填充时拉起Popup](#安装命令)。

3.在登录页面点击页面中密码输入框，在Popup中显示账号，选择其中任意账号后，页面会跳转到生物认证页面。

4.进入生物认证界面后点击成功按钮，页面会回到登录页面，并且账号密码输入框中分别显示出刚选择的用户名以及其对应的密码，点击失败按钮，页面回到登录页面，账号密码输入框中不能显示出刚选择的用户名以及其对应的密码。

5.在登录页面分别手动输入用户名和密码，点击"登录"按钮，页面先显示"登录成功"，随后自动触发OnSaveRequest回调，立即跳转新页面显示"请确认保存当前账号密码"，点击"确认"，页面回到"登录成功"页面。

6.在登录页面点击"注册"按钮，页面跳转到注册页面，点击注册页面中生成输入框，页面发生跳转，新页面显示"请确认是否生成密码"的标题，点击"确认"按钮，页面回到注册页面，并且生成密码输入框中显示生成的密码，注意需[配置账号密码自动填充时拉起模态窗](#安装命令)。

7.在注册页面，输入账号密码，点击"立即注册"按钮，页面先弹出"注册成功"弹窗，随后触发OnSaveRequest回调，立即跳转到页面显示"请确认保存当前账号密码"，点击"确认"按钮，返回注册界面，同时按钮变为“登录”。

### 工程目录

```
entry/src/main/ets/ 
|---autofillability
|   |---AutoFillAbility.ts                    // AutoFillExtensionAbility实现类
|---autoFillPages
|   |---AutoFillControl.ets                   // USER_NAME/Password类型的autofill控件页面 
|   |---AutoFillNewPassWord.ets               // NEW_PASSWORD类型的autofill控件页面
|   |---BiometricAuthentication.ets           // 生物认证页面
|   |---LoginSuccessPage.ets                  // 登录成功页面  
|   |---RegisterPage.ets                      // 注册页面 
|   |---SavePage.ets                          // 保存页面
|---entryability 
|   |---EntryAbility.ts            
|---pages
|   |---index.ets                            // 登录页面
```

### 具体实现

* 该示例分为五个分支：
  1. USER_NAME类型的AutoFill控件自动填充

  * USER_NAME类型的TextInput控件获焦后拉起AutoFillExtensionAbility，并触发onFillRequest回调，将选择的账号密码返回到textInput组件。
  * 源码链接：[Index.ets](entry/src/main/ets/pages/Index.ets)，[AutoFillAbility.ts](entry/src/main/ets/autofillability/AutoFillAbility.ts)，[AutoFillControl.ets](entry/src/main/ets/autofillpages/AutoFillControl.ets)
  * 参考接口：[application/AutoFillRequest](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/AutoFillRequest.d.ts)，[@ohos.app.ability.AutoFillExtensionAbility](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.AutoFillExtensionAbility.d.ts)，[application/ViewData](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/ViewData.d.ts)

   2. Password类型的AutoFill控件自动填充

  * Password类型的TextInput控件获焦后拉起AutoFillExtensionAbility，并触发onFillRequest回调，将选择的账号密码返回到textInput组件。
  * 源码链接：[Index.ets](entry/src/main/ets/pages/Index.ets)，[AutoFillAbility.ts](entry/src/main/ets/autofillability/AutoFillAbility.ts)，[AutoFillControl.ets](entry/src/main/ets/autofillpages/AutoFillControl.ets)
  * 参考接口：[application/AutoFillRequest](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/AutoFillRequest.d.ts)，[@ohos.app.ability.AutoFillExtensionAbility](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.AutoFillExtensionAbility.d.ts)， [application/ViewData](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/ViewData.d.ts)

  3. NEW_PASSWORD类型的AutoFill控件自动填充

  * NEW_PASSWORD类型的TextInput控件获焦后拉起AutoFillExtensionAbility，并触发onFillRequest回调，将选择的账号密码返回到textInput组件。
  * 源码链接：[RegisterPage.ets](entry/src/main/ets/autofillpages/RegisterPage.ets),  [AutoFillAbility.ts](entry/src/main/ets/autofillability/AutoFillAbility.ts)，[AutoFillNewPassWord.ets](entry/src/main/ets/autofillpages/AutoFillNewPassWord.ets)

  * 参考接口：[application/AutoFillRequest](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/AutoFillRequest.d.ts)，[@ohos.app.ability.AutoFillExtensionAbility](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.AutoFillExtensionAbility.d.ts)， [application/ViewData](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/ViewData.d.ts)

  4. 自动保存能力

  * 当登录页面消失，发起自动保存请求，触发onSaveRequest生命周期。
  * 源码链接：[Index.ets](entry/src/main/ets/pages/Index.ets)，[AutoFillAbility.ts](entry/src/main/ets/autofillability/AutoFillAbility.ts)，[LoginSuccessPage.ets](entry/src/main/ets/autofillpages/LoginSuccessPage.ets)，[SavePage.ets](entry/src/main/ets/autofillpages/SavePage.ets)
  * 参考接口：[application/AutoFillRequest](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/AutoFillRequest.d.ts)，[@ohos.app.ability.AutoFillExtensionAbility](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.AutoFillExtensionAbility.d.ts)

  5. 用户主动调用保存接口

  * 用户主动调用requestAutoSave接口保存账号密码。
  * 源码链接：[RegisterPage.ets](entry/src/main/ets/autofillpages/RegisterPage.ets)，[AutoFillAbility.ts](entry/src/main/ets/autofillability/AutoFillAbility.ts)，[SavePage.ets](entry/src/main/ets/autofillpages/SavePage.ets)
  * 参考接口：[application/AutoFillRequest](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/application/AutoFillRequest.d.ts)，[@ohos.app.ability.AutoFillExtensionAbility](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.AutoFillExtensionAbility.d.ts)，[@ohos.app.ability.autoFillManager](https://gitee.com/openharmony/interface_sdk-js/blob/master/api/@ohos.app.ability.autoFillManager.d.ts)

### 安装命令

1.验证生物认证界面需要在Window CMD输入如下命令配置账号密码自动填充时拉起Popup：

```
hdc shell param set persist.sys.abilityms.autofill.is_passwd_popup_window true
```

2.验证登录页面中注册功能需要在Window CMD输入如下命令配置账号密码自动填充时拉起模态窗：

```
hdc shell param set persist.sys.abilityms.autofill.is_passwd_popup_window false
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568；

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.43；

3.本示例涉及使用系统接口：AutoFillExtensionAbility.onFillRequest，AutoFillExtensionAbility.onSaveRequest，autoFillManager.requestAutoSave，需要手动替换Full SDK才能编译通过；

4.本示例需要使用DevEco Studio NEXT Beta1（Build Version: 5.0.3.800, built on September 4, 2024）才可编译运行；

5.本示例涉及权限至少为system_basic级别；

6.本示例的bundleName只能是"com.ohos.passwordbox"不可修改。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/AutoFill/AutoFill/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

