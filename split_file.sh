split_file.sh#!/bin/bash
#解析csv/excel文件，验证文件中图片是否正确
function split_array() {
    line_num=$1
    echo $line_num
    j=0
    OLD_IFS="$IFS"
    IFS=","
    arr=($2)
    column_length=${#arr[@]}
    # echo $(($column_length - 1))
    image_str=${arr[$(($column_length - 1))]}
    IFS=";"
    image_arr=($image_str)
    k=0
    line_num=$(($line_num - 1))
    current_date=`date "+%Y/%m/%d"`
    # echo $current_date
    if [  -d $current_date ]; then
        rm -rf $current_date
    fi
    mkdir -p $current_date
    for image in ${image_arr[@]}; do
        if (($k == 0)); then
            echo "<html>" >$current_date"/image"-$line_num.html
        fi
        k=$(($k + 1))
        echo "create" $current_date"/image-"$line_num-$k".log"
        IFS="-"
        image_obj=($image)
        IFS="$OLD_IFS"
        echo "base64,"${image_obj[1]}.${image_obj[0]} >$current_date"/image-"$line_num"-"$k".log"
        echo "<image src=\"data:image/"${image_obj[0]}";base64,"${image_obj[1]}"\" />" >>$current_date"/image-"$line_num".html"
    done
    echo "create" $current_date"/image-"$line_num".html"
    echo "</html>" >>$current_date"/image-"$line_num".html"
}

i=0
for line_str in $(cat $1); do
    i=$(($i + 1))
    if (($i == 1)); then
        continue
    else
        split_array $i $line_str
    fi
done
