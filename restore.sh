#!/bin/sh

# 用于备份一些常用设置，安装基本软件

# 切换软件源
sed -i "1iServer = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/$arch" bak.config
pacman -Syy
# 安装常用软件
for app in $(sed -n "s/^app:\(.*\)$/\1/p")
do
    pacman -S $app --noconfirm
done
# 从仓库获取配置文件
if [ -d 'tmp' ]
then
    rm -rf tmp
fi
$(sed -n 's/^repo:\(.*\)$/git clone \1 .\/tmp/p' bak.config )
cd tmp
for f in $("ls .")
do
    target="sed -n 's/file:\(.*$f\)/\1/p'"
    if [ -n "$target" ]
    then
        mv $f $target
    fi
done
cd ..
rm -rf tmp
