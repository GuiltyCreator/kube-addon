output: {
	name: "ngmanager-postgres"
	type: "postgres"
	properties: {
    POSTGRES_DB: "nginx"
		POSTGRES_USER: "ngmanager"
		POSTGRES_PASSWORD: "ngmanager"
		name: "ngmanager-pgsql"
		namespace: "ngmanager"
		image: "harbor.dev.wh.digitalchina.com/oam-test/ngmanager-postgres:12.6"
		port: 5432
		PGDATA: "/var/lib/postgresql/data"
		initsql: ##"""
/*
 Navicat Premium Data Transfer

 Source Server         : nginx-local
 Source Server Type    : PostgreSQL
 Source Server Version : 120006
 Source Host           : localhost:5432
 Source Catalog        : nginx-init
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 120006
 File Encoding         : 65001

 Date: 29/11/2021 16:10:28
*/


-- ----------------------------
-- Table structure for t_com_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_com_file";
CREATE TABLE "public"."t_com_file" (
                                       "id" varchar COLLATE "pg_catalog"."default" NOT NULL,
                                       "file_name" varchar(255) COLLATE "pg_catalog"."default",
                                       "content" bytea,
                                       "source" varchar(16) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_com_file"."id" IS '主键';
COMMENT ON COLUMN "public"."t_com_file"."file_name" IS '文件名称';
COMMENT ON COLUMN "public"."t_com_file"."content" IS '文件内容';
COMMENT ON COLUMN "public"."t_com_file"."source" IS '文件来源模块：device，file，node';
COMMENT ON TABLE "public"."t_com_file" IS '文件信息表，存储实际的文件';

-- ----------------------------
-- Records of t_com_file
-- ----------------------------

-- ----------------------------
-- Table structure for t_dev_access
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_dev_access";
CREATE TABLE "public"."t_dev_access" (
                                         "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                         "network" text[] COLLATE "pg_catalog"."default",
                                         "ntp" bool,
                                         "ip" varchar(16) COLLATE "pg_catalog"."default",
                                         "grpc_port" int8,
                                         "access_time" timestamp(6),
                                         "host_name" varchar(64) COLLATE "pg_catalog"."default",
                                         "iptables" bool
)
;
COMMENT ON COLUMN "public"."t_dev_access"."id" IS '主键';
COMMENT ON COLUMN "public"."t_dev_access"."network" IS '已接入设备的网卡名称';
COMMENT ON COLUMN "public"."t_dev_access"."ntp" IS '是否已安装ntp';
COMMENT ON COLUMN "public"."t_dev_access"."ip" IS '当前接入设备的ip';
COMMENT ON COLUMN "public"."t_dev_access"."grpc_port" IS '当前接入设备的grpc端口';
COMMENT ON COLUMN "public"."t_dev_access"."access_time" IS '接入时间';
COMMENT ON COLUMN "public"."t_dev_access"."host_name" IS '主机名称';
COMMENT ON COLUMN "public"."t_dev_access"."iptables" IS '是否已安装iptables';
COMMENT ON TABLE "public"."t_dev_access" IS '存储已接入设备的信息。每次接入新设备时刷新表数据。每次只能接入一个设备';

-- ----------------------------
-- Records of t_dev_access
-- ----------------------------

-- ----------------------------
-- Table structure for t_dev_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_dev_config";
CREATE TABLE "public"."t_dev_config" (
                                         "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                         "name" varchar(255) COLLATE "pg_catalog"."default",
                                         "ntp" text[] COLLATE "pg_catalog"."default",
                                         "app" text[] COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_dev_config"."id" IS '主键';
COMMENT ON COLUMN "public"."t_dev_config"."name" IS '名称';
COMMENT ON COLUMN "public"."t_dev_config"."ntp" IS 'NTP服务IP';
COMMENT ON COLUMN "public"."t_dev_config"."app" IS '应用ip:端口:映射端口';

-- ----------------------------
-- Records of t_dev_config
-- ----------------------------

-- ----------------------------
-- Table structure for t_dev_node
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_dev_node";
CREATE TABLE "public"."t_dev_node" (
                                       "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                       "name" varchar(255) COLLATE "pg_catalog"."default",
                                       "host_name" varchar(255) COLLATE "pg_catalog"."default",
                                       "ip" varchar(64) COLLATE "pg_catalog"."default",
                                       "net_mask" varchar(64) COLLATE "pg_catalog"."default",
                                       "tag" text[] COLLATE "pg_catalog"."default",
                                       "status" varchar(8) COLLATE "pg_catalog"."default",
                                       "pkg" varchar(64) COLLATE "pg_catalog"."default",
                                       "config" varchar(64) COLLATE "pg_catalog"."default",
                                       "dns" text[] COLLATE "pg_catalog"."default",
                                       "gateway" varchar(255) COLLATE "pg_catalog"."default",
                                       "network" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_dev_node"."id" IS '主键';
COMMENT ON COLUMN "public"."t_dev_node"."name" IS '节点名称';
COMMENT ON COLUMN "public"."t_dev_node"."host_name" IS '主机名';
COMMENT ON COLUMN "public"."t_dev_node"."ip" IS '节点IP';
COMMENT ON COLUMN "public"."t_dev_node"."net_mask" IS '网络掩码';
COMMENT ON COLUMN "public"."t_dev_node"."tag" IS '标记';
COMMENT ON COLUMN "public"."t_dev_node"."status" IS '设备状态。Init：初始化，未接入任何设备。Success：安装成功。Fail：安装失败';
COMMENT ON COLUMN "public"."t_dev_node"."pkg" IS '安装包文件。对应安装包表中的主键';
COMMENT ON COLUMN "public"."t_dev_node"."config" IS '公共配置。对应公共配置表中的主键';
COMMENT ON COLUMN "public"."t_dev_node"."dns" IS 'dns地址';
COMMENT ON COLUMN "public"."t_dev_node"."gateway" IS '网关地址';
COMMENT ON COLUMN "public"."t_dev_node"."network" IS '已选网卡';
COMMENT ON TABLE "public"."t_dev_node" IS '安装节点表';
-- ----------------------------
-- Records of t_dev_node
-- ----------------------------

-- ----------------------------
-- Table structure for t_dev_pkg
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_dev_pkg";
CREATE TABLE "public"."t_dev_pkg" (
                                      "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                      "name" varchar(255) COLLATE "pg_catalog"."default",
                                      "install" text[] COLLATE "pg_catalog"."default",
                                      "ssl" text[] COLLATE "pg_catalog"."default",
                                      "config" text[] COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_dev_pkg"."id" IS '主键';
COMMENT ON COLUMN "public"."t_dev_pkg"."name" IS '安装包名称';
COMMENT ON COLUMN "public"."t_dev_pkg"."install" IS '安装文件。对应安装包文件信息表中的主键';
COMMENT ON COLUMN "public"."t_dev_pkg"."ssl" IS '证书文件。对应安装包文件信息表中的主键';
COMMENT ON COLUMN "public"."t_dev_pkg"."config" IS '配置文件。对应安装包文件信息表中的主键';
COMMENT ON TABLE "public"."t_dev_pkg" IS '安装文件包信息表';

-- ----------------------------
-- Records of t_dev_pkg
-- ----------------------------

-- ----------------------------
-- Table structure for t_dev_pkg_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_dev_pkg_file";
CREATE TABLE "public"."t_dev_pkg_file" (
                                           "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                           "name" varchar(255) COLLATE "pg_catalog"."default",
                                           "content" varchar(64) COLLATE "pg_catalog"."default",
                                           "tag" text[] COLLATE "pg_catalog"."default",
                                           "created_at" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_dev_pkg_file"."id" IS '主键';
COMMENT ON COLUMN "public"."t_dev_pkg_file"."name" IS '文件名称';
COMMENT ON COLUMN "public"."t_dev_pkg_file"."content" IS '文件内容。对应文件信息表中的主键';
COMMENT ON COLUMN "public"."t_dev_pkg_file"."tag" IS '标记';
COMMENT ON COLUMN "public"."t_dev_pkg_file"."created_at" IS '上传时间';

-- ----------------------------
-- Records of t_dev_pkg_file
-- ----------------------------

-- ----------------------------
-- Table structure for t_file_upload
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_file_upload";
CREATE TABLE "public"."t_file_upload" (
                                          "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                          "file_name" varchar(255) COLLATE "pg_catalog"."default",
                                          "content" varchar(64) COLLATE "pg_catalog"."default",
                                          "tag" text[][] COLLATE "pg_catalog"."default",
                                          "created_at" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_file_upload"."id" IS '主键';
COMMENT ON COLUMN "public"."t_file_upload"."file_name" IS '文件名称';
COMMENT ON COLUMN "public"."t_file_upload"."content" IS '文件信息表的主键';
COMMENT ON COLUMN "public"."t_file_upload"."tag" IS 'tag标记';
COMMENT ON COLUMN "public"."t_file_upload"."created_at" IS '文件上传时间';
COMMENT ON TABLE "public"."t_file_upload" IS '上传文件表';

-- ----------------------------
-- Records of t_file_upload
-- ----------------------------

-- ----------------------------
-- Table structure for t_log_access
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_log_access";
CREATE TABLE "public"."t_log_access" (
                                         "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                         "node_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                         "time" timestamp(6),
                                         "status" varchar(255) COLLATE "pg_catalog"."default",
                                         "req" varchar(1024) COLLATE "pg_catalog"."default",
                                         "host" varchar(256) COLLATE "pg_catalog"."default",
                                         "code" int8,
                                         "bytes" int8,
                                         "client" varchar(64) COLLATE "pg_catalog"."default",
                                         "cachekey" varchar(1024) COLLATE "pg_catalog"."default",
                                         "http_pragma" varchar(255) COLLATE "pg_catalog"."default",
                                         "http_authorization" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                         "cookie_nocache" varchar(255) COLLATE "pg_catalog"."default",
                                         "arg_nocache" varchar(255) COLLATE "pg_catalog"."default",
                                         "referer" varchar(1024) COLLATE "pg_catalog"."default",
                                         "agent" varchar(255) COLLATE "pg_catalog"."default",
                                         "xff" varchar(255) COLLATE "pg_catalog"."default",
                                         "ups_addr" varchar(64) COLLATE "pg_catalog"."default",
                                         "ups_host" varchar(64) COLLATE "pg_catalog"."default",
                                         "req_time" varchar(255) COLLATE "pg_catalog"."default",
                                         "ups_res_time" varchar(64) COLLATE "pg_catalog"."default",
                                         "ups_con_time" varchar(64) COLLATE "pg_catalog"."default",
                                         "ups_header_time" varchar(64) COLLATE "pg_catalog"."default",
                                         "uhv" varchar(255) COLLATE "pg_catalog"."default",
                                         "uhsc" varchar(255) COLLATE "pg_catalog"."default",
                                         "uhe" varchar(255) COLLATE "pg_catalog"."default",
                                         "uhcc" varchar(255) COLLATE "pg_catalog"."default",
                                         "uhxae" varchar(255) COLLATE "pg_catalog"."default",
                                         "content" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_log_access"."id" IS '主键';
COMMENT ON COLUMN "public"."t_log_access"."node_id" IS '对应的节点id';
COMMENT ON COLUMN "public"."t_log_access"."content" IS '完整内容';
COMMENT ON TABLE "public"."t_log_access" IS '自取模式下，存储每个节点最新的access日志数据。最多5M';

-- ----------------------------
-- Records of t_log_access
-- ----------------------------

-- ----------------------------
-- Table structure for t_log_error
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_log_error";
CREATE TABLE "public"."t_log_error" (
                                        "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                        "node_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                        "time" timestamp(6),
                                        "type" varchar(16) COLLATE "pg_catalog"."default",
                                        "content" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_log_error"."id" IS '主键';
COMMENT ON COLUMN "public"."t_log_error"."node_id" IS '节点id';
COMMENT ON COLUMN "public"."t_log_error"."time" IS '记录时间';
COMMENT ON COLUMN "public"."t_log_error"."type" IS '记录类型，info、error、warn、alert等';
COMMENT ON COLUMN "public"."t_log_error"."content" IS '完整内容';
COMMENT ON TABLE "public"."t_log_error" IS '自取模式下，存储每个节点最新的error日志。记录最近一周的数据';

-- ----------------------------
-- Records of t_log_error
-- ----------------------------

-- ----------------------------
-- Table structure for t_node_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_node_file";
CREATE TABLE "public"."t_node_file" (
                                        "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                        "node_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                        "name" varchar(255) COLLATE "pg_catalog"."default",
                                        "file_type" varchar(64) COLLATE "pg_catalog"."default",
                                        "url" varchar(255) COLLATE "pg_catalog"."default",
                                        "content" varchar(64) COLLATE "pg_catalog"."default",
                                        "status" varchar(8) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_node_file"."id" IS '主键';
COMMENT ON COLUMN "public"."t_node_file"."node_id" IS '对应节点注册信息表的主键';
COMMENT ON COLUMN "public"."t_node_file"."name" IS '文件名称';
COMMENT ON COLUMN "public"."t_node_file"."file_type" IS '文件类型。config：配置文件，ssl：证书文件';
COMMENT ON COLUMN "public"."t_node_file"."url" IS '文件地址';
COMMENT ON COLUMN "public"."t_node_file"."content" IS '文件内容。';
COMMENT ON COLUMN "public"."t_node_file"."status" IS '发布状态。INIT：未修改，UPDATE：已修改';
COMMENT ON TABLE "public"."t_node_file" IS '节点文件表，存储节点当前文件信息。包含配置文件，ssl文件等';

-- ----------------------------
-- Records of t_node_file
-- ----------------------------

-- ----------------------------
-- Table structure for t_node_file_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_node_file_log";
CREATE TABLE "public"."t_node_file_log" (
                                            "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                            "file_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                            "name" varchar(255) COLLATE "pg_catalog"."default",
                                            "file_type" varchar(64) COLLATE "pg_catalog"."default",
                                            "url" varchar(255) COLLATE "pg_catalog"."default",
                                            "content" varchar(64) COLLATE "pg_catalog"."default",
                                            "publish_time" timestamp(0)
)
;
COMMENT ON COLUMN "public"."t_node_file_log"."id" IS '主键';
COMMENT ON COLUMN "public"."t_node_file_log"."file_id" IS '对应节点文件表中的主键';
COMMENT ON COLUMN "public"."t_node_file_log"."name" IS '文件名称';
COMMENT ON COLUMN "public"."t_node_file_log"."file_type" IS '文件类型。config：配置文件，ssl：证书文件';
COMMENT ON COLUMN "public"."t_node_file_log"."url" IS '文件地址';
COMMENT ON COLUMN "public"."t_node_file_log"."content" IS '文件内容，对应文件信息表的主键';
COMMENT ON COLUMN "public"."t_node_file_log"."publish_time" IS '发布时间';
COMMENT ON TABLE "public"."t_node_file_log" IS '节点文件日志表，用于存储所有节点的配置文件修改与发布的日志信息';

-- ----------------------------
-- Records of t_node_file_log
-- ----------------------------

-- ----------------------------
-- Table structure for t_node_metric
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_node_metric";
CREATE TABLE "public"."t_node_metric" (
                                          "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL::character varying,
                                          "node_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                          "cpu_use" numeric(10,2),
                                          "disk_use" numeric(10,2),
                                          "mem_use" numeric(10,2),
                                          "mem_free" numeric(10,2),
                                          "swap_use" numeric(10,2),
                                          "net_drop_in" int8,
                                          "net_drop_out" int8,
                                          "net_listen_overflow" int8,
                                          "oss_http_conn_drop" int8,
                                          "oss_http_conn_accept" int8,
                                          "oss_http_conn_current" int8,
                                          "oss_http_conn_idle" int8,
                                          "oss_http_req_rps" int8,
                                          "oss_http_resp_4xx" int8,
                                          "oss_http_resp_5xx" int8,
                                          "oss_http_resp_discard" int8,
                                          "oss_http_conn_active" int8,
                                          "oss_upstream_conn_time" int8,
                                          "plus_http_ssl_failed" int8,
                                          "plus_http_resp_4xx" int8,
                                          "plus_http_resp_5xx" int8,
                                          "plus_http_resp_discard" int8,
                                          "total_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_node_metric"."id" IS '主键';
COMMENT ON COLUMN "public"."t_node_metric"."node_id" IS '节点id';
COMMENT ON COLUMN "public"."t_node_metric"."cpu_use" IS 'cpu使用率';
COMMENT ON COLUMN "public"."t_node_metric"."disk_use" IS '磁盘使用率';
COMMENT ON COLUMN "public"."t_node_metric"."mem_use" IS '内存使用率';
COMMENT ON COLUMN "public"."t_node_metric"."mem_free" IS '内存空闲大小，单位MB';
COMMENT ON COLUMN "public"."t_node_metric"."swap_use" IS '交换区使用率';
COMMENT ON COLUMN "public"."t_node_metric"."net_drop_in" IS '入包丢弃量';
COMMENT ON COLUMN "public"."t_node_metric"."net_drop_out" IS '出包丢弃量';
COMMENT ON COLUMN "public"."t_node_metric"."net_listen_overflow" IS 'listen队列溢出数量';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_conn_drop" IS '丢弃HTTP连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_conn_accept" IS '接受http连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_conn_current" IS 'OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_conn_idle" IS 'OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_req_rps" IS '采样周期内的平均rps。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_resp_4xx" IS '4xx响应报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_resp_5xx" IS '5xx响应报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_resp_discard" IS '丢弃报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_http_conn_active" IS '当前active连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."oss_upstream_conn_time" IS '单位ms。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric"."plus_http_ssl_failed" IS 'http失败数。plus专有';
COMMENT ON COLUMN "public"."t_node_metric"."plus_http_resp_4xx" IS '4xx响应报文数';
COMMENT ON COLUMN "public"."t_node_metric"."plus_http_resp_5xx" IS '5xx响应报文数';
COMMENT ON COLUMN "public"."t_node_metric"."plus_http_resp_discard" IS '丢弃响应报文数';
COMMENT ON COLUMN "public"."t_node_metric"."total_time" IS '统计时间';

-- ----------------------------
-- Records of t_node_metric
-- ----------------------------

-- ----------------------------
-- Table structure for t_node_metric_day
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_node_metric_day";
CREATE TABLE "public"."t_node_metric_day" (
                                              "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL::character varying,
                                              "node_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                              "cpu_use" numeric(10,2),
                                              "disk_use" numeric(10,2),
                                              "mem_use" numeric(10,2),
                                              "swap_use" numeric(10,2),
                                              "net_drop_in" int8,
                                              "net_drop_out" int8,
                                              "net_listen_overflow" int8,
                                              "oss_http_conn_drop" int8,
                                              "oss_http_conn_accept" int8,
                                              "oss_http_conn_current" int8,
                                              "oss_http_conn_idle" int8,
                                              "oss_http_req_rps" int8,
                                              "oss_http_resp_4xx" int8,
                                              "oss_http_resp_5xx" int8,
                                              "oss_http_resp_discard" int8,
                                              "oss_upstream_conn_time" int8,
                                              "plus_http_ssl_failed" int8,
                                              "plus_http_resp_4xx" int8,
                                              "plus_http_resp_5xx" int8,
                                              "plus_http_resp_discard" int8,
                                              "mem_free" numeric(10,2),
                                              "oss_http_conn_active" int8,
                                              "total_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_node_metric_day"."id" IS '主键';
COMMENT ON COLUMN "public"."t_node_metric_day"."node_id" IS '节点id';
COMMENT ON COLUMN "public"."t_node_metric_day"."cpu_use" IS 'cpu使用率';
COMMENT ON COLUMN "public"."t_node_metric_day"."disk_use" IS '磁盘使用率';
COMMENT ON COLUMN "public"."t_node_metric_day"."mem_use" IS '内存使用率';
COMMENT ON COLUMN "public"."t_node_metric_day"."swap_use" IS '交换区使用率';
COMMENT ON COLUMN "public"."t_node_metric_day"."net_drop_in" IS '入包丢弃量';
COMMENT ON COLUMN "public"."t_node_metric_day"."net_drop_out" IS '出包丢弃量';
COMMENT ON COLUMN "public"."t_node_metric_day"."net_listen_overflow" IS 'listen队列溢出数量';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_conn_drop" IS '丢弃HTTP连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_conn_accept" IS '接受http连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_conn_current" IS 'OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_conn_idle" IS 'OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_req_rps" IS '采样周期内的平均rps。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_resp_4xx" IS '4xx响应报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_resp_5xx" IS '5xx响应报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_resp_discard" IS '丢弃报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_upstream_conn_time" IS '单位ms。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."plus_http_ssl_failed" IS 'http失败数。plus专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."plus_http_resp_4xx" IS '4xx响应报文数';
COMMENT ON COLUMN "public"."t_node_metric_day"."plus_http_resp_5xx" IS '5xx响应报文数';
COMMENT ON COLUMN "public"."t_node_metric_day"."plus_http_resp_discard" IS '丢弃响应报文数';
COMMENT ON COLUMN "public"."t_node_metric_day"."mem_free" IS '内存空闲大小，单位MB';
COMMENT ON COLUMN "public"."t_node_metric_day"."oss_http_conn_active" IS '当前active连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_day"."total_time" IS '统计时间';

-- ----------------------------
-- Records of t_node_metric_day
-- ----------------------------

-- ----------------------------
-- Table structure for t_node_metric_hour
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_node_metric_hour";
CREATE TABLE "public"."t_node_metric_hour" (
                                               "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL DEFAULT NULL::character varying,
                                               "node_id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                               "cpu_use" numeric(10,2),
                                               "disk_use" numeric(10,2),
                                               "mem_use" numeric(10,2),
                                               "swap_use" numeric(10,2),
                                               "net_drop_in" int8,
                                               "net_drop_out" int8,
                                               "net_listen_overflow" int8,
                                               "oss_http_conn_drop" int8,
                                               "oss_http_conn_accept" int8,
                                               "oss_http_conn_current" int8,
                                               "oss_http_conn_idle" int8,
                                               "oss_http_req_rps" int8,
                                               "oss_http_resp_4xx" int8,
                                               "oss_http_resp_5xx" int8,
                                               "oss_http_resp_discard" int8,
                                               "oss_upstream_conn_time" int8,
                                               "plus_http_ssl_failed" int8,
                                               "plus_http_resp_4xx" int8,
                                               "plus_http_resp_5xx" int8,
                                               "plus_http_resp_discard" int8,
                                               "mem_free" numeric(10,2),
                                               "oss_http_conn_active" int8,
                                               "total_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_node_metric_hour"."id" IS '主键';
COMMENT ON COLUMN "public"."t_node_metric_hour"."node_id" IS '节点id';
COMMENT ON COLUMN "public"."t_node_metric_hour"."cpu_use" IS 'cpu使用率';
COMMENT ON COLUMN "public"."t_node_metric_hour"."disk_use" IS '磁盘使用率';
COMMENT ON COLUMN "public"."t_node_metric_hour"."mem_use" IS '内存使用率';
COMMENT ON COLUMN "public"."t_node_metric_hour"."swap_use" IS '交换区使用率';
COMMENT ON COLUMN "public"."t_node_metric_hour"."net_drop_in" IS '入包丢弃量';
COMMENT ON COLUMN "public"."t_node_metric_hour"."net_drop_out" IS '出包丢弃量';
COMMENT ON COLUMN "public"."t_node_metric_hour"."net_listen_overflow" IS 'listen队列溢出数量';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_conn_drop" IS '丢弃HTTP连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_conn_accept" IS '接受http连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_conn_current" IS 'OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_conn_idle" IS 'OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_req_rps" IS '采样周期内的平均rps。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_resp_4xx" IS '4xx响应报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_resp_5xx" IS '5xx响应报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_resp_discard" IS '丢弃报文数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_upstream_conn_time" IS '单位ms。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."plus_http_ssl_failed" IS 'http失败数。plus专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."plus_http_resp_4xx" IS '4xx响应报文数';
COMMENT ON COLUMN "public"."t_node_metric_hour"."plus_http_resp_5xx" IS '5xx响应报文数';
COMMENT ON COLUMN "public"."t_node_metric_hour"."plus_http_resp_discard" IS '丢弃响应报文数';
COMMENT ON COLUMN "public"."t_node_metric_hour"."mem_free" IS '内存空闲大小，单位MB';
COMMENT ON COLUMN "public"."t_node_metric_hour"."oss_http_conn_active" IS '当前active连接数。OSS专有';
COMMENT ON COLUMN "public"."t_node_metric_hour"."total_time" IS '统计时间';

-- ----------------------------
-- Records of t_node_metric_hour
-- ----------------------------

-- ----------------------------
-- Table structure for t_node_register
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_node_register";
CREATE TABLE "public"."t_node_register" (
                                            "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                            "ip" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
                                            "status" varchar(8) COLLATE "pg_catalog"."default",
                                            "tag" text[][] COLLATE "pg_catalog"."default",
                                            "name" varchar(64) COLLATE "pg_catalog"."default",
                                            "os" varchar(64) COLLATE "pg_catalog"."default",
                                            "cpu" varchar(64) COLLATE "pg_catalog"."default",
                                            "nginx_type" varchar(64) COLLATE "pg_catalog"."default",
                                            "nginx_version" varchar(64) COLLATE "pg_catalog"."default",
                                            "agent_version" varchar(64) COLLATE "pg_catalog"."default",
                                            "disk_total" numeric(10,2),
                                            "mem_total" numeric(10,2),
                                            "grpc_port" int8,
                                            "register_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_node_register"."id" IS '主键';
COMMENT ON COLUMN "public"."t_node_register"."ip" IS 'IP地址，唯一';
COMMENT ON COLUMN "public"."t_node_register"."status" IS '节点状态。Up：在线，Down：离线，Fault：异常';
COMMENT ON COLUMN "public"."t_node_register"."tag" IS 'tag标签。多个值，数组格式';
COMMENT ON COLUMN "public"."t_node_register"."name" IS '节点名称';
COMMENT ON COLUMN "public"."t_node_register"."os" IS 'os信息';
COMMENT ON COLUMN "public"."t_node_register"."cpu" IS 'cpu信息';
COMMENT ON COLUMN "public"."t_node_register"."nginx_type" IS 'nginx类型';
COMMENT ON COLUMN "public"."t_node_register"."nginx_version" IS 'nginx版本';
COMMENT ON COLUMN "public"."t_node_register"."agent_version" IS 'agent版本';
COMMENT ON COLUMN "public"."t_node_register"."disk_total" IS '磁盘容量';
COMMENT ON COLUMN "public"."t_node_register"."mem_total" IS '内存容量';
COMMENT ON COLUMN "public"."t_node_register"."grpc_port" IS 'agent侧gprc端口号';
COMMENT ON COLUMN "public"."t_node_register"."register_time" IS '注册时间';
COMMENT ON TABLE "public"."t_node_register" IS '节点注册信息表，用于存储所有节点的注册信息';

-- ----------------------------
-- Records of t_node_register
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_sys_config";
CREATE TABLE "public"."t_sys_config" (
                                         "key" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
                                         "value" varchar(64) COLLATE "pg_catalog"."default",
                                         "module" varchar(16) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_sys_config"."key" IS '配置key';
COMMENT ON COLUMN "public"."t_sys_config"."value" IS '配置value。elk的IP地址，MQ：自取，默认；ELK：elk获取';
COMMENT ON COLUMN "public"."t_sys_config"."module" IS '模块名。可选值：system。device';
COMMENT ON TABLE "public"."t_sys_config" IS '系统配置信息表';

-- ----------------------------
-- Records of t_sys_config
-- ----------------------------
INSERT INTO "public"."t_sys_config" VALUES ('install_mode', 'n', 'device');
INSERT INTO "public"."t_sys_config" VALUES ('elk_ip', '', 'system');
INSERT INTO "public"."t_sys_config" VALUES ('log_type', 'MQ', 'system');

-- ----------------------------
-- Table structure for t_sys_license
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_sys_license";
CREATE TABLE "public"."t_sys_license" (
                                          "user" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                          "cutoff_time" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                          "node_num" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                          "license" text COLLATE "pg_catalog"."default" NOT NULL,
                                          "valid_time" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
COMMENT ON COLUMN "public"."t_sys_license"."user" IS '用户名';
COMMENT ON COLUMN "public"."t_sys_license"."cutoff_time" IS '激活截止时间，加密保存';
COMMENT ON COLUMN "public"."t_sys_license"."node_num" IS '节点数量，加密保存';
COMMENT ON COLUMN "public"."t_sys_license"."license" IS 'license加密字符串';
COMMENT ON COLUMN "public"."t_sys_license"."valid_time" IS '有效期限，月。加密保存';
COMMENT ON TABLE "public"."t_sys_license" IS 'license激活信息表';

-- ----------------------------
-- Records of t_sys_license
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys_role
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_sys_role";
CREATE TABLE "public"."t_sys_role" (
                                       "id" int4 NOT NULL,
                                       "name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_sys_role"."id" IS '主键，角色id';
COMMENT ON COLUMN "public"."t_sys_role"."name" IS '角色名称';
COMMENT ON TABLE "public"."t_sys_role" IS '角色信息表，预置4个角色。不可更改';

-- ----------------------------
-- Records of t_sys_role
-- ----------------------------
INSERT INTO "public"."t_sys_role" VALUES (1, '安装用户');
INSERT INTO "public"."t_sys_role" VALUES (5, '普通用户');
INSERT INTO "public"."t_sys_role" VALUES (4, '操作员');
INSERT INTO "public"."t_sys_role" VALUES (3, '管理员');
INSERT INTO "public"."t_sys_role" VALUES (2, '超级管理员');

-- ----------------------------
-- Table structure for t_sys_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_sys_user";
CREATE TABLE "public"."t_sys_user" (
                                       "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
                                       "user_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
                                       "password" varchar(255) COLLATE "pg_catalog"."default",
                                       "role_id" int4,
                                       "pwd_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_sys_user"."id" IS '用户id，主键';
COMMENT ON COLUMN "public"."t_sys_user"."user_name" IS '用户姓名，唯一，用于登录';
COMMENT ON COLUMN "public"."t_sys_user"."password" IS '密码';
COMMENT ON COLUMN "public"."t_sys_user"."role_id" IS '角色id。对应角色信息表中的主键';
COMMENT ON COLUMN "public"."t_sys_user"."pwd_time" IS '密码修改时间。空表示首次登录';
COMMENT ON TABLE "public"."t_sys_user" IS '用户信息表';

-- ----------------------------
-- Records of t_sys_user
-- ----------------------------
INSERT INTO "public"."t_sys_user" VALUES ('892099087933902848', 'root', '$2a$04$WTzYzlrNGLv4s0FKc4XZxO/8Y026Fm9KsAY/yWkOOx6h5kYQ7uMd2', 1, NULL);
INSERT INTO "public"."t_sys_user" VALUES ('892099087933902849', 'admin', '$2a$04$EwF4rbvLpLHmIaiFNQqznO6oYByd10xyrc0ApRvRPV/St.S7hsh9m', 2, NULL);

-- ----------------------------
-- Primary Key structure for table t_com_file
-- ----------------------------
ALTER TABLE "public"."t_com_file" ADD CONSTRAINT "t_com_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_dev_access
-- ----------------------------
ALTER TABLE "public"."t_dev_access" ADD CONSTRAINT "t_dev_access_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_dev_config
-- ----------------------------
ALTER TABLE "public"."t_dev_config" ADD CONSTRAINT "t_dev_config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_dev_node
-- ----------------------------
ALTER TABLE "public"."t_dev_node" ADD CONSTRAINT "t_dev_node_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_dev_pkg
-- ----------------------------
ALTER TABLE "public"."t_dev_pkg" ADD CONSTRAINT "t_dev_pkg_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_dev_pkg_file
-- ----------------------------
ALTER TABLE "public"."t_dev_pkg_file" ADD CONSTRAINT "t_dev_pkg_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_file_upload
-- ----------------------------
ALTER TABLE "public"."t_file_upload" ADD CONSTRAINT "t_file_upload_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_log_access
-- ----------------------------
ALTER TABLE "public"."t_log_access" ADD CONSTRAINT "t_log_access_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_log_error
-- ----------------------------
ALTER TABLE "public"."t_log_error" ADD CONSTRAINT "t_log_error_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_node_file
-- ----------------------------
ALTER TABLE "public"."t_node_file" ADD CONSTRAINT "t_node_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_node_file_log
-- ----------------------------
ALTER TABLE "public"."t_node_file_log" ADD CONSTRAINT "t_node_file_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_node_metric
-- ----------------------------
ALTER TABLE "public"."t_node_metric" ADD CONSTRAINT "t_node_metric_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_node_metric_day
-- ----------------------------
ALTER TABLE "public"."t_node_metric_day" ADD CONSTRAINT "t_node_metric_day_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_node_metric_hour
-- ----------------------------
ALTER TABLE "public"."t_node_metric_hour" ADD CONSTRAINT "t_node_metric_hour_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table t_node_register
-- ----------------------------
ALTER TABLE "public"."t_node_register" ADD CONSTRAINT "t_node_register_ip_key" UNIQUE ("ip");

-- ----------------------------
-- Primary Key structure for table t_node_register
-- ----------------------------
ALTER TABLE "public"."t_node_register" ADD CONSTRAINT "t_node_register_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_sys_config
-- ----------------------------
ALTER TABLE "public"."t_sys_config" ADD CONSTRAINT "t_sys_config_pkey" PRIMARY KEY ("key");

-- ----------------------------
-- Primary Key structure for table t_sys_role
-- ----------------------------
ALTER TABLE "public"."t_sys_role" ADD CONSTRAINT "t_sys_role_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table t_sys_user
-- ----------------------------
ALTER TABLE "public"."t_sys_user" ADD CONSTRAINT "t_sys_user_user_name_key" UNIQUE ("user_name");

-- ----------------------------
-- Primary Key structure for table t_sys_user
-- ----------------------------
ALTER TABLE "public"."t_sys_user" ADD CONSTRAINT "t_sys_user_pkey" PRIMARY KEY ("id");
"""##
	}

//	traits:[{
//		type: "storage"
//		properties: pvc:[{
//			mountPath: "/var/lib/postgresql/data"
//      name: "postgredb"
//			resources:{
//      	requests: storage: "8Gi"
////        limits: storage: "8Gi"
//      }
//      selector: {
//      	matchLabels
//      }
//    }]
//	}]
}