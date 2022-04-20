# cluster-script
This Project is to provide shell or python tools
## jar_switcher
jar_swither is a light-weight shell project to replace bunches of jars and reffered soft links.

### What is Special for jar_switcher
As we know, soft links in CentOS system have list or tree stucture, they may seem like as follows:

```
   a->b->c
   or
   a->b->c
   d->b->c
```

the root node is the key that really works and leaf node or non-leaf node is just a refference, thus,
what we do is just to replace the jar wtih proper version in root node of a soft link and maintain the 
previous structure.

### What is disadvantage for jar_switcher
by now, it cannot compare the version between the original jar and replacing jar, so be careful when 
you use it

### How to use jar_switcher
```
Step 1:
su root

Step 2:
mkdir -p $path

Step 3:
upload jar_switcher to your host, and 
chown -R root:root jar_switcher.sh;chmod u+x jar_switcher.sh

Step 4:
upload the jar you want to replace in $path, and
chown -R root:root $uploaded_jar

Step 5:
sh jar_switcher.sh $path
```

## jar_switcher
jar_switcher是一款用于批量替换jar包和相应软链接的轻量级工具。

### 它有什么特点
众所周知，软链接在Linux CentOS操作系统中是以链表或者树形结构存在的，它的结构类似以下:

```
   a->b->c
   or
   a->b->c
   d->b->c
```
真正起作用的只有根部节点的jar包，其余都是对其的引用，因此，我们只需要对根据节点的jar进
行替换，其余维持结构不变即可

### 它有什么缺点
截止目前，它还不能识别相同jar包不同版本之间的区别，为防止错乱替换，在使用之前请小心

### 使用方法
```
Step 1:
//因为工具涉及到删除等操作，所以请在root权限下操作
su root

Step 2:
//创建文件夹用以存放你想要替换的jar包
mkdir -p $path

Step 3:
//上传jar_switcher.sh到你所需要的服务器 
chown -R root:root jar_switcher.sh;chmod u+x jar_switcher.sh

Step 4:
//将你想要替换的jar包放入到刚刚创建的路径$path中
chown -R root:root $uploaded_jar

Step 5:
//启动脚本，关于变量$path，我们建议你以类似/apprun/jars/形式输入
sh jar_switcher.sh $path
```
