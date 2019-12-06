#!/bin/bash
# while_read_bottm(){
#     awk '{print $0}' $1 >> $2
# }
# 前端还是后台，默认是后台:1，其他输入项都是前端
is_bankend=1
# echo 'sadf:'$( ! -n "$2" )
if [[ -n "$2" ]] && [[ 1 -ne "$2" ]] ; then
    is_bankend=0
fi
# 是否需要创建目标文件
create_target_file_flag=0
# 目标文件命名
target_relative_dir_name='generate'
if [ ! -d $1 ];then 
    echo '目录不存在'
    exit
fi
# target dir
dir=$1
cd $dir
current_path=$(pwd)
# 把/替换为空格，数组默认是通过空格隔离的
array=(${current_path//// })
length=${#array[@]}
# echo ${array[$length-1]}
cd ../
temp_base_dir=$(pwd)
target_dir=$temp_base_dir/$target_relative_dir_name
if [ ! -d $target_dir ]; then
    mkdir $target_dir
fi

target_file_begin=$target_dir/${array[$length-1]}-$(date +"%Y%m%d%H%M%S")
target_file_temp=$target_file_begin'.temp'
echo '$target_file_temp:'$target_file_temp
if [ -f $target_file_temp ] ; 
then
    true > $target_file_temp
else
    touch $target_file_temp
fi
echo $dir
# echo $(find $dir -name "*.java")
# file_array=''
echo $is_bankend
if [ $is_bankend -eq 1 ]; 
then
    # file_array=$(find $dir -type f -iname "*.java" -o -iname "*.php")
    file_array=$(find $dir -type f -iname "*.java")
    # file_array=$(find $dir -type f -iname "*.php" -o -iname "*.json")
else
    # file_array=$(find $dir -type f -iname "*.js" -o -iname "*.vue" -o -iname "*.css" -o -iname "*.html" -o -iname "*.json")
    file_array=$(find $dir -type f -maxdepth 7 -iname "*.js" -o -iname "*.vue" -o -iname "*.css" -o -iname "*.json")
fi
# echo $file_array
for file_name in $file_array
do
    if [ -f $file_name ]; 
    then
        echo $file_name
        # awk '{print $0 >> $target_file}' $file_name 
        cat $file_name >> $target_file_temp
        # while_read_bottm $file_name $target_file
    fi
done
echo 'init finish*************************************************'
target_file_name=$target_file_begin'.doc'
if [ -f $target_file_name ] ; 
then
    true > $target_file_name
else
    touch $target_file_name
fi
LC_CTYPE=C 
sed '/\/\*/,/\*\//d' $target_file_temp > $target_file_name
rm -rf $target_file_temp
echo 'finish*************************************************'
# sed -i "s/"
# cat $target_file
exit