#!/bin/sh

# 检查是否有显示器接入
display=$(xrandr --listmonitors|sed '1d'|wc -l)
if [ $display -eq 1 ]
then
    echo '未检测到外接显示器'
    exit 0
fi

if [ $display -ne 2 ]
then
    echo '当前脚本只能处理双显示器'
    exit 0
fi

# 调用xrandr获取显示器信息，使用sed提取
params=$(xrandr --listmonitors|sed -e '1d' -e 's/^.* \<\([0-9]*\)\/.*x\([0-9]*\).*\>  \(\<.*\>\)$/--output \3 --mode \1x\2 --pos tokenx0/g' -e '1,2s/--mode/--primary --mode/g')
x1=$(xrandr --listmonitors|sed -e '1d' -e 's/^.* \<\([0-9]*\)\/.*x.*$/\1 /g' -e '3,$d' -e 's/ //' )
x2=$(xrandr --listmonitors|sed -e '1,2d' -e 's/^.* \<\([0-9]*\)\/.*$/\1 /g' -e 's/ //')

# 拼接参数
comm='xrandr'
for p in $params
do
    comm=${comm}" "${p}
done


# 获取命令行参数
if [ $# == 1 ]
then
    pos=$1
else
    echo '选择显示器位置:'
    echo '1.左侧'
    echo '2.右侧'
    read v
    # 忽略参数检查
    if [ v -eq 1]
    then
        pos='left'
    else
        pos='right'
    fi
fi

if [ $pos == "right" ]
then
    comm=${comm/token/0}
    comm=${comm/token/$x1}
else
    comm=${comm/token/$x2}
    comm=${comm/token/0}
fi

`$comm`
