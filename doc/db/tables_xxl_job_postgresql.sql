CREATE TABLE XXL_JOB_GROUP
(
    id           SERIAL PRIMARY KEY,
    app_name     VARCHAR(64) NOT NULL,
    title        VARCHAR(12) NOT NULL,
    address_type SMALLINT DEFAULT 0 NOT NULL,
    address_list VARCHAR(512),
    update_time  TIMESTAMP
);

COMMENT ON COLUMN XXL_JOB_GROUP.app_name
  IS '执行器AppName';
COMMENT ON COLUMN XXL_JOB_GROUP.title
  IS '执行器名称';
COMMENT ON COLUMN XXL_JOB_GROUP.address_type
  IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN XXL_JOB_GROUP.address_list
  IS '执行器地址列表，多地址逗号分隔';

CREATE TABLE XXL_JOB_INFO
(
    id                        SERIAL PRIMARY KEY,
    job_group                 INTEGER NOT NULL,
    job_desc                  VARCHAR(255) NOT NULL,
    add_time                  TIMESTAMP,
    update_time               TIMESTAMP,
    author                    VARCHAR(64),
    alarm_email               VARCHAR(255),
    schedule_type             VARCHAR(50) DEFAULT 'NONE' NOT NULL,
    schedule_conf             VARCHAR(128),
    misfire_strategy          VARCHAR(50) DEFAULT 'DO_NOTHING' NOT NULL,
    executor_route_strategy   VARCHAR(50),
    executor_handler          VARCHAR(255),
    executor_param            VARCHAR(512),
    executor_block_strategy   VARCHAR(50),
    executor_timeout          INTEGER DEFAULT 0 NOT NULL,
    executor_fail_retry_count INTEGER DEFAULT 0 NOT NULL,
    glue_type                 VARCHAR(50) NOT NULL,
    glue_source               TEXT,  -- Use TEXT for larger text, similar to NCLOB
    glue_remark               VARCHAR(128),
    glue_updatetime           TIMESTAMP,
    child_jobid               VARCHAR(255),
    trigger_status            SMALLINT DEFAULT 0 NOT NULL,
    trigger_last_time         BIGINT DEFAULT 0 NOT NULL,
    trigger_next_time         BIGINT DEFAULT 0 NOT NULL
);

COMMENT ON COLUMN XXL_JOB_INFO.job_group
  IS '执行器主键ID';
COMMENT ON COLUMN XXL_JOB_INFO.author
  IS '作者';
COMMENT ON COLUMN XXL_JOB_INFO.alarm_email
  IS '报警邮件';
COMMENT ON COLUMN XXL_JOB_INFO.schedule_type
  IS '调度类型';
COMMENT ON COLUMN XXL_JOB_INFO.schedule_conf
  IS '调度配置，值含义取决于调度类型';
COMMENT ON COLUMN XXL_JOB_INFO.misfire_strategy
  IS '调度过期策略';
COMMENT ON COLUMN XXL_JOB_INFO.executor_route_strategy
  IS '执行器路由策略';
COMMENT ON COLUMN XXL_JOB_INFO.executor_handler
  IS '执行器任务handler';
COMMENT ON COLUMN XXL_JOB_INFO.executor_param
  IS '执行器任务参数';
COMMENT ON COLUMN XXL_JOB_INFO.executor_block_strategy
  IS '阻塞处理策略';
COMMENT ON COLUMN XXL_JOB_INFO.executor_timeout
  IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN XXL_JOB_INFO.executor_fail_retry_count
  IS '失败重试次数';
COMMENT ON COLUMN XXL_JOB_INFO.glue_type
  IS 'GLUE类型';
COMMENT ON COLUMN XXL_JOB_INFO.glue_source
  IS 'GLUE源代码';
COMMENT ON COLUMN XXL_JOB_INFO.glue_remark
  IS 'GLUE备注';
