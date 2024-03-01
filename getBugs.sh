echo -n "" > out.buggy
echo -n "" > out.fixed
for p in $(cat javaprojects.txt)
do
    folder=$(echo $p | cut -d"/" -f5)
    git clone "$p.git" "projects/$folder"
    cd "projects/$folder"
    git log | tr "\n" "~" | sed 's/~commit/\ncommit/g' | tr "~" " " > log.txt # ~ is used as its uncommon
    echo -n "" > bugCommits.txt
    cd ../..
    cat keywords.txt | while read k
    do
        grep "$k" "projects/$folder/log.txt" | cut -d" " -f2 >> projects/$folder/bugCommits.txt
    done
    cd "projects/$folder"
    for c in $(cat bugCommits.txt)
    do
        for f in $(git show --pretty="" --name-only $c)
        do
            if [[ $f == *\.java ]]
            then
                git show -W $c~1:$f > prev.tmp.java
                if [ $? -eq 0 ]
                then
                    git show -W $c:$f > next.tmp.java
                    python3.10 ../../getMethods.py
                    cat out.tmp.buggy >> ../../out.buggy
                    cat out.tmp.fixed >> ../../out.fixed
                fi
            fi
        done
    done
    cd ../..
    rm -rf "projects/$folder"
done
