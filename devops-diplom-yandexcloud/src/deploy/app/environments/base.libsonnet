local svc(name, type, port, targetPort=null, nodePort=null, url=null) = {
  name: name,
	type: type,
	[if url != null then 'url']: url,
	port: {
			name: 'tcp',
			port: port,
			[if targetPort != null then 'targetPort']: targetPort,
			[if nodePort != null then 'nodePort']: nodePort,
		},
};


{
  components: {
    app: {
      name: 'app-meow',
      replicas: 1,
      image: {
        repository: 'raleonid/app-meow',
        tag: '0.0.1',
        pullPolicy: 'IfNotPresent',
      },
      service: {
				type: 'ClusterIP',
				ports: {
						name: 'tcp',
						port: 8000,
						targetPort: 80,
					},
      }
    },
  },
}
