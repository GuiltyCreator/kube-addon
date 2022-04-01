"elasticsearch": {
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
		kind: "Deployment"
		metadata: {
			name: parameter.name
			namespace: parameter.namespace
		}
		spec: {
			selector: matchLabels: app: parameter.name
			template: {
				metadata: labels: app: parameter.name
				spec: containers: [{
					name: parameter.name
					image: parameter.image
					imagePullPolicy: "Always"
//					imagePullPolicy: parameter.imagePullPolicy
					env: [{
						name: "discovery.type"
						value: "single-node"
					}]
					ports: [{
						containerPort: 9200
						name: "access"
					},{
						containerPort: 9300
						name: "cluster"
					}]
				}]
			}
		}
	}

	outputs: service: {
		apiVersion: "v1"
		kind: "Service"
		metadata: {
			name: parameter.name
			labels: app: parameter.name
			namespace: parameter.namespace
		}
		spec:{
			ports: [{
				port: parameter.accessPort
				protocol: "TCP"
				targetPort: 9200
				name: "access"
			},{
				port: parameter.clusterPort
				protocol: "TCP"
				targetPort: 9300
				name: "cluster"
			}]
		}
	}

	parameter:{
		name: *context.namespace | string
		namespace: *context.namespace | string
		image: *"harbor.dev.wh.digitalchina.com/oam-test/rabbitmq:3.9.7" | string
//		imagePullPolicy?: *"Always" | "Never" | "IfNotPresent"
		accessPort: *9200 | int
		clusterPort: *9300 | int
	}
}