
local p = import '../params.libsonnet';
local params = p.components.app;


[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: params.name,
      labels: {
        app: params.name,
      },
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: params.name,
        },
      },
      template: {
        metadata: {
          labels: {
            app: params.name,
          },
        },
        spec: {
          containers: [
            {
              name: params.name,
              image: params.image.repository + ':' + params.image.tag,
              ports: [
                {
                  name: 'http',
                  containerPort: params.service.ports.port,
                  protocol: 'TCP',
                }
              ],
              imagePullPolicy: params.image.pullPolicy,
            },
          ],
        },
      },
    },
  },
]
