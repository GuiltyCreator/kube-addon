"etcd": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "etcd component"
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
//						imagePullPolicy: parameter.imagePullPolicy
						ports: [{
							containerPort: 2379
							name: "access"
						},{
							containerPort: 2380
							name: "cluster"
						}]
						command: ["/usr/local/bin/etcd"]
						args: [
							"--name=s1",
							"--data-dir=/etcd-data",
							"--listen-client-urls=http://0.0.0.0:2379",
							"--advertise-client-urls=http://0.0.0.0:2379",
							"--listen-peer-urls=http://0.0.0.0:2380",
							"--initial-advertise-peer-urls=http://0.0.0.0:2380",
							"--initial-cluster=s1=http://0.0.0.0:2380",
							"--initial-cluster-token=tkn",
							"--initial-cluster-state=new",
							"--log-level=info",
							"--logger=zap",
							"--log-outputs=stderr"]
					}]
				}
			}
		}
	}

	outputs: service: {
		apiVersion: "v1"
		kind: "Service"
		"metadata": {
			name: parameter.name
			namespace: parameter.namespace
			labels: app: parameter.name
		}
		spec: {
			ports: [{
				port: parameter.accessPort
				protocol: "TCP"
				targetPort: 2379
				name: "access"
			},{
				port: parameter.clusterPort
				protocol: "TCP"
				targetPort: 2380
				name: "cluster"
			}]
			selector: app: parameter.name
		}
	}

	parameter: {
		name: *context.namespace | string
		namespace: *context.namespace | string
		image: *"harbor.dev.wh.digitalchina.com/oam-test/etcd:v3.5.0" | string
//		imagePullPolicy?: *"Always" | "Never" | "IfNotPresent"
		accessPort: *2379 | int
		clusterPort: *2380 | int
	}
}