# Mind Base 设计

> MindBase更像是另一种"Java语言", Dart语言类比构建JVM的"C语言"
> 
> 每个表对应一个实体类(不是聚合根), 直接使用 Accessor进行读写; 聚合根暂不使用

## 标志:

- `#dev` 设计中的实现功能选项(尚未确定是否要实现)
- `#todo` 预备实现的功能(确定下一步要实现)
- `#check` 当前已实现的功能



---

## 其他概念

- 函子: https://segmentfault.com/a/1190000023744960

- 函数式编程: https://www.sandromaglione.com/practical-functional-programming-step-by-step-haskell-typescript-dart-part-1/



---

## RecordMeta 记录元数据设计

### Meta v3 取消改名

### Meta v2 (重命名为Schema) #check

- 将 List<Attribute> 改为 Map<int,Attribute>. 即,将Attr存储的`k`提取到Meta内部.
  
  - 优点: 便于序列化, 便于分类key值

- 类重命名为 Schema

---

## Attr 属性设计

### 属性 v5 #dev

> 完全实现 FP
> 
> 参考: [函数式编程进阶：杰克船长的黑珍珠号 - 掘金](https://juejin.cn/post/6844904034260910094)

- 重命名 Value为 Container , 或者直接使用 dartz包 内的相关类



### 属性 v4 #todo

> 引入 FP概念, Value对应`函子`, 

Attr的构成:

- k, 即 `k值`, 是一个Meta中,Attr的唯一标识, int类型, 自增

- name `列名`, 展示在视图上的表头名称

- memo `列备注`

- calc `计算表达式`, 如果某个属性是 `get方法`, 则需要调用 `calc`计算得到`show值`, 可以为空





### 属性 V3B #dev

> 相关: 表达式v4
> 
> 即 `Dart like` 模式, 原始类型都是`对象`
> 
> 可能不太合适, 将原始的String, int等作特殊处理(即`Java like`性能会比较好)

- 将属性本身作为一个引用`关系`, 引用的是MindBase提供的各种默认Value类型,如 String, Int 等等, 属性就可以拥有一些方法(函数)了, 而属性下的值, 都是方法的原始参数, 因此这些方法也不需要额外的参数
  
  - 优点: 自我构建
  
  - 缺点: 可能存在比较大的性能损耗问题 (考虑参考Dart,引入native关键字...)

### 属性 v3A #todo

- 添加值验证表达式，例如：
  
  - 限定 String的长度，内容, regex
  
  - 限定 num的范围，大小
  
  - 等等

- 添加 Method 类型，让关系中的类拥有对外提供方法表达式)调用的能力



### 属性v2 #check

- 值检查表达式: 在set值时,检查值是否符合Attribute的Type要求



## Method方法设计

> 参考 https://www.sandromaglione.com/dart-flutter-static-metaprogramming-macro-prototype/ ## Define the macro 章
> 
> 显然, Method无法被Function取代

### Method v2 (包装Func `表达式v9` ) #dev

### Method v1A（与Attr合并方案）

- 方法是一种特殊的Attr，存在于RecordMeta中。新增一种 type”method”来表示，
  
  - 方法的返回值： 如果Method无需参数，则展示为Value，否则为空
  
  - 方法的参数存放在Attr中。
    
    - 方法的参数可以来自其他表，如果没有进行处理，则可以表示引用

### Method v1B（独立Metod方案）

- 方法与Attr平行， 存在与RecordMeta中。无需新增AttrType枚举
  
  - 方法的返回值： 同 v1A
  
  - 方法的参数存放在Attr中



## Expression 表达式设计

> **前提**: 表达式的计算是相对于`一行记录`即一个`Record`实例而言的, `跨实例计算`是不合理的, 例如在同一个表中检查是否有重复值, 统计当前实例数量等等(或许可以在<sug,check>中实现)
> 
> **Sign参考**
> 
> `Show值` 指 展示在某个Cell中的值, 如 字符串 "张三"
> 
> `Value值` 指 某个Cell被持久化的值, 如 Value类实例 Value.of("张三")
> 
> `k值` 值 某个Record中某个Attr的标识 `Attr::k`

