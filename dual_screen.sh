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

params=$(xrandr --listmonitors|sed -e '1d' -e 's/^.* \<\([0-9]*\)\/.*x\([0-9]*\).*\>  \(\<.*\>\)$/--output \3 --mode \1x\2 --pos tokenx0/g' -e '1,2s/--mode/--primary --mode/g' -e '1,2s/token/0/g')

comm='xrandr'
for p in $params
do
    comm=${comm}" "${p}
done

# 获取命令行参数
if [ $# == 1 ]
then

    exit 0
else
    echo "参数错误"
fi
