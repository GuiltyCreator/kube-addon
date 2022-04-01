import(
	"encoding/base64"
)
nacos: {
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
	}
	description: "My nacos component."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "v1"
		data: {
			"mysql.db.name":  parameter.mysql.db
			"mysql.host":     parameter.mysql.host
			"mysql.password": parameter.mysql.password
			"mysql.port":     parameter.mysql.port
			"mysql.user":     parameter.mysql.user
		}
		kind: "ConfigMap"
		metadata: {
			name: context.name + "-nacos-config"
		}
	}
	outputs: {
		nacos: {
			apiVersion: "apps/v1"
			kind:       "StatefulSet"
			metadata: {
				name: context.name + "-nacos"
			}
			spec: {
				selector: matchLabels: app: context.name + "-nacos"
				replicas:    1
				serviceName: context.name + "-nacos-headless"
				template: {
					metadata: labels: app:context.name + "-nacos"
					spec: containers: [{
						name: "nacos"
						env: [{
							name: "MYSQL_SERVICE_HOST"
							valueFrom: configMapKeyRef: {
								name: context.name + "-nacos-config"
								key:  "mysql.host"
							}
						}, {
							name: "MYSQL_SERVICE_DB_NAME"
							valueFrom: configMapKeyRef: {
								name: context.name + "-nacos-config"
								key:  "mysql.db.name"
							}
						}, {
							name: "MYSQL_SERVICE_PORT"
							valueFrom: configMapKeyRef: {
								name: context.name + "-nacos-config"
								key:  "mysql.port"
							}
						}, {
							name: "MYSQL_SERVICE_USER"
							valueFrom: configMapKeyRef: {
								name: context.name + "-nacos-config"
								key:  "mysql.user"
							}
						}, {
							name: "MYSQL_SERVICE_PASSWORD"
							valueFrom: configMapKeyRef: {
								name: context.name + "-nacos-config"
								key:  "mysql.password"
							}
						}, {
							name:  "MODE"
							value: "standalone"
						}, {
							name:  "NACOS_SERVER_PORT"
							value: "8848"
						}]
						ports: [{
							name:          "client"
							containerPort: 8848
						}]
						image:           "nacos/nacos-server:2.0.2"
					}]
				}
			}
		}
		"nacos-headless": {
			apiVersion: "v1"
			kind:       "Service"
			metadata: {
				name:      context.name + "-nacos-headless"
				labels: app: context.name + "-nacos"
			}
			spec: {
				clusterIP: "None"
				ports: [{
					name:       "server"
					port:       8848
					targetPort: 8848
				}]
				selector: app: context.name + "-nacos"
			}
		}
		"nacos-service": {
			apiVersion: "v1"
			kind:       "Service"
			metadata: {
				name:      context.name + "-nacos-service"
			}
			spec: {
				ports: [{
					name:       "http"
					port:       8848
					targetPort: 8848
					if parameter.serviceType == "NodePort" {
					  if parameter.nodePort != _|_{
					    nodePort:   parameter.nodePort
					  }
					}
					protocol:   "TCP"
				}]
				selector: app: context.name + "-nacos"
				type: parameter.serviceType
			}
		}
		secret: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name: context.name + "-nacos-secret"
		}
		type: "Opaque"
		data: {
			url: base64.Encode(null,context.name + "-nacos-service." + context.namespace + ".svc.cluster.local:8848")
		}
	}
	}
	parameter: {
		mysql: {
			db: *"nacos" | string
			host: *"mysql.default.svc.cluster.local" | string
			port: *"3306" | string
			user: *"root" | string
			password: *"123456" | string
		}
		serviceType: *"ClusterIP" | "NodePort"
    nodePort ?: int
	}
}
