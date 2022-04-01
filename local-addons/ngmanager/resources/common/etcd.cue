output: {
	type: "etcd"
	properties: {
		name: "ngmanager-etcd"
    namespace: "ngmanager"
    image: "harbor.dev.wh.digitalchina.com/oam-test/etcd:v3.5.0"
    accessPort: 2379
    clusterPort: 2380
	}
}