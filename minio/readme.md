
docker run -p 9000:9000  -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"  minio/minio server /data
启动，并且设置access_key与secret_key 
此时可以通过localhost:9000 访问页面版，输入access,secret进入体验页面版功能，创建bucket，上传，删除，无修改。
命令行方式： 
mc

docker pull minio/mc
docker run minio/mc ls play
安装工具
mc ls play
创建bucket (make bucket) 不能用下划线
mc mb play/test-1
copy
mc cp a.txt play/test-_1/
list
mc ls play


下面来看看使用客户端调用方式（golang）
package main

import (
  "github.com/minio/minio-go/v6"
  "log"
)

func main() {
  endpoint := "localhost"
  accessKeyID := "AKIAIOSFODNN7EXAMPLE"
  secretAccessKey := "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  useSSL := true

  // Initialize minio client object.
  minioClient, err := minio.New(endpoint, accessKeyID, secretAccessKey, useSSL)
  if err != nil {
    log.Fatalln(err)
  }

  log.Printf("success %#v\n", minioClient) // minioClient is now setup
}


正常连接





