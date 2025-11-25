# 合理使用系统接口测试用例归档

## 用例表

| 测试功能	                         | 预置条件	        | 输入                   | 	预期输出                  |	测试结果 |
|-------------------------------|--------------|----------------------|------------------------|--------|
| 拉起应用	                         | 设备正常运行	      | 	                    | 成功拉起应用	                |Pass 
| 进入getStringSync(id)页面	        | 成功进入页面	      | 点击getStringSync(id)	 | 成功进入资源获取1页面	           |Pass
| 进入getStringSync(Resource)页面	  | 成功进入页面	      | 点击getStringSync(Resource)	 | 成功进入资源获取2页面	           |Pass
| 进入UsingWordBreak页面	           | 成功进入页面	      | 点击UsingWordBreak	 | 成功进入文本断行1页面	           |Pass
| 进入UsingZeroWidthSpace页面	      | 成功进入页面	      | 点击UsingZeroWidthSpace	 | 成功进入文本断行2页面	           |Pass
| 进入GetAnonymousIdSync页面	       | 成功进入页面	      | 点击GetAnonymousIdSync	 | 成功进入IFAA免密认证的匿名化ID1页面	 |Pass
| 进入GetAnonymousId页面	           | 成功进入页面	      | 点击GetAnonymousId	 | 成功进入IFAA免密认证的匿名化ID2页面	 |Pass
| 进入RuntimeInterface页面	         | 成功进入页面	      | 点击RuntimeInterface	 | 成功进入Intl国际化	 |Pass
| 进入LocalizationKitInterface页面	 | 成功进入页面	      | 点击LocalizationKitInterface	 | 成功进入LocalizationKit国际化	 |Pass