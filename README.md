fluent-plugin-webpost
=====================

受け取ったレコードを指定の web api にポストするアウトプットプラグインです

http body としてレコードの配列を json 形式で格納します。その他、バッファや再送処理などは fluentd のBufferOutput の機構に準じます。

利用方法
----------------------

```
<match leia.result.post>
  post_url http://example.com/post/
  user_agent jedi/bot1.0

  flush_interval 5s
</match>
```


