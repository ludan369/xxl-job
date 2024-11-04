## application.properties配置文件的关键配置项

```properties
### mybatis 修改此处的同时请勾选相应的profile：目前支持：mysql、oracle、postgresql
xxljob-dialect=oracle #在此处配置数据库【数据库脚本在doc/db】
mybatis.mapper-locations=classpath:/mybatis-mapper/${xxljob-dialect}/*Mapper.xml
#mybatis.type-aliases-package=com.xxl.job.admin.core.model

### xxl-job, datasource
spring.profiles.active=${xxljob-dialect}
```

## profiles激活依赖
```xml
<profiles>
    <profile>
        <id>mysql</id>
        <activation>
            <property>
                <name>xxljob-dialect</name>
                <value>mysql</value>
            </property>
        </activation>
        <dependencies>
            <!-- 使用 MySQL 的依赖 -->
            <dependency>
                <groupId>com.mysql</groupId>
                <artifactId>mysql-connector-j</artifactId>
                <version>${mysql-connector-j.version}</version>
            </dependency>
        </dependencies>
    </profile>
    <profile>
        <id>oracle</id>
        <activation>
            <property>
                <name>xxljob-dialect</name>
                <value>oracle</value>
            </property>
        </activation>
        <dependencies>
            <!-- 使用 Oracle 的依赖 -->
            <dependency>
                <groupId>com.oracle.ojdbc</groupId>
                <artifactId>ojdbc8</artifactId>
                <version>19.3.0.0</version>
            </dependency>
            <dependency>
                <groupId>com.oracle.database.nls</groupId>
                <artifactId>orai18n</artifactId>
                <version>19.7.0.0</version>
            </dependency>
        </dependencies>
    </profile>
    <profile>
        <id>postgresql</id>
        <activation>
            <property>
                <name>xxljob-dialect</name>
                <value>postgresql</value>
            </property>
        </activation>
        <dependencies>
            <!-- 使用 postgresql 的依赖 -->
            <dependency>
                <groupId>org.postgresql</groupId>
                <artifactId>postgresql</artifactId>
                <version>42.2.16</version>
            </dependency>
        </dependencies>
    </profile>
</profiles>
```
