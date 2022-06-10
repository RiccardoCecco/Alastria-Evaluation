#!/bin/bash

TOTAL_USERS=10
TOTAL_TRANSACTIONS=200
TOTAL_ADOPTERS=200
OPTION=$1 #Option to deploy the smart contract; Values: "contract"
TOTAL_ADOPTERS_ONE="$((TOTAL_ADOPTERS-1))"

echo -e "\n"

echo -e "$(tput setaf 4)$OPTION $(tput setaf 7)selected"

rm -rf ../test/*
rm ../contracts/Adoption.sol

count=1

# Generate random adopters to adopt

#while [ "$count" -le $TOTAL_TRANSACTIONS ]; do
#  number=$RANDOM
#  let "number %= $TOTAL_ADOPTERS"

# if [[ $count != $TOTAL_TRANSACTIONS ]]
# then
#   number_total=$number","
# else
#   number_total=$number
# fi
# let "count += 1"
# result[$count]=$number_total
#done

# Generate all adopters to adopt
while [ "$count" -le $TOTAL_TRANSACTIONS ]; do
  number="$((count-1))"
  if [[ $count != $TOTAL_TRANSACTIONS ]]
  then
    number_total=$number","
  else
    number_total=$number
  fi
  result[$count]=$number_total
  let "count += 1"
done

# Launch the ganache blockchain system
echo "GANACHE CREATION"
rm ganache-cli.txt
rm accounts.txt

ganache-cli --accounts $TOTAL_USERS -p 7545 -i 1337 > ganache-cli.txt &
echo "Ganache-cli process"
echo "$!"
sleep 10

#Generate the test in the respective folder by the template myTest.sol
echo -e "$(tput setaf 3)Generating files for the test deployment$(tput setaf 7)\n"

sed -e "s/adopt-pet/[${result[*]}]/g" -e "s/total-number/$TOTAL_TRANSACTIONS/g" -e "s/total-adopters/$TOTAL_ADOPTERS/g" ./myTest.sol > ../test/testAdoption.sol


cp ./ganache-cli.txt ./accounts.txt
sed -i '1,4d;15,$d' ./accounts.txt

input="./accounts.txt"
i=1
while IFS= read -r line
do
  #echo "$line"
  if [[ $i -le $TOTAL_USERS ]]
  then
    new=$(cut -d' ' -f2 <<<"$line")
    #accounts[$i]=$new
    sed -e "s/a-ad/$new/g" -e "s/cnt-name/TestAdoption$i/g" ../test/testAdoption.sol > ../test/testAdoption_$i.sol
  fi
  let "i += 1"
done < "$input"

rm ../test/testAdoption.sol

if [[ $OPTION == "contract" ]]
then
  echo -e "\n"
  #Generate the contract in the respective folder by the template Adoption.sol
  echo -e "$(tput setaf 3)Generating files for the contract deployment$(tput setaf 7)\n"

  sed -e "s/total-adopters/$TOTAL_ADOPTERS/g" -e "s/total-one/$TOTAL_ADOPTERS_ONE/g" ./Adoption.sol > ../contracts/Adoption.sol

  #Compile and migrate the contract
  echo -e "$(tput setaf 6)Truffle Deploy$(tput setaf 7)\n"
  truffle deploy
fi

index_one=1
while [ "$index_one" -le $TOTAL_USERS ]; do
  if [[ $index_one -le $TOTAL_USERS ]]
  then
    indexes[$index_one]="test/testAdoption_"$index_one".sol"
  fi
  let "index_one += 1"
done

echo -e "\n"

echo -e "$(tput setaf 6)Truffle Test$(tput setaf 7)\n"

rm ./logs/*

index=1
# PARALLELIZE THE EXECUTIONS OF TRUFFLE
while [ "$index" -le $TOTAL_USERS ]; do
  if [[ $index -le $TOTAL_USERS ]]
  then
     truffle test ../test/testAdoption_$index.sol --show-events --network skipMigrations > ./logs/truffle_test_$index.txt &
     echo "Truffle process"
     echo "$!"
  fi
  let "index += 1"
done

exit 1;

cd ..

echo ${indexes[*]}
truffle test "${indexes[*]}" --show-events
