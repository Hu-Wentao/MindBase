# Mind Base 设计

> MindBase更像是另一种"Java语言", Dart语言类比构建JVM的"C语言"
> 
> 每个表对应一个实体类(不是聚合根), 直接使用 Accessor进行读写; 聚合根暂不使用

## 标志:

- `#dev` 设计中的实现功能选项(尚未确定是否要实现)
- `#todo` 预备实现的功能(确定下一步要实现)
- `#check` 当前已实现的功能

---

## RecordMeta 记录模式设计(Schema)

### Meta v2 (重命名为Schema) #todo

- 将 List<Attribute> 改为 Map<int,Attribute>. 即,将Attr存储的`k`提取到Meta内部.
  
  - 优点: 便于序列化, 便于分类key值

- 类重命名为 Schema

---

## Attr 属性设计

### 属性 v3A #todo

- 添加值验证表达式，例如：
  
  - 限定 String的长度，内容， regex
  
  - 限定 num的范围，大小。。
  
  - 等等

- 添加 Method 类型，让关系中的类拥有对外提供方法表达式)调用的能力

### 属性 V3B #dev

> 相关: 表达式v4
> 
> 即 `Dart like` 模式, 原始类型都是`对象`
> 
> 可能不太合适, 将原始的String,int等作特殊处理(即Java like性能会比较好)

- 将属性本身作为一个引用`关系`, 引用的是MindBase提供的各种默认Value类型,如 String, Int等等, 属性就可以拥有一些方法(函数)了, 而属性下的值, 都是方法的原始参数, 因此这些方法也不需要额外的参数
  
  - 优点: 自我构建
  
  - 缺点: 可能存在比较大的性能损耗问题 (考虑参考Dart,引入native关键字...)

### 属性v2 #check

- 值检查表达式: 在set值时,检查值是否符合Attribute的Type要求

---

## Record 记录设计

### 记录 v2 (独立collection) #todo

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

- 使用`Mongo_Dart` 返回的 dynamic Map操作Value, 包括但不限于 Object,DataTime, 和int,bool等类型

### 字段值 v2C (T) #dev

> <考虑后期实现> 要求严格, 存储了实际的值类型, 列类型变更时,需要遍历,转换对应字段的类型

- 使用 `mongo_dart`提供的类型, 并且在Value中添加实际值的泛型,

- 将Value中不合法的值暂存在 `Value::e` 中

---

## Expression 表达式设计

### 表达式v4 #todo

- 表达式需要有集合操作函数, 参考 `Kotlin Collection`设计

- 为Attr添加相关的函数,即 `Attr自带的方法`, 例如 num类型自带加减乘除等等

- 单个字段值也是表达式, 类比kotlin的 dsl返回值`

#### Func

- 将所有的Func都改为native的纯函数形式,

- !!! 允许嵌入 js, py 脚本作为函数

#### Method

- 参照 Python的函数, 直接引用Func, 并且将首个参数设为 `self`

### 表达式v3

> 将带状态的函数改为方法

#### 表达式 Expression #todo

- 表达式是对`Func`的包装, 包装了参数等

-

#### 函数 Func

- 函数就单纯的作为程序内的对象, 类比编程语言的+,-,*,/等符号和sdk中提供的各种函数
- 带有状态的函数应当作为用户自建的表的方法对外提供, 程序本身不再提供这类`带状态的函数`

#### 方法 Method

- 新增一个与 Attribute平行的 Method类 可以接收外部参数,并返回值,
- 优) 新增一个Attribute类型为Method

---

# 实现细节

## Record的存放

### 是否应该将属于不同schema(record_meta)的record存放在同一个collection中?

### 当前方案: 存放在同一个集合.

- 优点:

- 缺点: 造成record集合太大
  
  ### 不同schema的record存放在 "tb_${schemaId}"集合中

- 优点:

- 缺点:

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

- 入参类型, 数量
- 出参类型(只有一个)
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
