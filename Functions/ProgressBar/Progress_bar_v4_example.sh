#!/bin/sh

source  $(dirname $0)/Progress_bar_v4.sh

tput reset

START=1
END=100

printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Black to White" $NUM $END 232  233  234  235  236  237  238  239  240  241  242  243  244  245  246  247  248  249  250  251  252  253  254  255 # black to white
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Red" $NUM $END 196 # Red
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Red Cylinders" $NUM 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 016  052  088  124  160 124 088 052 016 # red cylinders
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Yellow Cyclinders" $NUM 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 016  058  100  142  184 184 142 100 058 016 # Yellow cylinders
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Green to Yellow" $NUM $END 028  064  070  106  142  148  184  226  220  214  208  202  196 # Green yellow red gradient
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Red Yellow" $NUM 0 226  220 220  214  208  202 202 196 202 202  208  214  220 220 # Red yellow red gradient
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Yellow and Blue" $NUM 0 0 0 0 0 0 0 0 0 0 226 033 # Yellow and blue
done


tput reset
printf "\n\n\n"
# Proof of concept
for NUM in $(seq ${START} ${END}); do
    ProgressBar "Rainbow" $NUM $END 165 129 93 57 21 20 19 18 17 52 088 124 160 196 197 198 199 200 201 #Gradient
done







exit 0
