# 语言基础类库测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用        |	设备正常运行|	无	|成功拉起应用|Pass|
|查看应用菜单显示|	成功拉起应用|	无	|显示内容正常|Pass|
|Xml & ConvertXml(XML解析，生成与转换)| 成功拉起应用，位于首页 |	点击首页菜单中**Xml & ConvertXml(XML解析，生成与转换)**	|进入Xml界面，内容显示正常|Pass|
|构建xml文本功能测试|	位于Xml页|	点击Xml 生成按钮|	构建xml文本，并在按钮上方的文本框显示xml文本内容|Pass|
|解析已经预置的xml文本功能测试|	位于Xml页|	点击Xml 解析按钮|	会解析已经预置的xml文本，并在文本框显示解析信息|Pass|
|将预置的xml文本转换为JavaScript对象功能测试|	位于Xml页|	点击Xml 转换按钮|	会将预置的xml文本转换为JavaScript对象，并在文本框显示|Pass|
|util工具函数| 成功拉起应用，位于首页 |	点击首页菜单中**Util工具函数**	|进入Util界面，内容显示正常|Pass|
|字符串编解码| 位于Util页面 |	点击util页面中的**StringCode(字符串编解码)**	|进入字符串编解码界面，内容显示正常|Pass|
|字符串编解码| 位于字符串编解码页面 |	点击特定格式输出	|输出不同格式的结果|Pass|
|字符串编解码| 位于字符串编解码页面 |	点击文本编码器	|输出编码后的文本，返回读取与写入信息|Pass|
|字符串编解码| 位于字符串编解码页面 |	点击文本译码器	|输出译码后的文本|Pass|
|有理数| 位于Util页面 |	点击util页面中的**有理数**	|进入有理数界面，内容显示正常|Pass|
|有理数| 位于有理数页面 |	点击有理数界面的功能按钮	|界面中的显示框中显示获取的结果值|Pass|
|LRUCache (缓冲区)| 位于Util页面 |	点击util页面中的**缓冲区**	|进入缓冲区界面，内容显示正常|Pass|
|验证点击初始化缓冲区是否正常显示缓冲区内容|	位于缓冲区页面|   点击初始化缓冲区|   正常显示缓冲区内容|Pass|
|验证点击获取缓冲区容量是否正常显示缓冲区内容|	位于缓冲区页面|   点击获取缓冲区容量|   正常显示获取缓冲区容量|Pass|
|验证点击更新缓冲区容量是否正常显示缓冲区内容|	位于缓冲区页面|   点击更新缓冲区容量|   正常显示更新缓冲区容量|Pass|
|验证点击获取缓冲区字符串是否正常显示缓冲区内容|	位于缓冲区页面|   点击获取缓冲区字符串|   正常获取缓冲区字符串|Pass|
|验证点击添加键值对是否正常显示缓冲区内容|	位于缓冲区页面|   点击添加键值对|   正常添加键值对|Pass|
|验证点击获取键对应的值是否正常显示缓冲区内容|	位于缓冲区页面|   点击获取键对应的值|   正常获取键对应的值|Pass|
|验证点击获取所有键值对是否正常显示缓冲区内容|	位于缓冲区页面|   点击获取所有键值对|   正常获取所有键值对|Pass|
|验证点击删除指定键及关联值是否正常显示缓冲区内容|	位于缓冲区页面|   点击删除指定键及关联值|   正常删除指定键及关联值|Pass|
|验证点击清除所有键值对是否正常显示缓冲区内容|	位于缓冲区页面|   点击清除所有键值对|   正常清除所有键值对|Pass|
|验证点击查看操作记录是否正常显示缓冲区内容|	位于缓冲区页面|   点击查看操作记录|   正常查看操作记录|Pass|
|Base64Helper (Base64编解码)| 位于Util页面 |	点击util页面中的**Base64编解码**	|进入Base64编解码界面，内容显示正常|Pass|
|验证编码功能|	位于Base64编解码页面|   点击编码|   正常显示编码后的内容|Pass|
|验证解码功能|	位于Base64编解码页面|   点击解码|   正常显示解码后的内容|Pass|
|TypeCheck (类型检查)| 位于Util页面 |	点击util页面中的**类型检查**	|进入类型检查界面，内容显示正常|Pass|
|显示预置值功能测试|	位于类型检查页|	点击显示预置值按钮|	显示预置值|Pass|
|校验预置值功能测试|	类型检查页|	点击校验预置值按钮|	对预置值进行校验，并输出校验结果|Pass|
|Url字符串解析| 成功拉起应用，位于首页 |	点击首页菜单中**Url字符串解析**	|进入Url字符串解析界面，内容显示正常|Pass|
|验证点击插入键值对到查询字符串，查询字符串是否成功插入键值对|	位于URL字符串解析页面|   点击插入键值对到查询字符串|   插入键值对到查询字符串|Pass|
|验证点击删除键值对，查询字符串是否成功删除键值对|	位于URL字符串解析页面|   点击删除键值对|   查询字符串成功删除键值对|Pass|
|验证点击获取指定名称对应的第一个值，查询字符串是否成功获取指定名称对应的第一个值|	位于URL字符串解析页面|   点击获取指定名称对应的第一个值|   查询字符串成功获取指定名称对应的第一个值|Pass|
|验证点击设置键的新值，查询字符串是否成功设置键的新值|	位于URL字符串解析页面|   点击设置键的新值|   查询字符串成功设置键的新值|Pass|
|TaskPool启动任务池| 成功拉起应用，位于首页 | 点击首页菜单中**TaskPool（启动任务池）** | 进入TaskPool启动任务池界面，内容显示正常 |Pass|
|验证点击Execute task| 位于TaskPool启动任务池页面 | 点击Execute task按钮 | 正常启动Task，开始计数 |Pass|
|验证点击Cancel task| 位于TaskPool启动任务池页面 | 点击Cancel task按钮 | 正常取消Task，停止计数 |Pass|
|Deque线性容器| 成功拉起应用，位于首页 | 点击首页菜单中**Deque线性容器** | 进入Deque线性容器界面，内容显示正常 |Pass|
| 验证点击加号，是否正常跳转到新增联系人页面                   | 位于Deque线性容器页面 | 点击加号按钮 | 进入新增联系人页面 |Pass|
|验证点击请输入姓名输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击请选择文本框，是否弹出文本选择框| 位于新增联系人页面 | 点击请选择文本框 | 弹出文本选择框 |Pass|
|验证点击文本选择框的取消按钮，是否正常关闭文本选择框| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框 |Pass|
|验证点击文本选择框的确定按钮，是否正常关闭文本选择框并把当前选择的文本填充到请选择文本框中| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框并把当前选择的文本填充到请选择文本框中 |Pass|
|验证点击请输入电话输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Deque线性容器页面列表| 位于新增联系人页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Deque线性容器页面列表 | Pass     |
|新增三条联系人数据后，验证第二条数据删除按钮是否不可点击| 位于Deque线性容器页面 | 点击删除按钮 | 删除按钮不可点击（点击后无任何操作被执行） | Pass |
|新增三条联系人数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Deque线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条联系人数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Deque线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|HashMap非线性容器| 成功拉起应用，位于首页     | 点击首页菜单中**HashMap非线性容器**                     | 进入HashMap非线性容器界面，内容显示正常                      | Pass     |
|验证点击加号，是否正常跳转到新增HashMap页面| 位于HashMap非线性容器页面  | 点击加号按钮                                            | 进入新增HashMap页面                                          | Pass     |
|验证点击请输入Key输入框，是否弹出输入法并能进行数据输入| 位于新增HasMap页面         | 点击请输入Key输入框                                     | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击请输入Value输入框，是否弹出输入法并能进行数据输入| 位于新增HasMap页面         | 点击请输入Value输入框                                   | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的HashMap数据并刷新HashMap非线性容器页面列表| 位于新增HasMap页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的HashMap数据并刷新HashMap非线性容器页面列表 | Pass     |
|新增三条Key/Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于HashMap非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于HashMap非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于HashMap非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|HashSet非线性容器| 成功拉起应用，位于首页     | 点击首页菜单中**HashSet非线性容器**                     | 进入HashSet非线性容器界面，内容显示正常                      | Pass     |
|验证点击加号，是否正常跳转到新增HashSet页面| 位于HashSet非线性容器页面  | 点击加号按钮                                            | 进入新增HashSet页面                                          | Pass     |
|验证点击请输入Value输入框，是否弹出输入法并能进行数据输入| 位于新增HasSet页面         | 点击请输入Value输入框                                   | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的HashSet数据并刷新HashSet非线性容器页面列表| 位于新增HasSet页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的HashSet数据并刷新HashSet非线性容器页面列表 | Pass     |
|新增三条Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于HashSet非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于HashSet非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于HashSet非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|LightWeightMap非线性容器| 成功拉起应用，位于首页     | 点击首页菜单中**LightWeightMap非线性容器**       | 进入LightWeightMap非线性容器界面，内容显示正常           | Pass     |
|验证点击加号，是否正常跳转到新增LightWeightMap页面| 位于LightWeightMap非线性容器页面 | 点击加号按钮                                            | 进入新增LightWeightMap页面                           | Pass     |
|验证点击请输入Key输入框，是否弹出输入法并能进行数据输入| 位于新增LightWeightMap页面 | 点击请输入Key输入框                                     | 弹出输入法，可进行数据输入                                   | Pass     |
| 验证点击请输入Value输入框，是否弹出输入法并能进行数据输入    | 位于新增LightWeightMap页面 | 点击请输入Value输入框                                   | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的LightWeightMap数据并刷新LightWeightMap非线性容器页面列表| 位于新增LightWeightMap页面 | 点击对勾按钮 | 关闭当前页面返回到上一页，新增一条新的LightWeightMap数据并刷新LightWeightMap非线性容器页面列表 |Pass|
|新增三条Key/Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LightWeightMap非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LightWeightMap非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LightWeightMap非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|LightWeightSet非线性容器| 成功拉起应用，位于首页 | 点击首页菜单中**LightWeightSet非线性容器** | 进入LightWeightSet非线性容器界面，内容显示正常 |Pass|
|验证点击加号，是否正常跳转到新增LightWeightSet页面| 位于LightWeightSet非线性容器页面 | 点击加号按钮 | 进入新增LightWeightSet页面 |Pass|
|验证点击请输入Value输入框，是否弹出输入法并能进行数据输入| 位于新增LightWeightSet页面 | 点击请输入Value输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的LightWeightSet数据并刷新LightWeightSet非线性容器页面列表| 位于新增LightWeightSet页面 | 点击对勾按钮 | 关闭当前页面返回到上一页，新增一条新的LightWeightSet数据并刷新LightWeightSet非线性容器页面列表 |Pass|
|新增三条Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LightWeightSet非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LightWeightSet非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LightWeightSet非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|LinkedList线性容器| 成功拉起应用，位于首页 | 点击首页菜单中**LinkedList线性容器** | 进入LinkedList线性容器界面，内容显示正常 |Pass|
| 验证点击加号，是否正常跳转到新增联系人页面                   | 位于LinkedList线性容器页面 | 点击加号按钮 | 进入新增联系人页面 |Pass|
|验证点击请输入姓名输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击请选择文本框，是否弹出文本选择框| 位于新增联系人页面 | 点击请选择文本框 | 弹出文本选择框 |Pass|
|验证点击文本选择框的取消按钮，是否正常关闭文本选择框| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框 |Pass|
|验证点击文本选择框的确定按钮，是否正常关闭文本选择框并把当前选择的文本填充到请选择文本框中| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框并把当前选择的文本填充到请选择文本框中 |Pass|
|验证点击请输入电话输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的联系人数据并刷新LinkedList线性容器页面列表| 位于新增联系人页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的联系人数据并刷新LinkedList线性容器页面列表 | Pass     |
|新增三条联系人数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LinkedList线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条联系人数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LinkedList线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条联系人数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于LinkedList线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|PlainArray非线性容器| 成功拉起应用，位于首页     | 点击首页菜单中**PlainArray非线性容器** | 进入PlainArray非线性容器界面，内容显示正常 | Pass     |
|验证点击加号，是否正常跳转到新增PlainArray页面| 位于PlainArray非线性容器页面 | 点击加号按钮                                            | 进入新增PlainArray页面                 | Pass     |
|验证点击请输入Key输入框，是否弹出输入法并能进行数据输入| 位于新增PlainArray页面 | 点击请输入Key输入框                                     | 弹出输入法，可进行数据输入                                   | Pass     |
| 验证点击请输入Value输入框，是否弹出输入法并能进行数据输入    | 位于新增PlainArray页面 | 点击请输入Value输入框                                   | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的PlainArray数据并刷新PlainArray非线性容器页面列表| 位于新增PlainArray页面 | 点击对勾按钮 | 关闭当前页面返回到上一页，新增一条新的PlainArray数据并刷新PlainArray非线性容器页面列表 |Pass|
|新增三条Key/Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于PlainArray非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于PlainArray非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于PlainArray非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|Queue线性容器| 成功拉起应用，位于首页 | 点击首页菜单中**Queue线性容器** | 进入Queue线性容器界面，内容显示正常 |Pass|
| 验证点击加号，是否正常跳转到新增联系人页面                   | 位于Queue线性容器页面 | 点击加号按钮 | 进入新增联系人页面 |Pass|
|验证点击请输入姓名输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击请选择文本框，是否弹出文本选择框| 位于新增联系人页面 | 点击请选择文本框 | 弹出文本选择框 |Pass|
|验证点击文本选择框的取消按钮，是否正常关闭文本选择框| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框 |Pass|
|验证点击文本选择框的确定按钮，是否正常关闭文本选择框并把当前选择的文本填充到请选择文本框中| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框并把当前选择的文本填充到请选择文本框中 |Pass|
|验证点击请输入电话输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Queue线性容器页面列表| 位于新增联系人页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Queue线性容器页面列表 | Pass     |
|新增三条联系人数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Queue线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条联系人数据后，验证第二条数据删除按钮是否不可点击| 位于Queue线性容器页面 | 点击删除按钮 | 删除按钮不可点击（点击后无任何操作被执行） | Pass |
|新增三条联系人数据后，验证第三条数据删除按钮是否不可点击| 位于Queue线性容器页面 | 点击删除按钮 | 删除按钮不可点击（点击后无任何操作被执行） | Pass |
|Stack线性容器| 成功拉起应用，位于首页 | 点击首页菜单中**Stack线性容器** | 进入Stack线性容器界面，内容显示正常 |Pass|
| 验证点击加号，是否正常跳转到新增联系人页面                   | 位于Queue线性容器页面 | 点击加号按钮 | 进入新增联系人页面 |Pass|
|验证点击请输入姓名输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击请选择文本框，是否弹出文本选择框| 位于新增联系人页面 | 点击请选择文本框 | 弹出文本选择框 |Pass|
|验证点击文本选择框的取消按钮，是否正常关闭文本选择框| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框 |Pass|
|验证点击文本选择框的确定按钮，是否正常关闭文本选择框并把当前选择的文本填充到请选择文本框中| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框并把当前选择的文本填充到请选择文本框中 |Pass|
|验证点击请输入电话输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Stack线性容器页面列表| 位于新增联系人页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Stack线性容器页面列表 | Pass     |
|新增三条联系人数据后，验证第一条数据删除按钮是否不可点击| 位于Stack线性容器页面 | 点击删除按钮 | 删除按钮不可点击（点击后无任何操作被执行） | Pass |
|新增三条联系人数据后，验证第二条数据删除按钮是否不可点击| 位于Stack线性容器页面 | 点击删除按钮 | 删除按钮不可点击（点击后无任何操作被执行） | Pass |
|新增三条联系人数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Stack线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|TreeMap非线性容器| 成功拉起应用，位于首页     | 点击首页菜单中**TreeMap非线性容器**              | 进入TreeMap非线性容器界面，内容显示正常               | Pass     |
|验证点击加号，是否正常跳转到新增TreeMap页面| 位于TreeMap非线性容器页面 | 点击加号按钮                                            | 进入新增TreeMap页面                                   | Pass     |
|验证点击请输入Key输入框，是否弹出输入法并能进行数据输入| 位于新增TreeMap页面  | 点击请输入Key输入框                                     | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击请输入Value输入框，是否弹出输入法并能进行数据输入| 位于新增TreeMap页面  | 点击请输入Value输入框                                   | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的TreeMap数据并刷新TreeMap非线性容器页面列表| 位于新增TreeMap页面  | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的TreeMap数据并刷新TreeMap非线性容器页面列表 | Pass     |
|新增三条Key/Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于TreeMap非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于TreeMap非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Key/Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于TreeMap非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|TreeSet非线性容器| 成功拉起应用，位于首页     | 点击首页菜单中**TreeSet非线性容器**              | 进入TreeSet非线性容器界面，内容显示正常               | Pass     |
|验证点击加号，是否正常跳转到新增HashSet页面| 位于TreeSet非线性容器页面 | 点击加号按钮                                            | 进入新增TreeSet页面                                   | Pass     |
|验证点击请输入Value输入框，是否弹出输入法并能进行数据输入| 位于新增TreeSet页面  | 点击请输入Value输入框                                   | 弹出输入法，可进行数据输入                                   | Pass     |
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的TreeSet数据并刷新TreeSet非线性容器页面列表| 位于新增TreeSet页面  | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的TreeSet数据并刷新TreeSet非线性容器页面列表 | Pass     |
|新增三条Value数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于TreeSet非线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条Value数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于TreeSet非线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条Value数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于TreeSet非线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |
|Vector线性容器| 成功拉起应用，位于首页 | 点击首页菜单中**Vector线性容器** | 进入Vector线性容器界面，内容显示正常 |Pass|
| 验证点击加号，是否正常跳转到新增联系人页面                   | 位于Queue线性容器页面 | 点击加号按钮 | 进入新增联系人页面 |Pass|
|验证点击请输入姓名输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击请选择文本框，是否弹出文本选择框| 位于新增联系人页面 | 点击请选择文本框 | 弹出文本选择框 |Pass|
|验证点击文本选择框的取消按钮，是否正常关闭文本选择框| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框 |Pass|
|验证点击文本选择框的确定按钮，是否正常关闭文本选择框并把当前选择的文本填充到请选择文本框中| 位于新增联系人页面 | 点击取消按钮 | 关闭文本选择框并把当前选择的文本填充到请选择文本框中 |Pass|
|验证点击请输入电话输入框，是否弹出输入法并能进行数据输入| 位于新增联系人页面 | 点击请输入姓名输入框 | 弹出输入法，可进行数据输入 |Pass|
|验证点击对勾按钮，是否关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Vector线性容器页面列表| 位于新增联系人页面         | 点击对勾按钮                                            | 关闭当前页面返回到上一页，新增一条新的联系人数据并刷新Vector线性容器页面列表 | Pass     |
|新增三条联系人数据后，验证点击第一条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Vector线性容器页面 | 点击删除按钮 | 可删除第一条数据并刷新列表 | Pass |
|新增三条联系人数据后，验证点击第二条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Vector线性容器页面 | 点击删除按钮 | 可删除第二条数据并刷新列表 | Pass |
|新增三条联系人数据后，验证点击第三条数据删除按钮，是否正常删除列表数据并刷新列表| 位于Vector线性容器页面 | 点击删除按钮 | 可删除第三条数据并刷新列表 | Pass |