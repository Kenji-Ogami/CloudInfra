# README
# 1. 実現した機能（2021/12/1版）

* インスタンスをSCPで子サーバーに配信
* 空いているIPアドレスを探して取得する
* VMの設定とSSHの鍵を子サーバー内の各VM用ディレクトリに配信
* VM起動時、BootスクリプトでVM用領域に用意したマウントポイントをマウントし、設定と鍵を取得
* Web APIで起動したVMのIPアドレスとSSH用の鍵を配信
* 配信された鍵でVMにローカルからSSHでアクセス
* 余裕のあるサーバーをインスタンスに自動でアロケーションする（2021/12/1追加機能）
  * 余裕のあるサーバーを選択する為、コミット率というパラメータを導入
* VMのディスクイメージ転送、セットアップのタスクをスレッド化（2021/12/1追加機能）
* VMをAPI経由でシャットダウン、削除する機能（併せてIPアドレスも解放）（2021/12/1追加機能）
* 全てのインスタンスの状態を表示するダッシュボード機能（2021/12/1追加機能）

# 2. 記述したソースコード
* app/models/instances.rb                     : インスタンスの配信、セットアップ、削除、サーバー自動選択等の処理を記述
* app/models/ip_addresses.rb                  : IPアドレスの管理を記述
* app/controllers/instances_controllers.rb    : Web API、Dashboardの処理を記述
* app/controllers/ip_addresses_controllers.rb : Web APIを記述
* app/controllers/machines_controllers.rb     : Web APIを記述
* app/views/instances/index.html.erb          : Dashboard画面のデザイン
* app/assets/config/template.xml              : VMの定義ファイルのテンプレート
* app/assets/config/templage.cfg              : VMがBootする際にsourceさせる設定ファイルのテンプレート
* app/assets/config/rc.local                  : VM内に設置しているBoot Script
