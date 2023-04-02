local p = import '../params.libsonnet';
local params = p.components.app;
local url = std.extVar('url');

{
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    labels: {
      "app.meow/component": 'ingress',
      "app.meow/name": params.name,
    },
    name: params.name,
  },
  spec: {
		rules: [
			{
				host: url,
				http: {
					paths: [
						{
							path: "/",
							pathType: "Prefix",
							backend: {
								service: {
									name: params.name,
									port: {
										number: params.service.ports.port
									}
								}
							}
						}
					]
				}
			}
		]
	}
}