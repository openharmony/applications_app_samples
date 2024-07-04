|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用getBundleInfoForSelf接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用getBundleInfoForSelfSync接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用getProfileByAbility接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用getProfileByAbilitySync接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用GetProfileByExtensionAbility接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用GetProfileByExtensionAbilitySync接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.将.abc文件放到/data/app/el1/bundle/public/com.samples.bundlemanagement/目录下<br />2.拉起资源API示例页面 |不涉及|调用verifyAbc接口成功，页面正常展示字符串文本|否|Pass|
|进入主页| 1.将.abc文件放到/data/app/el1/bundle/public/com.samples.bundlemanagement/目录下                                                                                          <br />2.拉起资源API示例页面 |不涉及|调用deleteAbc接口成功，页面正常展示字符串文本|否|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用CanOpenLink接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用IsDefaultApplication接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起资源API示例页面 |不涉及|调用IsDefaultApplicationSync接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起Overlay示例页面，根据静态overlay脚本安装共享hsp包 |不涉及|调用SetOverlayEnabled接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起OverlayModuleInfo示例页面 |不涉及|调用GetOverlayModuleInfo接口成功，页面正常展示字符串文本|是|Pass|
|进入主页| 1.拉起OverlayModuleInfo示例页面 |不涉及|调用GetTargetOverlayModuleInfos接口成功，页面正常展示字符串文本|是|Pass|