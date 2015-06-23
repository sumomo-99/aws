#aws ElastiCache for Redis, RDS Snapshot Scripts  


ElastiCache for Redis, RDSのスナップショットを手動で取得するrubyスクリプトです。  

##Install
* 任意のディレクトリにスクリプトファイルを設置してください。
* aws-sdk for ruby v2が必要です。

##Usage
###ElastiCache for Redis
スナップショットを取得するElastiCacheのcluster-idとReginを指定して実行してください。  

``snapshot-redis.rb -c <CLUSTER-ID> -r <REGION>``

デフォルトでは3世代分のスナップショットを残し、古いスナップショットはスクリプト中で削除しています。  
保存する世代数を変更する場合は、スクリプト中の`SNAP_NUM`の値を変更してください。

####option
+ ``-c <CLUSTER-ID>, --cluster <CLUSTER-ID>``  
 スナップショットを取得するElastiCacheの**cluster-id**を指定します。必須のオプションです。  

+ ``-r <REGION>, --region <REGION>``  
スナップショットを取得するElastiCacheの**Region**を指定します。  
指定しない場合は、デフォルトで*ap-northeast-1*が設定されます。


###RDS
スナップショットを取得するRDSのDB InstanceとReginを指定して実行してください。  

``snapshot-rds.rb -c <DB-Instance> -r <REGION>``

デフォルトでは3世代分のスナップショットを残し、古いスナップショットはスクリプト中で削除しています。  
保存する世代数を変更する場合は、スクリプト中の`SNAP_NUM`の値を変更してください。

####option
+ ``-c <DB-Instance>, --cluster <DB-Instance>``  
 スナップショットを取得するRDSの**DB Instance**を指定します。必須のオプションです。  

+ ``-r <REGION>, --region <REGION>``  
スナップショットを取得するRDSの**Region**を指定します。  
指定しない場合は、デフォルトで*ap-northeast-1*が設定されます。
