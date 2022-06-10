#!/bin/bash

TOTAL_USERS=20
TOTAL_TRANSACTIONS=20
TOTAL_ADOPTERS=20
OPTION=$1 #Option to deploy the smart contract; Values: "contract"
TOTAL_ADOPTERS_ONE="$((TOTAL_ADOPTERS-1))"

echo -e "\n"

echo -e "$(tput setaf 4)$OPTION $(tput setaf 7)option selected"

rm -rf ../test/*
rm ../contracts/Adoption.sol

# Launch the ganache blockchain system
rm ganache-cli.txt
rm accounts.txt
echo -e "$(tput setaf 2)GANACHE CREATION$(tput setaf 7)\n"
ganache-cli --accounts $TOTAL_USERS -p 7545 -i 1337 > ganache-cli.txt &
ganache_p="$!"
sleep 30

#Generate the test in the respective folder by the template myTest.sol
echo -e "$(tput setaf 3)Generating files for the test deployment$(tput setaf 7)\n"

cp ./ganache-cli.txt ./accounts.txt
sed -i '1,4d;55,$d' ./accounts.txt

input="./accounts.txt"
i=1

while IFS= read -r line
do
  #echo "$line"
  if [[ $i -le $TOTAL_USERS ]]
  then
    account_number="$((i-1))"
    new=$(cut -d' ' -f2 <<<"$line")
    #accounts[$i]=$new
    sed -e "s/a-ad/$account_number/g" -e "s/total-number/$TOTAL_TRANSACTIONS/g" ./adopt_pets.js > ../test/adopt_pets_$i.js
  fi
  let "i += 1"
done < "$input"

if [[ $OPTION == "contract" ]]
then
  echo -e "\n"
  #Generate the contract in the respective folder by the template Adoption.sol
  echo -e "$(tput setaf 3)Generating files for the contract deployment$(tput setaf 7)\n"

  sed -e "s/total-adopters/$TOTAL_ADOPTERS/g" -e "s/total-one/$TOTAL_ADOPTERS_ONE/g" ./Adoption.sol > ../contracts/Adoption.sol

  #Compile and migrate the contract
  echo -e "$(tput setaf 6)Truffle Migrate$(tput setaf 7)\n"
  truffle migrate
fi

cp ./get_adopters.js ../test/get_adopters.js

echo -e "\n"
rm ./logs/*

echo -e "$(tput setaf 2)Creating Truffle Test processes$(tput setaf 7)\n"

index=1
while [ "$index" -le $TOTAL_USERS ]; do
  if [[ $index -le $TOTAL_USERS ]]
  then
    #truffle exec ../test/adopt_pets_$index.js > ./logs/truffle_test_$index.txt &
    truffle exec ../test/adopt_pets_$index.js > ./logs/truffle_test_$index.txt &
    processes_id[$index]="$!"
  fi
  let "index += 1"
done

echo -e "$(tput setaf 1)Waiting for processes$(tput setaf 7)\n"

p=1
while [ "$p" -le $TOTAL_USERS ]; do
  if [[ $p -le $TOTAL_USERS ]]
  then
    wait "${processes_id[$p]}"
    tag=$( tail -n 1 ./logs/truffle_test_$p.txt )
    total_time=$(cut -d' ' -f2 <<<"$tag")
    echo $total_time >> ./logs/truffle_test_total.txt
  fi
  let "p += 1"
done

# Kill Ganache-cli process running in the background
kill $ganache_p
