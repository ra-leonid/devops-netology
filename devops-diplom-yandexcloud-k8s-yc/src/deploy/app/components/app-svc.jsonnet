
local p = import '../params.libsonnet';
local params = p.components.app;


{
	apiVersion: 'v1',
	kind: 'Service',
	metadata: {
		name: params.name,
	},
	spec: {
		type: params.service.type,
		ports: [ params.service.ports ],
		selector: {
			app: params.name,
		},
	}
}