### 表达式 v10 引入 函子Functor

> [函数式编程（FP） - 掘金](https://juejin.cn/post/7065093131233919006#heading-9)



### 表达式方案分析: v9 与 v8B

|          | v6D                                                                     | v6E                                                                           |
| -------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| 引用其他类型字段 | Attr::calc, ref 函数                                                      | AttrType.ref 类型                                                               |
| 实现       | 新增内置函数 `ref`, <br>函数入参为`MetaId`, k值, 存储在`Attr`中<br>RecordId存储在`Value值`中 | 新增`AttrType.ref`<br>`Attr`新增 `RefMeta`属性,存储`MetaId`<br>`RecordId`存储在`Value值`中 |

### 表达式 v9 extends v8B (ref独立为`引用`类型, 新增`func`类型)

概述: v6D以及之前版本中, `引用字段`的实现依赖于 reference函数

在当前版本中, ref作为一种特殊的Attr类型, 包装或替换objectId类型. 在Attr中需要额外指定metaId, 以表示被引用的recordId所属的meta.

- ref类型的存储: 单元格的Attr存储metaId, Value存储recordId, 这样即可定位一条记录(另一个类的实例)

- ref类型的引用: ref类型可以被展示时, 与ObjectId相同,直接展示hexStr, 但是被函数引用时, 可以调用ref对应实例的`字段`和`方法`, 作为`Attr::calc`的参数

> ### 梳理对应关系
> 
> | MindBase    | 1分类 / 类比对应关系     | 2分类            |
> | ----------- | ---------------- | -------------- |
> | MetaDto实例   | > 类的属性信息         |                |
> |             | List             | > 类属性列表        |
> | RecordDto实例 | > 某个类的实例的字段值     |                |
> | Record实例    | > 某个类的实例         |                |
> |             | RecordMeta::List | > 类的属性/get方法列表 |
> 
> | MindBase - AttrType::ref | 编程语言/IDE                                                              |
> | ------------------------ | --------------------------------------------------------------------- |
> | ref引用                    | 从外部import一个类(import Bag类到当前类文件)<br>当前类持有外部类的实例(Student添加bag属性,类型为Bag) |
> | ref引用找不到metaId           | import找不到类(例如 Student::bag 的Bag类不存在)                                  |
> | ref引用,通过`Value值`找不到实例    | 类的属性值为null(例如 Student::bag 属性为null )                                  |
> 
> ### AttrType::ref 与 AttrType::objectId 的异同
> 
> | 类型                | ref                           | objectId                          | func `dev`                  |
> | ----------------- | ----------------------------- | --------------------------------- | --------------------------- |
> | 存在的意义             | 类似编程语言的指针引用                   | 类似编程语言中实体类的id值                    | 对应编程语言中的`方法`                |
> | 存储                | Attr存储metaId, Value存储recordId | Value存储一个ObjectId                 | Attr最外层是func,而不是Expr        |
> | 编辑属性              |                               |                                   | 改方法头                        |
> | 编辑参数              | 编辑模式下可选择其他表的某条记录(更换子对象)       | 只能编辑字符串内容<br>(如果k==0或1,则不应该被允许编辑) | 不可编辑                        |
> | 展示(`show值`)       | 直接展示objectId的hexStr           | <相同>                              | `方法`的结果无法被展示,只能被其他类作为"函数"引用 |
> | 作为`Attr::calc`参数时 | 可以选择recordId对应记录的任何字段作为参数     | 作为一个string字符串                     | 作为函数被引用                     |

### 表达式 v8B extends v7 (表达式升级为方法, Show值移动到`视图配置类`)

> 梳理对应关系
> 
> | MindBase                         | Dart                             |
> | -------------------------------- | -------------------------------- |
> | Record                           | 某个类的实例                           |
> | RecordMeta                       | 类结构信息                            |
> | Attr                             | 实例的某个属性                          |
> | Attr::Value                      | 字段 (Value的值就是字段值)                |
> | Attr::calc(无外部入参)                | get方法(此时Value不可编辑, 只有展示值)        |
> | Attr::calc(需要外部入参) <即`方法`, 暂不实现> | 普通方法(此时Value没有值,本列只能被其他类引用,作为函数) |
> 
> 表格视图的特有功能
> 
> > 关于 `视图配置类`, 与metaId同一层级, 一个表可以有多个视图配置类
> 
> | 场景      | 所属实体          | 备注  |
> | ------- | ------------- | --- |
> | 小数展示为整数 | 视图配置类::show函数 |     |
> 
> 场景实现
> 
> | 场景      | 编程实现                  | MindBase实现                                                                           | 备注                               | 金山轻维表             |
> | ------- | --------------------- | ------------------------------------------------------------------------------------ | -------------------------------- | ----------------- |
> | 记录内字段引用 | get方法<br>this.xx      | Attr::calc, this函数`todo` <br>Value为空, <br>Attr::calc存储 k值, <br><或许应当限制ref函数只能引用表内字段> | this函数只能引用当前Record的字段            | 公式-公式编辑器          |
> | 跨表字段引用  | 引用子对象的属性/方法           | Attr:calc, ref函数 `todo`<br>Value存储关联记录的objectId, <br>Attr::calc存储metaId,k值           | ref函数只能接收其他记录的objectId, 然后做进一步处理 | 双向关联, <br>但无法引用字段 |
> | 跨表方法引用  | 普通方法,<br>Function类型字段 | -- 这要求Expr在invoke时能够填入参数列表                                                           |                                  | --                |

- 将Expression自带的 args参数列表比作 Dart中的 `一个类方法的入参列表`,
  
  - 在调用的时候, 还允许通过某种方式,访问 Record实例本身
  
  

### 表达式 v8A extends v7 (show与value分离)

> `@override` 对于使用`calc`的列, `alue值` 与 `Show值`改为 不存在于同一列,
> 
> 如果要引用, 则应当使用 `reference`函数,手动指定`metaId`, `k值`, 而不是通过传参 <问题> 没有解决 recordId 的问题, 原方案 recordId由Value存储

- <考虑> 新增一个 `self`字段, 用于解决如何获取 Cell中的`Value值`的问题.

### 表达式 v7 extends v6A (不考虑 <check,sug>)

> Value的类型由 `Attr::calc`的返回值类型控制, 例如 toString 等等表达式
> 
> 本方案默认 所在列填写的Value为`calc`的参数, 并且`calc`的计算结果作为展示值, (即使 填写值/`Value值` 与 展示值/`Show值` 存在于同一列)
> 
> <问题> 最终Cell的类型到底时什么呢? 如果被引用的值是String, 那么填写值 ObjectId 应该在哪里被标识?

- Attr中的Expression实例
  
  - calc 计算表达式 `@override`
    
    - 不可为空, 默认填充一个值类型转换函数, 例如 toString 等等,用于限定Value的类型; 这样就默认Value对象的实际类型为 `dynamic` / `String`

- Invokable设计
  
  - <考虑A> 关于invoke() 可填充的参数:
    
    - Record本身,
    
    - Value所在列的Attr实例,
    
    - Record的RecordMeta实例, (Record::meta)
  
  - <考虑B>invoke()方法有一个默认的 Value类型参数
    
    - 对于 Expression, 表示其所在列的Value
    
    - 对于 Value, 表示其自身
    
    - 评估: 可能不行, 因为Expression还会内嵌其他表达式, invoke似乎只能时无参方法
  
  - <考虑B2> 为 Expression新增一个 `::invokeAtDomain`方法, 只允许在Record实例方法中被调用, 可以添加 <考虑A>中的参数到本方法中,
    
    - 解决了"首个参数为Value"的实现问题

### 表达式 v6A #Todo

`Show值` = `Attr::calc(Value值)` / `Attr::sug(Value值)`

- Attribute 拥有三种Expression实例
  
  - calc : (计算表达式) 即v5中的 "expr",
    
    - `Show值`=`Attr::calc(Value值)`
    
    - 计算的结果用于show或其他表达式的参数,
    
    - 可以为空, 为空时, `Show值` = `Value值`
    
    - Value作为Calc的参数之一
  
  - <暂不实现> check: (检查表达式) 在 "用户输入完成"/"calc计算完成"之后被调用,
    
    - 用于检查值是否合法,
    
    - 可以为空
  
  - <考虑,较难> sug: (建议值表达式) 在用户输入之前, 作为placeHolder展示在表格中,
    
    - 与calc不同, calc不为空时, Value作为计算参数 , 的Value被手动更改后会被展示
    
    - 问题: 如何处理 calc 和 sug 的冲突问题?

### 表达式 v5 #check

- 实体类
  
  Invokable
  
  Expression 保存 Func链, 以及引用参数, 例如某个属性(对应的Value)

Func 是纯函数, 使用name/alias 作为标识, 拥有 pTypeList和rType限定出入参类型

Value , `::invoke`

> 工作模式
> 
> func::name(value/func::name ) 
> 
> 关于计算最终展示在UI上的Value的值, 以"引用当前表的其他字段"为例
> 
> **原有的方式**:
> 
>     某个Record, 调用 ::getValueWithCalc, 传入要计算Value所在的Attr. Attr存储的Expr中指定了 func内容为引用其他字段, 同时指定了被引用字段所属的表,`k` 等等,
> 
> **新的计算方式**:
> 
> 前提条件: 1. Expr的参数是在建表时就已经指定好的;
> 
> 某个Record, 调用 ::getValueWithCalc, 传入要计算Value所在的Attr. Attr存在的Expr中指定了func, name为"字段引用函数", 同时存储的参数分别是 `被引用字段所在表的MetaId`, `被引用字段k值`, `被引用字段所在记录的RecordId`

> `#todo` 考虑将Attr也作为 Invokable 的实现类, 或者是Expression的实现类
> 
> 例如...
> 
> ... 可能没意义

- 持久化类

FuncDto 持久化`函数名称`,`入参` 因为函数入参类型,出参类型都已经固定了





---

## Record 记录设计

### 记录 v2 (独立collection) #check

- 当前所有的 Record都存放在同一个collection`record`中, 考虑将不同schema对应的record存放到对应的`record_${schema.id}`集合中

---

## Dto 传输对象设计

### Dto v2 为对应的key添加 `json key name`  #todo

- 如 `name`字段新增变量 `const String name_js`,值= "name", 以便`Form`等使用

---

## Value 字段值设计

- 关于转换整列字段类型: 可以考虑新增一列,等待转换完成后,切换列的k

### 字段值 v2A (String) #check

> 可以允许用户输入不符合要求的值

- 使用String类型持久化数据, 即所有的类型都以String保存在数据库中

- ObjectId, DateTime 除外
  
  - (`mongo_dart`自带支持这两个类型, 此外还有bson.TimeStamp类型)

### 字段值 v2B (dynamic) #dev

> 存储了实际的值类型, 列类型变更时,需要遍历,转换对应字段的类型

- 使用`Mongo_Dart` 返回的 dynamic Map操作Value, 包括但不限于 Object, DataTime, 和int,bool等类型

### 字段值 v2C (T) #dev

> <考虑后期实现> 要求严格, 存储了实际的值类型, 列类型变更时,需要遍历,转换对应字段的类型

- 使用 `mongo_dart`提供的类型, 并且在Value中添加实际值的泛型

- 将Value中不合法的值暂存在 `Value::e` 中



---

# 基础设施实现细节

## MongoDB相关

### Record持久化 v3 #dev, (可能不采纳)

将 record根据 workspace 划分为不同的

- 优点: 大大减少 `record_$metaId`集合的数量

- 缺点: 不太规范

### Record持久化 v2 #check

record根据schema::id划分为不同collection

不同schema的record存储在不同的 "tb_${schemaId}"集合中 

- 优点: 某种程度上符合 RMDBS的规范, 可以迁移到RMDBS

- 缺点: collection太多了

### Record持久化 v1

所有record都存放在同一个collection中

- 优点:

- 缺点: 造成record集合太大

## mongo_dart的watch

对于副本集, 可以watch单个集合 `collection`的变更

对于集群, 可以watch单个`database`的变更

### Record持久化样式

### v3 `#todo`

#### v2 将`_id`,`metaId`存储到 `fields`中，

- 所有fields都展开存储到Record的document中

#### v1 单独存储`_id`,`metaId`

- 所有fields都展开存储到Record的document中

---

# Flutter UI实现细节

## 数据库状态与视图状态更新设计

## v2 双Strem模式

1. 从数据库 ->UI State 流

通过 RepoEvent<> 实现接收 insert, replace, remove 事件

2. 从 UI State -> 数据库 流

新增一个 OperatorController (广播流), 由 WorkspaceProvider 持有

用户的操作将首先进入到该Controller, UI状态立即刷新; 同时等待数据库响应, 如果数据库长时间未响应,则弹出通知("操作未生效,请检查网络")并撤销用户的未生效更改

---

# 已过时方案 ================

## 函数设计v1

### 要求

- 能够通过参数组合`基本函数`,创造新函数,实现 元组(对象)的方法
- `FunWrap` 对`基本函数`,`云函数等进行包装`,
  - 可以展示函数执行进度

### 实现

- 创建一些基本功能的函数,如 `add`, `sub`, `mul`, `div`

### 基本函数的内容

- 入参类型 数量
- 出参类型 (只有一个)
- 函数ID: 类比"包名", 避免函数名冲突的情况
- 函数名称: 调用时的名称
- run 方法: 实现函数的具体功能

### 基本函数枚举

- ADD
- SUB
- MUL
- DIV
- MAX
- MIN

### 持久化

#### 函数是没有状态, 持久化的意义是?

- 不是持久化函数, 而是持久化一个方法, 内容包括一个函数运行的固定参数,
  - 如 正则表达式方法,在某个关系(类)中,持久化的内容包括`regex`,`参数所在Attr`,等等
  - 如 云函数方法,

### 状态

---

## 函数设计v2

### 函数的处理

- 程序内部构建无状态的纯函数, 如 `add`, `sub`, 特别是 `SHELL`, `HTTP_REQ`, `GRPC_CALL`, 等扩展性极强的特性
- 添加逻辑控制函数, 如 `FOR`等等, 参考 `函数式编程`

### 方法的处理(有状态的函数)

- 新增一个 FUNC类型(与number等平行), 可以传入外部的参数,类比一个 实例的方法,可以从外部接收参数,并返回值

---

表达式v4 #Depre

- 表达式需要有集合操作函数, 参考 `Kotlin Collection`设计

- 为Attr添加相关的函数,即 `Attr自带的方法`, 例如 num类型自带加减乘除等等

- 单个字段值也是表达式, 类比kotlin的 dsl返回值`

#### Func

- 将所有的Func都改为native的纯函数形式,

- !!! 允许嵌入 js, py 脚本作为函数

#### Method

- 将Expr作为 Attribute 的属性 ::expr

- Expression 属性设计
  
  - List pKeys：Expr执行参数列的`k`

- 应用场景 以 `Person`类(`name`, `age`, `::hello`, `::tags`), `Tag`类(`name`,`type`)为例
  
  - 本类引用：在`hello`列 引用当前类的`name`列值
    
    - 实现: `pKeys`存储 `Person::name`列的k, Value存储本类`ObjectId`, 或者存null
  
  - 外部类关联: 在 `::tags` 列 存储 Tag类的多个元素
    
    - 实现:
      
      - Expression:: `pKeys`存储 Tage类的 `name`列的`k`, 表示本列展示的值是`name` ,
      
      - Expression`::ref`/`::metaId` , 存储`metaId`
      
      - Value存储 `Tage`类的`id`

### 表达式v3

> 将带状态的函数改为方法

#### 表达式 Expression #todo

- 表达式是对`Func`的包装, 包装了参数等

#### 函数 Func

- 函数就单纯的作为程序内的对象, 类比编程语言的+,-,*,/等符号和sdk中提供的各种函数
- 带有状态的函数应当作为用户自建的表的方法对外提供, 程序本身不再提供这类`带状态的函数`

#### 方法 Method

- 新增一个与 Attribute平行的 Method类 可以接收外部参数,并返回值,
- 优) 新增一个Attribute类型为Method