COMMENT ON COLUMN XXL_JOB_INFO.glue_updatetime
  IS 'GLUE更新时间';
COMMENT ON COLUMN XXL_JOB_INFO.child_jobid
  IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN XXL_JOB_INFO.trigger_status
  IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN XXL_JOB_INFO.trigger_last_time
  IS '上次调度时间';
COMMENT ON COLUMN XXL_JOB_INFO.trigger_next_time
  IS '下次调度时间';

CREATE TABLE XXL_JOB_LOCK
(
    lock_name VARCHAR(50) NOT NULL PRIMARY KEY
);

COMMENT ON COLUMN XXL_JOB_LOCK.lock_name
  IS '锁名称';

CREATE TABLE XXL_JOB_LOG
(
    id                        BIGINT NOT NULL PRIMARY KEY,
    job_group                 INTEGER NOT NULL,
    job_id                    INTEGER NOT NULL,
    executor_address          VARCHAR(255),
    executor_handler          VARCHAR(255),
    executor_param            VARCHAR(512),
    executor_sharding_param   VARCHAR(20),
    executor_fail_retry_count INTEGER DEFAULT 0 NOT NULL,
    trigger_time              TIMESTAMP,
    trigger_code              INTEGER NOT NULL,
    trigger_msg               TEXT,  -- Use TEXT for larger text, similar to NCLOB
    handle_time               TIMESTAMP,
    handle_code               INTEGER NOT NULL,
    handle_msg                TEXT,  -- Use TEXT for larger text
    alarm_status              SMALLINT DEFAULT 0 NOT NULL
);

COMMENT ON COLUMN XXL_JOB_LOG.job_group
  IS '执行器主键ID';
COMMENT ON COLUMN XXL_JOB_LOG.job_id
  IS '任务，主键ID';
COMMENT ON COLUMN XXL_JOB_LOG.executor_address
  IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN XXL_JOB_LOG.executor_handler
  IS '执行器任务handler';
COMMENT ON COLUMN XXL_JOB_LOG.executor_param
  IS '执行器任务参数';
COMMENT ON COLUMN XXL_JOB_LOG.executor_sharding_param
  IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN XXL_JOB_LOG.executor_fail_retry_count
  IS '失败重试次数';
COMMENT ON COLUMN XXL_JOB_LOG.trigger_time
  IS '调度-时间';
COMMENT ON COLUMN XXL_JOB_LOG.trigger_code
  IS '调度-结果';
COMMENT ON COLUMN XXL_JOB_LOG.trigger_msg
  IS '调度-日志';
COMMENT ON COLUMN XXL_JOB_LOG.handle_time
  IS '执行-时间';
COMMENT ON COLUMN XXL_JOB_LOG.handle_code
  IS '执行-状态';
COMMENT ON COLUMN XXL_JOB_LOG.handle_msg
  IS '执行-日志';
COMMENT ON COLUMN XXL_JOB_LOG.alarm_status
  IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';

-- Create indexes
CREATE INDEX I_HANDLE_CODE ON XXL_JOB_LOG (handle_code);
CREATE INDEX I_TRIGGER_TIME ON XXL_JOB_LOG (trigger_time);

CREATE TABLE XXL_JOB_LOGGLUE
(
    id          INTEGER NOT NULL PRIMARY KEY,
    job_id      INTEGER NOT NULL,
    glue_type   VARCHAR(50),
    glue_source  TEXT,
    glue_remark VARCHAR(128) NOT NULL,
    add_time    TIMESTAMP,
    update_time TIMESTAMP
);

COMMENT ON COLUMN XXL_JOB_LOGGLUE.job_id
  IS '任务，主键ID';
COMMENT ON COLUMN XXL_JOB_LOGGLUE.glue_type
  IS 'GLUE类型';
COMMENT ON COLUMN XXL_JOB_LOGGLUE.glue_source
  IS 'GLUE源代码';
COMMENT ON COLUMN XXL_JOB_LOGGLUE.glue_remark
  IS 'GLUE备注';

