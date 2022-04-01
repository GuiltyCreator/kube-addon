"rabbitmq": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "etcd component"
	labels: {}
	type: "component"
}

template: {
	output:{
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
				spec: container: [{
					name: parameter.name
					image: parameter.image
					imagePullPolicy: "Always"
//					imagePullPolicy: parameter.imagePullPolicy
					ports: [{
						containerPort: 5672
						name: "server"
					},{
						containerPort: 15672
						name: "manager"
					}]
					command: ["/bin/sh","-c","rabbitmq-plugins enable rabbitmq_management;rabbitmq-server restart"]
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
		spec: {
			ports: [{
				port: parameter.serverPort
				targetPort: 5672
				protocol: "TCP"
				name: "server"
			},{
				port: parameter.managerPort
				targetPort: 15672
				protocol: "TCP"
				name: "manager"
			}]
			selector: app: parameter.name
		}
	}
	parameter: {
    name: *context.namespace | string
		namespace: *context.namespace | string
		image: *"harbor.dev.wh.digitalchina.com/oam-test/rabbitmq:3.9.7" | string
//		imagePullPolicy?: *"Always" | "Never" | "IfNotPresent"
		serverPort: *5672 | int
		managerPort: *15672 | int
	}
}