import json
import os

def loadFont():
    f = open("config-kv.json", encoding='utf-8')  # 设置以utf-8解码模式读取文件，encoding参数必须设置，否则默认以gbk模式读取文件，当文件中包含中文时，会报错
    setting = json.load(f)
    return setting

t = loadFont()

print(t)

def alter(file,old_str,new_str):
    with open(file, "r", encoding="utf-8") as f1,open("%s.bak" % file, "w", encoding="utf-8") as f2:
        for line in f1:
	    s = re.sub(old_str,new_str,line)
            f2.write(s)
    os.remove(file)
    os.rename("%s.bak" % file, file)
alter("file1", "admin", "password")
