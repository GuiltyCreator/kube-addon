"postgres": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "postgres component"
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "apps/v1"
		kind: "StatefulSet"
		metadata: {
			name: parameter.name
			namespace: parameter.namespace
		}
		spec: {
			selector: matchLabels: app: parameter.name
			template: {
				metadata: labels: app: parameter.name
				spec: {
					containers: [{
						name: parameter.name
						image: parameter.image
						imagePullPolicy: "Always"
//						imagePUllPolicy: parameter.imagePullPolicy
						ports: [{
							containerPort: 5432
						}]
						envFrom:[{
							configMapRef: name: "postgres-config"
						}]
						volumeMounts: [{
//							mountPath: parameter.PGDATA
//							name: "postgredb"
//						},{
							mountPath: "/docker-entrypoint-initdb.d"
							name: "psql-initdb"
						}]
					}]
					volumes: [{
//						name: "postgredb"
//						persistentVolumeClaim: claimName: "postgres-pvc"
//					},{
						name: "psql-initdb"
						configMap: name: "psql-initdb-config"
					}]
				}
			}
		}
	}

	outputs: {
		service: {
			apiVersion: "v1"
			kind: "Service"
			metadata: {
				name: parameter.name
				labels: app: parameter.name
				namespace: parameter.namespace
			}
			spec: {
				ports: [{
					port: parameter.port
					protocol: "TCP"
					targetPort: 5432
				}]
				selector: app: parameter.name
			}
		}
		"postgres-config": {
			apiVersion: "v1"
	    kind: "ConfigMap"
	    metadata: {
		    name: "postgres-config"
		    labels: app: "postgres"
		    namespace: parameter.namespace
	    }
	    data: {
		    PGDATA: parameter.PGDATA
		    POSTGRES_DB: parameter.POSTGRES_DB
		    POSTGRES_USER: parameter.POSTGRES_USER
		    POSTGRES_PASSWORD: parameter.POSTGRES_PASSWORD
 	    }
		}
//		"postgres-pvc": {
//			apiVersion: "v1"
//			kind: "PersistentVolumeClaim"
//			metadata: name: "postgres-pvc"
//			spec: {
//				accessModes: parameter.accessModes
//				resources: requests: storage: parameter.storage
//				if parameter.storageClassName != _|_ {
//					storageClassName: parameter.storageClassName
//				}
//			}
//		}
		"psql-initdb-config": {
			apiVersion: "v1"
			kind: "ConfigMap"
			metadata: {
				name: "psql-initdb-config"
				namespace: parameter.namespace
			}
			if parameter.initsql == _|_ {
				data: "initdb.sql": ""
			}
			if parameter.initsql != _|_ {
				data: "initdb.sql": parameter.initsql
			}
		}
	}

	parameter: {
		name: *context.namespace | string
		namespace: *context.namespace | string
		image: *"harbor.dev.wh.digitalchina.com/oam-test/ngmanager-postgres:12.6" | string
//		imagePullPolicy?: *"Always" | "Never" | "IfNotPresent"
		port: *5432 | int
		PGDATA: *"/var/lib/postgresql/data" | string
		POSTGRES_DB: "" | string
		POSTGRES_USER: "" | string
		POSTGRES_PASSWORD: "" | string
//		accessModes: *["ReadWriteMany"] | [...string]
//		storage: *10Gi | string
//		storageClassName?: string
		initsql?: string
  }
}



