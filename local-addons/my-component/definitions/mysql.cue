import(
	"encoding/base64"
)
mysql: {
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
	}
	description: "My mysql component."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "v1"
		data: "mysqld.cnf": """
        [mysqld]
        pid-file        = /var/run/mysqld/mysqld.pid
        socket          = /var/run/mysqld/mysqld.sock
        datadir         = /var/lib/mysql
        bind-address   = 0.0.0.0
        symbolic-links=0
        max_connections=1000
        default_storage_engine=innodb
        skip_external_locking
        lower_case_table_names=1
        skip_host_cache
        skip_name_resolve
        character_set_server=utf8
        sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
        """
		kind: "ConfigMap"
		metadata: {
			name:      context.name + "-mysql-config"
		}
	}
	outputs: {
		mysql: {
			apiVersion: "apps/v1"
			kind:       "StatefulSet"
			metadata: {
				name: context.name + "-mysql"
			}
			spec: {
				selector: matchLabels: app: context.name + "-mysql"
				replicas:    1
				serviceName: context.name + "-mysql-headless"
				template: {
					metadata: labels: app: context.name + "-mysql"
					spec: {
						containers: [{
							name: "mysql"
							env: [{
								name:  "MYSQL_ROOT_PASSWORD"
								value: parameter.rootPassword
							}, {
								if parameter.database != _|_ {
								  name:  "MYSQL_DATABASE"
								  value: parameter.database
								}
							}]
							ports: [{
								name:          "mysql"
								containerPort: 3306
							}]
							image: "mysql:8.0.28"
							volumeMounts: [{
								name: context.name + "-mysql-data"
								mountPath: "/var/lib/mysql"
							}, {
								name: context.name + "-mysql-config"
								mountPath: "/etc/mysql/conf.d/"
							},{
								if parameter.initdb != _|_{
								  name:  context.name + "-mysql-initdb"
								  mountPath: "/docker-entrypoint-initdb.d"
								}
						    }
						]
						}]
						volumes: [{
							name: context.name+ "-mysql-data"
							hostPath: path: parameter.hostPath
						}, {
							name: context.name + "-mysql-config"
							configMap: name: context.name + "-mysql-config"
						},{
					     if parameter.initdb != _|_		{
							     name: context.name + "-mysql-initdb"
							     configMap: name: parameter.initdb
						    }
					   }
				]
					}
				}
			}
		}
		"mysql-headless": {
			apiVersion: "v1"
			kind:       "Service"
			metadata: {
				name:  context.name + "-mysql-headless"
				labels: app: context.name + "-mysql"
			}
			spec: {
				ports: [{
					name:       "tcp"
					port:       3306
					protocol:   "TCP"
					targetPort: 3306
				}]
				selector: app: context.name + "-mysql"
				clusterIP: "None"
			}
		}
		"mysql-service": {
			apiVersion: "v1"
			kind:       "Service"
			metadata: {
				name: context.name + "-mysql-service"
				labels: app: context.name + "-mysql"
			}
			spec: {
				ports: [{
					name:       "tcp"
					if parameter.serviceType == "NodePort" {
					  if parameter.nodePort != _|_{
					    nodePort:   parameter.nodePort
					  }
					}

					port:       3306
					protocol:   "TCP"
					targetPort: 3306
				}]
				selector: app: context.name + "-mysql"
				type: parameter.serviceType
			}
		}
	  secret: {
		  apiVersion: "v1"
		  kind:       "Secret"
		  metadata: {
			  name: context.name + "-mysql-secret"
		  }
		  type: "Opaque"
		  data: {
			  root: base64.Encode(null,"root")
			  password: base64.Encode(null,parameter.rootPassword)
			  url: base64.Encode(null,context.name + "-mysql-service." + context.namespace + ".svc.cluster.local:3306")
		  }
	  }
	}
	parameter: {
		initdb ?: string
		hostPath: *"/home/k8s/mysql" | string
    serviceType: *"ClusterIP" | "NodePort"
    nodePort ?: int
    rootPassword: *"123456" | string
    database ?: string
	}
}
