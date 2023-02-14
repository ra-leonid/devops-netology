
local p = import '../params.libsonnet';
local params = p.components.frontend;

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
                  containerPort: params.service.targetPort,
                  protocol: 'TCP',
                }
              ],
              env: [
                {
                  name: 'BASE_URL',
                  value: 'http://' + p.components.backend.name + ':' + p.components.backend.service.port,
                }
              ],
              imagePullPolicy: params.image.pullPolicy,
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: params.name,
    },
    spec: {
      ports: [
        {
          name: params.name,
          port: params.service.port,
          targetPort: params.service.targetPort,
        }
      ],
      selector: {
        app: params.name,
      },
      type: params.service.type,
    }
  }
]
