如果已经初始化，直接启动即可

- `启动本地服务 gitboook serve`
接下来，我们输入 `$ gitbook serve` 命令，然后在浏览器地址栏中输入 `http://localhost:4000`

- 新建目录

首先我们来看一下gitbook目录结构及相关文件



book.json

主要存放配置信息


  {
  "plugins": [
    "collapsible-menu",
    "anchor-navigation-ex",
    "tbfed-pagefooter",
    "disqus"
  ],
  "title": "发布业务逻辑梳理",
  "pluginsConfig": {
      "tbfed-pagefooter": {
          "copyright":"Copyright &copy ershouche-FE 2019",
          "modify_label": "文件修订时间：",
          "modify_format": "YYYY-MM-DD HH:mm:ss"
      },
      "disqus": {
        "shortName": "gitbookuse"
      }
  }
  }




SUMMARY.md

Gitbook 的章节目录
![image](https://tva1.sinaimg.cn/large/007S8ZIlly1ggyrd129scj30ng0do41n.jpg)


新增目录文件时执行gitbook init会自动创建文件到对于目录下面

注意：

最顶层的是一级目录，缩进一次的是二级目录，默认会收缩进对应的一级目录里面，如果想创建更深层次的目录结构，就在对应的子目录下面以缩进的方式创建

该文件里面的缩进对于文档侧边栏目录的缩进

<img src="https://img.58cdn.com.cn/escstatic/fecar/pmuse/publish/fabu.png" width="200" />

- 构建gitbook build

执行该命令会生成一个_book文件夹，里面的内容对于生成的HTML文件

## 配置book.json

### 配置说明

|     变量      |                             描述                             |
| :-----------: | :----------------------------------------------------------: |
|     root      |       包含所有图书文件的根文件夹的路径，除了 book.json       |
|   structure   |              指定自述文件，摘要，词汇表等的路径              |
|     title     | 您的书名，默认值是从 README 中提取出来的。在 GitBook.com 上，这个字段是预填的。 |
|  description  | 您的书籍的描述，默认值是从 README 中提取出来的。在 GitBook.com 上，这个字段是预填的。 |
|    author     |         作者名。在GitBook.com上，这个字段是预填的。          |
|     isbn      |                      国际标准书号 ISBN                       |
|   language    | 本书的语言类型 —— [ISO code](https://links.jianshu.com/go?to=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FList_of_ISO_639-1_codes) 。默认值是 `en` |
|   direction   | 文本阅读顺序。可以是 rtl （从右向左）或 ltr （从左向右），默认值依赖于 language 的值。 |
|    gitbook    |    应该使用的GitBook版本，并接受类似于 `>=3.0.0` 的条件。    |
|     links     |                   在左侧导航栏添加链接信息                   |
|    plugins    | 要加载的插件列表([官网插件列表](https://links.jianshu.com/go?to=https%3A%2F%2Fdocs.gitbook.com%2Fv2-changes%2Fimportant-differences%23plugins)) |
| pluginsConfig |                          插件的配置                          |

### 默认插件


- highlight - 语法高亮插件
- search - 搜索插件
- sharing - 分享插件
- font-settings - 字体设置插件
- livereload - 热加载插件

搜索

![image-20200716145919634](https://tva1.sinaimg.cn/large/007S8ZIlly1ggstn51gezj30fy04gt8q.jpg)

字体

![image-20200716145955656](https://tva1.sinaimg.cn/large/007S8ZIlly1ggstnprwzij30b205wwel.jpg)

分享

![image-20200716150040280](https://tva1.sinaimg.cn/large/007S8ZIlly1ggstoianbfj308006zt8t.jpg)



### 删除默认插件

在平时开发中比如分享给出的都是一些国外的社交网站 对于我们没太大用户 那么我们可以删除默认配置

在插件配置在加`-`,配置完执行`gitbook install`即可

plugins: [
  "-sharing"
]

效果如下：

![image-20200716150604078](https://tva1.sinaimg.cn/large/007S8ZIlly1ggstu43pr7j31qo0icwgl.jpg)

右侧不再展示分享相关的按钮

### 常用配置

#### 代码复制

"plugins": [
  "code"
]

效果如下：

![image-20200720142753077](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxf7nx56kj317q06sjru.jpg)

代码复制按钮

"plugins": [
  "copy-code-button"
]

![image-20200720144333351](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxfnx31w6j318607cjrw.jpg)

#### 目录折叠

"plugins": [
  "expandable-chapters"
]

效果如下：

![image-20200720142951146](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxf9o7rq1j30cm0bcaap.jpg)

"plugins": [
  "expandable-chapters-small"
]

和上面一样都是折叠目录的，区别就是下面的箭头要细一些。

效果如下：

![image-20200720143153085](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxfbrr8ugj30g20egwfe.jpg)

#### 回到顶部

"plugins": [
  "back-to-top-button"
]

效果如下：

![image-20200720143530843](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxffk1906j31gu0g40v0.jpg)

#### 高级搜索

去除默认的search搜索和lunr，在搜索结果中，关键字会高亮；自带的 search 插件，关键字不会高亮

"plugins": [
        "-lunr",
        "-search",
        "search-pro"
  ]

原生搜索效果：

![image-20200720144425681](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxfotz6s0j31ye0jggro.jpg)

高级搜索：

![image-20200720144917280](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxftwiu0kj320s0ri12z.jpg)

搜索关键字高亮，支持中文、拼音和英文

#### 分享

分享当前页面，比默认的 sharing 插件多了一些分享方式

"plugins": ["-sharing", "sharing-plus"],
  "pluginsConfig": {
      "sharing": {
           "douban": false,
           "facebook": false,
           "google": true,
           "pocket": false,
           "qq": false,
           "qzone": true,
           "twitter": false,
           "weibo": true,
        "all": [
             "douban", "facebook", "google", "instapaper", "linkedin","twitter", "weibo",
             "messenger","qq", "qzone","viber","whatsapp"
         ]
     }

参数配置里面true的默认展示图标，false的默认不展示；all里面的会在分享按钮的下拉列表里面全部展示出来。

效果如下：

![image-20200720145713703](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxg25dfstj30ie0s8wg1.jpg)

分享效果如下：

![image-20200720145824437](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxg3dey89j315a0totcl.jpg)

#### 配置页脚

"plugins": [
     "tbfed-pagefooter"
  ],
  "pluginsConfig": {
      "tbfed-pagefooter": {
          "copyright":"Copyright &copy mine 2000-2020",
          "modify_label": "文件修订时间：",
          "modify_format": "YYYY-MM-DD HH:mm:ss"
      }
  }

效果如下：

![image-20200720152236897](https://tva1.sinaimg.cn/large/007S8ZIlly1ggxgskey19j318q03ijrs.jpg)

