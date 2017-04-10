# rails360

网站：[rails360](http://rails360.com:8080)

### 依赖

* rails 5.0
* ruby 2.4
* mysql 5.7
* redis
* imagemagick 

### 运行

mysql、redis服务必须先启动好。

```
bundle install
rake db:create
rake db:migrate
rake db:seed
rails s
```

### 测试

```
bundle exec rspec
```

### TODO

* 优化管理页面
* 添加全文检索功能
* ...