CREATE TABLE XXL_JOB_LOG_REPORT
(
    id            INTEGER NOT NULL PRIMARY KEY,
    trigger_day   DATE,
    running_count INTEGER DEFAULT 0 NOT NULL,
    suc_count     INTEGER DEFAULT 0 NOT NULL,
    fail_count    INTEGER DEFAULT 0 NOT NULL,
    update_time   TIMESTAMP
);

COMMENT ON COLUMN XXL_JOB_LOG_REPORT.trigger_day
  IS '调度-时间';
COMMENT ON COLUMN XXL_JOB_LOG_REPORT.running_count
  IS '运行中-日志数量';
COMMENT ON COLUMN XXL_JOB_LOG_REPORT.suc_count
  IS '执行成功-日志数量';
COMMENT ON COLUMN XXL_JOB_LOG_REPORT.fail_count
  IS '执行失败-日志数量';

CREATE TABLE XXL_JOB_REGISTRY
(
    id             INTEGER NOT NULL PRIMARY KEY,
    registry_group VARCHAR(50) NOT NULL,
    registry_key   VARCHAR(255) NOT NULL,
    registry_value VARCHAR(255) NOT NULL,
    update_time    TIMESTAMP
);

-- Add comments (if needed)
COMMENT ON COLUMN XXL_JOB_REGISTRY.registry_group
  IS '注册组';
COMMENT ON COLUMN XXL_JOB_REGISTRY.registry_key
  IS '注册键';
COMMENT ON COLUMN XXL_JOB_REGISTRY.registry_value
  IS '注册值';
COMMENT ON COLUMN XXL_JOB_REGISTRY.update_time
  IS '更新时间';

CREATE TABLE XXL_JOB_USER
(
    id         INTEGER NOT NULL PRIMARY KEY,
    username   VARCHAR(50) NOT NULL,
    password   VARCHAR(50) NOT NULL,
    role       SMALLINT NOT NULL,
    permission VARCHAR(255)
);

-- Add comments (if needed)
COMMENT ON COLUMN XXL_JOB_USER.username
  IS '账号';
COMMENT ON COLUMN XXL_JOB_USER.password
  IS '密码';
COMMENT ON COLUMN XXL_JOB_USER.role
  IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN XXL_JOB_USER.permission
  IS '权限：执行器ID列表，多个逗号分割';

        -- Create sequences
CREATE SEQUENCE XXL_JOB_GROUP_ID
    START WITH 2
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE XXL_JOB_INFO_ID
    START WITH 2
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE XXL_JOB_LOGGLUE_ID
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE XXL_JOB_LOG_ID
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE XXL_JOB_REGISTRY_ID
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE XXL_JOB_USER_ID
    START WITH 2
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE XXL_JOB_LOG_REPORT_ID
    START WITH 2
    INCREMENT BY 1
    CACHE 20;

INSERT INTO xxl_job_group (id, app_name, title, address_type, address_list, update_time)
VALUES (1, 'xxl-job-executor-sample', '示例执行器', 0, NULL, CURRENT_TIMESTAMP);

INSERT INTO xxl_job_info (id, job_group, job_desc, add_time, update_time, author, alarm_email,
                          schedule_type, schedule_conf, misfire_strategy, executor_route_strategy,
                          executor_handler, executor_param, executor_block_strategy,
                          executor_timeout, executor_fail_retry_count, glue_type, glue_source,
                          glue_remark, glue_updatetime, child_jobid)
VALUES (1, 1, '测试任务1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'XXL', '', 'CRON',
        '0 0 0 * * ? *', 'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION',
        0, 0, 'BEAN', '', 'GLUE代码初始化', CURRENT_TIMESTAMP, '');

INSERT INTO xxl_job_user (id, username, password, role, permission)
VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);

INSERT INTO xxl_job_lock (lock_name)
VALUES ('schedule_lock');
