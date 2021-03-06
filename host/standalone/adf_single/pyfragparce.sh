function jobsubargue {
jobsub="$1"
while read -r line
do
    if [ "$line" != "" ]; then
      name="$line"
      echo "$name"
    fi
done < "$jobsub"
}

function pyfragargue {
pyfrag="$1"
while read -r line
do
    if [ "$line" != "" ]; then
      name="$line"
      echo "--$name \\"
    fi
done < "$pyfrag"
}

function adfargue {
adf=$*

Mark=(scf xc basis BECKEGRID EPRINT)
SMark=(numericalquality relativistic charge symmetry unrestricted)

for sitem in ${SMark[*]}
do
  soption=`grep -iw "$sitem" $adf`
  if [ ! -z "$soption" ]; then
    soptionarray=( $soption )
    if [[ ! -z ${soptionarray[@]:1} ]]; then
      echo $sitem"="${soptionarray[@]:1}
    else
      echo $sitem"=True"
    fi
  fi
done

for item in ${Mark[*]}
do
grep  -iwA 20 "$item" $adf | grep -m 1 -iwB 20 'end' | grep -iv 'end' | grep -iv "$item" > "$item".txt
  if [ -s "$item".txt ]; then
    argue="$item".txt
    while read -r line
    do
      if [ "$line" != "" ]; then
        option="$line"
        optionarray=( $option )
        echo "$item."${optionarray[0]}"="${optionarray[@]:1}
      fi
    done < "$argue"
  fi
rm "$item".txt
done
}


input=$*
SCRIPTPATH="$( cd "$(dirname "$1")" ; pwd -P )"

grep  -A 200 'JOBSUB' $input | grep -B 200 'JOBSUB END' | grep -v 'JOBSUB' | grep -v 'JOBSUB END' > jobsub.txt
grep  -A 200 'ADF' $input | grep -B 200 'ADF END' | grep -v 'ADF' | grep -v 'ADF END' > adf.txt
grep  -A 200 'PyFrag' $input | grep -B 200 'PyFrag END' | grep -v 'PyFrag' | grep -v 'PyFrag END' > pyfrag.txt

submit="python3 \$HOSTPYFRAG/standalone/adf_single/PyFrag.py \\"
subadfinputfile="--adfinputfile "$SCRIPTPATH/"adfinputfile \\"


jobsubargue jobsub.txt                                      >> ./sub
echo $submit                                                >> ./sub
pyfragargue pyfrag.txt                                      >> ./sub
echo $subadfinputfile                                       >> ./sub
adfargue  adf.txt                                           >> ./adfinputfile
rm adf.txt jobsub.txt pyfrag.txt
