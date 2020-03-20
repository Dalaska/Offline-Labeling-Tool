#https://zhuanlan.zhihu.com/p/27917664
import json

# 转换文件
# s1 = json.loads('calibrated_sensor.json')
with open('calibrated_sensor.json', encoding='utf-8') as f:
    line = f.readline()
    d = json.loads(line)
    name = d['token']
    print(name,)
    f.close()
pass