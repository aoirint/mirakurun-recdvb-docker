# Mirakurun Dockerfile for recdvb

- [dogeel/recdvb](https://github.com/dogeel/recdvb)
- [stz2012/libarib25](https://github.com/stz2012/libarib25)

libarib25は、オリジナルのDockerfileには
npmの[arib-b25-stream-test](https://www.npmjs.com/package/arib-b25-stream-test)
（[stz2012/libarib25](https://github.com/stz2012/libarib25)のフォーク）
が入っていて、`/opt/node_modules/arib-b25-stream-test/bin`に実行バイナリ、
`/opt/bin`にシンボリックリンクがあるが、このイメージでは自前ビルドしたものを使う。

- recdvbビルド時、実行時にパスが通っていればよさそう
- `/opt/bin`以下のファイル名が`b25`でないのでシンボリックリンク/コピーで要修正か、オプションで指定できるか？

workディレクトリはコンテナ起動時に短いテスト録画を行った結果が格納される（マウント不要）。
何かしらの形でDVBデバイスが不安定なのを検出するものを入れたい。

systemd serviceファイルは/opt/mirakurunにこのリポジトリをcloneする想定になっている。
dockerのrestart機能を使わないのは、再起動時やエラー発生時にコンテナを破棄するため。
コンテナ作成時にホスト側の/devにデバイスが存在しないときの、破棄を伴わないコンテナ再起動の挙動に不安がある。

ハードウェア操作時にブロックしてゾンビプロセスが発生、docker-composeから制御不能になることがあり、原因調査中。

