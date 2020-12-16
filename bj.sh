#!/bin/bash
echo "NOTICE: if file in windows format, use dos2unix to convert!"
read

if [ $# -ne 1 ]; then
    echo "USAGE: $0 filename"
    exit
fi

dupfile=dup_$(date +%Y%m%d)

echo "* list all dup lines to file: $dupfile"
sort $1 | uniq -d > $dupfile

echo "* delete all dup lines in file $1"
i=0
current_file=$1
#echo "* target file $current_file"
while read line
do
    line1=$(echo $line | sed -e 's/ //g' -e 's/#//g')
    if [ -z "$line1" ]; then
        #echo "ignore # or blank line: $line"
        continue
    fi

    i=`expr $i + 1`
    #echo "    $i: $line"
    #echo "    * sed -e '/$line/d' $current_file  > $1_$i "
    sed -e "/$line/d" $current_file > $1_$i
    current_file=$1_$i
done < $dupfile

#echo "* append $dupfile to $current_file"
sed -i "/Re-orged/ r $dupfile" $current_file
mv $1 $1.bk
mv $current_file $1
rm $1_* dup_*
