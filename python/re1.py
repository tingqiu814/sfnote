import re
a = 'hello word还玩儿玩儿(kzxcbjvsdfsd)'
strinfo = re.compile('\(.*\)')
b = strinfo.sub('',a)
print(b)
