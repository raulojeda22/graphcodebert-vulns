dd if=/dev/random of=myrand count=1024
shuf --random-source=myrand out.buggy > data/vulns/outrand.buggy
shuf --random-source=myrand out.fixed > data/vulns/outrand.fixed

n=$(wc -l data/vulns/outrand.buggy | cut -d" " -f1)
train=$(($n*80/100))
rest=$(($n-$train))
valid=$(($rest*50/100))
test=$(($rest-$valid))

echo $train $valid $test

head -n $train outrand.fixed > data/vulns/train.buggy-fixed.fixed
head -n $train outrand.buggy > data/vulns/train.buggy-fixed.buggy
tail -n $rest outrand.fixed > data/vulns/part.fixed
tail -n $rest outrand.buggy > data/vulns/part.buggy
head -n $valid part.fixed > data/vulns/valid.buggy-fixed.fixed
head -n $valid part.buggy > data/vulns/valid.buggy-fixed.buggy
tail -n $test part.fixed > data/vulns/test.buggy-fixed.fixed
tail -n $test part.buggy > data/vulns/test.buggy-fixed.buggy