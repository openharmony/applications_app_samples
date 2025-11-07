# 测试用例归档

## 用例表

| 测试功能                   | 预置条件                          |输入| 预期输出                                                                       |是否自动|测试结果|
|------------------------|-------------------------------|-------------------------------|----------------------------------------------------------------------------|--------------------------------|--------------------------------|
| 拉起应用                   | 	设备正常运行                       |	无| 成功拉起应用                                                                     |是|Pass|
| GetPreferencesSync     | 	无                            |	点击GetPreferencesSync按钮| 	log打印Succeeded in get preferences.                                        |是|Pass|
| GetPreferencesSyncGSKV | 	isStorageTypeSupported返回true |	点击GetPreferencesSyncGSKV按钮| 	log打印Succeeded in get preferences GSKV.                                   |是|Pass|
| PutSync                | 	成功执行GetPreferencesSync     |	点击PutSync按钮| 	log打印Succeeded in putting data.                                           |是|Pass|
| GetSync                | 	成功执行GetPreferencesSync，PutSync          |	点击GetSync按钮| 	log打印Succeeded in getting val.                                            |是|Pass|
| DeleteSync             | 	成功执行GetPreferencesSync，PutSync          |	点击DeleteSync按钮，点击GetSync按钮| 	log打印Succeeded in deleting data.，Get执行后log打印The 'startup' value is default|是|Pass|
| Flush                  | 	成功执行GetPreferencesSync，PutSync          |	点击Flush按钮| 	log打印Succeeded in flushing.                                               |是|Pass|
| XML模式下的on              | 	成功执行GetPreferencesSync，PutSync          |	点击XMLOn按钮| 	log打印The key startup changed.                                             |是|Pass|
| GSKV模式下的on             | 	成功执行GetPreferencesSyncGSKV，PutSync                  |	点击GSKVOn按钮| 	log打印The key startup changed.                                             |是|Pass|
| DeleteXMLPreferences           | 	成功执行GetPreferencesSync              |	点击DeleteXMLPreferences按钮| 	log打印Succeeded in deleting preferences，再次执行PutSync等按钮log打印dataPreferences not initialized |是|Pass|
| DeleteGSKVPreferences          | 	成功执行GetPreferencesSyncGSKV               |	点击DeleteGSKVPreferences按钮| 	log打印Succeeded in deleting preferences，再次执行PutSync等按钮log打印dataPreferences not initialized |是|Pass|