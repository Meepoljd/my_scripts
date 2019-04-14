#!/bin/sh

# clone repo from github
if [ -d 'tmp' ]
then
    rm -rf tmp
fi
$(cat bak.config |sed -n 's/^repo:\(.*\)$/git clone \1 .\/tmp/p')
# rm old files
cd tmp
for file in $(ls -a .|sed 's/^.git$//;s/^\.*$//')
do
    $("git rm -r $file")
done
# mv dot files to repo
files=$(cat bak.config |sed -n 's/^files:\(.*\)$/\1/p')

for file in $files
do
    `cp $file ./`
done
# commit and push
commit_msg=$(date +%Y-%m-%d)
git add .
$("git commit -m $commit_msg")
git push
# remove repo
cd ..
rm -rf tmp
