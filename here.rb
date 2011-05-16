puts(
# Variations:
#  - use single quotes on 'AA...'
#  - use single quotes on '222..'
"000" + <<"AA\n#{x}\" + "111" + <<BB + "222\
333
444#{<<CC + "555" + <<-DD}666
777
   CC
CC
888
   DD
999
AA\n#{x}\
aaa
BB
bbb"
)
